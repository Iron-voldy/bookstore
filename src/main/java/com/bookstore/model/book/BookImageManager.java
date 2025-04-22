package com.bookstore.model.book;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.UUID;
import javax.servlet.ServletContext;
import javax.servlet.http.Part;

/**
 * Handles book image uploads and retrieval
 */
public class BookImageManager {
    private static final int MAX_IMAGE_SIZE = 5 * 1024 * 1024; // 5MB
    private static final String[] ALLOWED_EXTENSIONS = {".jpg", ".jpeg", ".png", ".gif"};
    private static final String DEFAULT_IMAGE = "default_cover.jpg";

    private String uploadPath;
    private ServletContext servletContext;

    /**
     * Constructor with ServletContext
     */
    public BookImageManager(ServletContext servletContext) {
        this.servletContext = servletContext;
        initializeUploadPath();
    }

    /**
     * Initialize the upload directory path
     */
    private void initializeUploadPath() {
        if (servletContext != null) {
            // Use WEB-INF/uploads/book-covers within the application context
            uploadPath = servletContext.getRealPath("/WEB-INF/uploads/book-covers");

            // Make sure directory exists
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                boolean created = uploadDir.mkdirs();
                System.out.println("Created book covers directory: " + uploadDir.getAbsolutePath() + " - Success: " + created);
            }
        } else {
            // Fallback to simple uploads directory if not in web context
            uploadPath = "uploads/book-covers";

            // Make sure directory exists
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                boolean created = uploadDir.mkdirs();
                System.out.println("Created fallback book covers directory: " + uploadPath + " - Success: " + created);
            }
        }

        System.out.println("BookImageManager: Using upload path: " + uploadPath);
    }

    /**
     * Upload a book cover image
     * @param imagePart the file part from multipart request
     * @return the filename of the uploaded image, or default image if upload fails
     */
    public String uploadBookCover(Part imagePart) {
        if (imagePart == null || imagePart.getSize() == 0) {
            return DEFAULT_IMAGE;
        }

        // Check file size
        if (imagePart.getSize() > MAX_IMAGE_SIZE) {
            System.err.println("Book cover image too large: " + imagePart.getSize() + " bytes");
            return DEFAULT_IMAGE;
        }

        // Get filename and check extension
        String fileName = getSubmittedFileName(imagePart);
        String fileExtension = getFileExtension(fileName).toLowerCase();

        if (!isAllowedExtension(fileExtension)) {
            System.err.println("Invalid book cover image extension: " + fileExtension);
            return DEFAULT_IMAGE;
        }

        // Generate unique filename to prevent overwriting
        String uniqueFileName = UUID.randomUUID().toString() + fileExtension;
        String filePath = uploadPath + File.separator + uniqueFileName;

        // Save the file
        try (InputStream input = imagePart.getInputStream();
             FileOutputStream output = new FileOutputStream(filePath)) {

            byte[] buffer = new byte[1024];
            int length;
            while ((length = input.read(buffer)) > 0) {
                output.write(buffer, 0, length);
            }

            System.out.println("Book cover uploaded successfully: " + uniqueFileName);
            return uniqueFileName;

        } catch (IOException e) {
            System.err.println("Error uploading book cover: " + e.getMessage());
            e.printStackTrace();
            return DEFAULT_IMAGE;
        }
    }

    /**
     * Delete a book cover image
     * @param imageName the filename to delete
     * @return true if successful, false otherwise
     */
    public boolean deleteBookCover(String imageName) {
        // Don't delete the default image
        if (imageName == null || imageName.equals(DEFAULT_IMAGE)) {
            return false;
        }

        try {
            File imageFile = new File(uploadPath + File.separator + imageName);
            if (imageFile.exists()) {
                boolean deleted = Files.deleteIfExists(imageFile.toPath());
                System.out.println("Book cover deleted: " + imageName + " - Success: " + deleted);
                return deleted;
            }
            return false;
        } catch (IOException e) {
            System.err.println("Error deleting book cover: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Get the absolute path of an image
     * @param imageName the filename
     * @return the absolute path
     */
    public String getImagePath(String imageName) {
        // If imageName is null or empty, return the default image
        if (imageName == null || imageName.trim().isEmpty()) {
            return uploadPath + File.separator + DEFAULT_IMAGE;
        }

        File imageFile = new File(uploadPath + File.separator + imageName);
        if (!imageFile.exists()) {
            return uploadPath + File.separator + DEFAULT_IMAGE;
        }

        return imageFile.getAbsolutePath();
    }

    private boolean isAllowedExtension(String extension) {
        for (String allowed : ALLOWED_EXTENSIONS) {
            if (allowed.equalsIgnoreCase(extension)) {
                return true;
            }
        }
        return false;
    }

    /**
     * Extract file extension from filename
     * @param fileName the filename
     * @return the file extension including dot
     */
    private String getFileExtension(String fileName) {
        if (fileName == null) {
            return "";
        }
        int lastDotIndex = fileName.lastIndexOf(".");
        if (lastDotIndex == -1) {
            return "";
        }
        return fileName.substring(lastDotIndex);
    }

    /**
     * Get the original filename from a Part
     * @param part the Part from file upload
     * @return the original filename
     */
    private String getSubmittedFileName(Part part) {
        String header = part.getHeader("content-disposition");
        if (header == null) {
            return null;
        }
        for (String token : header.split(";")) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return null;
    }

    /**
     * Create the default book cover if it doesn't exist
     * This would typically be done during application initialization
     */
    public void ensureDefaultCoverExists() {
        File defaultCover = new File(uploadPath + File.separator + DEFAULT_IMAGE);
        if (!defaultCover.exists()) {
            try {
                // Copy from resources or create a simple default image
                // This is a simplified implementation
                boolean created = defaultCover.createNewFile();
                System.out.println("Created default book cover: " + created);
            } catch (IOException e) {
                System.err.println("Error creating default book cover: " + e.getMessage());
                e.printStackTrace();
            }
        }
    }
}
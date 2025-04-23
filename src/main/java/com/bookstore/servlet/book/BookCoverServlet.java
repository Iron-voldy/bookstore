package com.bookstore.servlet.book;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.bookstore.model.book.BookImageManager;

/**
 * Servlet for serving book cover images
 */
@WebServlet("/book-covers/*")
public class BookCoverServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests - serve book cover images
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get the requested image filename from the URL
        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // Remove the leading slash
        String filename = pathInfo.substring(1);

        // Get BookImageManager to handle the image file
        BookImageManager imageManager = new BookImageManager(getServletContext());

        // Get the absolute path of the image
        String imagePath = imageManager.getImagePath(filename);

        // Check if the file exists
        File imageFile = new File(imagePath);
        if (!imageFile.exists()) {
            // If the requested image doesn't exist, serve the default cover
            imagePath = imageManager.getImagePath("default_cover.jpg");
            imageFile = new File(imagePath);

            // If even the default image doesn't exist, return 404
            if (!imageFile.exists()) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }
        }

        // Set the content type based on the image extension
        String contentType = getServletContext().getMimeType(imagePath);
        if (contentType == null) {
            contentType = "application/octet-stream";
        }
        response.setContentType(contentType);

        // Set content length (file size)
        response.setContentLength((int) imageFile.length());

        // Serve the image
        try (FileInputStream in = new FileInputStream(imageFile);
             OutputStream out = response.getOutputStream()) {

            byte[] buffer = new byte[4096];
            int bytesRead;

            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
        } catch (IOException e) {
            System.err.println("Error serving book cover: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
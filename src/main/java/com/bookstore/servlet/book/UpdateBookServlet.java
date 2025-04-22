package com.bookstore.servlet.book;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import com.bookstore.model.book.Book;
import com.bookstore.model.book.BookImageManager;
import com.bookstore.model.book.BookManager;
import com.bookstore.model.book.EBook;
import com.bookstore.model.book.PhysicalBook;
import com.bookstore.util.ValidationUtil;

/**
 * Servlet for handling book updates
 */
@WebServlet("/admin/update-book")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 5 * 1024 * 1024,    // 5MB
        maxRequestSize = 10 * 1024 * 1024 // 10MB
)
public class UpdateBookServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests - display update book form
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String bookId = request.getParameter("id");
        if (bookId == null || bookId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-books.jsp");
            return;
        }

        // Get book details
        BookManager bookManager = new BookManager(getServletContext());
        Book book = bookManager.getBookById(bookId);

        if (book == null) {
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Book not found");
            response.sendRedirect(request.getContextPath() + "/admin/manage-books.jsp");
            return;
        }

        // Set book in request
        request.setAttribute("book", book);

        // Determine book type
        if (book instanceof PhysicalBook) {
            request.setAttribute("bookType", "physical");
        } else if (book instanceof EBook) {
            request.setAttribute("bookType", "ebook");
        } else {
            request.setAttribute("bookType", "regular");
        }

        // Forward to edit form
        request.getRequestDispatcher("/admin/edit-book.jsp").forward(request, response);
    }

    /**
     * Handles POST requests - process the update book form
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        try {
            // Get book ID
            String bookId = request.getParameter("bookId");
            if (bookId == null || bookId.trim().isEmpty()) {
                session.setAttribute("errorMessage", "Book ID is required");
                response.sendRedirect(request.getContextPath() + "/admin/manage-books.jsp");
                return;
            }

            // Get existing book
            BookManager bookManager = new BookManager(getServletContext());
            Book existingBook = bookManager.getBookById(bookId);

            if (existingBook == null) {
                session.setAttribute("errorMessage", "Book not found");
                response.sendRedirect(request.getContextPath() + "/admin/manage-books.jsp");
                return;
            }

            // Get form parameters
            String title = request.getParameter("title");
            String author = request.getParameter("author");
            String isbn = request.getParameter("isbn");
            String publisher = request.getParameter("publisher");
            String publicationDateStr = request.getParameter("publicationDate");
            String genre = request.getParameter("genre");
            String description = request.getParameter("description");
            String priceStr = request.getParameter("price");
            String quantityStr = request.getParameter("quantity");
            String bookType = request.getParameter("bookType");
            String featured = request.getParameter("featured");

            // Book type specific parameters
            // For Physical Books
            String pageCountStr = request.getParameter("pageCount");
            String dimensions = request.getParameter("dimensions");
            String binding = request.getParameter("binding");
            String weightStr = request.getParameter("weight");
            String edition = request.getParameter("edition");
            String condition = request.getParameter("condition");
            String language = request.getParameter("language");

            // For EBooks
            String fileFormat = request.getParameter("fileFormat");
            String fileSizeStr = request.getParameter("fileSize");
            String drmProtected = request.getParameter("drmProtected");
            String downloadLink = request.getParameter("downloadLink");
            String watermarked = request.getParameter("watermarked");

            // Validate required fields
            if (ValidationUtil.isNullOrEmpty(title) || ValidationUtil.isNullOrEmpty(author) ||
                    ValidationUtil.isNullOrEmpty(isbn) || ValidationUtil.isNullOrEmpty(priceStr) ||
                    ValidationUtil.isNullOrEmpty(quantityStr)) {
                session.setAttribute("errorMessage", "Required fields are missing");
                response.sendRedirect(request.getContextPath() + "/admin/edit-book.jsp?id=" + bookId);
                return;
            }

            // Validate ISBN
            if (!ValidationUtil.isValidISBN(isbn)) {
                session.setAttribute("errorMessage", "Invalid ISBN format");
                response.sendRedirect(request.getContextPath() + "/admin/edit-book.jsp?id=" + bookId);
                return;
            }

            // Validate price
            if (!ValidationUtil.isValidPrice(priceStr)) {
                session.setAttribute("errorMessage", "Invalid price format");
                response.sendRedirect(request.getContextPath() + "/admin/edit-book.jsp?id=" + bookId);
                return;
            }

            // Parse price and quantity
            double price = ValidationUtil.parseDoubleOrDefault(priceStr, 0.0);
            int quantity = ValidationUtil.parseIntOrDefault(quantityStr, 0);

            // Parse publication date
            Date publicationDate = existingBook.getPublicationDate();
            if (!ValidationUtil.isNullOrEmpty(publicationDateStr)) {
                try {
                    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                    publicationDate = dateFormat.parse(publicationDateStr);
                } catch (ParseException e) {
                    System.err.println("Invalid publication date format: " + e.getMessage());
                    // Keep existing publication date
                }
            }

            // Handle file upload - only process if a new file is selected
            Part filePart = request.getPart("coverImage");
            BookImageManager imageManager = new BookImageManager(getServletContext());
            String coverImagePath = existingBook.getCoverImagePath(); // Default to existing

            if (filePart != null && filePart.getSize() > 0) {
                // Upload new image
                String newCoverImagePath = imageManager.uploadBookCover(filePart);

                // If upload successful, delete old image and update path
                if (!newCoverImagePath.equals("default_cover.jpg")) {
                    if (!existingBook.getCoverImagePath().equals("default_cover.jpg")) {
                        imageManager.deleteBookCover(existingBook.getCoverImagePath());
                    }
                    coverImagePath = newCoverImagePath;
                }
            }

            // Create appropriate book type for update
            Book updatedBook = null;

            // Check if book type has changed
            String existingType = "";
            if (existingBook instanceof PhysicalBook) {
                existingType = "physical";
            } else if (existingBook instanceof EBook) {
                existingType = "ebook";
            } else {
                existingType = "regular";
            }

            // If book type changed or not specified, use existing type
            if (bookType == null || bookType.trim().isEmpty()) {
                bookType = existingType;
            }

            // Set common book properties
            if ("physical".equals(bookType)) {
                PhysicalBook physicalBook;

                if (existingBook instanceof PhysicalBook) {
                    physicalBook = (PhysicalBook) existingBook;
                } else {
                    physicalBook = new PhysicalBook();
                    // Copy non-type-specific data
                    physicalBook.setId(existingBook.getId());
                    physicalBook.setAddedDate(existingBook.getAddedDate());
                    physicalBook.setAverageRating(existingBook.getAverageRating());
                    physicalBook.setNumberOfRatings(existingBook.getNumberOfRatings());
                }

                physicalBook.setTitle(title);
                physicalBook.setAuthor(author);
                physicalBook.setIsbn(isbn);
                physicalBook.setPublisher(publisher);
                physicalBook.setPublicationDate(publicationDate);
                physicalBook.setGenre(genre);
                physicalBook.setDescription(description);
                physicalBook.setPrice(price);
                physicalBook.setQuantity(quantity);
                physicalBook.setCoverImagePath(coverImagePath);
                physicalBook.setFeatured("on".equals(featured));

                // Set physical book specific fields
                physicalBook.setPageCount(ValidationUtil.parseIntOrDefault(pageCountStr, 0));
                physicalBook.setDimensions(dimensions);
                physicalBook.setBinding(binding);
                physicalBook.setWeightKg(ValidationUtil.parseDoubleOrDefault(weightStr, 0.0));
                physicalBook.setEdition(edition);
                physicalBook.setCondition(condition);
                physicalBook.setLanguage(language);

                updatedBook = physicalBook;
            } else if ("ebook".equals(bookType)) {
                EBook ebook;

                if (existingBook instanceof EBook) {
                    ebook = (EBook) existingBook;
                } else {
                    ebook = new EBook();
                    // Copy non-type-specific data
                    ebook.setId(existingBook.getId());
                    ebook.setAddedDate(existingBook.getAddedDate());
                    ebook.setAverageRating(existingBook.getAverageRating());
                    ebook.setNumberOfRatings(existingBook.getNumberOfRatings());
                }

                ebook.setTitle(title);
                ebook.setAuthor(author);
                ebook.setIsbn(isbn);
                ebook.setPublisher(publisher);
                ebook.setPublicationDate(publicationDate);
                ebook.setGenre(genre);
                ebook.setDescription(description);
                ebook.setPrice(price);
                ebook.setQuantity(quantity);
                ebook.setCoverImagePath(coverImagePath);
                ebook.setFeatured("on".equals(featured));

                // Set ebook specific fields
                ebook.setFileFormat(fileFormat);
                ebook.setFileSizeMB(ValidationUtil.parseDoubleOrDefault(fileSizeStr, 0.0));
                ebook.setDrm("on".equals(drmProtected));
                ebook.setDownloadLink(downloadLink);
                ebook.setWatermarked("on".equals(watermarked));

                updatedBook = ebook;
            } else {
                // Regular book
                updatedBook = new Book();

                // Copy data from existing book for fields not in form
                updatedBook.setId(existingBook.getId());
                updatedBook.setAddedDate(existingBook.getAddedDate());
                updatedBook.setAverageRating(existingBook.getAverageRating());
                updatedBook.setNumberOfRatings(existingBook.getNumberOfRatings());

                // Update fields from form
                updatedBook.setTitle(title);
                updatedBook.setAuthor(author);
                updatedBook.setIsbn(isbn);
                updatedBook.setPublisher(publisher);
                updatedBook.setPublicationDate(publicationDate);
                updatedBook.setGenre(genre);
                updatedBook.setDescription(description);
                updatedBook.setPrice(price);
                updatedBook.setQuantity(quantity);
                updatedBook.setCoverImagePath(coverImagePath);
                updatedBook.setFeatured("on".equals(featured));
            }

            // Update book in database
            boolean success = bookManager.updateBook(updatedBook);

            if (success) {
                session.setAttribute("successMessage", "Book updated successfully");
                response.sendRedirect(request.getContextPath() + "/admin/manage-books.jsp");
            } else {
                session.setAttribute("errorMessage", "Failed to update book. ISBN may already exist.");
                response.sendRedirect(request.getContextPath() + "/admin/edit-book.jsp?id=" + bookId);
            }

        } catch (Exception e) {
            System.err.println("Error updating book: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/manage-books.jsp");
        }
    }
}
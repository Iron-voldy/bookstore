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
 * Servlet for handling adding books
 */
@WebServlet("/admin/add-book")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 5 * 1024 * 1024,    // 5MB
        maxRequestSize = 10 * 1024 * 1024 // 10MB
)
public class AddBookServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests - display add book form
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Forward to the add book form
        request.getRequestDispatcher("/admin/add-book.jsp").forward(request, response);
    }

    /**
     * Handles POST requests - process the add book form
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        try {
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
                    ValidationUtil.isNullOrEmpty(quantityStr) || ValidationUtil.isNullOrEmpty(bookType)) {
                session.setAttribute("errorMessage", "Required fields are missing");
                response.sendRedirect(request.getContextPath() + "/admin/add-book.jsp");
                return;
            }

            // Validate ISBN
            if (!ValidationUtil.isValidISBN(isbn)) {
                session.setAttribute("errorMessage", "Invalid ISBN format");
                response.sendRedirect(request.getContextPath() + "/admin/add-book.jsp");
                return;
            }

            // Validate price
            if (!ValidationUtil.isValidPrice(priceStr)) {
                session.setAttribute("errorMessage", "Invalid price format");
                response.sendRedirect(request.getContextPath() + "/admin/add-book.jsp");
                return;
            }

            // Parse price and quantity
            double price = ValidationUtil.parseDoubleOrDefault(priceStr, 0.0);
            int quantity = ValidationUtil.parseIntOrDefault(quantityStr, 0);

            // Parse publication date
            Date publicationDate = null;
            if (!ValidationUtil.isNullOrEmpty(publicationDateStr)) {
                try {
                    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                    publicationDate = dateFormat.parse(publicationDateStr);
                } catch (ParseException e) {
                    // Invalid date format, use current date
                    publicationDate = new Date();
                    System.err.println("Invalid publication date format: " + e.getMessage());
                }
            } else {
                publicationDate = new Date(); // Default to current date
            }

            // Handle file upload
            Part filePart = request.getPart("coverImage");
            BookImageManager imageManager = new BookImageManager(getServletContext());
            String coverImagePath = imageManager.uploadBookCover(filePart);

            // Create appropriate book type
            Book book = null;

            if ("physical".equals(bookType)) {
                PhysicalBook physicalBook = new PhysicalBook();
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

                book = physicalBook;
            } else if ("ebook".equals(bookType)) {
                EBook ebook = new EBook();
                ebook.setTitle(title);
                ebook.setAuthor(author);
                ebook.setIsbn(isbn);
                ebook.setPublisher(publisher);
                ebook.setPublicationDate(publicationDate);
                ebook.setGenre(genre);
                ebook.setDescription(description);
                ebook.setPrice(price);
                ebook.setQuantity(quantity); // Typically unlimited for e-books, but keeping for consistency
                ebook.setCoverImagePath(coverImagePath);
                ebook.setFeatured("on".equals(featured));

                // Set ebook specific fields
                ebook.setFileFormat(fileFormat);
                ebook.setFileSizeMB(ValidationUtil.parseDoubleOrDefault(fileSizeStr, 0.0));
                ebook.setDrm("on".equals(drmProtected));
                ebook.setDownloadLink(downloadLink);
                ebook.setWatermarked("on".equals(watermarked));

                book = ebook;
            } else {
                // Generic book
                book = new Book();
                book.setTitle(title);
                book.setAuthor(author);
                book.setIsbn(isbn);
                book.setPublisher(publisher);
                book.setPublicationDate(publicationDate);
                book.setGenre(genre);
                book.setDescription(description);
                book.setPrice(price);
                book.setQuantity(quantity);
                book.setCoverImagePath(coverImagePath);
                book.setFeatured("on".equals(featured));
            }

            // Add book to database
            BookManager bookManager = new BookManager(getServletContext());
            boolean success = bookManager.addBook(book);

            if (success) {
                session.setAttribute("successMessage", "Book added successfully");
                response.sendRedirect(request.getContextPath() + "/admin/manage-books.jsp");
            } else {
                session.setAttribute("errorMessage", "Failed to add book. ISBN may already exist.");
                response.sendRedirect(request.getContextPath() + "/admin/add-book.jsp");
            }

        } catch (Exception e) {
            System.err.println("Error adding book: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/add-book.jsp");
        }
    }
}
package com.bookstore.servlet.book;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.bookstore.model.book.Book;
import com.bookstore.model.book.BookImageManager;
import com.bookstore.model.book.BookManager;

/**
 * Servlet for handling book deletion
 */
@WebServlet("/admin/delete-book")
public class DeleteBookServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles POST requests - process book deletion
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

            // Get book manager and image manager
            BookManager bookManager = new BookManager(getServletContext());
            BookImageManager imageManager = new BookImageManager(getServletContext());

            // Get the book to delete (needed to get the cover image path)
            Book book = bookManager.getBookById(bookId);

            if (book == null) {
                session.setAttribute("errorMessage", "Book not found");
                response.sendRedirect(request.getContextPath() + "/admin/manage-books.jsp");
                return;
            }

            // Store the image path before deleting the book
            String coverImagePath = book.getCoverImagePath();

            // Delete the book
            boolean bookDeleted = bookManager.deleteBook(bookId);

            if (bookDeleted) {
                // If book deletion successful, try to delete the cover image
                // Don't delete the default cover
                if (coverImagePath != null && !coverImagePath.equals("default_cover.jpg")) {
                    imageManager.deleteBookCover(coverImagePath);
                }

                session.setAttribute("successMessage", "Book deleted successfully");
            } else {
                session.setAttribute("errorMessage", "Failed to delete book");
            }

            // Redirect back to book management page
            response.sendRedirect(request.getContextPath() + "/admin/manage-books.jsp");

        } catch (Exception e) {
            System.err.println("Error deleting book: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/manage-books.jsp");
        }
    }

    /**
     * Handles GET requests - redirects to POST for security
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // For security, better to handle deletion via POST instead of GET
        // Redirect to the book management page if someone tries GET
        response.sendRedirect(request.getContextPath() + "/admin/manage-books.jsp");
    }
}
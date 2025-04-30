package com.bookstore.servlet.book;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.bookstore.model.book.Book;
import com.bookstore.model.book.BookManager;
import com.bookstore.model.book.EBook;
import com.bookstore.model.book.PhysicalBook;
import com.bookstore.model.review.ReviewManager;

/**
 * Servlet for handling book details display
 */
@WebServlet("/book-details")
public class BookDetailsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests - display book details
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get book ID from request
        String bookId = request.getParameter("id");

        if (bookId == null || bookId.trim().isEmpty()) {
            // Redirect to book search if no ID provided
            response.sendRedirect(request.getContextPath() + "/books");
            return;
        }

        // Get book details
        BookManager bookManager = new BookManager(getServletContext());
        Book book = bookManager.getBookById(bookId);

        if (book == null) {
            // Book not found
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Book not found");
            response.sendRedirect(request.getContextPath() + "/books");
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

        // Get related books (same author or genre) for recommendations
        Book[] sameAuthorBooks = bookManager.searchByAuthor(book.getAuthor());
        Book[] sameGenreBooks = bookManager.searchByGenre(book.getGenre());

        // Filter out the current book from recommendations
        java.util.List<Book> relatedBooks = new java.util.ArrayList<>();

        // Add same author books first (except the current book)
        if (sameAuthorBooks != null) {
            for (Book authorBook : sameAuthorBooks) {
                if (!authorBook.getId().equals(book.getId())) {
                    relatedBooks.add(authorBook);
                    if (relatedBooks.size() >= 4) break; // Limit to 4 books
                }
            }
        }

        // Add same genre books if we haven't filled the recommendations yet
        if (sameGenreBooks != null && relatedBooks.size() < 4) {
            for (Book genreBook : sameGenreBooks) {
                // Skip current book and books already added from same author
                if (!genreBook.getId().equals(book.getId()) && !relatedBooks.contains(genreBook)) {
                    relatedBooks.add(genreBook);
                    if (relatedBooks.size() >= 4) break; // Limit to 4 books
                }
            }
        }

        // Set related books in request
        request.setAttribute("relatedBooks", relatedBooks.toArray(new Book[0]));

        // Get review count - we'll use the number of ratings from the book
        int reviewsCount = book.getNumberOfRatings();
        request.setAttribute("reviewsCount", reviewsCount);

        // Forward to book details page
        request.getRequestDispatcher("/book/book-details.jsp").forward(request, response);
    }

    /**
     * Handles POST requests if needed
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Optionally handle POST requests, if required
        doGet(request, response);
    }
}
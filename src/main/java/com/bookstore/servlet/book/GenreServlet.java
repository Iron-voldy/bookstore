package com.bookstore.servlet.book;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.bookstore.model.book.Book;
import com.bookstore.model.book.BookManager;
import com.bookstore.util.QuickSort;

/**
 * Servlet for handling genre-specific book browsing
 */
@WebServlet("/genre")
public class GenreServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests - display genre-specific book page
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get genre parameter
        String genre = request.getParameter("genre");

        if (genre == null || genre.trim().isEmpty()) {
            // If no genre specified, redirect to all books
            response.sendRedirect(request.getContextPath() + "/books");
            return;
        }

        // Get book manager and fetch books by genre
        BookManager bookManager = new BookManager(getServletContext());
        Book[] genreBooks = bookManager.searchByGenre(genre);

        // Sort by rating using QuickSort
        QuickSort.sort(genreBooks, (b1, b2) -> Double.compare(b2.getAverageRating(), b1.getAverageRating()));

        // Set attributes in request
        request.setAttribute("genre", genre);
        request.setAttribute("genreBooks", genreBooks);

        // Get top books (up to 5) for featured section
        int topBooksCount = Math.min(5, genreBooks.length);
        Book[] topBooks = new Book[topBooksCount];
        System.arraycopy(genreBooks, 0, topBooks, 0, topBooksCount);
        request.setAttribute("topBooks", topBooks);

        // Forward to the genre page
        request.getRequestDispatcher("/book/genre-books.jsp").forward(request, response);
    }
}
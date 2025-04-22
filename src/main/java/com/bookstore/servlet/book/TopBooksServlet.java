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
 * Servlet for handling top books display (top rated, newest, featured)
 */
@WebServlet("/top-books")
public class TopBooksServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests - display top books page
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get BookManager
        BookManager bookManager = new BookManager(getServletContext());
        Book[] allBooks = bookManager.getAllBooks();

        // Get top rated books using QuickSort
        Book[] topRatedBooks = allBooks.clone();
        QuickSort.sort(topRatedBooks, (b1, b2) -> Double.compare(b2.getAverageRating(), b1.getAverageRating()));

        // Get top 10 books (or less if fewer books exist)
        int topCount = Math.min(10, topRatedBooks.length);
        Book[] topBooks = new Book[topCount];
        System.arraycopy(topRatedBooks, 0, topBooks, 0, topCount);

        // Get newest arrivals
        Book[] newestArrivalBooks = allBooks.clone();
        QuickSort.sort(newestArrivalBooks, (b1, b2) -> b2.getAddedDate().compareTo(b1.getAddedDate()));

        // Get top 10 newest books
        Book[] newestBooks = new Book[topCount];
        System.arraycopy(newestArrivalBooks, 0, newestBooks, 0, topCount);

        // Get featured books
        java.util.List<Book> featuredList = new java.util.ArrayList<>();
        for (Book book : allBooks) {
            if (book.isFeatured()) {
                featuredList.add(book);
                if (featuredList.size() >= 10) break;
            }
        }
        Book[] featuredBooks = featuredList.toArray(new Book[0]);

        // Set attributes in request
        request.setAttribute("topRatedBooks", topBooks);
        request.setAttribute("newestBooks", newestBooks);
        request.setAttribute("featuredBooks", featuredBooks);

        // Collect all genres for navigation
        java.util.Set<String> genres = new java.util.TreeSet<>();
        for (Book book : allBooks) {
            if (book.getGenre() != null && !book.getGenre().isEmpty()) {
                genres.add(book.getGenre());
            }
        }
        request.setAttribute("genres", genres.toArray(new String[0]));

        // Forward to the top books page
        request.getRequestDispatcher("/book/top-books.jsp").forward(request, response);
    }
}
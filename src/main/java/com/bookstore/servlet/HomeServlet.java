package com.bookstore.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.bookstore.model.book.Book;
import com.bookstore.model.book.BookManager;

/**
 * Servlet for handling the home page
 */
@WebServlet("/home")
public class HomeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests - display the home page with featured books
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get BookManager
        BookManager bookManager = new BookManager(getServletContext());

        // Get featured books
        Book[] featuredBooks = bookManager.getFeaturedBooks();

        // If no featured books, get top rated books
        if (featuredBooks == null || featuredBooks.length == 0) {
            featuredBooks = bookManager.getTopRatedBooks(3);
        }

        // Set attributes in request
        request.setAttribute("featuredBooks", featuredBooks);

        // Forward to the home page
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}
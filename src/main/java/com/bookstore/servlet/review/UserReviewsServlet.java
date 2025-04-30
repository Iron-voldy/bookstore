package com.bookstore.servlet.review;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.bookstore.model.book.Book;
import com.bookstore.model.book.BookManager;
import com.bookstore.model.review.Review;
import com.bookstore.model.review.ReviewManager;

/**
 * Servlet for displaying a user's reviews
 */
@WebServlet("/user-reviews")
public class UserReviewsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests - display user's reviews
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        String userId = (session != null) ? (String) session.getAttribute("userId") : null;

        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get user's reviews
        ReviewManager reviewManager = new ReviewManager(getServletContext());
        List<Review> userReviews = reviewManager.getUserReviews(userId);

        // Get book details for each review
        BookManager bookManager = new BookManager(getServletContext());
        Map<String, Book> bookMap = new HashMap<>();

        for (Review review : userReviews) {
            String bookId = review.getBookId();
            if (!bookMap.containsKey(bookId)) {
                Book book = bookManager.getBookById(bookId);
                if (book != null) {
                    bookMap.put(bookId, book);
                }
            }
        }

        // Set attributes for the JSP
        request.setAttribute("userReviews", userReviews);
        request.setAttribute("bookMap", bookMap);

        // Forward to the user reviews page
        request.getRequestDispatcher("/review/user-reviews.jsp").forward(request, response);
    }
}
package com.bookstore.servlet.review;

import java.io.IOException;
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
import com.bookstore.util.ValidationUtil;

/**
 * Servlet for handling adding new reviews
 */
@WebServlet("/add-book-review")
public class AddReviewServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests - displays the add review form
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get book ID from request
        String bookId = request.getParameter("bookId");

        if (ValidationUtil.isNullOrEmpty(bookId)) {
            response.sendRedirect(request.getContextPath() + "/books");
            return;
        }

        // Get book details
        BookManager bookManager = new BookManager(getServletContext());
        Book book = bookManager.getBookById(bookId);

        if (book == null) {
            request.getSession().setAttribute("errorMessage", "Book not found");
            response.sendRedirect(request.getContextPath() + "/books");
            return;
        }

        // Check if user is logged in
        HttpSession session = request.getSession(false);
        String userId = (session != null) ? (String) session.getAttribute("userId") : null;

        // Check if user has already reviewed this book
        ReviewManager reviewManager = new ReviewManager(getServletContext());
        boolean hasReviewed = reviewManager.hasUserReviewedBook(userId, bookId);

        if (hasReviewed) {
            request.getSession().setAttribute("errorMessage", "You have already reviewed this book");
            response.sendRedirect(request.getContextPath() + "/book-details?id=" + bookId);
            return;
        }

        // Set book and review attributes
        request.setAttribute("book", book);
        request.setAttribute("hasVerifiedPurchase", false); // Implement purchase verification logic

        // Forward to review page
        request.getRequestDispatcher("/review/add-review.jsp").forward(request, response);
    }

    /**
     * Handles POST requests - processes the review submission
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get parameters
        String bookId = request.getParameter("bookId");
        String ratingStr = request.getParameter("rating");
        String comment = request.getParameter("comment");

        // Validate inputs
        if (ValidationUtil.isNullOrEmpty(bookId) ||
                ValidationUtil.isNullOrEmpty(ratingStr) ||
                ValidationUtil.isNullOrEmpty(comment)) {
            request.setAttribute("errorMessage", "All fields are required");
            doGet(request, response);
            return;
        }

        // Parse rating
        int rating;
        try {
            rating = Integer.parseInt(ratingStr);
            if (rating < 1 || rating > 5) {
                throw new NumberFormatException("Invalid rating");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid rating");
            doGet(request, response);
            return;
        }

        // Get session details
        HttpSession session = request.getSession(false);
        String userId = (session != null) ? (String) session.getAttribute("userId") : null;
        String userName = (session != null) ? (String) session.getAttribute("username") : null;

        // Get review manager
        ReviewManager reviewManager = new ReviewManager(getServletContext());

        // Add review based on user status
        Review review;
        if (userId != null) {
            // Try verified review first
            review = reviewManager.addVerifiedReview(userId, userName, bookId, comment, rating);

            // If verified review fails, try standard review
            if (review == null) {
                review = reviewManager.addStandardReview(userId, userName, bookId, comment, rating);
            }
        } else {
            // Guest review
            String guestName = request.getParameter("guestName");
            if (ValidationUtil.isNullOrEmpty(guestName)) {
                request.setAttribute("errorMessage", "Name is required for guest reviews");
                doGet(request, response);
                return;
            }

            review = reviewManager.addGuestReview(guestName, bookId, comment, rating);
        }

        // Handle review submission result
        if (review != null) {
            request.getSession().setAttribute("successMessage", "Your review has been submitted successfully");
        } else {
            request.getSession().setAttribute("errorMessage", "Failed to submit review");
        }

        // Redirect to book details page
        response.sendRedirect(request.getContextPath() + "/book-details?id=" + bookId);
    }
}
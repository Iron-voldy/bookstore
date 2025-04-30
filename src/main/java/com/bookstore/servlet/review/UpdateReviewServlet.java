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
 * Servlet for handling review updates
 */
@WebServlet("/update-book-review")
public class UpdateReviewServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests - display the edit review form
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

        String reviewId = request.getParameter("reviewId");

        if (ValidationUtil.isNullOrEmpty(reviewId)) {
            response.sendRedirect(request.getContextPath() + "/books");
            return;
        }

        // Get review details
        ReviewManager reviewManager = new ReviewManager(getServletContext());
        Review review = reviewManager.getReviewById(reviewId);

        if (review == null) {
            session.setAttribute("errorMessage", "Review not found");
            response.sendRedirect(request.getContextPath() + "/books");
            return;
        }

        // Check if the review belongs to the user
        if (!userId.equals(review.getUserId())) {
            session.setAttribute("errorMessage", "You do not have permission to edit this review");
            response.sendRedirect(request.getContextPath() + "/books");
            return;
        }

        // Get book details
        BookManager bookManager = new BookManager(getServletContext());
        Book book = bookManager.getBookById(review.getBookId());

        if (book == null) {
            session.setAttribute("errorMessage", "Book not found");
            response.sendRedirect(request.getContextPath() + "/books");
            return;
        }

        // Set attributes for the JSP
        request.setAttribute("review", review);
        request.setAttribute("book", book);

        // Forward to the edit review page
        request.getRequestDispatcher("/review/edit-review.jsp").forward(request, response);
    }

    /**
     * Handles POST requests - process the review update
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        String userId = (session != null) ? (String) session.getAttribute("userId") : null;

        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get parameters
        String reviewId = request.getParameter("reviewId");
        String rating = request.getParameter("rating");
        String comment = request.getParameter("comment");

        // Validate inputs
        if (ValidationUtil.isNullOrEmpty(reviewId) ||
                ValidationUtil.isNullOrEmpty(rating) ||
                ValidationUtil.isNullOrEmpty(comment)) {
            request.setAttribute("errorMessage", "All fields are required");
            doGet(request, response);
            return;
        }

        try {
            int ratingValue = Integer.parseInt(rating);

            if (ratingValue < 1 || ratingValue > 5) {
                request.setAttribute("errorMessage", "Rating must be between 1 and 5");
                doGet(request, response);
                return;
            }

            // Get review manager
            ReviewManager reviewManager = new ReviewManager(getServletContext());

            // Get the review to check permissions and get the book ID
            Review review = reviewManager.getReviewById(reviewId);
            if (review == null) {
                session.setAttribute("errorMessage", "Review not found");
                response.sendRedirect(request.getContextPath() + "/books");
                return;
            }

            // Check if the review belongs to the user
            if (!userId.equals(review.getUserId())) {
                session.setAttribute("errorMessage", "You do not have permission to edit this review");
                response.sendRedirect(request.getContextPath() + "/books");
                return;
            }

            // Update the review
            boolean updated = reviewManager.updateReview(reviewId, userId, comment, ratingValue);

            if (updated) {
                session.setAttribute("successMessage", "Review updated successfully");
                response.sendRedirect(request.getContextPath() + "/book-reviews?bookId=" + review.getBookId());
            } else {
                request.setAttribute("errorMessage", "Failed to update review");
                doGet(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid rating format");
            doGet(request, response);
        }
    }
}
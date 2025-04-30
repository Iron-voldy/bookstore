package com.bookstore.servlet.review;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.bookstore.model.review.Review;
import com.bookstore.model.review.ReviewManager;
import com.bookstore.util.ValidationUtil;

@WebServlet("/delete-book-review")
public class DeleteReviewServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get review ID
        String reviewId = request.getParameter("reviewId");

        if (ValidationUtil.isNullOrEmpty(reviewId)) {
            response.sendRedirect(request.getContextPath() + "/books");
            return;
        }

        // Check user authentication
        HttpSession session = request.getSession(false);
        String userId = (session != null) ? (String) session.getAttribute("userId") : null;

        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get review manager and find review
        ReviewManager reviewManager = new ReviewManager(getServletContext());
        Review review = reviewManager.getReviewById(reviewId);

        if (review == null) {
            request.getSession().setAttribute("errorMessage", "Review not found");
            response.sendRedirect(request.getContextPath() + "/books");
            return;
        }

        // Verify user owns the review
        if (!userId.equals(review.getUserId())) {
            request.getSession().setAttribute("errorMessage", "You are not authorized to delete this review");
            response.sendRedirect(request.getContextPath() + "/books");
            return;
        }

        // Set review and book details for confirmation
        request.setAttribute("review", review);
        request.setAttribute("bookId", review.getBookId());
        request.getRequestDispatcher("/review/delete-review.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get review ID
        String reviewId = request.getParameter("reviewId");
        String confirm = request.getParameter("confirm");

        if (ValidationUtil.isNullOrEmpty(reviewId)) {
            response.sendRedirect(request.getContextPath() + "/books");
            return;
        }

        // Check user authentication
        HttpSession session = request.getSession(false);
        String userId = (session != null) ? (String) session.getAttribute("userId") : null;

        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get review manager
        ReviewManager reviewManager = new ReviewManager(getServletContext());
        Review review = reviewManager.getReviewById(reviewId);

        if (review == null) {
            request.getSession().setAttribute("errorMessage", "Review not found");
            response.sendRedirect(request.getContextPath() + "/books");
            return;
        }

        // Verify user owns the review
        if (!userId.equals(review.getUserId())) {
            request.getSession().setAttribute("errorMessage", "You are not authorized to delete this review");
            response.sendRedirect(request.getContextPath() + "/books");
            return;
        }

        // Check confirmation
        if ("yes".equals(confirm)) {
            // Attempt to delete review
            boolean deleted = reviewManager.deleteReview(reviewId, userId);

            if (deleted) {
                request.getSession().setAttribute("successMessage", "Review deleted successfully");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to delete review");
            }
        }

        // Redirect to book details page
        response.sendRedirect(request.getContextPath() + "/book-details?id=" + review.getBookId());
    }
}
package com.bookstore.servlet.user;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.bookstore.model.user.User;
import com.bookstore.model.user.UserManager;
import com.bookstore.util.ValidationUtil;

/**
 * Servlet for handling password change requests
 */
@WebServlet("/change-password")
public class ChangePasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles POST requests - process the password change
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            // Not logged in, redirect to login
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get user ID from session
        String userId = (String) session.getAttribute("userId");

        // Get form parameters
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validate input
        if (currentPassword == null || newPassword == null || confirmPassword == null ||
                currentPassword.trim().isEmpty() || newPassword.trim().isEmpty() ||
                confirmPassword.trim().isEmpty()) {
            session.setAttribute("errorMessage", "All password fields are required");
            response.sendRedirect(request.getContextPath() + "/user/profile.jsp");
            return;
        }

        // Check if passwords match
        if (!newPassword.equals(confirmPassword)) {
            session.setAttribute("errorMessage", "New passwords do not match");
            response.sendRedirect(request.getContextPath() + "/user/profile.jsp");
            return;
        }

        // Validate password strength
        if (!ValidationUtil.isValidPassword(newPassword)) {
            session.setAttribute("errorMessage", "Password must be at least 8 characters and include uppercase, lowercase, numbers, and special characters");
            response.sendRedirect(request.getContextPath() + "/user/profile.jsp");
            return;
        }

        // Attempt to change password
        UserManager userManager = new UserManager(getServletContext());
        boolean success = userManager.changePassword(userId, currentPassword, newPassword);

        if (success) {
            session.setAttribute("successMessage", "Password changed successfully");
            response.sendRedirect(request.getContextPath() + "/user/profile.jsp");
        } else {
            session.setAttribute("errorMessage", "Current password is incorrect");
            response.sendRedirect(request.getContextPath() + "/user/profile.jsp");
        }
    }
}
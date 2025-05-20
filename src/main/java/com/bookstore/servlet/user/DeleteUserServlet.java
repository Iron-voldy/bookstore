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

/**
 * Servlet for handling user account deletion
 */
@WebServlet("/delete-user")
public class DeleteUserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles POST requests - process the user deletion
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

        // Get current user ID and the user ID to delete
        String currentUserId = (String) session.getAttribute("userId");
        String userIdToDelete = request.getParameter("userId");
        String confirmPassword = request.getParameter("confirmPassword");

        // If no userIdToDelete is provided, assume self-deletion
        if (userIdToDelete == null || userIdToDelete.trim().isEmpty()) {
            userIdToDelete = currentUserId;
        }

        // Check if user is trying to delete their own account
        boolean isSelfDeletion = userIdToDelete.equals(currentUserId);

        // For self-deletion, password confirmation is required
        if (isSelfDeletion && (confirmPassword == null || confirmPassword.trim().isEmpty())) {
            session.setAttribute("errorMessage", "Please confirm your password to delete your account");
            response.sendRedirect(request.getContextPath() + "/user/profile.jsp");
            return;
        }

        // Get user manager
        UserManager userManager = new UserManager(getServletContext());

        // If self-deletion, verify password
        if (isSelfDeletion) {
            User currentUser = userManager.getUserById(currentUserId);
            if (currentUser == null || !currentUser.authenticate(confirmPassword)) {
                session.setAttribute("errorMessage", "Incorrect password. Account deletion failed.");
                response.sendRedirect(request.getContextPath() + "/user/profile.jsp");
                return;
            }
        }
        // If not self-deletion, check if user has admin rights (only admins can delete other users)
        else {
            Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
            if (isAdmin == null || !isAdmin) {
                session.setAttribute("errorMessage", "You do not have permission to delete other user accounts");
                response.sendRedirect(request.getContextPath() + "/user/profile.jsp");
                return;
            }
        }

        // Attempt to delete the user
        boolean deleted = userManager.deleteUser(userIdToDelete);

        if (deleted) {
            // If self-deletion, invalidate session and redirect to home
            if (isSelfDeletion) {
                session.setAttribute("successMessage", "Your account has been successfully deleted");
                session.invalidate();

                // Create a new session for the message
                HttpSession newSession = request.getSession(true);
                newSession.setAttribute("successMessage", "Your account has been successfully deleted");

                response.sendRedirect(request.getContextPath() + "/");
            }
            // If admin deleting another user, redirect to admin user management
            else {
                session.setAttribute("successMessage", "User account has been successfully deleted");
                response.sendRedirect(request.getContextPath() + "/admin/users");
            }
        } else {
            session.setAttribute("errorMessage", "Failed to delete the user account. Please try again.");
            if (isSelfDeletion) {
                response.sendRedirect(request.getContextPath() + "/user/profile.jsp");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/users");
            }
        }
    }
}
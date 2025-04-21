package com.bookstore.servlet.user;

import java.io.IOException;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.bookstore.model.user.PremiumUser;
import com.bookstore.model.user.RegularUser;
import com.bookstore.model.user.User;
import com.bookstore.model.user.UserManager;
import com.bookstore.util.ValidationUtil;

/**
 * Servlet for handling user profile updates
 */
@WebServlet("/update-profile")
public class UpdateProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests - display the update profile form
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
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

        // Create UserManager and get user
        UserManager userManager = new UserManager(getServletContext());
        User user = userManager.getUserById(userId);

        if (user == null) {
            // User not found (should not happen normally)
            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Add user to request attributes
        request.setAttribute("user", user);

        // Forward to update profile page
        request.getRequestDispatcher("/user/update-profile.jsp").forward(request, response);
    }

    /**
     * Handles POST requests - process the update profile form
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

        // Create UserManager and get user
        UserManager userManager = new UserManager(getServletContext());
        User user = userManager.getUserById(userId);

        if (user == null) {
            // User not found (should not happen normally)
            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get form parameters
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        String upgradeAccount = request.getParameter("upgradeAccount");

        // Validate email format if provided
        if (email != null && !email.trim().isEmpty() && !ValidationUtil.isValidEmail(email)) {
            request.setAttribute("errorMessage", "Invalid email format");
            request.setAttribute("user", user);
            request.getRequestDispatcher("/user/update-profile.jsp").forward(request, response);
            return;
        }

        // Check if current password is correct if they want to change password
        if (newPassword != null && !newPassword.trim().isEmpty()) {
            if (currentPassword == null || !user.authenticate(currentPassword)) {
                request.setAttribute("errorMessage", "Current password is incorrect");
                request.setAttribute("user", user);
                request.getRequestDispatcher("/user/update-profile.jsp").forward(request, response);
                return;
            }

            // Check if new passwords match
            if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("errorMessage", "New passwords do not match");
                request.setAttribute("user", user);
                request.getRequestDispatcher("/user/update-profile.jsp").forward(request, response);
                return;
            }

            // Validate password strength
            if (!ValidationUtil.isValidPassword(newPassword)) {
                request.setAttribute("errorMessage", "Password must be at least 8 characters and include uppercase, lowercase, numbers, and special characters");
                request.setAttribute("user", user);
                request.getRequestDispatcher("/user/update-profile.jsp").forward(request, response);
                return;
            }

            // Update password
            user.setPassword(newPassword);
        }

        // Update fullName if provided
        if (fullName != null && !fullName.trim().isEmpty()) {
            user.setFullName(fullName);
        }

        // Update email if provided
        if (email != null && !email.trim().isEmpty()) {
            user.setEmail(email);
        }

        // Handle account upgrade if requested
        boolean upgraded = false;
        if ("yes".equals(upgradeAccount) && user instanceof RegularUser) {
            upgraded = userManager.upgradeToPremium(userId);
            // Get the newly upgraded user
            if (upgraded) {
                user = userManager.getUserById(userId);
            }
        } else {
            // Just update the existing user
            userManager.updateUser(user);
        }

        // Update session with new user data
        session.setAttribute("user", user);

        // Update user type in session if upgraded
        if (upgraded && user instanceof PremiumUser) {
            session.setAttribute("userType", "premium");
            PremiumUser premiumUser = (PremiumUser)user;
            session.setAttribute("membershipTier", premiumUser.getMembershipTier());
            session.setAttribute("rewardPoints", premiumUser.getRewardPoints());
            session.setAttribute("subscriptionActive", premiumUser.isSubscriptionActive());
        }

        // Set success message
        if (upgraded) {
            session.setAttribute("successMessage", "Profile updated successfully! Your account has been upgraded to Premium.");
        } else {
            session.setAttribute("successMessage", "Profile updated successfully!");
        }

        // Redirect back to profile page
        response.sendRedirect(request.getContextPath() + "/user/profile.jsp");
    }
}
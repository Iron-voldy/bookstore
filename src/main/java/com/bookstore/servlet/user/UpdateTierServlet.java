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
import com.bookstore.model.user.PremiumUser;

/**
 * Servlet for handling premium membership tier updates
 */
@WebServlet("/update-tier")
public class UpdateTierServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles POST requests - process the tier update
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
        String newTier = request.getParameter("newTier");

        // Validate input
        if (newTier == null || newTier.trim().isEmpty() ||
                (!newTier.equals("SILVER") && !newTier.equals("GOLD") && !newTier.equals("PLATINUM"))) {
            session.setAttribute("errorMessage", "Invalid membership tier selection");
            response.sendRedirect(request.getContextPath() + "/user/profile.jsp");
            return;
        }

        // Get user manager
        UserManager userManager = new UserManager(getServletContext());

        // Get current user
        User user = userManager.getUserById(userId);

        // Check if user is premium
        if (!(user instanceof PremiumUser)) {
            session.setAttribute("errorMessage", "Only Premium users can change membership tiers");
            response.sendRedirect(request.getContextPath() + "/user/profile.jsp");
            return;
        }

        PremiumUser premiumUser = (PremiumUser) user;

        // Process payment change (in a real application) - simplified here

        // Update membership tier
        boolean success = premiumUser.upgradeTier(newTier);

        if (success) {
            // Update user in database
            userManager.updateUser(premiumUser);

            // Update session attributes
            session.setAttribute("user", premiumUser);
            session.setAttribute("membershipTier", premiumUser.getMembershipTier());

            session.setAttribute("successMessage", "Your membership has been updated to " + newTier + " Tier!");
            response.sendRedirect(request.getContextPath() + "/user/profile.jsp");
        } else {
            session.setAttribute("errorMessage", "Failed to update your membership tier. Please try again.");
            response.sendRedirect(request.getContextPath() + "/user/profile.jsp");
        }
    }
}
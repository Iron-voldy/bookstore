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
 * Servlet for handling account upgrades to premium
 */
@WebServlet("/upgrade-to-premium")
public class UpgradeToPremiumServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests - display the upgrade page
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

        // Get user details
        UserManager userManager = new UserManager(getServletContext());
        User user = userManager.getUserById(userId);

        // Check if user is already premium
        if (user instanceof PremiumUser) {
            session.setAttribute("errorMessage", "Your account is already a Premium account");
            response.sendRedirect(request.getContextPath() + "/user/profile.jsp");
            return;
        }

        // Set user in request and forward to upgrade page
        request.setAttribute("user", user);
        request.getRequestDispatcher("/user/upgrade-premium.jsp").forward(request, response);
    }

    /**
     * Handles POST requests - process the upgrade
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

        // Get user manager
        UserManager userManager = new UserManager(getServletContext());

        // Get current user
        User user = userManager.getUserById(userId);

        // Check if user is already premium
        if (user instanceof PremiumUser) {
            session.setAttribute("errorMessage", "Your account is already a Premium account");
            response.sendRedirect(request.getContextPath() + "/user/profile.jsp");
            return;
        }

        // Process payment (in a real application) - simplified here
        // This would normally involve integrating with a payment gateway

        // Upgrade account to premium
        boolean success = userManager.upgradeToPremium(userId);

        if (success) {
            // Update the user in the session
            user = userManager.getUserById(userId);
            session.setAttribute("user", user);
            session.setAttribute("userType", "premium");

            if (user instanceof PremiumUser) {
                PremiumUser premiumUser = (PremiumUser) user;
                session.setAttribute("membershipTier", premiumUser.getMembershipTier());
                session.setAttribute("rewardPoints", premiumUser.getRewardPoints());
                session.setAttribute("subscriptionActive", premiumUser.isSubscriptionActive());
            }

            session.setAttribute("successMessage", "Your account has been upgraded to Premium! Enjoy your free trial.");
            response.sendRedirect(request.getContextPath() + "/user/profile.jsp");
        } else {
            session.setAttribute("errorMessage", "Failed to upgrade your account. Please try again.");
            response.sendRedirect(request.getContextPath() + "/upgrade-to-premium");
        }
    }
}
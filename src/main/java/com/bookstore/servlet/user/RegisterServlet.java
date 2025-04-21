package com.bookstore.servlet.user;

import java.io.IOException;
import java.util.Calendar;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.bookstore.model.user.PremiumUser;
import com.bookstore.model.user.RegularUser;
import com.bookstore.model.user.UserManager;
import com.bookstore.util.ValidationUtil;

/**
 * Servlet for handling user registration
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests - display the registration form
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is already logged in
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            // User is already logged in, redirect to home page
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        // Forward to the registration page
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    /**
     * Handles POST requests - process the registration form
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get form parameters
        String fullName = request.getParameter("fullName");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String premiumAccount = request.getParameter("premiumAccount");
        String termsAgreement = request.getParameter("termsAgreement");

        // Debug logging
        System.out.println("RegisterServlet: Processing registration for user: " + username);
        System.out.println("RegisterServlet: Email: " + email);
        System.out.println("RegisterServlet: Full Name: " + fullName);
        System.out.println("RegisterServlet: Premium Account: " + premiumAccount);

        // Validate all required fields
        if (fullName == null || username == null || email == null || password == null ||
                confirmPassword == null || termsAgreement == null ||
                fullName.trim().isEmpty() || username.trim().isEmpty() ||
                email.trim().isEmpty() || password.trim().isEmpty() ||
                confirmPassword.trim().isEmpty()) {

            request.setAttribute("errorMessage", "All fields are required");
            request.setAttribute("fullName", fullName);
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // Validate terms agreement
        if (!"on".equals(termsAgreement)) {
            request.setAttribute("errorMessage", "You must agree to the Terms of Service and Privacy Policy");
            request.setAttribute("fullName", fullName);
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // Validate password match
        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match");
            request.setAttribute("fullName", fullName);
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // Validate username format
        if (!ValidationUtil.isValidUsername(username)) {
            request.setAttribute("errorMessage", "Username must be 3-20 characters and can only contain letters, numbers, and underscores");
            request.setAttribute("fullName", fullName);
            request.setAttribute("email", email);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // Validate email format
        if (!ValidationUtil.isValidEmail(email)) {
            request.setAttribute("errorMessage", "Invalid email format");
            request.setAttribute("fullName", fullName);
            request.setAttribute("username", username);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // Validate password strength
        if (!ValidationUtil.isValidPassword(password)) {
            request.setAttribute("errorMessage", "Password must be at least 8 characters and include uppercase, lowercase, numbers, and special characters");
            request.setAttribute("fullName", fullName);
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        try {
            // Create UserManager
            UserManager userManager = new UserManager(getServletContext());

            // Check if username already exists
            if (userManager.getUserByUsername(username) != null) {
                request.setAttribute("errorMessage", "Username already exists");
                request.setAttribute("fullName", fullName);
                request.setAttribute("email", email);
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }

            // Create a new user based on account type
            boolean isPremium = "on".equals(premiumAccount);

            if (isPremium) {
                // Create premium user
                PremiumUser user = new PremiumUser();
                user.setUsername(username);
                user.setPassword(password);
                user.setEmail(email);
                user.setFullName(fullName);

                // Set premium-specific properties
                Calendar calendar = Calendar.getInstance();
                calendar.add(Calendar.YEAR, 1); // 1 year subscription
                user.setSubscriptionExpiryDate(calendar.getTime());
                user.setMembershipTier("SILVER");
                user.setRewardPoints(100); // Welcome bonus

                // Add user
                boolean success = userManager.addUser(user);

                if (success) {
                    HttpSession session = request.getSession();
                    session.setAttribute("successMessage", "Registration successful! You have been registered as a premium user. Enjoy your 30-day free trial!");
                    response.sendRedirect(request.getContextPath() + "/login");
                } else {
                    request.setAttribute("errorMessage", "Registration failed. Please try again.");
                    request.getRequestDispatcher("/register.jsp").forward(request, response);
                }
            } else {
                // Create regular user
                RegularUser user = new RegularUser();
                user.setUsername(username);
                user.setPassword(password);
                user.setEmail(email);
                user.setFullName(fullName);
                user.setLoyaltyPoints(50); // Welcome bonus

                // Add user
                boolean success = userManager.addUser(user);

                if (success) {
                    HttpSession session = request.getSession();
                    session.setAttribute("successMessage", "Registration successful! Please login to continue.");
                    response.sendRedirect(request.getContextPath() + "/login");
                } else {
                    request.setAttribute("errorMessage", "Registration failed. Please try again.");
                    request.getRequestDispatcher("/register.jsp").forward(request, response);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred during registration: " + e.getMessage());
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
}
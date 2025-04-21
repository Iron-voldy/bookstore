package com.bookstore.servlet.user;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.bookstore.model.user.User;
import com.bookstore.model.user.UserManager;
import com.bookstore.model.user.PremiumUser;
import com.bookstore.model.user.RegularUser;

/**
 * Servlet for handling user login
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests - display the login form
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

        // Check for "remember me" cookie
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("rememberedUser".equals(cookie.getName())) {
                    String username = cookie.getValue();
                    if (username != null && !username.isEmpty()) {
                        request.setAttribute("rememberedUsername", username);
                        request.setAttribute("rememberMe", "checked");
                    }
                    break;
                }
            }
        }

        // Forward to the login page
        request.getRequestDispatcher("/user/login.jsp").forward(request, response);
    }

    /**
     * Handles POST requests - process the login form
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get form parameters
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String rememberMe = request.getParameter("rememberMe");

        System.out.println("LoginServlet: Login attempt for user: " + username);

        // Validate input
        if (username == null || password == null ||
                username.trim().isEmpty() || password.trim().isEmpty()) {

            request.setAttribute("errorMessage", "Username and password are required");
            request.getRequestDispatcher("/user/login.jsp").forward(request, response);
            return;
        }

        try {
            // Create UserManager and attempt authentication
            UserManager userManager = new UserManager(getServletContext());
            User user = userManager.authenticateUser(username, password);

            System.out.println("LoginServlet: Authentication result for " + username + ": " + (user != null ? "Success" : "Failed"));

            if (user != null) {
                // Create session and add user
                HttpSession session = request.getSession(true);
                session.setAttribute("user", user);
                session.setAttribute("userId", user.getUserId());
                session.setAttribute("username", user.getUsername());

                // Add user type attribute
                if (user instanceof PremiumUser) {
                    session.setAttribute("userType", "premium");

                    // Add premium-specific attributes
                    PremiumUser premiumUser = (PremiumUser) user;
                    session.setAttribute("membershipTier", premiumUser.getMembershipTier());
                    session.setAttribute("rewardPoints", premiumUser.getRewardPoints());
                    session.setAttribute("subscriptionActive", premiumUser.isSubscriptionActive());
                } else if (user instanceof RegularUser) {
                    session.setAttribute("userType", "regular");

                    // Add regular-specific attributes
                    RegularUser regularUser = (RegularUser) user;
                    session.setAttribute("loyaltyPoints", regularUser.getLoyaltyPoints());
                } else {
                    session.setAttribute("userType", "basic");
                }

                // Set remember-me cookie if requested
                if ("on".equals(rememberMe)) {
                    Cookie userCookie = new Cookie("rememberedUser", username);
                    userCookie.setMaxAge(30 * 24 * 60 * 60); // 30 days
                    userCookie.setPath("/");
                    response.addCookie(userCookie);
                } else {
                    // If "remember me" is not checked, delete the cookie
                    Cookie userCookie = new Cookie("rememberedUser", "");
                    userCookie.setMaxAge(0); // Delete cookie
                    userCookie.setPath("/");
                    response.addCookie(userCookie);
                }

                // Set success message
                session.setAttribute("successMessage", "Welcome back, " + user.getFullName() + "!");

                // Redirect to home page
                response.sendRedirect(request.getContextPath() + "/index.jsp");
            } else {
                // Authentication failed
                request.setAttribute("errorMessage", "Invalid username or password");
                request.setAttribute("username", username);
                if ("on".equals(rememberMe)) {
                    request.setAttribute("rememberMe", "checked");
                }
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            // Log any exceptions
            System.err.println("LoginServlet: Exception occurred during login:");
            e.printStackTrace();

            request.setAttribute("errorMessage", "An error occurred during login: " + e.getMessage());
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

    /**
     * Handles DELETE requests - for logout
     */
    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get the current session
        HttpSession session = request.getSession(false);
        if (session != null) {
            // Log the logout
            String username = (String) session.getAttribute("username");
            if (username != null) {
                System.out.println("LogoutServlet: User logged out: " + username);
            }

            // Invalidate the session
            session.invalidate();

            // Remove the remember-me cookie if it exists
            Cookie[] cookies = request.getCookies();
            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    if ("rememberedUser".equals(cookie.getName())) {
                        cookie.setMaxAge(0);
                        cookie.setPath("/");
                        response.addCookie(cookie);
                        break;
                    }
                }
            }
        }

        // Send a success response
        response.setStatus(HttpServletResponse.SC_OK);
        response.getWriter().write("Logged out successfully");
    }
}
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
import com.bookstore.model.cart.CartManager;

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
        System.out.println("LoginServlet: doGet method called");

        // Check if user is already logged in
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            System.out.println("LoginServlet: User already logged in, redirecting to home page");
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
                        System.out.println("LoginServlet: Found remembered user: " + username);
                    }
                    break;
                }
            }
        }

        // Forward to the login page
        System.out.println("LoginServlet: Forwarding to login page");
        request.getRequestDispatcher("/user/login.jsp").forward(request, response);
    }

    /**
     * Handles POST requests - process the login form
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("LoginServlet: doPost method called");

        // Get form parameters
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String rememberMe = request.getParameter("rememberMe");

        System.out.println("LoginServlet: Login attempt for user: " + username);
        System.out.println("LoginServlet: Remember me: " + (rememberMe != null ? "Yes" : "No"));

        // Validate input
        if (username == null || password == null ||
                username.trim().isEmpty() || password.trim().isEmpty()) {
            System.out.println("LoginServlet: Missing username or password");
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

                // Store the entire user object
                session.setAttribute("user", user);

                // Also store individual attributes for convenience
                session.setAttribute("userId", user.getUserId());
                session.setAttribute("username", user.getUsername());
                session.setAttribute("fullName", user.getFullName());
                session.setAttribute("email", user.getEmail());

                // Print debug information
                System.out.println("LoginServlet: Setting session attributes");
                System.out.println("LoginServlet: Session ID: " + session.getId());
                System.out.println("LoginServlet: User ID: " + user.getUserId());
                System.out.println("LoginServlet: Username: " + user.getUsername());

                // Add user type attribute
                if (user instanceof PremiumUser) {
                    session.setAttribute("userType", "premium");

                    // Add premium-specific attributes
                    PremiumUser premiumUser = (PremiumUser) user;
                    session.setAttribute("membershipTier", premiumUser.getMembershipTier());
                    session.setAttribute("rewardPoints", premiumUser.getRewardPoints());
                    session.setAttribute("subscriptionActive", premiumUser.isSubscriptionActive());

                    System.out.println("LoginServlet: User is Premium - Tier: " + premiumUser.getMembershipTier());
                } else if (user instanceof RegularUser) {
                    session.setAttribute("userType", "regular");

                    // Add regular-specific attributes
                    RegularUser regularUser = (RegularUser) user;
                    session.setAttribute("loyaltyPoints", regularUser.getLoyaltyPoints());

                    System.out.println("LoginServlet: User is Regular - Points: " + regularUser.getLoyaltyPoints());
                } else {
                    session.setAttribute("userType", "basic");
                    System.out.println("LoginServlet: User is Basic");
                }

                // Update cart information if available
                String cartId = (String) session.getAttribute("cartId");
                if (cartId != null) {
                    // Transfer guest cart to user account
                    CartManager cartManager = new CartManager(getServletContext());
                    // Logic to transfer cart would go here
                    // For now, just update the cart count
                    int cartCount = cartManager.getCartItemCount(user.getUserId());
                    session.setAttribute("cartCount", cartCount);
                }

                // Set remember-me cookie if requested
                if ("on".equals(rememberMe)) {
                    Cookie userCookie = new Cookie("rememberedUser", username);
                    userCookie.setMaxAge(30 * 24 * 60 * 60); // 30 days
                    userCookie.setPath("/");
                    response.addCookie(userCookie);
                    System.out.println("LoginServlet: Setting remember-me cookie");
                } else {
                    // If "remember me" is not checked, delete the cookie
                    Cookie userCookie = new Cookie("rememberedUser", "");
                    userCookie.setMaxAge(0); // Delete cookie
                    userCookie.setPath("/");
                    response.addCookie(userCookie);
                    System.out.println("LoginServlet: Removing remember-me cookie");
                }

                // Set success message
                session.setAttribute("successMessage", "Welcome back, " + user.getFullName() + "!");
                System.out.println("LoginServlet: Set success message");

                // Redirect to home page
                System.out.println("LoginServlet: Redirecting to home page");
                response.sendRedirect(request.getContextPath() + "/index.jsp");
            } else {
                // Authentication failed
                System.out.println("LoginServlet: Authentication failed");
                request.setAttribute("errorMessage", "Invalid username or password");
                request.setAttribute("username", username);
                if ("on".equals(rememberMe)) {
                    request.setAttribute("rememberMe", "checked");
                }
                request.getRequestDispatcher("/user/login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            // Log any exceptions
            System.err.println("LoginServlet: Exception occurred during login:");
            e.printStackTrace();

            request.setAttribute("errorMessage", "An error occurred during login: " + e.getMessage());
            request.getRequestDispatcher("/user/login.jsp").forward(request, response);
        }
    }

    /**
     * Handles DELETE requests - for logout
     */
    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("LoginServlet: doDelete method called (logout)");

        // Get the current session
        HttpSession session = request.getSession(false);
        if (session != null) {
            // Log the logout
            String username = (String) session.getAttribute("username");
            if (username != null) {
                System.out.println("LoginServlet: User logged out: " + username);
            }

            // Invalidate the session
            session.invalidate();
            System.out.println("LoginServlet: Session invalidated");

            // Remove the remember-me cookie if it exists
            Cookie[] cookies = request.getCookies();
            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    if ("rememberedUser".equals(cookie.getName())) {
                        cookie.setMaxAge(0);
                        cookie.setPath("/");
                        response.addCookie(cookie);
                        System.out.println("LoginServlet: Removed remember-me cookie");
                        break;
                    }
                }
            }
        }

        // Send a success response
        response.setStatus(HttpServletResponse.SC_OK);
        response.getWriter().write("Logged out successfully");
        System.out.println("LoginServlet: Sent logout success response");
    }
}
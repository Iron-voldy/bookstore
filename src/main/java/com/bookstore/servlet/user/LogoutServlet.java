package com.bookstore.servlet.user;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet for handling user logout
 */
@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests - log out the user
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
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

        // Create a new session for the message
        HttpSession newSession = request.getSession(true);
        newSession.setAttribute("successMessage", "You have been successfully logged out.");

        // Redirect to the login page
        response.sendRedirect(request.getContextPath() + "/login");
    }
}
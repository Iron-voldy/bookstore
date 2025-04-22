package com.bookstore.servlet.admin;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.bookstore.model.admin.Admin;
import com.bookstore.model.admin.AdminManager;

/**
 * Servlet for handling admin login
 */
@WebServlet("/admin/login")
public class AdminLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests - display the login form
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if admin is already logged in
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("adminId") != null) {
            // Admin is already logged in, redirect to dashboard
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }

        // Forward to the login page
        request.getRequestDispatcher("/admin/login.jsp").forward(request, response);
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

        // Validate input
        if (username == null || password == null ||
                username.trim().isEmpty() || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Username and password are required");
            request.getRequestDispatcher("/admin/login.jsp").forward(request, response);
            return;
        }

        // Create AdminManager and attempt authentication
        AdminManager adminManager = new AdminManager(getServletContext());
        Admin admin = adminManager.authenticateAdmin(username, password);

        if (admin != null) {
            // Create session and add admin
            HttpSession session = request.getSession(true);
            session.setAttribute("adminId", admin.getAdminId());
            session.setAttribute("adminUsername", admin.getUsername());
            session.setAttribute("adminFullName", admin.getFullName());
            session.setAttribute("adminRole", admin.getRole());
            session.setAttribute("isSuperAdmin", admin.isSuperAdmin());

            // Set success message
            session.setAttribute("successMessage", "Welcome back, " + admin.getFullName() + "!");

            // Redirect to admin dashboard
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        } else {
            // Authentication failed
            request.setAttribute("errorMessage", "Invalid username or password");
            request.getRequestDispatcher("/admin/login.jsp").forward(request, response);
        }
    }
}
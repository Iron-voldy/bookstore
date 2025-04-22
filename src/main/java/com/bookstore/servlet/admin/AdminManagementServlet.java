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
import java.util.List;
import java.util.UUID;

/**
 * Servlet for handling admin management (list, add, edit, delete)
 */
@WebServlet("/admin/manage-admins")
public class AdminManagementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests - display admin management page
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check admin authentication
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        // Check if super admin (only super admins can manage other admins)
        boolean isSuperAdmin = (Boolean) session.getAttribute("isSuperAdmin");
        if (!isSuperAdmin) {
            session.setAttribute("errorMessage", "Access denied. Only super admins can manage administrators.");
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }

        // Get all admins
        AdminManager adminManager = new AdminManager(getServletContext());
        List<Admin> allAdmins = adminManager.getAllAdmins();

        // Set attributes for the page
        request.setAttribute("admins", allAdmins);

        // Forward to admin management page
        request.getRequestDispatcher("/admin/manage-admins.jsp").forward(request, response);
    }

    /**
     * Handles POST requests - process admin actions (add, edit, delete)
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check admin authentication
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        // Check if super admin
        boolean isSuperAdmin = (Boolean) session.getAttribute("isSuperAdmin");
        if (!isSuperAdmin) {
            session.setAttribute("errorMessage", "Access denied. Only super admins can manage administrators.");
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }

        // Get action parameter
        String action = request.getParameter("action");

        if (action == null || action.isEmpty()) {
            session.setAttribute("errorMessage", "Invalid action");
            response.sendRedirect(request.getContextPath() + "/admin/manage-admins");
            return;
        }

        AdminManager adminManager = new AdminManager(getServletContext());

        switch (action) {
            case "add":
                addAdmin(request, response, adminManager, session);
                break;
            case "edit":
                editAdmin(request, response, adminManager, session);
                break;
            case "delete":
                deleteAdmin(request, response, adminManager, session);
                break;
            case "activate":
                activateAdmin(request, response, adminManager, session);
                break;
            case "deactivate":
                deactivateAdmin(request, response, adminManager, session);
                break;
            case "resetPassword":
                resetAdminPassword(request, response, adminManager, session);
                break;
            default:
                session.setAttribute("errorMessage", "Invalid action");
                response.sendRedirect(request.getContextPath() + "/admin/manage-admins");
        }
    }

    /**
     * Add a new administrator
     */
    private void addAdmin(HttpServletRequest request, HttpServletResponse response,
                          AdminManager adminManager, HttpSession session)
            throws ServletException, IOException {

        // Get form parameters
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String role = request.getParameter("role");

        // Validate input
        if (username == null || password == null || confirmPassword == null ||
                fullName == null || email == null || role == null ||
                username.trim().isEmpty() || password.trim().isEmpty() ||
                confirmPassword.trim().isEmpty() || fullName.trim().isEmpty() ||
                email.trim().isEmpty() || role.trim().isEmpty()) {

            session.setAttribute("errorMessage", "All fields are required");
            response.sendRedirect(request.getContextPath() + "/admin/manage-admins");
            return;
        }

        // Check password match
        if (!password.equals(confirmPassword)) {
            session.setAttribute("errorMessage", "Passwords do not match");
            response.sendRedirect(request.getContextPath() + "/admin/manage-admins");
            return;
        }

        // Validate role
        if (!role.equals("ADMIN") && !role.equals("SUPER_ADMIN")) {
            session.setAttribute("errorMessage", "Invalid role");
            response.sendRedirect(request.getContextPath() + "/admin/manage-admins");
            return;
        }

        // Create new admin
        Admin newAdmin = new Admin(
                UUID.randomUUID().toString(),
                username,
                password, // In production, should be hashed
                fullName,
                email,
                role
        );

        // Add admin
        boolean success = adminManager.addAdmin(newAdmin);

        if (success) {
            session.setAttribute("successMessage", "Administrator added successfully");
        } else {
            session.setAttribute("errorMessage", "Failed to add administrator. Username may already exist.");
        }

        response.sendRedirect(request.getContextPath() + "/admin/manage-admins");
    }

    /**
     * Edit an existing administrator
     */
    private void editAdmin(HttpServletRequest request, HttpServletResponse response,
                           AdminManager adminManager, HttpSession session)
            throws ServletException, IOException {

        // Get form parameters
        String adminId = request.getParameter("adminId");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String role = request.getParameter("role");

        // Validate input
        if (adminId == null || fullName == null || email == null || role == null ||
                adminId.trim().isEmpty() || fullName.trim().isEmpty() ||
                email.trim().isEmpty() || role.trim().isEmpty()) {

            session.setAttribute("errorMessage", "All fields are required");
            response.sendRedirect(request.getContextPath() + "/admin/manage-admins");
            return;
        }

        // Validate role
        if (!role.equals("ADMIN") && !role.equals("SUPER_ADMIN")) {
            session.setAttribute("errorMessage", "Invalid role");
            response.sendRedirect(request.getContextPath() + "/admin/manage-admins");
            return;
        }

        // Get existing admin
        Admin admin = adminManager.getAdminById(adminId);

        if (admin == null) {
            session.setAttribute("errorMessage", "Administrator not found");
            response.sendRedirect(request.getContextPath() + "/admin/manage-admins");
            return;
        }

        // Check if trying to change own role from SUPER_ADMIN to ADMIN
        String currentAdminId = (String) session.getAttribute("adminId");
        if (adminId.equals(currentAdminId) && admin.isSuperAdmin() && role.equals("ADMIN")) {
            session.setAttribute("errorMessage", "Cannot downgrade your own role from Super Admin");
            response.sendRedirect(request.getContextPath() + "/admin/manage-admins");
            return;
        }

        // Update admin
        admin.setFullName(fullName);
        admin.setEmail(email);
        admin.setRole(role);

        boolean success = adminManager.updateAdmin(admin);

        if (success) {
            session.setAttribute("successMessage", "Administrator updated successfully");
        } else {
            session.setAttribute("errorMessage", "Failed to update administrator");
        }

        response.sendRedirect(request.getContextPath() + "/admin/manage-admins");
    }

    /**
     * Delete an administrator
     */
    private void deleteAdmin(HttpServletRequest request, HttpServletResponse response,
                             AdminManager adminManager, HttpSession session)
            throws ServletException, IOException {

        // Get admin ID
        String adminId = request.getParameter("adminId");

        if (adminId == null || adminId.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Administrator ID is required");
            response.sendRedirect(request.getContextPath() + "/admin/manage-admins");
            return;
        }

        // Check if trying to delete self
        String currentAdminId = (String) session.getAttribute("adminId");
        if (adminId.equals(currentAdminId)) {
            session.setAttribute("errorMessage", "Cannot delete your own account");
            response.sendRedirect(request.getContextPath() + "/admin/manage-admins");
            return;
        }

        // Delete admin
        boolean success = adminManager.deleteAdmin(adminId);

        if (success) {
            session.setAttribute("successMessage", "Administrator deleted successfully");
        } else {
            session.setAttribute("errorMessage", "Failed to delete administrator. Cannot delete the last super admin.");
        }

        response.sendRedirect(request.getContextPath() + "/admin/manage-admins");
    }

    /**
     * Activate an administrator account
     */
    private void activateAdmin(HttpServletRequest request, HttpServletResponse response,
                               AdminManager adminManager, HttpSession session)
            throws ServletException, IOException {

        // Get admin ID
        String adminId = request.getParameter("adminId");

        if (adminId == null || adminId.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Administrator ID is required");
            response.sendRedirect(request.getContextPath() + "/admin/manage-admins");
            return;
        }

        // Activate admin
        boolean success = adminManager.activateAdmin(adminId);

        if (success) {
            session.setAttribute("successMessage", "Administrator activated successfully");
        } else {
            session.setAttribute("errorMessage", "Failed to activate administrator");
        }

        response.sendRedirect(request.getContextPath() + "/admin/manage-admins");
    }

    /**
     * Deactivate an administrator account
     */
    private void deactivateAdmin(HttpServletRequest request, HttpServletResponse response,
                                 AdminManager adminManager, HttpSession session)
            throws ServletException, IOException {

        // Get admin ID
        String adminId = request.getParameter("adminId");

        if (adminId == null || adminId.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Administrator ID is required");
            response.sendRedirect(request.getContextPath() + "/admin/manage-admins");
            return;
        }

        // Check if trying to deactivate self
        String currentAdminId = (String) session.getAttribute("adminId");
        if (adminId.equals(currentAdminId)) {
            session.setAttribute("errorMessage", "Cannot deactivate your own account");
            response.sendRedirect(request.getContextPath() + "/admin/manage-admins");
            return;
        }

        // Deactivate admin
        boolean success = adminManager.deactivateAdmin(adminId);

        if (success) {
            session.setAttribute("successMessage", "Administrator deactivated successfully");
        } else {
            session.setAttribute("errorMessage", "Failed to deactivate administrator. Cannot deactivate the last super admin.");
        }

        response.sendRedirect(request.getContextPath() + "/admin/manage-admins");
    }

    /**
     * Reset administrator password
     */
    private void resetAdminPassword(HttpServletRequest request, HttpServletResponse response,
                                    AdminManager adminManager, HttpSession session)
            throws ServletException, IOException {

        // Get parameters
        String adminId = request.getParameter("adminId");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (adminId == null || newPassword == null || confirmPassword == null ||
                adminId.trim().isEmpty() || newPassword.trim().isEmpty() || confirmPassword.trim().isEmpty()) {

            session.setAttribute("errorMessage", "All fields are required");
            response.sendRedirect(request.getContextPath() + "/admin/manage-admins");
            return;
        }

        // Check if passwords match
        if (!newPassword.equals(confirmPassword)) {
            session.setAttribute("errorMessage", "Passwords do not match");
            response.sendRedirect(request.getContextPath() + "/admin/manage-admins");
            return;
        }

        // Reset password
        boolean success = adminManager.resetPassword(adminId, newPassword);

        if (success) {
            session.setAttribute("successMessage", "Password reset successfully");
        } else {
            session.setAttribute("errorMessage", "Failed to reset password");
        }

        response.sendRedirect(request.getContextPath() + "/admin/manage-admins");
    }
}
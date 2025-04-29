package com.bookstore.servlet.admin.order;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.bookstore.model.order.OrderManager;

/**
 * Servlet for deleting orders (admin function)
 */
@WebServlet("/admin/delete-order")
public class DeleteOrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private OrderManager orderManager;

    @Override
    public void init() throws ServletException {
        // Initialize OrderManager with ServletContext
        orderManager = new OrderManager(getServletContext());
    }

    /**
     * Handles POST requests - delete an order
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        try {
            // Check if admin is logged in
            if (session.getAttribute("adminId") == null) {
                response.sendRedirect(request.getContextPath() + "/admin/login");
                return;
            }

            // Check if admin is super admin
            Boolean isSuperAdmin = (Boolean) session.getAttribute("isSuperAdmin");
            if (isSuperAdmin == null || !isSuperAdmin) {
                session.setAttribute("errorMessage", "Only super administrators can delete orders");
                response.sendRedirect(request.getContextPath() + "/admin/orders");
                return;
            }

            // Get order ID from request parameter
            String orderId = request.getParameter("orderId");
            if (orderId == null || orderId.trim().isEmpty()) {
                session.setAttribute("errorMessage", "Order ID is required");
                response.sendRedirect(request.getContextPath() + "/admin/orders");
                return;
            }

            // Get confirmation parameter
            String confirm = request.getParameter("confirm");
            if (!"yes".equals(confirm)) {
                session.setAttribute("errorMessage", "Confirmation required to delete an order");
                response.sendRedirect(request.getContextPath() + "/admin/order-details?orderId=" + orderId);
                return;
            }

            // Log the deletion request
            System.out.println("Admin is attempting to delete order: " + orderId);

            // Delete the order
            boolean deleted = orderManager.deleteOrder(orderId);

            if (deleted) {
                session.setAttribute("successMessage", "Order deleted successfully");
                System.out.println("Order deleted successfully: " + orderId);
            } else {
                session.setAttribute("errorMessage", "Failed to delete order");
                System.out.println("Failed to delete order: " + orderId);
            }

            // Redirect to orders list
            response.sendRedirect(request.getContextPath() + "/admin/orders");
        } catch (Exception e) {
            // Log the error
            System.err.println("Error in DeleteOrderServlet: " + e.getMessage());
            e.printStackTrace();

            // Set error message
            session.setAttribute("errorMessage", "An error occurred while deleting order: " + e.getMessage());

            // Redirect to orders list
            response.sendRedirect(request.getContextPath() + "/admin/orders");
        }
    }

    /**
     * Handles GET requests - redirect to POST
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect GET requests to order list
        response.sendRedirect(request.getContextPath() + "/admin/orders");
    }
}
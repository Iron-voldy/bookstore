package com.bookstore.servlet.admin.order;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.bookstore.model.order.OrderManager;
import com.bookstore.model.order.OrderStatus;

/**
 * Servlet for updating order status
 */
@WebServlet("/admin/update-order-status")
public class UpdateOrderStatusServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles POST requests - update order status
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // Check if admin is logged in
        if (session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        // Get form data
        String orderId = request.getParameter("orderId");
        String statusStr = request.getParameter("status");
        String trackingNumber = request.getParameter("trackingNumber");
        String notes = request.getParameter("notes");

        // Validate required fields
        if (orderId == null || orderId.trim().isEmpty() ||
                statusStr == null || statusStr.trim().isEmpty()) {

            session.setAttribute("errorMessage", "Order ID and status are required");
            response.sendRedirect(request.getContextPath() + "/admin/orders");
            return;
        }

        // Get order manager
        OrderManager orderManager = new OrderManager(getServletContext());

        // Convert status string to enum
        OrderStatus newStatus;
        try {
            newStatus = OrderStatus.valueOf(statusStr.toUpperCase());
        } catch (IllegalArgumentException e) {
            session.setAttribute("errorMessage", "Invalid order status");
            response.sendRedirect(request.getContextPath() + "/admin/order-details?orderId=" + orderId);
            return;
        }

        // Update order status
        boolean updated = orderManager.updateOrderStatus(orderId, newStatus);

        // If shipping status, update tracking number
        if (newStatus == OrderStatus.SHIPPED && trackingNumber != null && !trackingNumber.trim().isEmpty()) {
            orderManager.updateTrackingNumber(orderId, trackingNumber);
        }

        // Update notes if provided
        if (notes != null && !notes.trim().isEmpty()) {
            orderManager.updateOrderNotes(orderId, notes);
        }

        if (updated) {
            session.setAttribute("successMessage", "Order status updated successfully");
        } else {
            session.setAttribute("errorMessage", "Failed to update order status");
        }

        // Redirect back to order details
        response.sendRedirect(request.getContextPath() + "/admin/order-details?orderId=" + orderId);
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
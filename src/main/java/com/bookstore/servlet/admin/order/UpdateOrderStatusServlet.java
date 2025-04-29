package com.bookstore.servlet.admin.order;

import java.io.IOException;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.bookstore.model.order.Order;
import com.bookstore.model.order.OrderManager;
import com.bookstore.model.order.OrderStatus;

/**
 * Servlet for updating order status
 */
@WebServlet("/admin/update-order-status")
public class UpdateOrderStatusServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private OrderManager orderManager;

    @Override
    public void init() throws ServletException {
        // Initialize OrderManager with ServletContext
        orderManager = new OrderManager(getServletContext());
    }

    /**
     * Handles POST requests - update order status
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

            // Get form data
            String orderId = request.getParameter("orderId");
            String statusStr = request.getParameter("status");
            String trackingNumber = request.getParameter("trackingNumber");
            String notes = request.getParameter("notes");

            // Log request parameters
            System.out.println("Update Order Request - Order ID: " + orderId +
                    ", Status: " + statusStr +
                    ", Tracking: " + trackingNumber);

            // Validate required fields
            if (orderId == null || orderId.trim().isEmpty() ||
                    statusStr == null || statusStr.trim().isEmpty()) {

                session.setAttribute("errorMessage", "Order ID and status are required");
                response.sendRedirect(request.getContextPath() + "/admin/orders");
                return;
            }

            // Get the order
            Order order = orderManager.getOrderById(orderId);
            if (order == null) {
                session.setAttribute("errorMessage", "Order not found");
                response.sendRedirect(request.getContextPath() + "/admin/orders");
                return;
            }

            // Convert status string to enum
            OrderStatus newStatus;
            try {
                newStatus = OrderStatus.valueOf(statusStr.toUpperCase());
            } catch (IllegalArgumentException e) {
                session.setAttribute("errorMessage", "Invalid order status");
                response.sendRedirect(request.getContextPath() + "/admin/order-details?orderId=" + orderId);
                return;
            }

            // Validate status transitions
            OrderStatus currentStatus = order.getStatus();
            if (currentStatus == OrderStatus.CANCELLED && newStatus != OrderStatus.CANCELLED) {
                session.setAttribute("errorMessage", "Cannot change status of a cancelled order");
                response.sendRedirect(request.getContextPath() + "/admin/order-details?orderId=" + orderId);
                return;
            }

            if (currentStatus == OrderStatus.DELIVERED && newStatus != OrderStatus.DELIVERED) {
                session.setAttribute("errorMessage", "Cannot change status of a delivered order");
                response.sendRedirect(request.getContextPath() + "/admin/order-details?orderId=" + orderId);
                return;
            }

            // Validate tracking number for shipped status
            if (newStatus == OrderStatus.SHIPPED &&
                    (trackingNumber == null || trackingNumber.trim().isEmpty())) {
                session.setAttribute("errorMessage", "Tracking number is required for shipped orders");
                response.sendRedirect(request.getContextPath() + "/admin/order-details?orderId=" + orderId);
                return;
            }

            // Update order status
            boolean updated = orderManager.updateOrderStatus(orderId, newStatus);

            // Update tracking number if provided
            if (trackingNumber != null && !trackingNumber.trim().isEmpty()) {
                orderManager.updateTrackingNumber(orderId, trackingNumber);
            }

            // Update notes if provided
            if (notes != null && !notes.trim().isEmpty()) {
                orderManager.updateOrderNotes(orderId, notes);
            }

            // Handle special status updates
            if (updated) {
                String successMessage = "Order status updated to " + newStatus.getDisplayName();

                // Special handling for specific statuses
                if (newStatus == OrderStatus.SHIPPED) {
                    successMessage += " with tracking number: " + trackingNumber;
                } else if (newStatus == OrderStatus.CANCELLED) {
                    successMessage = "Order has been cancelled";
                } else if (newStatus == OrderStatus.DELIVERED) {
                    successMessage = "Order marked as delivered";
                }

                session.setAttribute("successMessage", successMessage);
            } else {
                session.setAttribute("errorMessage", "Failed to update order status");
            }

            // Redirect back to order details
            response.sendRedirect(request.getContextPath() + "/admin/order-details?orderId=" + orderId);
        } catch (Exception e) {
            // Log the error
            System.err.println("Error in UpdateOrderStatusServlet: " + e.getMessage());
            e.printStackTrace();

            // Set error message
            session.setAttribute("errorMessage", "An error occurred while updating order status: " + e.getMessage());

            // Get orderId from request if available for redirection
            String orderId = request.getParameter("orderId");
            if (orderId != null && !orderId.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/admin/order-details?orderId=" + orderId);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/orders");
            }
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
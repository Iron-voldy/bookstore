package com.bookstore.servlet.admin;

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
 * Servlet for handling order status updates from admin
 */
@WebServlet("/admin/update-order-status")
public class AdminUpdateOrderStatusServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private OrderManager orderManager;

    @Override
    public void init() throws ServletException {
        orderManager = new OrderManager(getServletContext());
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // Check if admin is logged in
        if (session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        try {
            // Get parameters
            String orderId = request.getParameter("orderId");
            String statusStr = request.getParameter("status");
            String trackingNumber = request.getParameter("trackingNumber");
            String notes = request.getParameter("notes");

            System.out.println("AdminUpdateOrderStatusServlet: orderId=" + orderId
                    + ", status=" + statusStr
                    + ", tracking=" + trackingNumber);

            // Validate required parameters
            if (orderId == null || orderId.trim().isEmpty() || statusStr == null || statusStr.trim().isEmpty()) {
                session.setAttribute("errorMessage", "Order ID and status are required");
                response.sendRedirect(request.getContextPath() + "/admin/orders");
                return;
            }

            // Get order
            Order order = orderManager.getOrderById(orderId);
            if (order == null) {
                session.setAttribute("errorMessage", "Order not found");
                response.sendRedirect(request.getContextPath() + "/admin/orders");
                return;
            }

            // Print the current status before change
            System.out.println("AdminUpdateOrderStatusServlet: Current order status: " +
                    (order.getStatus() != null ? order.getStatus().name() : "null"));

            // Convert status
            OrderStatus newStatus;
            try {
                newStatus = OrderStatus.valueOf(statusStr);
                System.out.println("AdminUpdateOrderStatusServlet: New status parsed as: " + newStatus.name());
            } catch (IllegalArgumentException e) {
                System.err.println("AdminUpdateOrderStatusServlet: Invalid status value: " + statusStr);
                session.setAttribute("errorMessage", "Invalid order status");
                response.sendRedirect(request.getContextPath() + "/admin/order-details?orderId=" + orderId);
                return;
            }

            // Validate tracking number if status is SHIPPED
            if (newStatus == OrderStatus.SHIPPED && (trackingNumber == null || trackingNumber.trim().isEmpty())) {
                session.setAttribute("errorMessage", "Tracking number is required when marking an order as Shipped");
                response.sendRedirect(request.getContextPath() + "/admin/order-details?orderId=" + orderId);
                return;
            }

            // Get admin info
            String adminUsername = (String) session.getAttribute("adminUsername");

            // Update order status
            order.setStatus(newStatus);
            System.out.println("AdminUpdateOrderStatusServlet: Order status updated in object to: " + order.getStatus().name());

            // Update tracking number if provided
            if (trackingNumber != null && !trackingNumber.trim().isEmpty()) {
                order.setTrackingNumber(trackingNumber);
            }

            // Set dates based on status
            if (newStatus == OrderStatus.SHIPPED && order.getShippedDate() == null) {
                order.setShippedDate(new Date());
            } else if (newStatus == OrderStatus.DELIVERED && order.getDeliveredDate() == null) {
                order.setDeliveredDate(new Date());
            }

            // Update notes if provided
            if (notes != null && !notes.trim().isEmpty()) {
                String existingNotes = order.getNotes() != null ? order.getNotes() : "";
                String statusNote = String.format("[%s] %s changed status to %s",
                        new Date(), adminUsername != null ? adminUsername : "Admin", newStatus.getDisplayName());

                String updatedNotes = existingNotes.isEmpty() ?
                        statusNote + "\n" + notes :
                        existingNotes + "\n" + statusNote + "\n" + notes;

                order.setNotes(updatedNotes);
            }

            // Save changes
            boolean updated = orderManager.updateOrderStatus(orderId, newStatus);

            System.out.println("AdminUpdateOrderStatusServlet: Update result: " + updated);

            // Verify the order status again after update
            Order verifiedOrder = orderManager.getOrderById(orderId);
            if (verifiedOrder != null) {
                System.out.println("AdminUpdateOrderStatusServlet: Verified order status after update: " +
                        (verifiedOrder.getStatus() != null ? verifiedOrder.getStatus().name() : "null"));
            } else {
                System.out.println("AdminUpdateOrderStatusServlet: Could not verify order after update - not found");
            }

            if (updated) {
                session.setAttribute("successMessage", "Order status updated successfully");
            } else {
                session.setAttribute("errorMessage", "Failed to update order status");
            }

            // Redirect back to order details
            response.sendRedirect(request.getContextPath() + "/admin/order-details?orderId=" + orderId);

        } catch (Exception e) {
            System.err.println("Error in AdminUpdateOrderStatusServlet: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/orders");
        }
    }
}
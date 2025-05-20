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

            // Convert status
            OrderStatus newStatus;
            try {
                newStatus = OrderStatus.valueOf(statusStr);
            } catch (IllegalArgumentException e) {
                session.setAttribute("errorMessage", "Invalid order status");
                response.sendRedirect(request.getContextPath() + "/admin/order-details?orderId=" + orderId);
                return;
            }

            // Get admin info
            String adminUsername = (String) session.getAttribute("adminUsername");

            // Update order status
            order.setStatus(newStatus);

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
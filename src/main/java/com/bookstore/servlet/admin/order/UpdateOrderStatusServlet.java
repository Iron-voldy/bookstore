package com.bookstore.servlet.admin.order;

import java.io.IOException;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.bookstore.model.book.Book;
import com.bookstore.model.book.BookManager;
import com.bookstore.model.order.Order;
import com.bookstore.model.order.OrderItem;
import com.bookstore.model.order.OrderManager;
import com.bookstore.model.order.OrderStatus;
import com.bookstore.model.user.User;
import com.bookstore.model.user.UserManager;

/**
 * Servlet for updating order status in the admin panel
 */
@WebServlet("/admin/update-order-status")
public class UpdateOrderStatusServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Managers for different database operations
    private OrderManager orderManager;
    private BookManager bookManager;
    private UserManager userManager;

    /**
     * Initialize servlet with necessary managers
     */
    @Override
    public void init() throws ServletException {
        // Initialize managers with ServletContext
        orderManager = new OrderManager(getServletContext());
        bookManager = new BookManager(getServletContext());
        userManager = new UserManager(getServletContext());
    }

    /**
     * Handle POST requests for updating order status
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // Check if admin is logged in
        if (session.getAttribute("adminId") == null) {
            session.setAttribute("errorMessage", "Please log in to update order status");
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        try {
            // Retrieve form parameters
            String orderId = request.getParameter("orderId");
            String statusStr = request.getParameter("status");
            String trackingNumber = request.getParameter("trackingNumber");
            String notes = request.getParameter("notes");

            // Validate required parameters
            if (orderId == null || orderId.trim().isEmpty() ||
                    statusStr == null || statusStr.trim().isEmpty()) {
                session.setAttribute("errorMessage", "Order ID and status are required");
                response.sendRedirect(request.getContextPath() + "/admin/orders");
                return;
            }

            // Retrieve the order
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

            // Prevent changing status of completed or cancelled orders
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

            // Tracking number validation for shipped status
            if (newStatus == OrderStatus.SHIPPED) {
                if (trackingNumber == null || trackingNumber.trim().isEmpty()) {
                    session.setAttribute("errorMessage", "Tracking number is required when marking order as Shipped");
                    response.sendRedirect(request.getContextPath() + "/admin/order-details?orderId=" + orderId);
                    return;
                }
                // Set tracking number
                order.setTrackingNumber(trackingNumber.trim());
                order.setShippedDate(new Date());
            }

            // Update notes - append new notes with timestamp
            String updatedNotes = order.getNotes() != null ? order.getNotes() : "";
            if (notes != null && !notes.trim().isEmpty()) {
                // Add a timestamp to the new note
                updatedNotes += (updatedNotes.isEmpty() ? "" : "\n") +
                        "[" + new Date() + "] " + notes.trim();
            }
            order.setNotes(updatedNotes);

            // Special handling for order cancellation
            if (newStatus == OrderStatus.CANCELLED) {
                // Revert inventory for physical books
                handleCancelledOrderInventory(order);
            }

            // Special handling for delivered status
            if (newStatus == OrderStatus.DELIVERED) {
                order.setDeliveredDate(new Date());
            }

            // Update order status
            boolean statusUpdateResult = orderManager.updateOrderStatus(orderId, newStatus);

            if (statusUpdateResult) {
                // Construct success message
                String successMessage = constructSuccessMessage(currentStatus, newStatus, trackingNumber);
                session.setAttribute("successMessage", successMessage);
            } else {
                session.setAttribute("errorMessage", "Failed to update order status");
            }

            // Redirect back to order details
            response.sendRedirect(request.getContextPath() + "/admin/order-details?orderId=" + orderId);

        } catch (Exception e) {
            // Log and handle unexpected errors
            System.err.println("Error in UpdateOrderStatusServlet: " + e.getMessage());
            e.printStackTrace();

            // Set error message
            session.setAttribute("errorMessage",
                    "An unexpected error occurred: " + e.getMessage());

            // Redirect to orders list
            response.sendRedirect(request.getContextPath() + "/admin/orders");
        }
    }

    /**
     * Handle inventory restoration for cancelled physical books
     * @param order The cancelled order
     */
    private void handleCancelledOrderInventory(Order order) {
        if (order.getItems() == null) return;

        // Restore inventory for physical books
        for (OrderItem item : order.getItems()) {
            // Only restore physical books
            if ("PHYSICAL".equals(item.getBookType())) {
                Book book = bookManager.getBookById(item.getBookId());
                if (book != null) {
                    // Increase book quantity
                    book.increaseQuantity(item.getQuantity());
                    bookManager.updateBook(book);
                }
            }
        }
    }

    /**
     * Construct a user-friendly success message based on status change
     * @param currentStatus Previous order status
     * @param newStatus New order status
     * @param trackingNumber Tracking number (if applicable)
     * @return Descriptive success message
     */
    private String constructSuccessMessage(OrderStatus currentStatus,
                                           OrderStatus newStatus,
                                           String trackingNumber) {
        StringBuilder message = new StringBuilder("Order status updated");

        // Describe the transition
        message.append(" from ").append(currentStatus.getDisplayName())
                .append(" to ").append(newStatus.getDisplayName());

        // Add tracking number for shipped orders
        if (newStatus == OrderStatus.SHIPPED && trackingNumber != null) {
            message.append(". Tracking number: ").append(trackingNumber);
        }

        return message.toString();
    }

    /**
     * Handle GET requests by redirecting to orders page
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect GET requests to orders list
        response.sendRedirect(request.getContextPath() + "/admin/orders");
    }
}
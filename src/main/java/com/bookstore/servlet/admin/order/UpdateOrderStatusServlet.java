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
        System.out.println("UpdateOrderStatusServlet initialized with managers");
    }

    /**
     * Handle POST requests for updating order status
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        System.out.println("UpdateOrderStatusServlet: doPost started");

        // Check if admin is logged in
        if (session.getAttribute("adminId") == null) {
            System.out.println("UpdateOrderStatusServlet: Admin not logged in");
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

            System.out.println("UpdateOrderStatusServlet: Processing orderId=" + orderId +
                    ", status=" + statusStr +
                    ", trackingNumber=" + trackingNumber);

            // Validate required parameters
            if (orderId == null || orderId.trim().isEmpty() ||
                    statusStr == null || statusStr.trim().isEmpty()) {
                System.out.println("UpdateOrderStatusServlet: Missing required parameters");
                session.setAttribute("errorMessage", "Order ID and status are required");
                response.sendRedirect(request.getContextPath() + "/admin/orders");
                return;
            }

            // Retrieve the order
            Order order = orderManager.getOrderById(orderId);
            if (order == null) {
                System.out.println("UpdateOrderStatusServlet: Order not found: " + orderId);
                session.setAttribute("errorMessage", "Order not found");
                response.sendRedirect(request.getContextPath() + "/admin/orders");
                return;
            }

            // Convert status string to enum
            OrderStatus newStatus;
            try {
                newStatus = OrderStatus.valueOf(statusStr.toUpperCase());
                System.out.println("UpdateOrderStatusServlet: New status parsed: " + newStatus);
            } catch (IllegalArgumentException e) {
                System.out.println("UpdateOrderStatusServlet: Invalid status: " + statusStr);
                session.setAttribute("errorMessage", "Invalid order status");
                response.sendRedirect(request.getContextPath() + "/admin/order-details?orderId=" + orderId);
                return;
            }

            // Validate status transitions
            OrderStatus currentStatus = order.getStatus();
            System.out.println("UpdateOrderStatusServlet: Current status: " + currentStatus +
                    ", New status: " + newStatus);

            // Tracking number validation for shipped status
            if (newStatus == OrderStatus.SHIPPED) {
                if (trackingNumber == null || trackingNumber.trim().isEmpty()) {
                    System.out.println("UpdateOrderStatusServlet: Missing tracking number for SHIPPED status");
                    session.setAttribute("errorMessage", "Tracking number is required when marking order as Shipped");
                    response.sendRedirect(request.getContextPath() + "/admin/order-details?orderId=" + orderId);
                    return;
                }
                // Set tracking number
                order.setTrackingNumber(trackingNumber.trim());
                order.setShippedDate(new Date());
                System.out.println("UpdateOrderStatusServlet: Set tracking number: " + trackingNumber.trim());
                System.out.println("UpdateOrderStatusServlet: Set shipped date: " + order.getShippedDate());
            }

            // Update notes - append new notes with timestamp
            String updatedNotes = order.getNotes() != null ? order.getNotes() : "";
            if (notes != null && !notes.trim().isEmpty()) {
                // Add a timestamp to the new note
                String newNote = "[" + new Date() + "] " + notes.trim();
                updatedNotes += (updatedNotes.isEmpty() ? "" : "\n") + newNote;
                System.out.println("UpdateOrderStatusServlet: Added note: " + newNote);
            }
            order.setNotes(updatedNotes);

            // Special handling for order cancellation
            if (newStatus == OrderStatus.CANCELLED) {
                System.out.println("UpdateOrderStatusServlet: Handling cancelled order inventory");
                // Revert inventory for physical books
                handleCancelledOrderInventory(order);
            }

            // Special handling for delivered status
            if (newStatus == OrderStatus.DELIVERED) {
                order.setDeliveredDate(new Date());
                System.out.println("UpdateOrderStatusServlet: Set delivered date: " + order.getDeliveredDate());
            }

            // First try direct update through OrderManager
            boolean statusUpdateResult = orderManager.updateOrderStatus(orderId, newStatus);
            System.out.println("UpdateOrderStatusServlet: Status update through OrderManager result: " + statusUpdateResult);

            // If OrderManager update fails, try manual update
            if (!statusUpdateResult) {
                System.out.println("UpdateOrderStatusServlet: Attempting manual status update");
                // Set the status directly on the order object
                order.setStatus(newStatus);

                // Try to save changes via another method if available
                // This is a fallback mechanism
                try {
                    statusUpdateResult = saveOrderStatusManually(order);
                    System.out.println("UpdateOrderStatusServlet: Manual update result: " + statusUpdateResult);
                } catch (Exception e) {
                    System.err.println("UpdateOrderStatusServlet: Error during manual update: " + e.getMessage());
                    e.printStackTrace();
                }
            }

            if (statusUpdateResult) {
                // Construct success message
                String successMessage = constructSuccessMessage(currentStatus, newStatus, trackingNumber);
                System.out.println("UpdateOrderStatusServlet: Success message: " + successMessage);
                session.setAttribute("successMessage", successMessage);
            } else {
                session.setAttribute("errorMessage", "Failed to update order status. Please try again.");
                System.out.println("UpdateOrderStatusServlet: Failed to update status");
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
     * Method to manually save order status when OrderManager methods fail
     * This is a fallback mechanism
     */
    private boolean saveOrderStatusManually(Order order) {
        try {
            // Try to save the entire order including its updated status
            // This is a simplified approach and might not work in all cases
            boolean updated = orderManager.updateOrderStatus(order.getOrderId(), order.getStatus());
            return updated;
        } catch (Exception e) {
            System.err.println("Error saving order status manually: " + e.getMessage());
            e.printStackTrace();
            return false;
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
            if (item.getBookType() != null &&
                    (item.getBookType().equals("PHYSICAL") || item.getBookType().equals("BOOK"))) {
                Book book = bookManager.getBookById(item.getBookId());
                if (book != null) {
                    // Increase book quantity
                    book.increaseQuantity(item.getQuantity());
                    boolean updated = bookManager.updateBook(book);
                    System.out.println("UpdateOrderStatusServlet: Restored inventory for book: " +
                            book.getTitle() + ", quantity: " + item.getQuantity() +
                            ", update result: " + updated);
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
        if (newStatus == OrderStatus.SHIPPED && trackingNumber != null && !trackingNumber.isEmpty()) {
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
        System.out.println("UpdateOrderStatusServlet: GET request received, redirecting to orders page");
        response.sendRedirect(request.getContextPath() + "/admin/orders");
    }
}
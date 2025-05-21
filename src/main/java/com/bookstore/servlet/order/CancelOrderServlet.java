package com.bookstore.servlet.order;

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
import com.bookstore.model.book.Book;
import com.bookstore.model.book.BookManager;
import com.bookstore.model.order.OrderItem;

/**
 * Servlet for handling order cancellation by customers
 */
@WebServlet("/cancel-order")
public class CancelOrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private OrderManager orderManager;
    private BookManager bookManager;

    @Override
    public void init() throws ServletException {
        // Initialize managers with ServletContext
        orderManager = new OrderManager(getServletContext());
        bookManager = new BookManager(getServletContext());
        System.out.println("CancelOrderServlet initialized with managers");
    }

    /**
     * Handles POST requests - process order cancellation
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        System.out.println("CancelOrderServlet: doPost started");

        // Check if user is logged in
        String userId = (String) session.getAttribute("userId");
        if (userId == null) {
            System.out.println("CancelOrderServlet: User not logged in");
            session.setAttribute("errorMessage", "Please log in to cancel an order");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get order ID from request parameter
        String orderId = request.getParameter("orderId");
        if (orderId == null || orderId.trim().isEmpty()) {
            System.out.println("CancelOrderServlet: Missing orderId parameter");
            session.setAttribute("errorMessage", "Order ID is required");
            response.sendRedirect(request.getContextPath() + "/order-history");
            return;
        }

        System.out.println("CancelOrderServlet: Processing cancellation for orderId=" + orderId + " by user " + userId);

        // Get order details
        Order order = orderManager.getOrderById(orderId);
        if (order == null) {
            System.out.println("CancelOrderServlet: Order not found: " + orderId);
            session.setAttribute("errorMessage", "Order not found");
            response.sendRedirect(request.getContextPath() + "/order-history");
            return;
        }

        // Check if this order belongs to the logged-in user
        if (!order.getUserId().equals(userId)) {
            System.out.println("CancelOrderServlet: Permission denied - Order belongs to " +
                    order.getUserId() + ", not " + userId);
            session.setAttribute("errorMessage", "You do not have permission to cancel this order");
            response.sendRedirect(request.getContextPath() + "/order-history");
            return;
        }

        // Check if order can be cancelled
        if (!order.canCancel()) {
            System.out.println("CancelOrderServlet: Order cannot be cancelled, status: " + order.getStatus());
            session.setAttribute("errorMessage", "This order cannot be cancelled. Current status: " + order.getStatus());
            response.sendRedirect(request.getContextPath() + "/order-details?orderId=" + orderId);
            return;
        }

        try {
            // Add cancellation note
            String existingNotes = order.getNotes() != null ? order.getNotes() : "";
            String cancelNote = String.format("[%s] Order cancelled by user", new Date());
            order.setNotes(existingNotes.isEmpty() ? cancelNote : existingNotes + "\n" + cancelNote);

            // Update order status to CANCELLED
            boolean cancelled = orderManager.cancelOrder(orderId);

            if (cancelled) {
                session.setAttribute("successMessage", "Order has been cancelled successfully");
                System.out.println("CancelOrderServlet: Order cancelled successfully");
            } else {
                session.setAttribute("errorMessage", "Failed to cancel order. Please try again or contact customer support.");
                System.out.println("CancelOrderServlet: Failed to cancel order");
            }
        } catch (Exception e) {
            System.err.println("CancelOrderServlet: Error during cancellation: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("errorMessage", "An error occurred while cancelling your order: " + e.getMessage());
        }

        // Redirect back to order details
        response.sendRedirect(request.getContextPath() + "/order-details?orderId=" + orderId);
    }

    /**
     * Handles GET requests - redirect to POST with error message
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // GET requests are not supported, redirect to order history
        HttpSession session = request.getSession();
        session.setAttribute("errorMessage", "Invalid request method. Please use the cancel button on the order details page.");
        response.sendRedirect(request.getContextPath() + "/order-history");
    }
}
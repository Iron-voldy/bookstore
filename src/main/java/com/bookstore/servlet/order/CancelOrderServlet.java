package com.bookstore.servlet.order;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.bookstore.model.order.Order;
import com.bookstore.model.order.OrderManager;

/**
 * Servlet for handling order cancellation
 */
@WebServlet("/cancel-order")
public class CancelOrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles POST requests - process order cancellation
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // Check if user is logged in
        String userId = (String) session.getAttribute("userId");
        if (userId == null) {
            session.setAttribute("errorMessage", "Please log in to cancel an order");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get order ID from request parameter
        String orderId = request.getParameter("orderId");
        if (orderId == null || orderId.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Order ID is required");
            response.sendRedirect(request.getContextPath() + "/order-history");
            return;
        }

        // Get order manager
        OrderManager orderManager = new OrderManager(getServletContext());

        // Get order details
        Order order = orderManager.getOrderById(orderId);
        if (order == null) {
            session.setAttribute("errorMessage", "Order not found");
            response.sendRedirect(request.getContextPath() + "/order-history");
            return;
        }

        // Check if this order belongs to the logged-in user
        if (!order.getUserId().equals(userId)) {
            session.setAttribute("errorMessage", "You do not have permission to cancel this order");
            response.sendRedirect(request.getContextPath() + "/order-history");
            return;
        }

        // Check if order can be cancelled
        if (!order.canCancel()) {
            session.setAttribute("errorMessage", "This order cannot be cancelled");
            response.sendRedirect(request.getContextPath() + "/order-details?orderId=" + orderId);
            return;
        }

        // Cancel the order
        boolean cancelled = orderManager.cancelOrder(orderId);

        if (cancelled) {
            session.setAttribute("successMessage", "Order cancelled successfully");
        } else {
            session.setAttribute("errorMessage", "Failed to cancel order");
        }

        // Redirect back to order details
        response.sendRedirect(request.getContextPath() + "/order-details?orderId=" + orderId);
    }

    /**
     * Handles GET requests - redirect to POST
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect GET requests to POST
        response.sendRedirect(request.getContextPath() + "/order-history");
    }
}
package com.bookstore.servlet.order;

import java.io.IOException;
import java.util.List;
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
 * Servlet for handling order history display
 */
@WebServlet("/order-history")
public class OrderHistoryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests - display order history
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // Check if user is logged in
        String userId = (String) session.getAttribute("userId");
        if (userId == null) {
            session.setAttribute("errorMessage", "Please log in to view your order history");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get status filter parameter
        String statusFilter = request.getParameter("status");
        OrderStatus status = null;
        if (statusFilter != null && !statusFilter.trim().isEmpty()) {
            try {
                status = OrderStatus.valueOf(statusFilter.toUpperCase());
            } catch (IllegalArgumentException e) {
                // Invalid status, ignore filter
            }
        }

        // Get order manager
        OrderManager orderManager = new OrderManager(getServletContext());

        // Get user orders
        List<Order> orders;
        if (status != null) {
            // Get orders by status and filter by user
            List<Order> statusOrders = orderManager.getOrdersByStatus(status);
            orders = new java.util.ArrayList<>();
            for (Order order : statusOrders) {
                if (order.getUserId().equals(userId)) {
                    orders.add(order);
                }
            }
        } else {
            // Get all orders for this user
            orders = orderManager.getOrdersByUser(userId);
        }

        // Set attributes in request
        request.setAttribute("orders", orders);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("statuses", OrderStatus.values());

        // Forward to order history page
        request.getRequestDispatcher("/order/order-history.jsp").forward(request, response);
    }
}
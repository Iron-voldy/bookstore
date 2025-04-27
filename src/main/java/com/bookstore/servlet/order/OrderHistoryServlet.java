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

@WebServlet("/order-history")
public class OrderHistoryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private OrderManager orderManager;

    public void init() throws ServletException {
        // Initialize OrderManager with ServletContext
        orderManager = new OrderManager(getServletContext());
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get user session
        HttpSession session = request.getSession(false);

        // Debug logging
        System.out.println("OrderHistoryServlet: doGet method started");

        // Check if user is logged in
        if (session == null || session.getAttribute("userId") == null) {
            // Redirect to login if not logged in
            System.out.println("User not logged in, redirecting to login page");
            if (session != null) {
                session.setAttribute("redirectAfterLogin", request.getContextPath() + "/order-history");
            }
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get user ID
        String userId = (String) session.getAttribute("userId");
        System.out.println("OrderHistoryServlet: userId = " + userId);

        // Set OrderStatus array as an attribute for the JSP
        OrderStatus[] statuses = OrderStatus.values();
        request.setAttribute("statuses", statuses);

        // Get status filter parameter
        String statusFilter = request.getParameter("status");
        System.out.println("OrderHistoryServlet: statusFilter = " + statusFilter);

        // Fetch orders
        List<Order> orders;
        try {
            if (statusFilter != null && !statusFilter.isEmpty()) {
                try {
                    OrderStatus status = OrderStatus.valueOf(statusFilter.toUpperCase());
                    System.out.println("Filtering orders by status: " + status);
                    orders = orderManager.getOrdersByUser(userId);

                    // Filter in Java rather than in database query
                    orders.removeIf(order -> order.getStatus() != status);
                } catch (IllegalArgumentException e) {
                    // Invalid status, fetch all orders
                    System.out.println("Invalid status filter: " + statusFilter + ", showing all orders");
                    orders = orderManager.getOrdersByUser(userId);
                }
            } else {
                // Fetch all orders for the user
                System.out.println("Fetching all orders for user");
                orders = orderManager.getOrdersByUser(userId);
            }

            System.out.println("Found " + (orders != null ? orders.size() : 0) + " orders");

            // Verify order totals to avoid null values
            if (orders != null) {
                for (Order order : orders) {
                    if (order.getTotal() == 0) {
                        // Recalculate totals if they appear to be missing
                        order.calculateTotals();
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("Error fetching orders: " + e.getMessage());
            e.printStackTrace();
            orders = null;
            session.setAttribute("errorMessage", "An error occurred while fetching your orders: " + e.getMessage());
        }

        // Set attributes for the JSP
        request.setAttribute("orders", orders);
        request.setAttribute("statusFilter", statusFilter);

        System.out.println("OrderHistoryServlet: Forwarding to order-history.jsp");

        // Forward to order history page
        request.getRequestDispatcher("/order/order-history.jsp").forward(request, response);
    }
}
package com.bookstore.servlet.order;

import java.io.IOException;
import java.util.ArrayList;
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

    @Override
    public void init() throws ServletException {
        // Initialize OrderManager with ServletContext
        orderManager = new OrderManager(getServletContext());
        System.out.println("OrderHistoryServlet initialized");
    }

    @Override
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

        // Fetch orders - ONLY FOR THE CURRENT USER
        List<Order> orders;
        try {
            // Get only the current user's orders first
            orders = orderManager.getOrdersByUser(userId);
            System.out.println("Found " + orders.size() + " orders for user: " + userId);

            // Then filter by status if needed
            if (statusFilter != null && !statusFilter.isEmpty()) {
                try {
                    OrderStatus status = OrderStatus.valueOf(statusFilter.toUpperCase());
                    System.out.println("Filtering orders by status: " + status);

                    List<Order> filteredOrders = new ArrayList<>();
                    for (Order order : orders) {
                        if (order.getStatus() == status) {
                            filteredOrders.add(order);
                        }
                    }
                    orders = filteredOrders;
                    System.out.println("Found " + orders.size() + " orders after status filtering");
                } catch (IllegalArgumentException e) {
                    // Invalid status, keep all orders
                    System.out.println("Invalid status filter: " + statusFilter + ", showing all orders");
                }
            }

            // Debug orders list
            if (orders != null && !orders.isEmpty()) {
                System.out.println("Order details:");
                for (Order order : orders) {
                    System.out.println("Order ID: " + order.getOrderId() +
                            ", Status: " + order.getStatus() +
                            ", Items: " + (order.getItems() != null ? order.getItems().size() : 0) +
                            ", Total: " + order.getTotal());
                }
            } else {
                System.out.println("No orders found for user ID: " + userId);
            }

            // Verify order totals to avoid null values
            if (orders != null) {
                for (Order order : orders) {
                    if (order.getTotal() == 0) {
                        // Recalculate totals if they appear to be missing
                        order.calculateTotals();
                    }

                    // Ensure there are items in the order
                    if (order.getItems() == null) {
                        order.setItems(new ArrayList<>());
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
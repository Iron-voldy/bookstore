package com.bookstore.servlet.order;

import java.io.IOException;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.bookstore.model.order.Order;
import com.bookstore.model.order.OrderItem;
import com.bookstore.model.order.OrderManager;

/**
 * Servlet for displaying order details for customers
 */
@WebServlet("/order-details")
public class OrderDetailsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private OrderManager orderManager;

    @Override
    public void init() throws ServletException {
        orderManager = new OrderManager(getServletContext());
        System.out.println("OrderDetailsServlet initialized with orderManager");
    }

    /**
     * Handles GET requests - display order details for customer view
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        System.out.println("OrderDetailsServlet: doGet method started");

        // Check if user is logged in
        String userId = (String) session.getAttribute("userId");
        if (userId == null) {
            System.out.println("OrderDetailsServlet: User not logged in");
            session.setAttribute("errorMessage", "Please log in to view order details");
            session.setAttribute("redirectAfterLogin", request.getRequestURI() + "?" + request.getQueryString());
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get order ID from request parameter
        String orderId = request.getParameter("orderId");
        if (orderId == null || orderId.trim().isEmpty()) {
            System.out.println("OrderDetailsServlet: Missing orderId parameter");
            session.setAttribute("errorMessage", "Order ID is required");
            response.sendRedirect(request.getContextPath() + "/order-history");
            return;
        }

        System.out.println("OrderDetailsServlet: Displaying order " + orderId + " for user " + userId);

        try {
            // Get order details
            Order order = orderManager.getOrderById(orderId);
            if (order == null) {
                System.out.println("OrderDetailsServlet: Order not found: " + orderId);
                session.setAttribute("errorMessage", "Order not found");
                response.sendRedirect(request.getContextPath() + "/order-history");
                return;
            }

            // Check if this order belongs to the logged-in user
            if (!order.getUserId().equals(userId)) {
                System.out.println("OrderDetailsServlet: User " + userId + " tried to access order " +
                        orderId + " belonging to user " + order.getUserId());
                session.setAttribute("errorMessage", "You do not have permission to view this order");
                response.sendRedirect(request.getContextPath() + "/order-history");
                return;
            }

            // Ensure order has valid items
            if (order.getItems() == null) {
                System.out.println("OrderDetailsServlet: Order has null items, initializing empty list");
                order.setItems(new ArrayList<>());
            }

            // Recalculate totals to ensure they are up to date
            try {
                order.calculateTotals();
                System.out.println("OrderDetailsServlet: Order totals recalculated");
            } catch (Exception e) {
                // Log the error, but don't block the page load
                System.err.println("Error recalculating order totals: " + e.getMessage());
                e.printStackTrace();
            }

            // Debug output
            System.out.println("OrderDetailsServlet: Order has " +
                    (order.getItems() != null ? order.getItems().size() : "0") + " items");
            System.out.println("OrderDetailsServlet: Subtotal: " + order.getSubtotal());
            System.out.println("OrderDetailsServlet: Tax: " + order.getTax());
            System.out.println("OrderDetailsServlet: Total: " + order.getTotal());

            // Set order in request
            request.setAttribute("order", order);

            // Forward to customer order details page
            System.out.println("OrderDetailsServlet: Forwarding to order/order-details.jsp");
            request.getRequestDispatcher("/order/order-details.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Error in OrderDetailsServlet: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("errorMessage", "An error occurred while loading order details: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/order-history");
        }
    }
}
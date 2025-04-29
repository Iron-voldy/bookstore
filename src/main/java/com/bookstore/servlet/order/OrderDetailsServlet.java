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
 * Servlet for displaying order details
 */
@WebServlet("/order-details")
public class OrderDetailsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private OrderManager orderManager;

    @Override
    public void init() throws ServletException {
        orderManager = new OrderManager(getServletContext());
    }

    /**
     * Handles GET requests - display order details
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // Check if user is logged in
        if (session.getAttribute("userId") == null) {
            session.setAttribute("errorMessage", "Please log in to view order details");
            session.setAttribute("redirectAfterLogin", request.getRequestURI() + "?" + request.getQueryString());
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

        // Get order details
        Order order = orderManager.getOrderById(orderId);
        if (order == null) {
            session.setAttribute("errorMessage", "Order not found");
            response.sendRedirect(request.getContextPath() + "/order-history");
            return;
        }

        // Check if this order belongs to the logged-in user
        String userId = (String) session.getAttribute("userId");
        if (!order.getUserId().equals(userId)) {
            session.setAttribute("errorMessage", "You do not have permission to view this order");
            response.sendRedirect(request.getContextPath() + "/order-history");
            return;
        }

        // Ensure order has valid items and totals
        if (order.getItems() == null) {
            order.setItems(new ArrayList<>());
        }

        // Recalculate totals to ensure they are up to date
        try {
            order.calculateTotals();
        } catch (Exception e) {
            // Log the error, but don't block the page load
            System.err.println("Error recalculating order totals: " + e.getMessage());
            e.printStackTrace();
        }

        // Debug output
        System.out.println("OrderDetailsServlet: Displaying order " + orderId);
        System.out.println("OrderDetailsServlet: Order has " +
                (order.getItems() != null ? order.getItems().size() : "0") + " items");
        System.out.println("OrderDetailsServlet: Subtotal: " + order.getSubtotal());
        System.out.println("OrderDetailsServlet: Tax: " + order.getTax());
        System.out.println("OrderDetailsServlet: Total: " + order.getTotal());

        // Set order in request
        request.setAttribute("order", order);

        // Forward to order details page
        request.getRequestDispatcher("/order/order-details.jsp").forward(request, response);
    }
}
package com.bookstore.servlet.admin.order;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.bookstore.model.order.Order;
import com.bookstore.model.order.OrderManager;
import com.bookstore.model.order.OrderStatus;
import com.bookstore.model.user.User;
import com.bookstore.model.user.UserManager;

/**
 * Servlet for displaying order details in admin panel
 */
@WebServlet("/admin/order-details")
public class AdminOrderDetailsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private OrderManager orderManager;
    private UserManager userManager;

    @Override
    public void init() throws ServletException {
        // Initialize managers with ServletContext
        orderManager = new OrderManager(getServletContext());
        userManager = new UserManager(getServletContext());
    }

    /**
     * Handles GET requests - display order details
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        try {
            // Check if admin is logged in
            if (session.getAttribute("adminId") == null) {
                response.sendRedirect(request.getContextPath() + "/admin/login");
                return;
            }

            // Get order ID from request parameter
            String orderId = request.getParameter("orderId");
            if (orderId == null || orderId.trim().isEmpty()) {
                session.setAttribute("errorMessage", "Order ID is required");
                response.sendRedirect(request.getContextPath() + "/admin/orders");
                return;
            }

            // Get order details
            Order order = orderManager.getOrderById(orderId);
            if (order == null) {
                session.setAttribute("errorMessage", "Order not found");
                response.sendRedirect(request.getContextPath() + "/admin/orders");
                return;
            }

            // Ensure order has valid items and totals
            if (order.getItems() == null || order.getItems().isEmpty()) {
                System.out.println("Order has no items: " + orderId);
            } else {
                System.out.println("Order has " + order.getItems().size() + " items");
            }

            // Make sure totals are calculated
            try {
                order.calculateTotals();
            } catch (Exception e) {
                System.err.println("Error calculating order totals: " + e.getMessage());
            }

            // Get customer information
            String userId = order.getUserId();
            User customer = null;
            if (userId != null) {
                customer = userManager.getUserById(userId);
                if (customer == null) {
                    System.out.println("Customer not found for user ID: " + userId);
                }
            }

            // Set attributes in request
            request.setAttribute("order", order);
            request.setAttribute("customer", customer);
            request.setAttribute("statuses", OrderStatus.values());

            // Forward to admin order details page
            request.getRequestDispatcher("/admin/order/order-details.jsp").forward(request, response);
        } catch (Exception e) {
            // Log the error
            System.err.println("Error in AdminOrderDetailsServlet: " + e.getMessage());
            e.printStackTrace();

            // Set error message
            session.setAttribute("errorMessage", "An error occurred while loading order details: " + e.getMessage());

            // Redirect to orders list
            response.sendRedirect(request.getContextPath() + "/admin/orders");
        }
    }
}
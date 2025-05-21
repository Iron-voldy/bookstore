package com.bookstore.servlet.admin;

import java.io.IOException;
import java.util.ArrayList;

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
        orderManager = new OrderManager(getServletContext());
        userManager = new UserManager(getServletContext());
        System.out.println("AdminOrderDetailsServlet initialized");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // Check if admin is logged in
        if (session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        // Get order ID from request
        String orderId = request.getParameter("orderId");
        if (orderId == null || orderId.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Order ID is required");
            response.sendRedirect(request.getContextPath() + "/admin/orders");
            return;
        }

        System.out.println("AdminOrderDetailsServlet: Retrieving order: " + orderId);

        // Clear any previous order data from request (important!)
        request.removeAttribute("order");
        request.removeAttribute("customer");
        request.removeAttribute("statuses");

        // Get order details - force reload from OrderManager to prevent stale data
        orderManager = new OrderManager(getServletContext()); // Reload OrderManager to get fresh data
        Order order = orderManager.getOrderById(orderId);

        if (order == null) {
            session.setAttribute("errorMessage", "Order not found");
            response.sendRedirect(request.getContextPath() + "/admin/orders");
            return;
        }

        // Log order details for debugging
        System.out.println("AdminOrderDetailsServlet: Order found - ID: " + order.getOrderId() +
                ", Status: " + order.getStatus());

        // Get customer info if available
        User customer = null;
        if (order.getUserId() != null) {
            customer = userManager.getUserById(order.getUserId());
        }

        // Make sure order has items
        if (order.getItems() == null) {
            order.setItems(new ArrayList<>());
        }

        // Make sure totals are calculated
        order.calculateTotals();

        // Set order statuses for the dropdown
        OrderStatus[] statuses = OrderStatus.values();

        // Debugging order status
        System.out.println("AdminOrderDetailsServlet: Order Status: " +
                (order.getStatus() != null ? order.getStatus().name() : "NULL"));
        System.out.println("AdminOrderDetailsServlet: Available Statuses: " +
                java.util.Arrays.toString(statuses));

        // Set attributes for JSP (must be done AFTER clearing previous attributes)
        request.setAttribute("order", order);
        request.setAttribute("customer", customer);
        request.setAttribute("statuses", statuses);

        // Forward to admin order details page
        request.getRequestDispatcher("/admin/order/order-details.jsp").forward(request, response);
    }
}
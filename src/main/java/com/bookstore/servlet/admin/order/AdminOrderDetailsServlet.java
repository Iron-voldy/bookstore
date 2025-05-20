package com.bookstore.servlet.admin.order;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
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
        // Initialize managers
        orderManager = new OrderManager(getServletContext());
        userManager = new UserManager(getServletContext());
        System.out.println("AdminOrderDetailsServlet initialized with managers");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Check if admin is logged in
        if (session == null || session.getAttribute("adminId") == null) {
            System.out.println("AdminOrderDetailsServlet: Admin not logged in, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        try {
            // Get order ID from request parameter
            String orderId = request.getParameter("orderId");
            if (orderId == null || orderId.trim().isEmpty()) {
                System.out.println("AdminOrderDetailsServlet: No order ID provided");
                session.setAttribute("errorMessage", "Order ID is required");
                response.sendRedirect(request.getContextPath() + "/admin/orders");
                return;
            }

            // Debugging
            System.out.println("AdminOrderDetailsServlet: Loading order with ID: " + orderId);

            // Get order details
            Order order = orderManager.getOrderById(orderId);

            if (order == null) {
                System.out.println("AdminOrderDetailsServlet: Order not found: " + orderId);
                session.setAttribute("errorMessage", "Order not found");
                response.sendRedirect(request.getContextPath() + "/admin/orders");
                return;
            }

            // Ensure order has items
            if (order.getItems() == null) {
                System.out.println("AdminOrderDetailsServlet: Order has no items, initializing empty list");
                order.setItems(new ArrayList<>());
            }

            // Force recalculation of totals
            order.calculateTotals();

            System.out.println("AdminOrderDetailsServlet: Order loaded successfully. Status: " +
                    (order.getStatus() != null ? order.getStatus().name() : "NULL"));
            System.out.println("AdminOrderDetailsServlet: Order items count: " + order.getItems().size());
            System.out.println("AdminOrderDetailsServlet: Order total: " + order.getTotal());

            // Get customer information
            User customer = null;
            if (order.getUserId() != null) {
                customer = userManager.getUserById(order.getUserId());
                System.out.println("AdminOrderDetailsServlet: Customer found: " +
                        (customer != null ? customer.getUsername() : "NULL"));
            }

            // Set attributes for the JSP
            request.setAttribute("order", order);
            request.setAttribute("customer", customer);

            // Get all possible statuses and set as attribute
            OrderStatus[] statuses = OrderStatus.values();
            System.out.println("AdminOrderDetailsServlet: Available statuses: " + Arrays.toString(statuses));
            request.setAttribute("statuses", statuses);

            // Forward to order details page
            System.out.println("AdminOrderDetailsServlet: Forwarding to admin/order/order-details.jsp");
            request.getRequestDispatcher("/admin/order/order-details.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Error in AdminOrderDetailsServlet: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("errorMessage", "An error occurred while loading order details: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/orders");
        }
    }
}
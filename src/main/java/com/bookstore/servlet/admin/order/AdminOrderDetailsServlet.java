package com.bookstore.servlet.admin.order;

import java.io.IOException;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
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
 * Simplified servlet for displaying order details in admin panel
 */
@WebServlet("/admin/order-details")
public class AdminOrderDetailsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Check if admin is logged in
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        try {
            // Get order ID from request parameter
            String orderId = request.getParameter("orderId");
            if (orderId == null || orderId.trim().isEmpty()) {
                session.setAttribute("errorMessage", "Order ID is required");
                response.sendRedirect(request.getContextPath() + "/admin/orders");
                return;
            }

            // Get order details
            OrderManager orderManager = new OrderManager(getServletContext());
            Order order = orderManager.getOrderById(orderId);

            if (order == null) {
                session.setAttribute("errorMessage", "Order not found");
                response.sendRedirect(request.getContextPath() + "/admin/orders");
                return;
            }

            // Ensure order has items
            if (order.getItems() == null) {
                order.setItems(new ArrayList<>());
            }

            // Force recalculation of totals
            order.calculateTotals();

            // Get customer information
            UserManager userManager = new UserManager(getServletContext());
            User customer = null;
            if (order.getUserId() != null) {
                customer = userManager.getUserById(order.getUserId());
            }

            // Set attributes for the JSP
            request.setAttribute("order", order);
            request.setAttribute("customer", customer);
            request.setAttribute("statuses", OrderStatus.values());

            // Forward to order details page
            request.getRequestDispatcher("/admin/order/order-details.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Error in AdminOrderDetailsServlet: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("errorMessage", "An error occurred while loading order details: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/orders");
        }
    }
}
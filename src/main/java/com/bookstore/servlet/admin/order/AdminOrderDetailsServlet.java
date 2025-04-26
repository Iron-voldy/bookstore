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

    /**
     * Handles GET requests - display order details
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

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

        // Get order manager
        OrderManager orderManager = new OrderManager(getServletContext());

        // Get order details
        Order order = orderManager.getOrderById(orderId);
        if (order == null) {
            session.setAttribute("errorMessage", "Order not found");
            response.sendRedirect(request.getContextPath() + "/admin/orders");
            return;
        }

        // Get customer information
        String userId = order.getUserId();
        User customer = null;
        if (userId != null) {
            UserManager userManager = new UserManager(getServletContext());
            customer = userManager.getUserById(userId);
        }

        // Set attributes in request
        request.setAttribute("order", order);
        request.setAttribute("customer", customer);
        request.setAttribute("statuses", OrderStatus.values());

        // Forward to admin order details page
        request.getRequestDispatcher("/admin/order/order-details.jsp").forward(request, response);
    }
}
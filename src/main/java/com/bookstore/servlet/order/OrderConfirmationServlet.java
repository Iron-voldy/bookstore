package com.bookstore.servlet.order;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.bookstore.model.order.Order;
import com.bookstore.model.order.OrderManager;

/**
 * Servlet for handling order confirmation
 */
@WebServlet("/order-confirmation")
public class OrderConfirmationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests - display order confirmation
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // Check if user is logged in
        if (session.getAttribute("userId") == null) {
            session.setAttribute("errorMessage", "Please log in to view order confirmation");
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
        OrderManager orderManager = new OrderManager(getServletContext());
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

        // Set order in request
        request.setAttribute("order", order);

        // Forward to confirmation page
        request.getRequestDispatcher("/order/order-confirmation.jsp").forward(request, response);
    }
}
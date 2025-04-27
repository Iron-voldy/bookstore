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
 * Servlet for handling order confirmation display
 */
@WebServlet("/order-confirmation")
public class OrderConfirmationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private OrderManager orderManager;

    @Override
    public void init() throws ServletException {
        orderManager = new OrderManager(getServletContext());
    }

    /**
     * Handles GET requests - display order confirmation
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // Check if user is logged in
        String userId = (String) session.getAttribute("userId");
        if (userId == null) {
            session.setAttribute("errorMessage", "Please log in to view order confirmation");
            session.setAttribute("redirectAfterLogin", request.getRequestURI() + "?" + request.getQueryString());
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get order ID from request parameter
        String orderId = request.getParameter("orderId");
        if (orderId == null || orderId.trim().isEmpty()) {
            // If no order ID is provided, check if there's one in the session
            orderId = (String) session.getAttribute("currentOrderId");
            if (orderId == null) {
                session.setAttribute("errorMessage", "Order ID is required");
                response.sendRedirect(request.getContextPath() + "/order-history");
                return;
            }
        }

        // Get order details
        Order order = orderManager.getOrderById(orderId);

        if (order == null) {
            session.setAttribute("errorMessage", "Order not found");
            response.sendRedirect(request.getContextPath() + "/order-history");
            return;
        }

        // Check if this order belongs to the logged-in user
        if (!order.getUserId().equals(userId)) {
            session.setAttribute("errorMessage", "You do not have permission to view this order");
            response.sendRedirect(request.getContextPath() + "/order-history");
            return;
        }

        // Set order in request
        request.setAttribute("order", order);

        // Remove the currentOrderId from session since we're done with it
        session.removeAttribute("currentOrderId");

        // Forward to confirmation page
        request.getRequestDispatcher("/order/order-confirmation.jsp").forward(request, response);
    }
}
package com.bookstore.servlet.order;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

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

    public void init() throws ServletException {
        // Initialize OrderManager with ServletContext
        orderManager = new OrderManager(getServletContext());
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get user session
        HttpSession session = request.getSession(false);

        // Check if user is logged in
        if (session == null || session.getAttribute("userId") == null) {
            // Redirect to login if not logged in
            session.setAttribute("redirectAfterLogin", request.getContextPath() + "/order-history");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get user ID
        String userId = (String) session.getAttribute("userId");

        // Set OrderStatus array as an attribute for the JSP
        request.setAttribute("statuses", OrderStatus.values());

        // Get status filter parameter
        String statusFilter = request.getParameter("status");

        // Fetch orders
        List<Order> orders;
        if (statusFilter != null && !statusFilter.isEmpty()) {
            try {
                OrderStatus status = OrderStatus.valueOf(statusFilter.toUpperCase());
                orders = orderManager.getOrdersByUser(userId).stream()
                        .filter(order -> order.getStatus() == status)
                        .collect(Collectors.toList());
            } catch (IllegalArgumentException e) {
                // Invalid status, fetch all orders
                orders = orderManager.getOrdersByUser(userId);
            }
        } else {
            // Fetch all orders for the user
            orders = orderManager.getOrdersByUser(userId);
        }

        // Set attributes for the JSP
        request.setAttribute("orders", orders);
        request.setAttribute("statusFilter", statusFilter);

        // Forward to order history page
        request.getRequestDispatcher("/order/order-history.jsp").forward(request, response);
    }
}
package com.bookstore.servlet.admin.order;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.bookstore.model.order.Order;
import com.bookstore.model.order.OrderManager;
import com.bookstore.model.order.OrderStatus;

/**
 * Servlet for handling admin order list
 */
@WebServlet("/admin/orders")
public class AdminOrdersServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests - display admin order list
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

        // Get status filter parameter
        String statusFilter = request.getParameter("status");
        OrderStatus status = null;
        if (statusFilter != null && !statusFilter.trim().isEmpty()) {
            try {
                status = OrderStatus.valueOf(statusFilter.toUpperCase());
            } catch (IllegalArgumentException e) {
                // Invalid status, ignore filter
            }
        }

        // Get search query
        String search = request.getParameter("search");

        // Get order manager
        OrderManager orderManager = new OrderManager(getServletContext());

        // Get orders based on filters
        List<Order> orders;
        if (search != null && !search.trim().isEmpty()) {
            // Search for orders
            orders = orderManager.searchOrders(search);
        } else if (status != null) {
            // Filter by status
            orders = orderManager.getOrdersByStatus(status);
        } else {
            // Get all orders
            orders = orderManager.getAllOrders();
        }

        // Get order counts by status for dashboard stats
        Map<OrderStatus, Integer> orderCounts = orderManager.getOrderCountsByStatus();

        // Set attributes in request
        request.setAttribute("orders", orders);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("statuses", OrderStatus.values());
        request.setAttribute("orderCounts", orderCounts);
        request.setAttribute("totalSales", orderManager.getTotalSales());
        request.setAttribute("search", search);

        // Forward to admin orders page
        request.getRequestDispatcher("/admin/order/orders.jsp").forward(request, response);
    }
}
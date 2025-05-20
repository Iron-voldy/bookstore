package com.bookstore.servlet.admin;  // Make sure this is the correct package

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
 * Servlet for displaying all orders in admin panel
 */
@WebServlet("/admin/orders")  // This URL pattern is causing the conflict
public class AdminOrdersServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private OrderManager orderManager;

    @Override
    public void init() throws ServletException {
        orderManager = new OrderManager(getServletContext());
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

        try {
            // Get filters
            String statusFilter = request.getParameter("status");
            String search = request.getParameter("search");

            System.out.println("AdminOrdersServlet: status filter = " + statusFilter + ", search = " + search);

            // Get order statistics
            Map<OrderStatus, Integer> orderCounts = orderManager.getOrderCountsByStatus();
            double totalSales = orderManager.getTotalSales();

            // Get orders based on filters
            List<Order> orders;
            if (search != null && !search.trim().isEmpty()) {
                orders = orderManager.searchOrders(search);
            } else if (statusFilter != null && !statusFilter.trim().isEmpty()) {
                try {
                    OrderStatus status = OrderStatus.valueOf(statusFilter.toUpperCase());
                    orders = orderManager.getOrdersByStatus(status);
                } catch (IllegalArgumentException e) {
                    orders = orderManager.getAllOrders();
                }
            } else {
                orders = orderManager.getAllOrders();
            }

            // Set order statuses for filtering
            OrderStatus[] statuses = OrderStatus.values();

            // Set attributes for JSP
            request.setAttribute("orders", orders);
            request.setAttribute("orderCounts", orderCounts);
            request.setAttribute("totalSales", totalSales);
            request.setAttribute("statusFilter", statusFilter);
            request.setAttribute("search", search);
            request.setAttribute("statuses", statuses);

            // Forward to admin orders page
            request.getRequestDispatcher("/admin/order/orders.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Error in AdminOrdersServlet: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        }
    }
}
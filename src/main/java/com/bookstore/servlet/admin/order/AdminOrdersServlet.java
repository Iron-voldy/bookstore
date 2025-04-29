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
    private OrderManager orderManager;

    @Override
    public void init() throws ServletException {
        // Initialize OrderManager with ServletContext
        orderManager = new OrderManager(getServletContext());
    }

    /**
     * Handles GET requests - display admin order list
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

            // Get status filter parameter
            String statusFilter = request.getParameter("status");
            OrderStatus status = null;
            if (statusFilter != null && !statusFilter.trim().isEmpty()) {
                try {
                    status = OrderStatus.valueOf(statusFilter.toUpperCase());
                } catch (IllegalArgumentException e) {
                    // Invalid status, ignore filter
                    System.out.println("Invalid status filter: " + statusFilter);
                }
            }

            // Get search query
            String search = request.getParameter("search");

            // Get orders based on filters
            List<Order> orders;
            if (search != null && !search.trim().isEmpty()) {
                // Search for orders
                orders = orderManager.searchOrders(search);
                System.out.println("Searching for orders with query: " + search + ", found: " + orders.size());
            } else if (status != null) {
                // Filter by status
                orders = orderManager.getOrdersByStatus(status);
                System.out.println("Filtering orders by status: " + status + ", found: " + orders.size());
            } else {
                // Get all orders
                orders = orderManager.getAllOrders();
                System.out.println("Getting all orders, found: " + orders.size());
            }

            // Get order counts by status for dashboard stats
            Map<OrderStatus, Integer> orderCounts = orderManager.getOrderCountsByStatus();

            // Get total sales with proper handling
            double totalSales = 0.0;
            try {
                totalSales = orderManager.getTotalSales();
                System.out.println("Total sales amount: " + totalSales);
            } catch (Exception e) {
                System.err.println("Error getting total sales: " + e.getMessage());
                e.printStackTrace();
                // Default to 0.0 for total sales
                totalSales = 0.0;
            }

            // Set attributes in request
            request.setAttribute("orders", orders);
            request.setAttribute("statusFilter", statusFilter);
            request.setAttribute("statuses", OrderStatus.values());
            request.setAttribute("orderCounts", orderCounts);
            request.setAttribute("totalSales", Double.valueOf(totalSales));
            request.setAttribute("search", search);

            // Forward to admin orders page
            request.getRequestDispatcher("/admin/order/orders.jsp").forward(request, response);
        } catch (Exception e) {
            // Log the error
            System.err.println("Error in AdminOrdersServlet: " + e.getMessage());
            e.printStackTrace();

            // Set error message
            session.setAttribute("errorMessage", "An error occurred while loading orders: " + e.getMessage());

            // Forward to error page or dashboard
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        }
    }
}
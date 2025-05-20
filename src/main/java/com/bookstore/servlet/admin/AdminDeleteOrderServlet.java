package com.bookstore.servlet.admin;

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
 * Servlet for handling order deletion from admin
 */
@WebServlet("/admin/delete-order")
public class AdminDeleteOrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private OrderManager orderManager;

    @Override
    public void init() throws ServletException {
        orderManager = new OrderManager(getServletContext());
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // Check if admin is logged in
        if (session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        // Check if admin is a super admin
        Boolean isSuperAdmin = (Boolean) session.getAttribute("isSuperAdmin");
        if (isSuperAdmin == null || !isSuperAdmin) {
            session.setAttribute("errorMessage", "You do not have permission to delete orders");
            response.sendRedirect(request.getContextPath() + "/admin/orders");
            return;
        }

        try {
            // Get order ID
            String orderId = request.getParameter("orderId");
            String confirm = request.getParameter("confirm");

            System.out.println("AdminDeleteOrderServlet: orderId=" + orderId + ", confirm=" + confirm);

            // Validate parameters
            if (orderId == null || orderId.trim().isEmpty()) {
                session.setAttribute("errorMessage", "Order ID is required");
                response.sendRedirect(request.getContextPath() + "/admin/orders");
                return;
            }

            // Check if deletion is confirmed
            if (!"yes".equals(confirm)) {
                session.setAttribute("errorMessage", "Delete operation not confirmed");
                response.sendRedirect(request.getContextPath() + "/admin/order-details?orderId=" + orderId);
                return;
            }

            // Get order to verify it exists
            Order order = orderManager.getOrderById(orderId);
            if (order == null) {
                session.setAttribute("errorMessage", "Order not found");
                response.sendRedirect(request.getContextPath() + "/admin/orders");
                return;
            }

            // Delete the order
            boolean deleted = orderManager.deleteOrder(orderId);

            if (deleted) {
                session.setAttribute("successMessage", "Order deleted successfully");
                response.sendRedirect(request.getContextPath() + "/admin/orders");
            } else {
                session.setAttribute("errorMessage", "Failed to delete order");
                response.sendRedirect(request.getContextPath() + "/admin/order-details?orderId=" + orderId);
            }

        } catch (Exception e) {
            System.err.println("Error in AdminDeleteOrderServlet: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/orders");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect GET requests to orders page
        response.sendRedirect(request.getContextPath() + "/admin/orders");
    }
}
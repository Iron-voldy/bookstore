package com.bookstore.servlet.admin.order;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.bookstore.model.order.OrderManager;

/**
 * Servlet for deleting orders (admin function)
 */
@WebServlet("/admin/delete-order")
public class DeleteOrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles POST requests - delete an order
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
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

        // Get confirmation parameter
        String confirm = request.getParameter("confirm");
        if (!"yes".equals(confirm)) {
            session.setAttribute("errorMessage", "Confirmation required to delete an order");
            response.sendRedirect(request.getContextPath() + "/admin/order-details?orderId=" + orderId);
            return;
        }

        // Delete the order
        OrderManager orderManager = new OrderManager(getServletContext());
        boolean deleted = orderManager.deleteOrder(orderId);

        if (deleted) {
            session.setAttribute("successMessage", "Order deleted successfully");
        } else {
            session.setAttribute("errorMessage", "Failed to delete order");
        }

        // Redirect to orders list
        response.sendRedirect(request.getContextPath() + "/admin/orders");
    }

    /**
     * Handles GET requests - redirect to POST
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect GET requests to order list
        response.sendRedirect(request.getContextPath() + "/admin/orders");
    }
}
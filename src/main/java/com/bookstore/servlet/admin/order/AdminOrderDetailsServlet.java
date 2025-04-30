package com.bookstore.servlet.admin.order;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.bookstore.model.order.Order;
import com.bookstore.model.order.OrderItem;
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
    private OrderManager orderManager;
    private UserManager userManager;

    @Override
    public void init() throws ServletException {
        // Initialize managers with ServletContext
        orderManager = new OrderManager(getServletContext());
        userManager = new UserManager(getServletContext());
    }

    /**
     * Handles GET requests - display order details
     */
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

            // Force recalculation of totals and ensure they are not null
            try {
                // Validate and clean order items
                validateAndCleanOrderItems(order);

                // Manually calculate totals
                double calculatedSubtotal = calculateSubtotal(order);
                double calculatedTax = calculateTax(calculatedSubtotal);
                double calculatedTotal = calculateTotal(calculatedSubtotal, calculatedTax);

                // Set calculated values if they are zero or invalid
                if (order.getSubtotal() <= 0) {
                    order.setSubtotal(calculatedSubtotal);
                }
                if (order.getTax() <= 0) {
                    order.setTax(calculatedTax);
                }
                if (order.getTotal() <= 0) {
                    order.setTotal(calculatedTotal);
                }
            } catch (Exception e) {
                System.err.println("Error processing order totals: " + e.getMessage());
                e.printStackTrace();
            }

            // Get customer information
            String userId = order.getUserId();
            User customer = null;
            if (userId != null) {
                customer = userManager.getUserById(userId);
            }

            // Set attributes for the JSP
            request.setAttribute("order", order);
            request.setAttribute("customer", customer);
            request.setAttribute("statuses", OrderStatus.values());

            // Explicitly set the orderDate to handle formatting issues
            request.setAttribute("orderDate",
                    order.getOrderDate() != null ? order.getOrderDate() : new Date());

            // Set calculated values as separate attributes
            request.setAttribute("calculatedSubtotal", calculateSubtotal(order));
            request.setAttribute("calculatedTax", calculateTax(calculateSubtotal(order)));
            request.setAttribute("calculatedTotal", calculateTotal(
                    calculateSubtotal(order),
                    calculateTax(calculateSubtotal(order))
            ));

            // Forward to order details page
            request.getRequestDispatcher("/admin/order/order-details.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Unexpected error in AdminOrderDetailsServlet: " + e.getMessage());
            e.printStackTrace();

            // Set error message
            session.setAttribute("errorMessage",
                    "An unexpected error occurred while loading order details: " + e.getMessage());

            // Redirect to orders list
            response.sendRedirect(request.getContextPath() + "/admin/orders");
        }
    }

    /**
     * Calculate subtotal manually with robust error handling
     * @param order The order to calculate subtotal for
     * @return The calculated subtotal
     */
    private double calculateSubtotal(Order order) {
        if (order.getItems() == null || order.getItems().isEmpty()) {
            return 0.0;
        }

        return order.getItems().stream()
                .mapToDouble(item -> {
                    // Handle cases where discounted price might be zero
                    double price = item.getDiscountedPrice() > 0 ?
                            item.getDiscountedPrice() :
                            (item.getPrice() > 0 ? item.getPrice() : 0.0);

                    // Handle potential negative or zero quantity
                    int quantity = item.getQuantity() > 0 ? item.getQuantity() : 1;

                    return price * quantity;
                })
                .sum();
    }

    /**
     * Calculate tax based on subtotal
     * @param subtotal The subtotal to calculate tax on
     * @return Calculated tax amount
     */
    private double calculateTax(double subtotal) {
        // Default tax rate of 7%
        return subtotal * 0.07;
    }

    /**
     * Calculate total including subtotal, tax, and shipping
     * @param subtotal Subtotal amount
     * @param tax Tax amount
     * @return Total amount
     */
    private double calculateTotal(double subtotal, double tax) {
        // Add shipping cost if applicable
        double shippingCost = subtotal < 35.0 ? 4.99 : 0.0;
        return subtotal + tax + shippingCost;
    }

    /**
     * Validate and clean order items to prevent calculation errors
     * @param order The order to validate
     */
    private void validateAndCleanOrderItems(Order order) {
        if (order.getItems() == null) {
            order.setItems(new ArrayList<>());
            return;
        }

        // Remove invalid items
        order.getItems().removeIf(item ->
                item == null ||
                        item.getQuantity() <= 0 ||
                        (item.getDiscountedPrice() <= 0 && item.getPrice() <= 0)
        );
    }
}
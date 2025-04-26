package com.bookstore.servlet.order;

import java.io.IOException;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.bookstore.model.cart.CartManager;
import com.bookstore.model.order.Order;
import com.bookstore.model.order.OrderManager;
import com.bookstore.model.user.User;
import com.bookstore.model.user.UserManager;

/**
 * Servlet for handling the checkout process
 */
@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests - display the checkout form
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // Verify user is logged in
        String userId = (String) session.getAttribute("userId");
        String cartId = (String) session.getAttribute("cartId");

        // If not logged in, redirect to login
        if (userId == null) {
            session.setAttribute("errorMessage", "Please log in to complete checkout");
            session.setAttribute("redirectAfterLogin", request.getContextPath() + "/checkout");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Check if cart is empty
        CartManager cartManager = new CartManager(getServletContext());
        Map<String, Integer> cart = cartManager.getUserCart(userId);

        if (cart.isEmpty()) {
            session.setAttribute("errorMessage", "Your cart is empty");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        // Get user information for pre-filling the form
        UserManager userManager = new UserManager(getServletContext());
        User user = userManager.getUserById(userId);

        if (user != null) {
            request.setAttribute("user", user);
        }

        // Calculate cart totals
        double subtotal = cartManager.getCartTotal(userId);
        double tax = subtotal * 0.07;  // 7% tax
        double shipping = (subtotal < 35.0) ? 4.99 : 0.0; // Free shipping for orders over $35
        double total = subtotal + tax + shipping;

        // Set attributes for JSP
        request.setAttribute("cart", cart);
        request.setAttribute("cartBooks", cartManager.getCartBookDetails(userId));
        request.setAttribute("subtotal", subtotal);
        request.setAttribute("tax", tax);
        request.setAttribute("shipping", shipping);
        request.setAttribute("total", total);

        // Forward to checkout page
        request.getRequestDispatcher("/order/checkout.jsp").forward(request, response);
    }

    /**
     * Handles POST requests - process the checkout form
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // Verify user is logged in
        String userId = (String) session.getAttribute("userId");

        // If not logged in, redirect to login
        if (userId == null) {
            session.setAttribute("errorMessage", "Please log in to complete checkout");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get form data
        String shippingAddress = request.getParameter("shippingAddress");
        String billingAddress = request.getParameter("billingAddress");
        String contactEmail = request.getParameter("contactEmail");
        String contactPhone = request.getParameter("contactPhone");
        String sameAsBilling = request.getParameter("sameAsBilling");

        // Handle "same as billing" checkbox
        if ("on".equals(sameAsBilling)) {
            billingAddress = shippingAddress;
        }

        // Validate required fields
        if (shippingAddress == null || shippingAddress.trim().isEmpty() ||
                billingAddress == null || billingAddress.trim().isEmpty() ||
                contactEmail == null || contactEmail.trim().isEmpty() ||
                contactPhone == null || contactPhone.trim().isEmpty()) {

            session.setAttribute("errorMessage", "All fields are required");
            response.sendRedirect(request.getContextPath() + "/checkout");
            return;
        }

        // Get cart items
        CartManager cartManager = new CartManager(getServletContext());
        Map<String, Integer> cart = cartManager.getUserCart(userId);

        if (cart.isEmpty()) {
            session.setAttribute("errorMessage", "Your cart is empty");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        try {
            // Create the order
            OrderManager orderManager = new OrderManager(getServletContext());
            Order order = orderManager.createOrder(userId, cart, shippingAddress,
                    billingAddress, contactEmail, contactPhone);

            if (order != null) {
                // Clear the cart
                cartManager.clearCart(userId);
                session.setAttribute("cartCount", 0);

                // Store order ID in session for payment processing
                session.setAttribute("currentOrderId", order.getOrderId());

                // Redirect to payment page
                response.sendRedirect(request.getContextPath() + "/process-payment");
            } else {
                session.setAttribute("errorMessage", "Failed to create order. Please try again.");
                response.sendRedirect(request.getContextPath() + "/checkout");
            }

        } catch (Exception e) {
            System.err.println("Error processing checkout: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/checkout");
        }
    }
}
package com.bookstore.servlet.order;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.bookstore.model.book.Book;
import com.bookstore.model.book.BookManager;
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
        System.out.println("CheckoutServlet: doGet method started");

        // Verify user is logged in
        String userId = (String) session.getAttribute("userId");

        System.out.println("CheckoutServlet: userId from session = " + userId);

        // If not logged in, redirect to login
        if (userId == null) {
            session.setAttribute("errorMessage", "Please log in to complete checkout");
            session.setAttribute("redirectAfterLogin", request.getContextPath() + "/checkout");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // Initialize managers
            BookManager bookManager = new BookManager(getServletContext());
            CartManager cartManager = new CartManager(getServletContext());
            UserManager userManager = new UserManager(getServletContext());

            // Get cart items
            Map<String, Integer> cart = cartManager.getUserCart(userId);
            System.out.println("CheckoutServlet: cart size = " + cart.size());

            if (cart.isEmpty()) {
                session.setAttribute("errorMessage", "Your cart is empty");
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }

            // Get user information for pre-filling the form
            User user = userManager.getUserById(userId);
            System.out.println("CheckoutServlet: user = " + (user != null ? user.toString() : "null"));
            request.setAttribute("user", user);

            // Get cart books details
            Map<String, Book> cartBooks = cartManager.getCartBookDetails(userId);

            // Calculate cart totals
            double subtotal = cartManager.getCartTotal(userId);
            double tax = subtotal * 0.07;  // 7% tax
            double shipping = (subtotal < 35.0) ? 4.99 : 0.0; // Free shipping for orders over $35
            double total = subtotal + tax + shipping;

            System.out.println("CheckoutServlet: calculated values - subtotal=" + subtotal
                    + ", tax=" + tax + ", shipping=" + shipping + ", total=" + total);

            // Set attributes for JSP
            request.setAttribute("cart", cart);
            request.setAttribute("cartBooks", cartBooks);
            request.setAttribute("subtotal", Double.valueOf(subtotal));
            request.setAttribute("tax", Double.valueOf(tax));
            request.setAttribute("shipping", Double.valueOf(shipping));
            request.setAttribute("total", Double.valueOf(total));

            // Forward to checkout page
            System.out.println("CheckoutServlet: Forwarding to checkout.jsp");
            request.getRequestDispatcher("/order/checkout.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("CheckoutServlet: Error displaying checkout page: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }

    /**
     * Handles POST requests - process the checkout form
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        System.out.println("CheckoutServlet: doPost method started");

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

        System.out.println("CheckoutServlet: Form data - shipping=" + shippingAddress
                + ", billing=" + billingAddress + ", email=" + contactEmail
                + ", phone=" + contactPhone + ", sameAsBilling=" + sameAsBilling);

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

        try {
            // Initialize managers
            CartManager cartManager = new CartManager(getServletContext());
            OrderManager orderManager = new OrderManager(getServletContext());

            // Get cart items
            Map<String, Integer> cart = cartManager.getUserCart(userId);

            if (cart.isEmpty()) {
                session.setAttribute("errorMessage", "Your cart is empty");
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }

            // Create the order
            Order order = orderManager.createOrder(userId, cart, shippingAddress,
                    billingAddress, contactEmail, contactPhone);

            if (order != null) {
                System.out.println("CheckoutServlet: Order created successfully - orderId=" + order.getOrderId());

                // Clear the cart
                cartManager.clearCart(userId);
                session.setAttribute("cartCount", 0);
                session.setAttribute("cart", new HashMap<String, Integer>()); // For backward compatibility

                // Store order ID in session for payment processing
                session.setAttribute("currentOrderId", order.getOrderId());

                // Redirect to payment page
                response.sendRedirect(request.getContextPath() + "/process-payment");
            } else {
                System.err.println("CheckoutServlet: Failed to create order");
                session.setAttribute("errorMessage", "Failed to create order. Please try again.");
                response.sendRedirect(request.getContextPath() + "/checkout");
            }

        } catch (Exception e) {
            System.err.println("CheckoutServlet: Error processing checkout: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/checkout");
        }
    }
}
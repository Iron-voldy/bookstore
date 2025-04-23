package com.bookstore.servlet.cart;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.bookstore.model.cart.CartManager;

/**
 * Servlet for handling clearing the shopping cart
 */
@WebServlet("/clear-cart")
public class ClearCartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests - clear cart
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get session
        HttpSession session = request.getSession(true);

        // Get user ID or guest cart ID
        String userId = (String) session.getAttribute("userId");
        String cartId = (String) session.getAttribute("cartId");

        // Use either user ID or cart ID
        String effectiveId = userId != null ? userId : cartId;

        // If we have a valid ID, clear the cart
        if (effectiveId != null) {
            CartManager cartManager = new CartManager(getServletContext());
            boolean success = cartManager.clearCart(effectiveId);

            if (success) {
                // For backward compatibility
                session.removeAttribute("cart");
                session.setAttribute("cartCount", 0);

                // Set success message
                session.setAttribute("successMessage", "Your cart has been cleared");
            } else {
                session.setAttribute("errorMessage", "Failed to clear your cart");
            }
        } else {
            // No cart to clear
            session.setAttribute("successMessage", "Your cart is already empty");
        }

        // Redirect back to cart page
        response.sendRedirect(request.getContextPath() + "/cart");
    }
}
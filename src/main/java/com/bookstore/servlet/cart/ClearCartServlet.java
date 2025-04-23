package com.bookstore.servlet.cart;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

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
        HttpSession session = request.getSession();

        // Remove cart from session
        session.removeAttribute("cart");

        // Reset cart count
        session.setAttribute("cartCount", 0);

        // Set success message
        session.setAttribute("successMessage", "Your cart has been cleared");

        // Redirect back to cart page
        response.sendRedirect(request.getContextPath() + "/cart");
    }
}
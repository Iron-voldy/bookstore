package com.bookstore.servlet.cart;

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

/**
 * Servlet for displaying the shopping cart
 */
@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests - display cart
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

        // Create a new cart ID if needed (for new users)
        if (effectiveId == null) {
            effectiveId = CartManager.generateCartId();
            session.setAttribute("cartId", effectiveId);
        }

        // Get CartManager
        CartManager cartManager = new CartManager(getServletContext());

        // Get cart details
        Map<String, Integer> cart = cartManager.getUserCart(effectiveId);
        Map<String, Book> cartBooks = cartManager.getCartBookDetails(effectiveId);
        double cartTotal = cartManager.getCartTotal(effectiveId);
        int cartCount = cartManager.getCartItemCount(effectiveId);

        // For backward compatibility, also update the session cart
        session.setAttribute("cart", cart);
        session.setAttribute("cartCount", cartCount);

        // Set attributes for JSP
        request.setAttribute("cart", cart);
        request.setAttribute("cartBooks", cartBooks);
        request.setAttribute("cartTotal", cartTotal);
        request.setAttribute("cartCount", cartCount);

        // Forward to cart JSP
        request.getRequestDispatcher("/cart.jsp").forward(request, response);
    }
}
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
import com.bookstore.model.book.EBook;
import com.bookstore.model.cart.CartManager;

/**
 * Servlet for handling shopping cart updates (increase, decrease, remove items)
 */
@WebServlet("/update-cart")
public class UpdateCartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles POST requests - update cart items
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get parameters
        String bookId = request.getParameter("bookId");
        String action = request.getParameter("action");

        // Validate parameters
        if (bookId == null || bookId.trim().isEmpty() || action == null || action.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        // Get session and user/cart ID
        HttpSession session = request.getSession(true);
        String userId = (String) session.getAttribute("userId");
        String cartId = (String) session.getAttribute("cartId");

        // Use either user ID or cart ID
        String effectiveId = userId != null ? userId : cartId;

        // Create a new cart ID if needed (shouldn't happen here but just in case)
        if (effectiveId == null) {
            effectiveId = CartManager.generateCartId();
            session.setAttribute("cartId", effectiveId);
        }

        // Get CartManager
        CartManager cartManager = new CartManager(getServletContext());

        // Get current cart for reference
        Map<String, Integer> cart = cartManager.getUserCart(effectiveId);

        // Get BookManager to check book availability
        BookManager bookManager = new BookManager(getServletContext());
        Book book = bookManager.getBookById(bookId);

        if (book == null) {
            // Book not found, redirect to cart
            session.setAttribute("errorMessage", "Book not found");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        // Handle different actions
        boolean success = false;
        switch (action) {
            case "increase":
                // Increase quantity by 1
                if (cart.containsKey(bookId)) {
                    int currentQuantity = cart.get(bookId);

                    // For physical books, check if we can add more
                    if (!(book instanceof EBook) && currentQuantity >= book.getQuantity()) {
                        session.setAttribute("errorMessage", "Cannot add more copies than available in stock");
                    } else {
                        success = cartManager.updateCartItem(effectiveId, bookId, currentQuantity + 1);
                        if (success) {
                            session.setAttribute("successMessage", "Cart updated");
                        }
                    }
                }
                break;

            case "decrease":
                // Decrease quantity by 1
                if (cart.containsKey(bookId)) {
                    int currentQuantity = cart.get(bookId);

                    if (currentQuantity > 1) {
                        // Decrease by 1
                        success = cartManager.updateCartItem(effectiveId, bookId, currentQuantity - 1);
                        if (success) {
                            session.setAttribute("successMessage", "Cart updated");
                        }
                    } else {
                        // Remove item if quantity would be 0
                        success = cartManager.removeFromCart(effectiveId, bookId);
                        if (success) {
                            session.setAttribute("successMessage", book.getTitle() + " removed from cart");
                        }
                    }
                }
                break;

            case "remove":
                // Remove item completely
                if (cart.containsKey(bookId)) {
                    success = cartManager.removeFromCart(effectiveId, bookId);
                    if (success) {
                        session.setAttribute("successMessage", book.getTitle() + " removed from cart");
                    }
                }
                break;

            default:
                // Invalid action
                session.setAttribute("errorMessage", "Invalid action");
                break;
        }

        // For backward compatibility, update the session cart
        if (success) {
            // Reload the cart after changes
            cart = cartManager.getUserCart(effectiveId);
            session.setAttribute("cart", cart);

            // Update cart count
            int cartCount = cartManager.getCartItemCount(effectiveId);
            session.setAttribute("cartCount", cartCount);
        }

        // Redirect back to cart
        response.sendRedirect(request.getContextPath() + "/cart");
    }
}
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

        // Get session and cart
        HttpSession session = request.getSession();
        Map<String, Integer> cart = (Map<String, Integer>) session.getAttribute("cart");

        // Initialize cart if it doesn't exist
        if (cart == null) {
            cart = new HashMap<>();
            session.setAttribute("cart", cart);
        }

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
        switch (action) {
            case "increase":
                // Increase quantity by 1
                if (cart.containsKey(bookId)) {
                    int currentQuantity = cart.get(bookId);

                    // For physical books, check if we can add more
                    if (!(book instanceof EBook) && currentQuantity >= book.getQuantity()) {
                        session.setAttribute("errorMessage", "Cannot add more copies than available in stock");
                    } else {
                        cart.put(bookId, currentQuantity + 1);
                        session.setAttribute("successMessage", "Cart updated");
                    }
                }
                break;

            case "decrease":
                // Decrease quantity by 1
                if (cart.containsKey(bookId)) {
                    int currentQuantity = cart.get(bookId);

                    if (currentQuantity > 1) {
                        // Decrease by 1
                        cart.put(bookId, currentQuantity - 1);
                        session.setAttribute("successMessage", "Cart updated");
                    } else {
                        // Remove item if quantity would be 0
                        cart.remove(bookId);
                        session.setAttribute("successMessage", book.getTitle() + " removed from cart");
                    }
                }
                break;

            case "remove":
                // Remove item completely
                if (cart.containsKey(bookId)) {
                    cart.remove(bookId);
                    session.setAttribute("successMessage", book.getTitle() + " removed from cart");
                }
                break;

            default:
                // Invalid action
                session.setAttribute("errorMessage", "Invalid action");
                break;
        }

        // Update cart count
        int cartCount = 0;
        for (int itemQuantity : cart.values()) {
            cartCount += itemQuantity;
        }
        session.setAttribute("cartCount", cartCount);

        // Redirect back to cart
        response.sendRedirect(request.getContextPath() + "/cart");
    }
}
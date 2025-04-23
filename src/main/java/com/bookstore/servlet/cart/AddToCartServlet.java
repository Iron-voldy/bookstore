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
 * Servlet for handling adding books to the shopping cart
 */
@WebServlet("/add-to-cart")
public class AddToCartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests - redirects to POST
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Redirect GET requests to use POST for proper cart manipulation
        String bookId = request.getParameter("bookId");
        String quantity = request.getParameter("quantity");

        if (bookId != null && !bookId.isEmpty()) {
            // Forward to the same URL but using POST
            request.setAttribute("bookId", bookId);
            request.setAttribute("quantity", quantity != null ? quantity : "1");
            request.getRequestDispatcher("/add-to-cart").forward(request, response);
        } else {
            // If no book ID, redirect to books page
            response.sendRedirect(request.getContextPath() + "/books");
        }
    }

    /**
     * Handles POST requests - add book to cart
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get the book ID and quantity
        String bookId = request.getParameter("bookId");
        String quantityStr = request.getParameter("quantity");

        // If parameters were set by doGet, use those instead
        if (bookId == null && request.getAttribute("bookId") != null) {
            bookId = (String) request.getAttribute("bookId");
        }

        if (quantityStr == null && request.getAttribute("quantity") != null) {
            quantityStr = (String) request.getAttribute("quantity");
        }

        // Validate input
        if (bookId == null || bookId.trim().isEmpty()) {
            // Missing bookId parameter, redirect to books page
            response.sendRedirect(request.getContextPath() + "/books");
            return;
        }

        // Parse quantity, default to 1
        int quantity = 1;
        if (quantityStr != null && !quantityStr.trim().isEmpty()) {
            try {
                quantity = Integer.parseInt(quantityStr.trim());
                if (quantity < 1) {
                    quantity = 1;
                }
            } catch (NumberFormatException e) {
                // Invalid quantity, use default
            }
        }

        // Get book from database to verify it exists
        BookManager bookManager = new BookManager(getServletContext());
        Book book = bookManager.getBookById(bookId);

        if (book == null) {
            // Book not found, redirect with error message
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Book not found");
            response.sendRedirect(request.getContextPath() + "/books");
            return;
        }

        // Check book availability
        boolean isAvailable = false;
        if (book instanceof EBook) {
            // E-books are always available
            isAvailable = true;
        } else {
            // Physical books need to check quantity
            isAvailable = book.getQuantity() >= quantity;
        }

        if (!isAvailable) {
            // Book not available in requested quantity
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Requested quantity not available");
            response.sendRedirect(request.getContextPath() + "/book-details?id=" + bookId);
            return;
        }

        // Get the current session
        HttpSession session = request.getSession(true);

        // Get or create user ID (for guest users)
        String userId = (String) session.getAttribute("userId");
        if (userId == null) {
            // Create a cart ID for anonymous users
            userId = CartManager.generateCartId();
            session.setAttribute("cartId", userId);
        }

        // Get CartManager and add item to cart
        CartManager cartManager = new CartManager(getServletContext());

        // First make sure the cart has a session map for backward compatibility
        Map<String, Integer> sessionCart = (Map<String, Integer>) session.getAttribute("cart");
        if (sessionCart == null) {
            sessionCart = new HashMap<>();
            session.setAttribute("cart", sessionCart);
        }

        // Add to persistent cart
        boolean success = cartManager.addToCart(userId, bookId, quantity);

        // Also update session cart for backward compatibility
        if (success) {
            // Update session cart
            int currentQuantity = sessionCart.getOrDefault(bookId, 0);
            sessionCart.put(bookId, currentQuantity + quantity);

            // Update cart count
            int cartCount = cartManager.getCartItemCount(userId);
            session.setAttribute("cartCount", cartCount);

            // Set success message
            session.setAttribute("successMessage", book.getTitle() + " added to your cart");
        } else {
            // Set error message
            session.setAttribute("errorMessage", "Failed to add " + book.getTitle() + " to your cart");
        }

        // Redirect to cart page instead of book details
        response.sendRedirect(request.getContextPath() + "/cart");
    }
}
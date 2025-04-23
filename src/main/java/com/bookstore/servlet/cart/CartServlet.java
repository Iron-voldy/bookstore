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
        HttpSession session = request.getSession();

        // Get or initialize cart
        Map<String, Integer> cart = (Map<String, Integer>) session.getAttribute("cart");
        if (cart == null) {
            cart = new HashMap<>();
            session.setAttribute("cart", cart);
        }

        // Get book details for items in cart
        BookManager bookManager = new BookManager(getServletContext());
        Map<String, Book> cartBooks = new HashMap<>();
        double cartTotal = 0.0;

        for (Map.Entry<String, Integer> entry : cart.entrySet()) {
            String bookId = entry.getKey();
            int quantity = entry.getValue();

            Book book = bookManager.getBookById(bookId);
            if (book != null) {
                cartBooks.put(bookId, book);
                cartTotal += book.getDiscountedPrice() * quantity;
            }
        }

        // Set attributes
        request.setAttribute("cart", cart);
        request.setAttribute("cartBooks", cartBooks);
        request.setAttribute("cartTotal", cartTotal);

        // Forward to cart JSP
        request.getRequestDispatcher("/cart.jsp").forward(request, response);
    }
}
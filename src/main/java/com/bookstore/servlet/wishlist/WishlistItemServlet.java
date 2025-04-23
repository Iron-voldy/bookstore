// File: src/main/java/com/bookstore/servlet/wishlist/WishlistItemServlet.java
package com.bookstore.servlet.wishlist;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.bookstore.model.book.Book;
import com.bookstore.model.book.BookManager;
import com.bookstore.model.wishlist.Wishlist;
import com.bookstore.model.wishlist.WishlistItem;
import com.bookstore.model.wishlist.WishlistManager;

/**
 * Servlet for managing wishlist items (add, update, remove)
 */
@WebServlet("/wishlist-item")
public class WishlistItemServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handle GET requests - add book to wishlist from book details page
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            // Redirect to login page
            session.setAttribute("errorMessage", "Please log in to manage your wishlist");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String userId = (String) session.getAttribute("userId");

        // Get action parameter
        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/wishlists");
            return;
        }

        // Get book ID
        String bookId = request.getParameter("bookId");
        if (bookId == null || bookId.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Invalid book ID");
            response.sendRedirect(request.getContextPath() + "/books");
            return;
        }

        // Check if book exists
        BookManager bookManager = new BookManager(getServletContext());
        Book book = bookManager.getBookById(bookId);
        if (book == null) {
            session.setAttribute("errorMessage", "Book not found");
            response.sendRedirect(request.getContextPath() + "/books");
            return;
        }

        // Initialize WishlistManager
        WishlistManager wishlistManager = new WishlistManager(getServletContext());

        switch (action) {
            case "add":
                // If it's a quick add, get default wishlist or create one
                Wishlist defaultWishlist = wishlistManager.getDefaultWishlist(userId);
                if (defaultWishlist == null) {
                    session.setAttribute("errorMessage", "Could not find or create default wishlist");
                    response.sendRedirect(request.getContextPath() + "/book-details?id=" + bookId);
                    return;
                }

                // Check if book is already in the wishlist
                if (wishlistManager.isBookInWishlist(defaultWishlist.getWishlistId(), bookId)) {
                    session.setAttribute("infoMessage", book.getTitle() + " is already in your wishlist");
                    response.sendRedirect(request.getContextPath() + "/book-details?id=" + bookId);
                    return;
                }

                // Add book to wishlist with default values
                boolean added = wishlistManager.addBookToWishlist(
                        defaultWishlist.getWishlistId(),
                        bookId,
                        "", // No notes
                        3); // Medium priority

                if (added) {
                    session.setAttribute("successMessage", book.getTitle() + " added to your wishlist");
                } else {
                    session.setAttribute("errorMessage", "Failed to add book to wishlist");
                }

                // Redirect back to book details
                response.sendRedirect(request.getContextPath() + "/book-details?id=" + bookId);
                break;

            case "select-wishlist":
                // Get user wishlists
                request.setAttribute("wishlists", wishlistManager.getUserWishlists(userId));
                request.setAttribute("book", book);

                // Forward to select wishlist page
                request.getRequestDispatcher("/wishlist/select-wishlist.jsp").forward(request, response);
                break;

            case "edit":
                String wishlistId = request.getParameter("wishlistId");
                if (wishlistId == null || wishlistId.trim().isEmpty()) {
                    session.setAttribute("errorMessage", "Invalid wishlist ID");
                    response.sendRedirect(request.getContextPath() + "/wishlists");
                    return;
                }

                // Get wishlist
                Wishlist wishlist = wishlistManager.getWishlist(wishlistId);
                if (wishlist == null) {
                    session.setAttribute("errorMessage", "Wishlist not found");
                    response.sendRedirect(request.getContextPath() + "/wishlists");
                    return;
                }

                // Check if user owns this wishlist
                if (!wishlist.getUserId().equals(userId)) {
                    session.setAttribute("errorMessage", "You do not have permission to edit this wishlist");
                    response.sendRedirect(request.getContextPath() + "/wishlists");
                    return;
                }

                // Check if book is in wishlist
                if (!wishlistManager.isBookInWishlist(wishlistId, bookId)) {
                    session.setAttribute("errorMessage", "Book is not in this wishlist");
                    response.sendRedirect(request.getContextPath() + "/wishlists?action=view&id=" + wishlistId);
                    return;
                }

                // Get wishlist items
                request.setAttribute("wishlist", wishlist);
                request.setAttribute("book", book);

                // Get current notes and priority for this item
                for (WishlistItem item : wishlistManager.getWishlistItems(wishlistId)) {
                    if (item.getBookId().equals(bookId)) {
                        request.setAttribute("notes", item.getNotes());
                        request.setAttribute("priority", item.getPriority());
                        break;
                    }
                }

                // Forward to edit item page
                request.getRequestDispatcher("/wishlist/edit-item.jsp").forward(request, response);
                break;

            case "remove":
                wishlistId = request.getParameter("wishlistId");
                if (wishlistId == null || wishlistId.trim().isEmpty()) {
                    session.setAttribute("errorMessage", "Invalid wishlist ID");
                    response.sendRedirect(request.getContextPath() + "/wishlists");
                    return;
                }

                // Get wishlist
                wishlist = wishlistManager.getWishlist(wishlistId);
                if (wishlist == null) {
                    session.setAttribute("errorMessage", "Wishlist not found");
                    response.sendRedirect(request.getContextPath() + "/wishlists");
                    return;
                }

                // Check if user owns this wishlist
                if (!wishlist.getUserId().equals(userId)) {
                    session.setAttribute("errorMessage", "You do not have permission to modify this wishlist");
                    response.sendRedirect(request.getContextPath() + "/wishlists");
                    return;
                }

                // Remove book from wishlist
                boolean removed = wishlistManager.removeBookFromWishlist(wishlistId, bookId);

                if (removed) {
                    session.setAttribute("successMessage", book.getTitle() + " removed from wishlist");
                } else {
                    session.setAttribute("errorMessage", "Failed to remove book from wishlist");
                }

                // Redirect to wishlist view
                response.sendRedirect(request.getContextPath() + "/wishlists?action=view&id=" + wishlistId);
                break;

            default:
                // Invalid action, redirect to wishlists
                response.sendRedirect(request.getContextPath() + "/wishlists");
                break;
        }
    }

    /**
     * Handle POST requests - process wishlist item actions
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            // Redirect to login page
            session.setAttribute("errorMessage", "Please log in to manage your wishlist");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String userId = (String) session.getAttribute("userId");

        // Get action parameter
        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/wishlists");
            return;
        }

        // Initialize WishlistManager
        WishlistManager wishlistManager = new WishlistManager(getServletContext());

        switch (action) {
            case "add-to-selected":
                // Get form parameters
                String wishlistId = request.getParameter("wishlistId");
                String bookId = request.getParameter("bookId");
                String notes = request.getParameter("notes");
                String priorityStr = request.getParameter("priority");

                // Validate input
                if (wishlistId == null || wishlistId.trim().isEmpty() ||
                        bookId == null || bookId.trim().isEmpty()) {
                    session.setAttribute("errorMessage", "Invalid wishlist or book ID");
                    response.sendRedirect(request.getContextPath() + "/wishlists");
                    return;
                }

                // Parse priority
                int priority = 3; // Default to medium
                if (priorityStr != null && !priorityStr.trim().isEmpty()) {
                    try {
                        priority = Integer.parseInt(priorityStr);
                        // Ensure priority is between 1-5
                        if (priority < 1) priority = 1;
                        if (priority > 5) priority = 5;
                    } catch (NumberFormatException e) {
                        // Use default
                    }
                }

                // Get wishlist
                Wishlist wishlist = wishlistManager.getWishlist(wishlistId);
                if (wishlist == null) {
                    session.setAttribute("errorMessage", "Wishlist not found");
                    response.sendRedirect(request.getContextPath() + "/wishlists");
                    return;
                }

                // Check if user owns this wishlist
                if (!wishlist.getUserId().equals(userId)) {
                    session.setAttribute("errorMessage", "You do not have permission to modify this wishlist");
                    response.sendRedirect(request.getContextPath() + "/wishlists");
                    return;
                }

                // Check if book exists
                BookManager bookManager = new BookManager(getServletContext());
                Book book = bookManager.getBookById(bookId);
                if (book == null) {
                    session.setAttribute("errorMessage", "Book not found");
                    response.sendRedirect(request.getContextPath() + "/wishlists");
                    return;
                }

                // Check if book is already in the wishlist
                if (wishlistManager.isBookInWishlist(wishlistId, bookId)) {
                    session.setAttribute("infoMessage", book.getTitle() + " is already in this wishlist");
                    response.sendRedirect(request.getContextPath() + "/wishlists?action=view&id=" + wishlistId);
                    return;
                }

                // Add book to wishlist
                boolean added = wishlistManager.addBookToWishlist(wishlistId, bookId, notes, priority);

                if (added) {
                    session.setAttribute("successMessage", book.getTitle() + " added to wishlist");
                    response.sendRedirect(request.getContextPath() + "/wishlists?action=view&id=" + wishlistId);
                } else {
                    session.setAttribute("errorMessage", "Failed to add book to wishlist");
                    response.sendRedirect(request.getContextPath() + "/book-details?id=" + bookId);
                }
                break;

            case "update":
                // Get form parameters
                wishlistId = request.getParameter("wishlistId");
                bookId = request.getParameter("bookId");
                notes = request.getParameter("notes");
                priorityStr = request.getParameter("priority");

                // Validate input
                if (wishlistId == null || wishlistId.trim().isEmpty() ||
                        bookId == null || bookId.trim().isEmpty()) {
                    session.setAttribute("errorMessage", "Invalid wishlist or book ID");
                    response.sendRedirect(request.getContextPath() + "/wishlists");
                    return;
                }

                // Parse priority
                priority = 3; // Default to medium
                if (priorityStr != null && !priorityStr.trim().isEmpty()) {
                    try {
                        priority = Integer.parseInt(priorityStr);
                        // Ensure priority is between 1-5
                        if (priority < 1) priority = 1;
                        if (priority > 5) priority = 5;
                    } catch (NumberFormatException e) {
                        // Use default
                    }
                }

                // Get wishlist
                wishlist = wishlistManager.getWishlist(wishlistId);
                if (wishlist == null) {
                    session.setAttribute("errorMessage", "Wishlist not found");
                    response.sendRedirect(request.getContextPath() + "/wishlists");
                    return;
                }

                // Check if user owns this wishlist
                if (!wishlist.getUserId().equals(userId)) {
                    session.setAttribute("errorMessage", "You do not have permission to modify this wishlist");
                    response.sendRedirect(request.getContextPath() + "/wishlists");
                    return;
                }

                // Update wishlist item
                boolean updated = wishlistManager.updateWishlistItem(wishlistId, bookId, notes, priority);

                if (updated) {
                    session.setAttribute("successMessage", "Wishlist item updated successfully");
                } else {
                    session.setAttribute("errorMessage", "Failed to update wishlist item");
                }

                // Redirect back to wishlist view
                response.sendRedirect(request.getContextPath() + "/wishlists?action=view&id=" + wishlistId);
                break;

            default:
                // Invalid action, redirect to wishlists
                response.sendRedirect(request.getContextPath() + "/wishlists");
                break;
        }
    }
}
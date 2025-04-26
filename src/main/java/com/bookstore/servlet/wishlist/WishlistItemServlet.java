package com.bookstore.servlet.wishlist;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.bookstore.model.book.Book;
import com.bookstore.model.book.BookManager;
import com.bookstore.model.wishlist.Wishlist;
import com.bookstore.model.wishlist.WishlistManager;
import com.bookstore.model.wishlist.WishlistItem;

/**
 * Servlet for managing wishlist items (add, update, remove)
 */
@WebServlet("/wishlist-item")
public class WishlistItemServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final boolean DEBUG = true;

    /**
     * Validate user is logged in
     */
    private boolean isUserLoggedIn(HttpSession session) {
        return session != null && session.getAttribute("userId") != null;
    }

    /**
     * Redirect to login page
     */
    private void redirectToLogin(HttpSession session, HttpServletResponse response,
                                 HttpServletRequest request) throws IOException {
        log("User not logged in, redirecting to login", DEBUG);
        session.setAttribute("errorMessage", "Please log in to manage wishlist items");
        response.sendRedirect(request.getContextPath() + "/login");
    }

    /**
     * Set error message and redirect
     */
    private void setErrorAndRedirect(HttpSession session, String message,
                                     String redirectUrl, HttpServletResponse response)
            throws IOException {
        session.setAttribute("errorMessage", message);
        response.sendRedirect(redirectUrl);
    }

    /**
     * Validate wishlist and book IDs
     */
    private boolean isInvalidInput(String wishlistId, String bookId) {
        return wishlistId == null || wishlistId.trim().isEmpty() ||
                bookId == null || bookId.trim().isEmpty();
    }

    /**
     * Validate and parse priority
     */
    private int validatePriority(String priorityStr) {
        try {
            int priority = Integer.parseInt(priorityStr);
            // Ensure priority is between 1 and 5
            return Math.max(1, Math.min(5, priority));
        } catch (NumberFormatException e) {
            // Default to medium priority
            return 3;
        }
    }

    /**
     * Logging utility method
     */
    private void log(String message, boolean debug) {
        if (debug) {
            System.out.println("[WishlistItemServlet] " + message);
        }
    }

    /**
     * Handle GET requests - manage different actions for wishlist items
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        log("WishlistItemServlet: doGet method called", DEBUG);

        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (!isUserLoggedIn(session)) {
            redirectToLogin(session, response, request);
            return;
        }

        // Get essential parameters
        String userId = (String) session.getAttribute("userId");
        String action = request.getParameter("action");
        String wishlistId = request.getParameter("wishlistId");
        String bookId = request.getParameter("bookId");

        // Log input parameters
        log("Action: " + action, DEBUG);
        log("WishlistId: " + wishlistId, DEBUG);
        log("BookId: " + bookId, DEBUG);

        try {
            // Handle remove action
            if ("remove".equals(action)) {
                handleRemoveAction(request, response, session, userId, wishlistId, bookId);
                return;
            }

            // Handle edit action
            if ("edit".equals(action)) {
                handleEditAction(request, response, session, userId, wishlistId, bookId);
                return;
            }

            // Unsupported action
            log("Unsupported GET action: " + action, DEBUG);
            response.sendRedirect(request.getContextPath() + "/wishlists");

        } catch (Exception e) {
            log("Error in doGet: " + e.getMessage(), true);
            e.printStackTrace();
            session.setAttribute("errorMessage", "An unexpected error occurred");
            response.sendRedirect(request.getContextPath() + "/wishlists");
        }
    }

    /**
     * Handle POST requests - add or update wishlist items
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        log("WishlistItemServlet: doPost method called", DEBUG);

        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (!isUserLoggedIn(session)) {
            redirectToLogin(session, response, request);
            return;
        }

        // Get essential parameters
        String userId = (String) session.getAttribute("userId");
        String action = request.getParameter("action");
        String wishlistId = request.getParameter("wishlistId");
        String bookId = request.getParameter("bookId");

        // Log input parameters
        log("Action: " + action, DEBUG);
        log("WishlistId: " + wishlistId, DEBUG);
        log("BookId: " + bookId, DEBUG);

        try {
            // Handle update action
            if ("update".equals(action)) {
                handleUpdateAction(request, response, session, userId, wishlistId, bookId);
                return;
            }

            // Handle add to selected wishlist action
            if ("add-to-selected".equals(action)) {
                handleAddToSelectedAction(request, response, session, userId, wishlistId, bookId);
                return;
            }

            // Unsupported action
            log("Unsupported POST action: " + action, DEBUG);
            response.sendRedirect(request.getContextPath() + "/wishlists");

        } catch (Exception e) {
            log("Error in doPost: " + e.getMessage(), true);
            e.printStackTrace();
            session.setAttribute("errorMessage", "An unexpected error occurred");
            response.sendRedirect(request.getContextPath() + "/wishlists");
        }
    }

    /**
     * Handle remove action for a wishlist item
     */
    private void handleRemoveAction(HttpServletRequest request, HttpServletResponse response,
                                    HttpSession session, String userId,
                                    String wishlistId, String bookId)
            throws ServletException, IOException {
        // Validate inputs
        if (isInvalidInput(wishlistId, bookId)) {
            setErrorAndRedirect(session, "Invalid wishlist or book information",
                    request.getContextPath() + "/wishlists", response);
            return;
        }

        // Initialize managers
        WishlistManager wishlistManager = new WishlistManager(getServletContext());
        BookManager bookManager = new BookManager(getServletContext());

        // Get wishlist
        Wishlist wishlist = wishlistManager.getWishlist(wishlistId);
        if (wishlist == null || !wishlist.getUserId().equals(userId)) {
            setErrorAndRedirect(session, "You cannot modify this wishlist",
                    request.getContextPath() + "/wishlists", response);
            return;
        }

        // Retrieve book (for success message)
        Book book = bookManager.getBookById(bookId);
        String bookTitle = book != null ? book.getTitle() : "the book";

        // Remove book from wishlist
        boolean removed = wishlistManager.removeBookFromWishlist(wishlistId, bookId);

        if (removed) {
            log("Book removed from wishlist successfully", DEBUG);
            session.setAttribute("successMessage", bookTitle + " removed from wishlist");

            // Check if wishlist has items, if not, redirect to wishlists
            if (wishlistManager.getWishlistItems(wishlistId).isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/wishlists");
            } else {
                response.sendRedirect(request.getContextPath() +
                        "/wishlists?action=view&id=" + wishlistId);
            }
        } else {
            log("Failed to remove book from wishlist", DEBUG);
            setErrorAndRedirect(session, "Failed to remove book from wishlist",
                    request.getContextPath() + "/wishlists?action=view&id=" + wishlistId, response);
        }
    }

    /**
     * Handle edit action for a wishlist item
     */
    private void handleEditAction(HttpServletRequest request, HttpServletResponse response,
                                  HttpSession session, String userId,
                                  String wishlistId, String bookId)
            throws ServletException, IOException {
        // Validate inputs
        if (isInvalidInput(wishlistId, bookId)) {
            setErrorAndRedirect(session, "Invalid wishlist or book information",
                    request.getContextPath() + "/wishlists", response);
            return;
        }

        // Initialize managers
        WishlistManager wishlistManager = new WishlistManager(getServletContext());
        BookManager bookManager = new BookManager(getServletContext());

        // Get wishlist
        Wishlist wishlist = wishlistManager.getWishlist(wishlistId);
        if (wishlist == null || !wishlist.getUserId().equals(userId)) {
            setErrorAndRedirect(session, "You cannot modify this wishlist",
                    request.getContextPath() + "/wishlists", response);
            return;
        }

        // Get book
        Book book = bookManager.getBookById(bookId);
        if (book == null) {
            setErrorAndRedirect(session, "Book not found",
                    request.getContextPath() + "/wishlists?action=view&id=" + wishlistId, response);
            return;
        }

        // Find wishlist item
        WishlistItem itemToEdit = findWishlistItem(wishlistManager, wishlistId, bookId);
        if (itemToEdit == null) {
            setErrorAndRedirect(session, "Wishlist item not found",
                    request.getContextPath() + "/wishlists?action=view&id=" + wishlistId, response);
            return;
        }

        // Set attributes for edit page
        request.setAttribute("wishlist", wishlist);
        request.setAttribute("book", book);
        request.setAttribute("notes", itemToEdit.getNotes());
        request.setAttribute("priority", itemToEdit.getPriority());

        // Forward to edit page
        request.getRequestDispatcher("/wishlist/edit-item.jsp").forward(request, response);
    }

    /**
     * Handle update action for a wishlist item
     */
    private void handleUpdateAction(HttpServletRequest request, HttpServletResponse response,
                                    HttpSession session, String userId,
                                    String wishlistId, String bookId)
            throws ServletException, IOException {
        // Validate inputs
        if (isInvalidInput(wishlistId, bookId)) {
            setErrorAndRedirect(session, "Invalid wishlist or book information",
                    request.getContextPath() + "/wishlists", response);
            return;
        }

        // Initialize managers
        WishlistManager wishlistManager = new WishlistManager(getServletContext());

        // Get wishlist
        Wishlist wishlist = wishlistManager.getWishlist(wishlistId);
        if (wishlist == null || !wishlist.getUserId().equals(userId)) {
            setErrorAndRedirect(session, "You cannot modify this wishlist",
                    request.getContextPath() + "/wishlists", response);
            return;
        }

        // Get input parameters
        String notes = request.getParameter("notes");
        String priorityStr = request.getParameter("priority");

        // Validate and parse priority
        int priority = validatePriority(priorityStr);

        // Update wishlist item
        boolean updated = wishlistManager.updateWishlistItem(
                wishlistId, bookId, notes, priority
        );

        if (updated) {
            log("Wishlist item updated successfully", DEBUG);
            session.setAttribute("successMessage", "Wishlist item updated successfully");
        } else {
            log("Failed to update wishlist item", DEBUG);
            session.setAttribute("errorMessage", "Failed to update wishlist item");
        }

        // Redirect back to wishlist view
        response.sendRedirect(request.getContextPath() +
                "/wishlists?action=view&id=" + wishlistId);
    }

    /**
     * Handle adding a book to a selected wishlist
     */
    private void handleAddToSelectedAction(HttpServletRequest request, HttpServletResponse response,
                                           HttpSession session, String userId,
                                           String wishlistId, String bookId)
            throws ServletException, IOException {
        // Validate inputs
        if (isInvalidInput(wishlistId, bookId)) {
            setErrorAndRedirect(session, "Invalid wishlist or book information",
                    request.getContextPath() + "/wishlists", response);
            return;
        }

        // Initialize managers
        WishlistManager wishlistManager = new WishlistManager(getServletContext());
        BookManager bookManager = new BookManager(getServletContext());

        // Get wishlist
        Wishlist wishlist = wishlistManager.getWishlist(wishlistId);
        if (wishlist == null || !wishlist.getUserId().equals(userId)) {
            setErrorAndRedirect(session, "You cannot modify this wishlist",
                    request.getContextPath() + "/wishlists", response);
            return;
        }

        // Get input parameters
        String notes = request.getParameter("notes");
        String priorityStr = request.getParameter("priority");

        // Validate and parse priority
        int priority = validatePriority(priorityStr);

        // Check if book exists
        Book book = bookManager.getBookById(bookId);
        if (book == null) {
            setErrorAndRedirect(session, "Book not found",
                    request.getContextPath() + "/books", response);
            return;
        }

        // Add book to wishlist
        boolean added = wishlistManager.addBookToWishlist(
                wishlistId, bookId, notes, priority
        );

        if (added) {
            log("Book added to wishlist successfully", DEBUG);
            session.setAttribute("successMessage",
                    book.getTitle() + " added to " + wishlist.getName());
            response.sendRedirect(request.getContextPath() +
                    "/wishlists?action=view&id=" + wishlistId);
        } else {
            log("Failed to add book to wishlist", DEBUG);
            session.setAttribute("errorMessage", "Failed to add book to wishlist");
            response.sendRedirect(request.getContextPath() + "/books");
        }
    }

    /**
     * Find a specific wishlist item
     */
    private WishlistItem findWishlistItem(WishlistManager wishlistManager,
                                          String wishlistId, String bookId) {
        List<WishlistItem> items = wishlistManager.getWishlistItems(wishlistId);
        for (WishlistItem item : items) {
            if (item.getBookId().equals(bookId)) {
                return item;
            }
        }
        return null;
    }
}
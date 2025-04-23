// File: src/main/java/com/bookstore/servlet/wishlist/WishlistServlet.java
package com.bookstore.servlet.wishlist;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.bookstore.model.book.Book;
import com.bookstore.model.wishlist.Wishlist;
import com.bookstore.model.wishlist.WishlistItem;
import com.bookstore.model.wishlist.WishlistManager;

/**
 * Servlet for displaying user wishlists
 */
@WebServlet("/wishlists")
public class WishlistServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handle GET requests - display wishlists
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            // Redirect to login page
            session.setAttribute("errorMessage", "Please log in to view your wishlists");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String userId = (String) session.getAttribute("userId");

        // Get action parameter
        String action = request.getParameter("action");
        if (action == null) {
            action = "list"; // Default action
        }

        // Initialize WishlistManager
        WishlistManager wishlistManager = new WishlistManager(getServletContext());

        switch (action) {
            case "list":
                // Get all wishlists for the user
                List<Wishlist> userWishlists = wishlistManager.getUserWishlists(userId);
                request.setAttribute("wishlists", userWishlists);

                // Forward to wishlists page
                request.getRequestDispatcher("/wishlist/wishlists.jsp").forward(request, response);
                break;

            case "view":
                // Get wishlist ID
                String wishlistId = request.getParameter("id");
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

                // Check if user has access to this wishlist
                if (!wishlist.getUserId().equals(userId) && !wishlist.isPublic()) {
                    session.setAttribute("errorMessage", "You do not have permission to view this wishlist");
                    response.sendRedirect(request.getContextPath() + "/wishlists");
                    return;
                }

                // Get wishlist items with book details
                Map<WishlistItem, Book> wishlistItems = wishlistManager.getWishlistItemsWithBooks(wishlistId);

                // Set attributes
                request.setAttribute("wishlist", wishlist);
                request.setAttribute("wishlistItems", wishlistItems);

                // Forward to wishlist details page
                request.getRequestDispatcher("/wishlist/wishlist-details.jsp").forward(request, response);
                break;

            case "create":
                // Forward to create wishlist page
                request.getRequestDispatcher("/wishlist/create-wishlist.jsp").forward(request, response);
                break;

            case "edit":
                // Get wishlist ID
                wishlistId = request.getParameter("id");
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
                    session.setAttribute("errorMessage", "You do not have permission to edit this wishlist");
                    response.sendRedirect(request.getContextPath() + "/wishlists");
                    return;
                }

                // Set attributes
                request.setAttribute("wishlist", wishlist);

                // Forward to edit wishlist page
                request.getRequestDispatcher("/wishlist/edit-wishlist.jsp").forward(request, response);
                break;

            default:
                // Invalid action, redirect to list
                response.sendRedirect(request.getContextPath() + "/wishlists");
                break;
        }
    }

    /**
     * Handle POST requests - process wishlist actions
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            // Redirect to login page
            session.setAttribute("errorMessage", "Please log in to manage your wishlists");
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
            case "create":
                // Get form parameters
                String name = request.getParameter("name");
                String description = request.getParameter("description");
                String isPublicStr = request.getParameter("isPublic");

                // Validate input
                if (name == null || name.trim().isEmpty()) {
                    session.setAttribute("errorMessage", "Wishlist name is required");
                    response.sendRedirect(request.getContextPath() + "/wishlists?action=create");
                    return;
                }

                // Convert isPublic to boolean
                boolean isPublic = "on".equals(isPublicStr);

                // Create wishlist
                String wishlistId = wishlistManager.createWishlist(userId, name, description, isPublic);

                if (wishlistId != null) {
                    session.setAttribute("successMessage", "Wishlist created successfully");
                    response.sendRedirect(request.getContextPath() + "/wishlists?action=view&id=" + wishlistId);
                } else {
                    session.setAttribute("errorMessage", "Failed to create wishlist");
                    response.sendRedirect(request.getContextPath() + "/wishlists?action=create");
                }
                break;

            case "update":
                // Get form parameters
                wishlistId = request.getParameter("wishlistId");
                name = request.getParameter("name");
                description = request.getParameter("description");
                isPublicStr = request.getParameter("isPublic");

                // Validate input
                if (wishlistId == null || wishlistId.trim().isEmpty()) {
                    session.setAttribute("errorMessage", "Invalid wishlist ID");
                    response.sendRedirect(request.getContextPath() + "/wishlists");
                    return;
                }

                if (name == null || name.trim().isEmpty()) {
                    session.setAttribute("errorMessage", "Wishlist name is required");
                    response.sendRedirect(request.getContextPath() + "/wishlists?action=edit&id=" + wishlistId);
                    return;
                }

                // Get existing wishlist
                Wishlist wishlist = wishlistManager.getWishlist(wishlistId);
                if (wishlist == null) {
                    session.setAttribute("errorMessage", "Wishlist not found");
                    response.sendRedirect(request.getContextPath() + "/wishlists");
                    return;
                }

                // Check if user owns this wishlist
                if (!wishlist.getUserId().equals(userId)) {
                    session.setAttribute("errorMessage", "You do not have permission to update this wishlist");
                    response.sendRedirect(request.getContextPath() + "/wishlists");
                    return;
                }

                // Update wishlist
                wishlist.setName(name);
                wishlist.setDescription(description);
                wishlist.setPublic("on".equals(isPublicStr));

                boolean updated = wishlistManager.updateWishlist(wishlist);

                if (updated) {
                    session.setAttribute("successMessage", "Wishlist updated successfully");
                    response.sendRedirect(request.getContextPath() + "/wishlists?action=view&id=" + wishlistId);
                } else {
                    session.setAttribute("errorMessage", "Failed to update wishlist");
                    response.sendRedirect(request.getContextPath() + "/wishlists?action=edit&id=" + wishlistId);
                }
                break;

            case "delete":
                // Get wishlist ID
                wishlistId = request.getParameter("wishlistId");

                // Validate input
                if (wishlistId == null || wishlistId.trim().isEmpty()) {
                    session.setAttribute("errorMessage", "Invalid wishlist ID");
                    response.sendRedirect(request.getContextPath() + "/wishlists");
                    return;
                }

                // Get existing wishlist
                wishlist = wishlistManager.getWishlist(wishlistId);
                if (wishlist == null) {
                    session.setAttribute("errorMessage", "Wishlist not found");
                    response.sendRedirect(request.getContextPath() + "/wishlists");
                    return;
                }

                // Check if user owns this wishlist
                if (!wishlist.getUserId().equals(userId)) {
                    session.setAttribute("errorMessage", "You do not have permission to delete this wishlist");
                    response.sendRedirect(request.getContextPath() + "/wishlists");
                    return;
                }

                // Delete wishlist
                boolean deleted = wishlistManager.deleteWishlist(wishlistId);

                if (deleted) {
                    session.setAttribute("successMessage", "Wishlist deleted successfully");
                } else {
                    session.setAttribute("errorMessage", "Failed to delete wishlist");
                }

                response.sendRedirect(request.getContextPath() + "/wishlists");
                break;

            default:
                // Invalid action, redirect to list
                response.sendRedirect(request.getContextPath() + "/wishlists");
                break;
        }
    }
}
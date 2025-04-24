package com.bookstore.servlet.wishlist;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.bookstore.model.wishlist.Wishlist;
import com.bookstore.model.wishlist.WishlistManager;
import com.bookstore.model.wishlist.WishlistItem;
import com.bookstore.model.book.Book;
import com.bookstore.model.book.BookManager;

@WebServlet({"/wishlists", "/wishlists/create"})
public class WishlistServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            // Redirect to login page
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String userId = (String) session.getAttribute("userId");
        String action = request.getParameter("action");

        // Initialize WishlistManager
        WishlistManager wishlistManager = new WishlistManager(getServletContext());

        try {
            // Safely get user wishlists
            List<Wishlist> userWishlists = wishlistManager.getUserWishlists(userId);

            // Log wishlists for debugging
            System.out.println("WishlistServlet: Retrieved " + userWishlists.size() + " wishlists for user " + userId);
            for (Wishlist wishlist : userWishlists) {
                System.out.println("Wishlist: " + wishlist.getName() + ", Items: " + wishlist.getItemCount());
            }

            // Set wishlists in request
            request.setAttribute("wishlists", userWishlists);

            if (action == null || action.equals("list")) {
                // Forward to wishlists page
                request.getRequestDispatcher("/wishlist/wishlists.jsp").forward(request, response);
            } else if (action.equals("create")) {
                // Forward to create wishlist page
                request.getRequestDispatcher("/wishlist/create-wishlist.jsp").forward(request, response);
            } else if (action.equals("view")) {
                // Get wishlist ID
                String wishlistId = request.getParameter("id");
                if (wishlistId == null || wishlistId.trim().isEmpty()) {
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

                // Get book manager to retrieve book details
                BookManager bookManager = new BookManager(getServletContext());

                // Retrieve wishlist items with book details
                java.util.Map<WishlistItem, Book> wishlistItems = wishlistManager.getWishlistItemsWithBooks(wishlistId);

                // Set attributes
                request.setAttribute("wishlist", wishlist);
                request.setAttribute("wishlistItems", wishlistItems);

                // Forward to wishlist details page
                request.getRequestDispatcher("/wishlist/wishlist-details.jsp").forward(request, response);
            } else if (action.equals("edit")) {
                // Get wishlist ID
                String wishlistId = request.getParameter("id");
                if (wishlistId == null || wishlistId.trim().isEmpty()) {
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

                // Set attributes
                request.setAttribute("wishlist", wishlist);

                // Forward to edit wishlist page
                request.getRequestDispatcher("/wishlist/edit-wishlist.jsp").forward(request, response);
            } else {
                // Invalid action, redirect to list
                response.sendRedirect(request.getContextPath() + "/wishlists");
            }
        } catch (Exception e) {
            // Log the error with full stack trace
            System.err.println("WishlistServlet: Error processing request");
            e.printStackTrace();

            // Set error message in session
            session.setAttribute("errorMessage", "An unexpected error occurred: " + e.getMessage());

            // Redirect to wishlists page
            response.sendRedirect(request.getContextPath() + "/wishlists");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            // Redirect to login page
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String userId = (String) session.getAttribute("userId");
        String action = request.getParameter("action");

        // Initialize WishlistManager
        WishlistManager wishlistManager = new WishlistManager(getServletContext());

        try {
            if ("create".equals(action)) {
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
            } else if ("update".equals(action)) {
                // Get form parameters
                String wishlistId = request.getParameter("wishlistId");
                String name = request.getParameter("name");
                String description = request.getParameter("description");
                String isPublicStr = request.getParameter("isPublic");

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
            } else if ("delete".equals(action)) {
                // Get wishlist ID
                String wishlistId = request.getParameter("wishlistId");

                // Validate input
                if (wishlistId == null || wishlistId.trim().isEmpty()) {
                    session.setAttribute("errorMessage", "Invalid wishlist ID");
                    response.sendRedirect(request.getContextPath() + "/wishlists");
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
            } else {
                // Invalid action, redirect to list
                response.sendRedirect(request.getContextPath() + "/wishlists");
            }
        } catch (Exception e) {
            // Log the error with full stack trace
            System.err.println("WishlistServlet: Error processing request");
            e.printStackTrace();

            // Set error message in session
            session.setAttribute("errorMessage", "An unexpected error occurred: " + e.getMessage());

            // Redirect to wishlists page
            response.sendRedirect(request.getContextPath() + "/wishlists");
        }
    }
}
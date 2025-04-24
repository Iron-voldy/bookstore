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
import com.bookstore.model.wishlist.Wishlist;
import com.bookstore.model.wishlist.WishlistManager;
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
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String userId = (String) session.getAttribute("userId");
        String action = request.getParameter("action");

        // Initialize WishlistManager
        WishlistManager wishlistManager = new WishlistManager(getServletContext());

        try {
            // Default action is list
            if (action == null) {
                action = "list";
            }

            switch (action) {
                case "list":
                    // Get user's wishlists
                    List<Wishlist> userWishlists = wishlistManager.getUserWishlists(userId);

                    // Debug logging
                    System.out.println("WishlistServlet: Retrieved " + userWishlists.size() + " wishlists for user " + userId);
                    for (Wishlist wishlist : userWishlists) {
                        System.out.println("Wishlist: " + wishlist.getName() +
                                ", Items: " + wishlist.getItemCount() +
                                ", Public: " + wishlist.isPublic());
                    }

                    // Set wishlists in request
                    request.setAttribute("wishlists", userWishlists);

                    // Forward to wishlists page
                    request.getRequestDispatcher("/wishlist/wishlists.jsp").forward(request, response);
                    break;

                case "view":
                    // Get wishlist ID
                    String wishlistId = request.getParameter("id");
                    if (wishlistId == null || wishlistId.trim().isEmpty()) {
                        response.sendRedirect(request.getContextPath() + "/wishlists");
                        return;
                    }

                    // Get the specific wishlist
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
                    BookManager bookManager = new BookManager(getServletContext());
                    java.util.Map<com.bookstore.model.wishlist.WishlistItem, Book> wishlistItems =
                            wishlistManager.getWishlistItemsWithBooks(wishlistId);

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
                    // Get wishlist ID for editing
                    wishlistId = request.getParameter("id");
                    if (wishlistId == null || wishlistId.trim().isEmpty()) {
                        response.sendRedirect(request.getContextPath() + "/wishlists");
                        return;
                    }

                    // Get the wishlist to edit
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

                    // Set wishlist in request
                    request.setAttribute("wishlist", wishlist);

                    // Forward to edit wishlist page
                    request.getRequestDispatcher("/wishlist/edit-wishlist.jsp").forward(request, response);
                    break;

                default:
                    response.sendRedirect(request.getContextPath() + "/wishlists");
            }

        } catch (Exception e) {
            // Log the error
            e.printStackTrace();

            // Set error message
            session.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/wishlists");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Existing post method implementation for creating, updating, and deleting wishlists
        // (Keep your existing implementation)
    }
}
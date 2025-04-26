<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.bookstore.model.wishlist.Wishlist" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Wishlists - BookVerse</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <style>
        :root {
            --primary-dark: #121212;
            --secondary-dark: #1e1e1e;
            --accent-color: #8a5cf5;
            --accent-hover: #6e46c9;
            --text-primary: #f5f5f5;
            --text-secondary: #b0b0b0;
            --danger-color: #d64045;
            --success-color: #4caf50;
            --warning-color: #ff9800;
            --card-bg: #252525;
            --border-color: #333333;
        }

        body {
            background-color: var(--primary-dark);
            color: var(--text-primary);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .btn-accent {
            background-color: var(--accent-color);
            color: white;
            border: none;
            transition: all 0.3s;
        }

        .btn-accent:hover {
            background-color: var(--accent-hover);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(138, 92, 245, 0.3);
        }

        .card {
            background-color: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            height: 100%;
        }

        .empty-state {
            text-align: center;
            padding: 40px 20px;
        }

        .empty-state i {
            font-size: 3rem;
            margin-bottom: 20px;
            color: var(--text-secondary);
        }

        .badge-public {
            background-color: var(--accent-color);
            color: white;
        }

        .badge-private {
            background-color: var(--secondary-dark);
            border: 1px solid var(--border-color);
            color: var(--text-secondary);
        }
    </style>
</head>
<body>
    <%
        // Debug information
        List<Wishlist> wishlists = (List<Wishlist>)request.getAttribute("wishlists");
        System.out.println("JSP DEBUG: Wishlists attribute exists: " + (wishlists != null));
        if (wishlists != null) {
            System.out.println("JSP DEBUG: Number of wishlists: " + wishlists.size());
            for (Wishlist w : wishlists) {
                System.out.println("JSP DEBUG: Wishlist: " + w.getName() + ", Items: " + w.getItemCount());
            }
        }

        SimpleDateFormat dateFormat = new SimpleDateFormat("MMM d, yyyy");
    %>

    <!-- Include Header -->
    <jsp:include page="../includes/header.jsp" />

    <!-- Main Content -->
    <div class="container my-5">
        <!-- Flash Messages -->
        <%
            String successMessage = (String)session.getAttribute("successMessage");
            if (successMessage != null && !successMessage.isEmpty()) {
        %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i> <%= successMessage %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <%
                session.removeAttribute("successMessage");
            }

            String errorMessage = (String)session.getAttribute("errorMessage");
            if (errorMessage != null && !errorMessage.isEmpty()) {
        %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i> <%= errorMessage %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <%
                session.removeAttribute("errorMessage");
            }
        %>

        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2><i class="fas fa-heart me-2"></i> My Wishlists</h2>
            <a href="<%= request.getContextPath() %>/wishlists?action=create" class="btn btn-accent">
                <i class="fas fa-plus me-2"></i> Create New Wishlist
            </a>
        </div>

        <!-- Wishlists Grid -->
        <% if (wishlists == null || wishlists.isEmpty()) { %>
            <div class="card">
                <div class="card-body empty-state">
                    <i class="fas fa-heart-broken"></i>
                    <h4>No Wishlists Yet</h4>
                    <p>You haven't created any wishlists yet. Start by creating your first wishlist!</p>
                    <a href="<%= request.getContextPath() %>/wishlists?action=create" class="btn btn-accent mt-3">
                        <i class="fas fa-plus me-2"></i> Create New Wishlist
                    </a>
                </div>
            </div>
        <% } else { %>
            <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
                <% for (Wishlist wishlist : wishlists) { %>
                    <div class="col">
                        <div class="card">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-start mb-3">
                                    <h5 class="card-title"><%= wishlist.getName() %></h5>
                                    <span class="badge <%= wishlist.isPublic() ? "badge-public" : "badge-private" %>">
                                        <%= wishlist.isPublic() ? "Public" : "Private" %>
                                    </span>
                                </div>
                                <p class="card-text text-muted">
                                    <%= wishlist.getDescription() != null && !wishlist.getDescription().isEmpty()
                                       ? wishlist.getDescription() : "No description" %>
                                </p>
                                <p class="card-text">
                                    <small class="text-muted">
                                        <i class="fas fa-calendar-alt me-1"></i> Created:
                                        <%= wishlist.getCreatedDate() != null ? dateFormat.format(wishlist.getCreatedDate()) : "" %>
                                    </small>
                                </p>
                                <p class="card-text">
                                    <i class="fas fa-book me-1"></i> <%= wishlist.getItemCount() %> items
                                </p>
                            </div>
                            <div class="card-footer d-flex justify-content-between">
                                <a href="<%= request.getContextPath() %>/wishlists?action=view&id=<%= wishlist.getWishlistId() %>" class="btn btn-accent">
                                    <i class="fas fa-eye me-1"></i> View
                                </a>
                                <div>
                                    <a href="<%= request.getContextPath() %>/wishlists?action=edit&id=<%= wishlist.getWishlistId() %>" class="btn btn-outline-light">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    <button type="button" class="btn btn-outline-danger"
                                            data-bs-toggle="modal"
                                            data-bs-target="#deleteWishlistModal<%= wishlist.getWishlistId() %>">
                                        <i class="fas fa-trash-alt"></i>
                                    </button>
                                </div>
                            </div>

                            <!-- Delete Confirmation Modal -->
                            <div class="modal fade" id="deleteWishlistModal<%= wishlist.getWishlistId() %>" tabindex="-1" aria-hidden="true">
                                <div class="modal-dialog">
                                    <div class="modal-content bg-dark text-light">
                                        <div class="modal-header">
                                            <h5 class="modal-title">Confirm Deletion</h5>
                                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                        </div>
                                        <div class="modal-body">
                                            <p>Are you sure you want to delete the wishlist "<%= wishlist.getName() %>"?</p>
                                            <p class="text-danger">This action cannot be undone.</p>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-outline-light" data-bs-dismiss="modal">Cancel</button>
                                            <form action="<%= request.getContextPath() %>/wishlists" method="post">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="wishlistId" value="<%= wishlist.getWishlistId() %>">
                                                <button type="submit" class="btn btn-danger">Delete</button>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } %>
    </div>

    <!-- Include Footer -->
    <jsp:include page="../includes/footer.jsp" />

    <!-- Bootstrap Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
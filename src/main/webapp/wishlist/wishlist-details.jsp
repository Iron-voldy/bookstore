<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.bookstore.model.book.Book" %>
<%@ page import="com.bookstore.model.wishlist.Wishlist" %>
<%@ page import="com.bookstore.model.wishlist.WishlistItem" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Wishlist Details - BookVerse</title>
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

        .navbar {
            background-color: var(--secondary-dark);
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.3);
        }

        .navbar-brand {
            font-weight: bold;
            color: var(--accent-color) !important;
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

        .book-card {
            transition: transform 0.3s;
        }

        .book-card:hover {
            transform: translateY(-5px);
        }

        .alert-custom {
            background-color: var(--secondary-dark);
            color: var(--text-primary);
            border: 1px solid var(--border-color);
        }

        .alert-success {
            border-left: 4px solid var(--success-color);
        }

        .alert-danger {
            border-left: 4px solid var(--danger-color);
        }

        .book-cover {
            height: 200px;
            object-fit: cover;
            border-top-left-radius: 8px;
            border-top-right-radius: 8px;
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
        }

        .badge-private {
            background-color: var(--secondary-dark);
            border: 1px solid var(--border-color);
        }

        .breadcrumb {
            background-color: var(--secondary-dark);
            padding: 10px 15px;
            border-radius: 5px;
        }

        .breadcrumb-item a {
            color: var(--text-secondary);
            text-decoration: none;
        }

        .breadcrumb-item.active {
            color: var(--text-primary);
        }

        .priority-badge {
            font-size: 0.8rem;
            padding: 3px 8px;
            border-radius: 4px;
        }

        .priority-1 { background-color: #6c757d; }
        .priority-2 { background-color: #0d6efd; }
        .priority-3 { background-color: #198754; }
        .priority-4 { background-color: #fd7e14; }
        .priority-5 { background-color: #dc3545; }

        .rating i {
            color: gold;
        }

        :root {
            --primary-dark: #0a0a0f;           /* Deeper, richer dark background */
            --secondary-dark: #121218;         /* Slightly lighter than primary */
            --accent-color: #8a5cf5;           /* Vibrant purple accent */
            --accent-hover: #6e46c9;           /* Darker shade for hover */
            --text-primary: #e6e6e6;           /* Softer white for text */
            --text-secondary: #a0a0b0;         /* Muted gray for secondary text */
            --danger-color: #d64045;           /* Bright red for danger actions */
            --success-color: #4caf50;          /* Green for success */
            --warning-color: #ff9800;          /* Orange for warnings */
            --card-bg: #1a1a22;                /* Rich, deep card background */
            --border-color: #2a2a36;           /* Subtle border color */
            --gradient-bg: linear-gradient(
                135deg,
                var(--primary-dark) 0%,
                var(--secondary-dark) 100%
            );
        }

        body {
            background: var(--gradient-bg);
            background-attachment: fixed;
            color: var(--text-primary);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .card {
            background-color: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 12px;
            box-shadow:
                0 8px 16px rgba(0, 0, 0, 0.2),
                0 4px 8px rgba(138, 92, 245, 0.1);
            transition: all 0.3s ease;
            overflow: hidden;
        }

        .book-card {
            transform: translateY(0);
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }

        .book-card:hover {
            transform: translateY(-10px);
            box-shadow:
                0 12px 24px rgba(0, 0, 0, 0.3),
                0 6px 12px rgba(138, 92, 245, 0.2);
        }

        .book-cover {
            height: 250px;
            object-fit: cover;
            border-top-left-radius: 12px;
            border-top-right-radius: 12px;
            transition: transform 0.3s ease;
        }

        .book-card:hover .book-cover {
            transform: scale(1.05);
        }

        .card-body {
            background: linear-gradient(
                to bottom,
                rgba(26, 26, 34, 0.9) 0%,
                rgba(26, 26, 34, 1) 100%
            );
        }

        .priority-badge {
            font-size: 0.7rem;
            padding: 3px 8px;
            border-radius: 16px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-weight: 600;
        }

        /* Enhanced priority colors */
        .priority-1 {
            background-color: #4a4a4a;
            color: #b0b0b0;
        }
        .priority-2 {
            background-color: #0d6efd;
            color: white;
        }
        .priority-3 {
            background-color: #198754;
            color: white;
        }
        .priority-4 {
            background-color: #fd7e14;
            color: white;
        }
        .priority-5 {
            background-color: #dc3545;
            color: white;
        }

        .empty-state {
            background: linear-gradient(
                to bottom right,
                var(--card-bg) 0%,
                rgba(26, 26, 34, 0.8) 100%
            );
            border-radius: 12px;
        }
    </style>
</head>
<body>
    <%
        // Get the wishlist from request attributes
        Wishlist wishlist = (Wishlist)request.getAttribute("wishlist");
        Map<WishlistItem, Book> wishlistItems = (Map<WishlistItem, Book>)request.getAttribute("wishlistItems");

        // Format date
        SimpleDateFormat dateFormat = new SimpleDateFormat("MMMM d, yyyy");
        String formattedDate = "";
        if (wishlist != null && wishlist.getCreatedDate() != null) {
            formattedDate = dateFormat.format(wishlist.getCreatedDate());
        }

        // Debug information
        System.out.println("JSP DEBUG: Wishlist attribute exists: " + (wishlist != null));
        if (wishlist != null) {
            System.out.println("JSP DEBUG: Wishlist name: " + wishlist.getName());
            System.out.println("JSP DEBUG: Wishlist createdDate: " + wishlist.getCreatedDate());
        }

        System.out.println("JSP DEBUG: WishlistItems attribute exists: " + (wishlistItems != null));
        if (wishlistItems != null) {
            System.out.println("JSP DEBUG: Number of wishlist items: " + wishlistItems.size());
        }
    %>

    <!-- Include Header -->
    <jsp:include page="../includes/header.jsp" />

    <!-- Main Content -->
    <div class="container my-5">
        <!-- Breadcrumb -->
        <nav aria-label="breadcrumb" class="mb-4">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="<%= request.getContextPath() %>/">Home</a></li>
                <li class="breadcrumb-item"><a href="<%= request.getContextPath() %>/wishlists">My Wishlists</a></li>
                <li class="breadcrumb-item active" aria-current="page"><%= wishlist != null ? wishlist.getName() : "Wishlist Details" %></li>
            </ol>
        </nav>

        <!-- Wishlist Header -->
        <div class="card mb-4">
            <div class="card-body">
                <div class="d-flex justify-content-between align-items-start">
                    <div>
                        <h2 class="mb-2"><%= wishlist != null ? wishlist.getName() : "Wishlist" %></h2>
                        <p class="text-muted mb-2">
                            <% if (wishlist != null && wishlist.getDescription() != null && !wishlist.getDescription().isEmpty()) { %>
                                <%= wishlist.getDescription() %>
                            <% } else { %>
                                <span class="text-muted">No description</span>
                            <% } %>
                        </p>
                        <p class="mb-0">
                            <small class="text-muted">
                                <i class="fas fa-calendar-alt me-1"></i> Created:
                                <%= formattedDate %>
                            </small>
                        </p>
                        <p class="mb-0">
                            <% if (wishlist != null) { %>
                                <span class="badge <%= wishlist.isPublic() ? "badge-public" : "badge-private" %>">
                                    <i class="fas <%= wishlist.isPublic() ? "fa-globe" : "fa-lock" %> me-1"></i>
                                    <%= wishlist.isPublic() ? "Public" : "Private" %>
                                </span>
                            <% } %>
                        </p>
                    </div>
                    <div>
                        <a href="<%= request.getContextPath() %>/wishlists?action=edit&id=<%= wishlist != null ? wishlist.getWishlistId() : "" %>" class="btn btn-outline-light me-2">
                            <i class="fas fa-edit me-1"></i> Edit
                        </a>
                        <button type="button" class="btn btn-outline-danger"
                                data-bs-toggle="modal" data-bs-target="#deleteWishlistModal">
                            <i class="fas fa-trash-alt me-1"></i> Delete
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Flash Messages -->
        <%
            String successMessage = (String)session.getAttribute("successMessage");
            if (successMessage != null && !successMessage.isEmpty()) {
        %>
            <div class="alert alert-custom alert-success alert-dismissible fade show mb-4" role="alert">
                <i class="fas fa-check-circle me-2"></i> <%= successMessage %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <%
                session.removeAttribute("successMessage");
            }

            String errorMessage = (String)session.getAttribute("errorMessage");
            if (errorMessage != null && !errorMessage.isEmpty()) {
        %>
            <div class="alert alert-custom alert-danger alert-dismissible fade show mb-4" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i> <%= errorMessage %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <%
                session.removeAttribute("errorMessage");
            }
        %>

        <!-- Wishlist Items -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3><i class="fas fa-book me-2"></i> Items (<%= wishlist != null ? wishlist.getItemCount() : 0 %>)</h3>
            <a href="<%= request.getContextPath() %>/books" class="btn btn-accent">
                <i class="fas fa-plus me-2"></i> Add More Books
            </a>
        </div>

        <% if (wishlistItems == null || wishlistItems.isEmpty()) { %>
            <div class="card">
                <div class="card-body empty-state">
                    <i class="fas fa-book-open"></i>
                    <h4>No Books in Wishlist</h4>
                    <p>Your wishlist is empty. Add books to your wishlist while browsing the store.</p>
                    <a href="<%= request.getContextPath() %>/books" class="btn btn-accent mt-3">
                        <i class="fas fa-search me-2"></i> Browse Books
                    </a>
                </div>
            </div>
        <% } else { %>
            <div class="row row-cols-1 row-cols-md-2 row-cols-lg-4 g-4">
                <% for (Map.Entry<WishlistItem, Book> entry : wishlistItems.entrySet()) {
                    WishlistItem item = entry.getKey();
                    Book book = entry.getValue();

                    // Determine priority label
                    String priorityLabel = "";
                    String priorityClass = "";

                    switch(item.getPriority()) {
                        case 5:
                            priorityLabel = "Very High";
                            priorityClass = "priority-5";
                            break;
                        case 4:
                            priorityLabel = "High";
                            priorityClass = "priority-4";
                            break;
                        case 3:
                            priorityLabel = "Medium";
                            priorityClass = "priority-3";
                            break;
                        case 2:
                            priorityLabel = "Low";
                            priorityClass = "priority-2";
                            break;
                        case 1:
                            priorityLabel = "Very Low";
                            priorityClass = "priority-1";
                            break;
                        default:
                            priorityLabel = "Medium";
                            priorityClass = "priority-3";
                    }

                    // Get book cover
                    String coverPath = request.getContextPath() + "/book-covers/";
                    if (book.getCoverImagePath() != null && !book.getCoverImagePath().isEmpty()) {
                        coverPath += book.getCoverImagePath();
                    } else {
                        coverPath += "default_cover.jpg";
                    }
                %>
                    <div class="col">
                        <div class="card book-card">
                            <img src="<%= coverPath %>" class="book-cover" alt="<%= book.getTitle() %>">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <h5 class="card-title"><%= book.getTitle() %></h5>
                                    <span class="badge priority-badge <%= priorityClass %>"><%= priorityLabel %></span>
                                </div>
                                <p class="card-text text-muted small">by <%= book.getAuthor() %></p>

                                <div class="rating small mb-2">
                                    <%
                                        double rating = book.getAverageRating();
                                        for (int i = 1; i <= 5; i++) {
                                            if (i <= rating) {
                                    %>
                                        <i class="fas fa-star"></i>
                                    <% } else if (i <= rating + 0.5) { %>
                                        <i class="fas fa-star-half-alt"></i>
                                    <% } else { %>
                                        <i class="far fa-star"></i>
                                    <% } } %>
                                    <span class="ms-1">(<%= book.getAverageRating() %>)</span>
                                </div>

                                <p class="card-text fw-bold" style="color: var(--accent-color);">$<%= book.getPrice() %></p>

                                <% if (item.getNotes() != null && !item.getNotes().isEmpty()) { %>
                                    <div class="notes mt-2 small">
                                        <strong>Notes:</strong> <%= item.getNotes() %>
                                    </div>
                                <% } %>
                            </div>
                            <div class="card-footer d-flex justify-content-between">
                                <a href="<%= request.getContextPath() %>/book-details?id=<%= book.getId() %>" class="btn btn-outline-light btn-sm">
                                    <i class="fas fa-eye me-1"></i> Details
                                </a>
                                <div>
                                    <a href="<%= request.getContextPath() %>/wishlist-item?action=edit&wishlistId=<%= wishlist.getWishlistId() %>&bookId=<%= book.getId() %>" class="btn btn-outline-light btn-sm">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    <a href="<%= request.getContextPath() %>/wishlist-item?action=remove&wishlistId=<%= wishlist.getWishlistId() %>&bookId=<%= book.getId() %>" class="btn btn-outline-danger btn-sm">
                                        <i class="fas fa-times"></i>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } %>
    </div>

    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteWishlistModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content bg-dark text-light">
                <div class="modal-header">
                    <h5 class="modal-title">Confirm Deletion</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to delete the wishlist "<%= wishlist != null ? wishlist.getName() : "this wishlist" %>"?</p>
                    <p class="text-danger">This action cannot be undone and all items in this wishlist will be removed.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-light" data-bs-dismiss="modal">Cancel</button>
                    <form action="<%= request.getContextPath() %>/wishlists" method="post">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="wishlistId" value="<%= wishlist != null ? wishlist.getWishlistId() : "" %>">
                        <button type="submit" class="btn btn-danger">Delete</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Include Footer -->
    <jsp:include page="../includes/footer.jsp" />

    <!-- Bootstrap Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
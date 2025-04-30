<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="com.bookstore.model.book.Book" %>
<%@ page import="com.bookstore.model.book.BookManager" %>
<%@ page import="com.bookstore.model.book.EBook" %>
<%@ page import="com.bookstore.model.book.PhysicalBook" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.bookstore.model.cart.CartManager" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <%
        // Get the book from request attribute
        Book book = (Book)request.getAttribute("book");
        if (book == null) {
            response.sendRedirect(request.getContextPath() + "/books");
            return;
        }

        String bookType = (String)request.getAttribute("bookType");

        // Initialize cart count for the header
        Integer cartCount = (Integer) session.getAttribute("cartCount");
        if (cartCount == null) {
            // Get user ID or guest cart ID
            String userId = (String) session.getAttribute("userId");
            String cartId = (String) session.getAttribute("cartId");

            // Use either user ID or cart ID
            String effectiveId = userId != null ? userId : cartId;

            if (effectiveId != null) {
                // Get cart count from CartManager
                CartManager cartManager = new CartManager(application);
                cartCount = cartManager.getCartItemCount(effectiveId);
                session.setAttribute("cartCount", cartCount);
            } else {
                cartCount = 0;
                session.setAttribute("cartCount", 0);
            }
        }
    %>

    <title><%= book.getTitle() %> - BookVerse</title>
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

        .nav-link {
            color: var(--text-primary) !important;
            margin: 0 10px;
            position: relative;
        }

        .nav-link:after {
            content: '';
            position: absolute;
            width: 0;
            height: 2px;
            bottom: 0;
            left: 0;
            background-color: var(--accent-color);
            transition: width 0.3s;
        }

        .nav-link:hover:after {
            width: 100%;
        }

        .nav-link.active {
            color: var(--accent-color) !important;
            font-weight: 500;
        }

        .nav-link.active:after {
            width: 100%;
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
        }

        .breadcrumb-item a {
            color: var(--text-secondary);
            text-decoration: none;
        }

        .breadcrumb-item.active {
            color: var(--text-primary);
        }

        .breadcrumb-item + .breadcrumb-item::before {
            color: var(--text-secondary);
        }

        .book-cover-lg {
            width: 100%;
            max-height: 500px;
            object-fit: contain;
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.3);
        }

        .book-type-badge {
            background-color: var(--accent-color);
            color: white;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            margin-bottom: 15px;
            display: inline-block;
        }

        .ebook-badge {
            background-color: #4267B2;
        }

        .physical-badge {
            background-color: #8a5cf5;
        }

        .rating i {
            color: gold;
        }

        .price-section {
            background-color: rgba(138, 92, 245, 0.1);
            border: 1px solid rgba(138, 92, 245, 0.2);
            border-radius: 8px;
            padding: 15px;
            margin: 20px 0;
        }

        .old-price {
            text-decoration: line-through;
            color: var(--text-secondary);
            font-size: 1.1rem;
        }

        .current-price {
            font-size: 2rem;
            font-weight: bold;
            color: var(--accent-color);
        }

        .discount-badge {
            background-color: #e53935;
            color: white;
            padding: 3px 8px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            margin-left: 10px;
        }

        .book-details-table {
            margin: 20px 0;
        }

        .book-details-table th {
            width: 150px;
            color: var(--text-secondary);
        }

        .book-details-table td {
            color: var(--text-primary);
        }

        .description-section {
            margin: 20px 0;
            line-height: 1.6;
        }

        .quantity-selector {
            display: flex;
            align-items: center;
            margin: 15px 0;
        }

        .quantity-selector button {
            background-color: var(--secondary-dark);
            border: 1px solid var(--border-color);
            color: var(--text-primary);
            width: 40px;
            height: 40px;
            font-size: 1.2rem;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.2s;
        }

        .quantity-selector button:hover {
            background-color: var(--accent-color);
        }

        .quantity-selector input {
            width: 60px;
            height: 40px;
            text-align: center;
            border: 1px solid var(--border-color);
            background-color: var(--secondary-dark);
            color: var(--text-primary);
            margin: 0 5px;
        }

        .quantity-selector input:focus {
            outline: none;
            border-color: var(--accent-color);
        }

        .stock-status {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
        }

        .stock-status i {
            margin-right: 8px;
        }

        .in-stock {
            color: var(--success-color);
        }

        .out-of-stock {
            color: var(--danger-color);
        }

        .related-books-section {
            margin-top: 40px;
        }

        .related-book-card {
            height: 100%;
            transition: transform 0.3s;
        }

        .related-book-card:hover {
            transform: translateY(-5px);
        }

        .related-book-img {
            height: 200px;
            object-fit: cover;
            border-bottom: 1px solid var(--border-color);
        }

        .nav-tabs {
            border-bottom-color: var(--border-color);
        }

        .nav-tabs .nav-link {
            color: var(--text-secondary);
            border: none;
            padding: 10px 20px;
            border-radius: 0;
            margin: 0;
        }

        .nav-tabs .nav-link:hover {
            color: var(--text-primary);
        }

        .nav-tabs .nav-link.active {
            color: var(--accent-color);
            background-color: transparent;
            border-bottom: 2px solid var(--accent-color);
        }

        .tab-content {
            padding: 20px 0;
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
    </style>
</head>
<body>
    <%
        // Convert book specific type
        PhysicalBook physicalBook = null;
        EBook ebook = null;

        if ("physical".equals(bookType)) {
            physicalBook = (PhysicalBook)book;
        } else if ("ebook".equals(bookType)) {
            ebook = (EBook)book;
        }

        // Format dates
        String publicationDateStr = "";
        if (book.getPublicationDate() != null) {
            SimpleDateFormat dateFormat = new SimpleDateFormat("MMMM d, yyyy");
            publicationDateStr = dateFormat.format(book.getPublicationDate());
        }

        // Get cover image URL
        String coverPath = request.getContextPath() + "/book-covers/" + book.getCoverImagePath();
        if (book.getCoverImagePath() == null || book.getCoverImagePath().equals("default_cover.jpg")) {
            coverPath = request.getContextPath() + "/book-covers/default_cover.jpg";
        }

        // Calculate discount percentage if applicable
        double discountPercent = 0;
        if ("physical".equals(bookType) || "ebook".equals(bookType)) {
            double originalPrice = book.getPrice();
            double discountedPrice = book.getDiscountedPrice();

            if (discountedPrice < originalPrice) {
                discountPercent = Math.round((1 - discountedPrice / originalPrice) * 100);
            }
        }

        // Get related books
        Book[] relatedBooks = (Book[])request.getAttribute("relatedBooks");

        // Check if book is in stock - properly determine stock status
        boolean isInStock = false;
        if ("ebook".equals(bookType)) {
            // E-books are always in stock
            isInStock = true;
        } else {
            // For physical books and regular books, check quantity
            isInStock = book.getQuantity() > 0;
        }
    %>

    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark sticky-top">
        <div class="container">
            <a class="navbar-brand" href="<%=request.getContextPath()%>/">
                <i class="fas fa-book-open me-2"></i>BookVerse
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="<%=request.getContextPath()%>/">Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="<%=request.getContextPath()%>/books">Books</a>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="reviews-tab" data-bs-toggle="tab" data-bs-target="#reviews" type="button" role="tab" aria-controls="reviews" aria-selected="false">
                            Reviews (<%= request.getAttribute("reviewsCount") %>)
                        </button>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%=request.getContextPath()%>/contact">Contact</a>
                    </li>

                </ul>

                <!-- Search Form -->
                <form class="d-flex me-3" action="<%=request.getContextPath()%>/books" method="get">
                    <div class="input-group">
                        <input class="form-control" type="search" name="search" placeholder="Search books...">
                        <button class="btn btn-outline-light" type="submit">
                            <i class="fas fa-search"></i>
                        </button>
                    </div>
                </form>

                <!-- User Menu -->
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <a class="nav-link" href="<%=request.getContextPath()%>/cart">
                            <i class="fas fa-shopping-cart"></i>
                            <% if (cartCount > 0) { %>
                            <span class="badge bg-accent rounded-pill"><%= cartCount %></span>
                            <% } %>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%=request.getContextPath()%>/login">Login</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%=request.getContextPath()%>/register">Register</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="container my-5">
        <!-- Flash Messages -->
        <c:if test="${not empty sessionScope.successMessage}">
            <div class="alert alert-custom alert-success alert-dismissible fade show mb-4" role="alert">
                <i class="fas fa-check-circle me-2"></i> ${sessionScope.successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <c:remove var="successMessage" scope="session" />
        </c:if>

        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-custom alert-danger alert-dismissible fade show mb-4" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i> ${sessionScope.errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <c:remove var="errorMessage" scope="session" />
        </c:if>

        <!-- Breadcrumb -->
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/">Home</a></li>
                <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/books">Books</a></li>
                <% if (book.getGenre() != null && !book.getGenre().isEmpty()) { %>
                    <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/books?genre=<%= book.getGenre() %>"><%= book.getGenre() %></a></li>
                <% } %>
                <li class="breadcrumb-item active" aria-current="page"><%= book.getTitle() %></li>
            </ol>
        </nav>

        <div class="row">
            <!-- Book Cover -->
            <div class="col-md-4 mb-4">
                <img src="<%= coverPath %>" alt="<%= book.getTitle() %>" class="book-cover-lg">
            </div>

            <!-- Book Details -->
            <div class="col-md-8">
                <!-- Book Badge -->
                <% if ("physical".equals(bookType)) { %>
                    <span class="book-type-badge physical-badge">Physical Book</span>
                <% } else if ("ebook".equals(bookType)) { %>
                    <span class="book-type-badge ebook-badge">E-Book</span>
                <% } %>

                <h1 class="mb-2"><%= book.getTitle() %></h1>
                <p class="text-muted mb-3">by <strong><%= book.getAuthor() %></strong></p>

                <!-- Rating Stars -->
                <div class="rating mb-4">
                    <%
                        double rating = book.getAverageRating();
                        for (int i = 1; i <= 5; i++) {
                            if (i <= rating) {
                    %>
                        <i class="fas fa-star"></i>
                    <% } else if (i - 0.5 <= rating) { %>
                        <i class="fas fa-star-half-alt"></i>
                    <% } else { %>
                        <i class="far fa-star"></i>
                    <% } } %>
                    <span class="ms-1"><%= String.format("%.1f", rating) %></span>
                    <span class="text-muted">(<%= book.getNumberOfRatings() %> reviews)</span>
                </div>

                <!-- Price Section -->
                <div class="price-section">
                    <% if (discountPercent > 0) { %>
                        <div class="old-price">$<%= String.format("%.2f", book.getPrice()) %></div>
                        <div class="d-flex align-items-center">
                            <div class="current-price">$<%= String.format("%.2f", book.getDiscountedPrice()) %></div>
                            <span class="discount-badge">Save <%= (int)discountPercent %>%</span>
                        </div>
                    <% } else { %>
                        <div class="current-price">$<%= String.format("%.2f", book.getPrice()) %></div>
                    <% } %>
                </div>

                <!-- Stock Status -->
                <div class="stock-status">
                    <% if ("ebook".equals(bookType)) { %>
                        <i class="fas fa-check-circle in-stock"></i> <span class="in-stock">Instant Download Available</span>
                    <% } else { %>
                        <% if (isInStock) { %>
                            <i class="fas fa-check-circle in-stock"></i> <span class="in-stock">In Stock (<%= book.getQuantity() %> available)</span>
                        <% } else { %>
                            <i class="fas fa-times-circle out-of-stock"></i> <span class="out-of-stock">Out of Stock</span>
                        <% } %>
                    <% } %>
                </div>

                <!-- Add to Cart Section -->
                <form action="<%=request.getContextPath()%>/add-to-cart" method="post" class="mb-4">
                    <input type="hidden" name="bookId" value="<%= book.getId() %>">

                    <!-- Quantity Selector (only for physical books that are in stock) -->
                    <% if ("physical".equals(bookType) && isInStock) { %>
                        <div class="quantity-selector">
                            <button type="button" onclick="decreaseQuantity()">-</button>
                            <input type="number" id="quantity" name="quantity" value="1" min="1" max="<%= book.getQuantity() %>">
                            <button type="button" onclick="increaseQuantity()">+</button>
                        </div>
                    <% } else if ("ebook".equals(bookType)) { %>
                        <input type="hidden" name="quantity" value="1">
                    <% } %>

                    <!-- Add to Cart Button -->
                    <div class="d-grid gap-2">
                        <% if (isInStock) { %>
                            <button type="submit" class="btn btn-accent btn-lg">
                                <i class="fas fa-cart-plus me-2"></i> Add to Cart
                            </button>
                        <% } else { %>
                            <button type="button" class="btn btn-accent btn-lg" disabled>
                                <i class="fas fa-cart-plus me-2"></i> Out of Stock
                            </button>
                        <% } %>

                        <%
                            // Check if user is logged in
                            boolean isUserLoggedIn = (session.getAttribute("userId") != null);
                            boolean isInWishlist = false;

                            if (isUserLoggedIn) {
                                String userId = (String) session.getAttribute("userId");

                                // Check if the book is in any wishlist
                                com.bookstore.model.wishlist.WishlistManager wishlistManager = new com.bookstore.model.wishlist.WishlistManager(application);
                                isInWishlist = wishlistManager.isBookInUserWishlists(userId, book.getId());
                            }
                        %>

                        <!-- Wishlist Button -->
                        <% if (isUserLoggedIn) { %>
                            <% if (isInWishlist) { %>
                                <button type="button" class="btn btn-outline-light" disabled>
                                    <i class="fas fa-heart me-2"></i> In Wishlist
                                </button>
                            <% } else { %>
                                <a href="<%=request.getContextPath()%>/wishlist-item?action=select-wishlist&bookId=<%= book.getId() %>" class="btn btn-outline-light">
                                    <i class="far fa-heart me-2"></i> Add to Wishlist
                                </a>
                            <% } %>
                        <% } else { %>
                            <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-light">
                                <i class="far fa-heart me-2"></i> Add to Wishlist
                            </a>
                        <% } %>
                    </div>
                </form>
            </div>
        </div>

        <!-- Book Information Tabs -->
        <div class="mt-5">
            <ul class="nav nav-tabs" id="bookInfoTabs" role="tablist">
                <li class="nav-item" role="presentation">
                    <button class="nav-link active" id="description-tab" data-bs-toggle="tab" data-bs-target="#description" type="button" role="tab" aria-controls="description" aria-selected="true">Description</button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="details-tab" data-bs-toggle="tab" data-bs-target="#details" type="button" role="tab" aria-controls="details" aria-selected="false">Details</button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="reviews-tab" data-bs-toggle="tab" data-bs-target="#reviews" type="button" role="tab" aria-controls="reviews" aria-selected="false">Reviews</button>
                </li>
            </ul>
            <div class="tab-content" id="bookInfoTabsContent">
                <!-- Description Tab -->
                <div class="tab-pane fade show active" id="description" role="tabpanel" aria-labelledby="description-tab">
                    <div class="description-section">
                        <% if (book.getDescription() != null && !book.getDescription().isEmpty()) { %>
                            <%= book.getDescription() %>
                        <% } else { %>
                            <p class="text-muted">No description available for this book.</p>
                        <% } %>
                    </div>
                </div>

                <!-- Details Tab -->
                <div class="tab-pane fade" id="details" role="tabpanel" aria-labelledby="details-tab">
                    <table class="table book-details-table">
                        <tbody>
                            <tr>
                                <th>Title:</th>
                                <td><%= book.getTitle() %></td>
                            </tr>
                            <tr>
                                <th>Author:</th>
                                <td><%= book.getAuthor() %></td>
                            </tr>
                            <tr>
                                <th>ISBN:</th>
                                <td><%= book.getIsbn() %></td>
                            </tr>
                            <tr>
                                <th>Publisher:</th>
                                <td><%= book.getPublisher() != null ? book.getPublisher() : "N/A" %></td>
                            </tr>
                            <tr>
                                <th>Publication Date:</th>
                                <td><%= !publicationDateStr.isEmpty() ? publicationDateStr : "N/A" %></td>
                            </tr>
                            <tr>
                                <th>Genre:</th>
                                <td><%= book.getGenre() != null ? book.getGenre() : "N/A" %></td>
                            </tr>

                            <% if ("physical".equals(bookType) && physicalBook != null) { %>
                                <tr>
                                    <th>Page Count:</th>
                                    <td><%= physicalBook.getPageCount() > 0 ? physicalBook.getPageCount() : "N/A" %></td>
                                </tr>
                                <tr>
                                    <th>Dimensions:</th>
                                    <td><%= physicalBook.getDimensions() != null ? physicalBook.getDimensions() : "N/A" %></td>
                                </tr>
                                <tr>
                                    <th>Binding:</th>
                                    <td><%= physicalBook.getBinding() != null ? physicalBook.getBinding() : "N/A" %></td>
                                </tr>
                                <tr>
                                    <th>Weight:</th>
                                    <td><%= physicalBook.getWeightKg() > 0 ? physicalBook.getWeightKg() + " kg" : "N/A" %></td>
                                </tr>
                                <tr>
                                    <th>Edition:</th>
                                    <td><%= physicalBook.getEdition() != null ? physicalBook.getEdition() : "N/A" %></td>
                                </tr>
                                <tr>
                                    <th>Condition:</th>
                                    <td><%= physicalBook.getCondition() != null ? physicalBook.getCondition() : "N/A" %></td>
                                </tr>
                                <tr>
                                    <th>Language:</th>
                                    <td><%= physicalBook.getLanguage() != null ? physicalBook.getLanguage() : "N/A" %></td>
                                </tr>
                            <% } else if ("ebook".equals(bookType) && ebook != null) { %>
                                <tr>
                                    <th>File Format:</th>
                                    <td><%= ebook.getFileFormat() != null ? ebook.getFileFormat() : "N/A" %></td>
                                </tr>
                                <tr>
                                    <th>File Size:</th>
                                    <td><%= ebook.getFileSizeMB() > 0 ? ebook.getFileSizeMB() + " MB" : "N/A" %></td>
                                </tr>
                                <tr>
                                    <th>DRM Protected:</th>
                                    <td><%= ebook.isDrm() ? "Yes" : "No" %></td>
                                </tr>
                                <tr>
                                    <th>Watermarked:</th>
                                    <td><%= ebook.isWatermarked() ? "Yes" : "No" %></td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>

                <!-- Reviews Tab -->
                <div class="tab-pane fade" id="reviews" role="tabpanel" aria-labelledby="reviews-tab">
                    <div class="reviews-section">
                        <div class="text-center py-4">
                            <i class="fas fa-star fa-3x mb-3" style="color: gold;"></i>
                            <h4>Book Reviews</h4>
                            <p class="text-muted">This book has <%= request.getAttribute("reviewsCount") %> reviews.</p>
                            <% if (book.getNumberOfRatings() > 0) { %>
                                <p>Average Rating: <%= String.format("%.1f", book.getAverageRating()) %> / 5.0</p>
                            <% } else { %>
                                <p>No ratings yet. Be the first to review this book!</p>
                            <% } %>
                            <a href="<%= request.getContextPath() %>/add-book-review?bookId=<%= book.getId() %>" class="btn btn-accent mt-3">
                                <i class="fas fa-pen me-2"></i> Write a Review
                            </a>
                        </div>
                    </div>
                </div>

            </div>
        </div>

        <!-- Related Books Section -->
        <% if (relatedBooks != null && relatedBooks.length > 0) { %>
            <div class="related-books-section">
                <h3 class="mb-4">You May Also Like</h3>
                <div class="row row-cols-1 row-cols-md-2 row-cols-lg-4 g-4">
                    <% for (Book relatedBook : relatedBooks) {
                        // Skip the current book if it's in the related books
                        if (relatedBook.getId().equals(book.getId())) continue;

                        // Get related book cover
                        String relatedCoverPath = request.getContextPath() + "/book-covers/" + relatedBook.getCoverImagePath();
                        if (relatedBook.getCoverImagePath() == null || relatedBook.getCoverImagePath().equals("default_cover.jpg")) {
                            relatedCoverPath = request.getContextPath() + "/book-covers/default_cover.jpg";
                        }
                    %>
                        <div class="col">
                            <div class="card related-book-card h-100">
                                <img src="<%= relatedCoverPath %>" class="related-book-img" alt="<%= relatedBook.getTitle() %>">
                                <div class="card-body">
                                    <h6 class="card-title"><%= relatedBook.getTitle() %></h6>
                                    <p class="card-text text-muted small"><%= relatedBook.getAuthor() %></p>
                                    <div class="d-flex justify-content-between align-items-center">
                                        <span class="price">$<%= String.format("%.2f", relatedBook.getPrice()) %></span>
                                        <div class="rating small">
                                            <% for (int i = 1; i <= 5; i++) {
                                                if (i <= relatedBook.getAverageRating()) { %>
                                                <i class="fas fa-star"></i>
                                            <% } else if (i - 0.5 <= relatedBook.getAverageRating()) { %>
                                                <i class="fas fa-star-half-alt"></i>
                                            <% } else { %>
                                                <i class="far fa-star"></i>
                                            <% } } %>
                                        </div>
                                    </div>
                                </div>
                                <div class="card-footer p-0">
                                    <a href="<%=request.getContextPath()%>/book-details?id=<%= relatedBook.getId() %>" class="btn btn-outline-light w-100 rounded-0">View Details</a>
                                </div>
                            </div>
                        </div>
                    <% } %>
                </div>
            </div>
        <% } %>
    </div>

    <!-- Footer -->
    <footer class="bg-dark text-light py-4">
        <div class="container">
            <div class="row">
                <div class="col-md-4 mb-3">
                    <h5>BookVerse</h5>
                    <p>Your one-stop destination for all your literary needs. Discover new worlds, one page at a time.</p>
                </div>
                <div class="col-md-4 mb-3">
                    <h5>Quick Links</h5>
                    <ul class="list-unstyled">
                        <li><a href="<%=request.getContextPath()%>/" class="text-decoration-none text-light">Home</a></li>
                        <li><a href="<%=request.getContextPath()%>/books" class="text-decoration-none text-light">Books</a></li>
                        <li><a href="<%=request.getContextPath()%>/contact" class="text-decoration-none text-light">Contact Us</a></li>
                    </ul>
                </div>
                <div class="col-md-4 mb-3">
                    <h5>Contact Information</h5>
                    <address>
                        <i class="fas fa-map-marker-alt me-2"></i> 123 Book Street, Reading City<br>
                        <i class="fas fa-phone me-2"></i> (123) 456-7890<br>
                        <i class="fas fa-envelope me-2"></i> info@bookverse.com
                    </address>
                </div>
            </div>
            <hr>
            <div class="text-center">
                <p class="mb-0">&copy; 2023 BookVerse. All rights reserved.</p>
            </div>
        </div>
    </footer>

    <!-- Bootstrap Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Custom JavaScript -->
    <script>
        // Quantity selector functions
        function decreaseQuantity() {
            const quantityInput = document.getElementById('quantity');
            let quantity = parseInt(quantityInput.value);
            if (quantity > 1) {
                quantityInput.value = quantity - 1;
            }
        }

        function increaseQuantity() {
            const quantityInput = document.getElementById('quantity');
            let quantity = parseInt(quantityInput.value);
            const maxQuantity = parseInt(quantityInput.getAttribute('max'));
            if (quantity < maxQuantity) {
                quantityInput.value = quantity + 1;
            }
        }
    </script>
</body>
</html>
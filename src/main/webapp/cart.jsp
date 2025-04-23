<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="com.bookstore.model.book.Book" %>
<%@ page import="com.bookstore.model.book.BookManager" %>
<%@ page import="com.bookstore.model.book.EBook" %>
<%@ page import="com.bookstore.model.book.PhysicalBook" %>
<%@ page import="com.bookstore.model.cart.CartManager" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shopping Cart - BookVerse</title>
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

        .card-header {
            background-color: var(--secondary-dark);
            color: var(--text-primary);
            font-weight: 600;
        }

        .table-dark {
            background-color: var(--card-bg);
            color: var(--text-primary);
        }

        .table-dark th,
        .table-dark td {
            border-color: var(--border-color);
        }

        .cart-item-img {
            width: 80px;
            height: 120px;
            object-fit: cover;
            border-radius: 4px;
        }

        .cart-summary {
            background-color: var(--secondary-dark);
            border: 1px solid var(--border-color);
            border-radius: 8px;
            padding: 20px;
        }

        .book-type-badge {
            font-size: 0.7rem;
            padding: 3px 8px;
            border-radius: 12px;
            font-weight: 600;
        }

        .ebook-badge {
            background-color: #4267B2;
            color: white;
        }

        .physical-badge {
            background-color: #8a5cf5;
            color: white;
        }

        .quantity-control {
            display: flex;
            align-items: center;
        }

        .quantity-control button {
            background-color: var(--secondary-dark);
            border: 1px solid var(--border-color);
            color: var(--text-primary);
            width: 25px;
            height: 25px;
            font-size: 0.8rem;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
        }

        .quantity-control input {
            width: 40px;
            height: 25px;
            text-align: center;
            border: 1px solid var(--border-color);
            background-color: var(--secondary-dark);
            color: var(--text-primary);
            margin: 0 3px;
        }

        .empty-cart {
            text-align: center;
            padding: 40px 0;
        }

        .empty-cart i {
            font-size: 5rem;
            color: var(--text-secondary);
            margin-bottom: 20px;
        }

        .price {
            font-weight: bold;
            color: var(--accent-color);
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
    // Get user ID or guest cart ID
    String userId = (String) session.getAttribute("userId");
    String cartId = (String) session.getAttribute("cartId");

    // Use either user ID or cart ID
    String effectiveId = userId != null ? userId : cartId;

    // Initialize cart if needed
    CartManager cartManager = new CartManager(application);

    Map<String, Integer> cart;
    Map<String, Book> cartBooks;
    double cartTotal;
    int cartCount;

    if (effectiveId != null) {
        // Get cart from CartManager
        cart = cartManager.getUserCart(effectiveId);
        cartBooks = cartManager.getCartBookDetails(effectiveId);
        cartTotal = cartManager.getCartTotal(effectiveId);
        cartCount = cartManager.getCartItemCount(effectiveId);
    } else {
        // No cart yet, use empty values
        cart = new HashMap<>();
        cartBooks = new HashMap<>();
        cartTotal = 0.0;
        cartCount = 0;

        // Create a cart ID for future use
        effectiveId = CartManager.generateCartId();
        session.setAttribute("cartId", effectiveId);
    }

    // Update session values for compatibility
    session.setAttribute("cart", cart);
    session.setAttribute("cartCount", cartCount);
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
                        <a class="nav-link" href="<%=request.getContextPath()%>/books">Books</a>
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
                        <a class="nav-link active" href="<%=request.getContextPath()%>/cart">
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

        <!-- Page Header -->
        <h2 class="mb-4"><i class="fas fa-shopping-cart me-2"></i> Your Shopping Cart</h2>

        <% if (cart.isEmpty()) { %>
            <!-- Empty Cart Message -->
            <div class="card">
                <div class="card-body empty-cart">
                    <i class="fas fa-shopping-cart"></i>
                    <h3>Your cart is empty</h3>
                    <p class="text-muted">Browse our catalog to find your next favorite book!</p>
                    <a href="<%=request.getContextPath()%>/books" class="btn btn-accent mt-3">
                        <i class="fas fa-book me-2"></i> Browse Books
                    </a>
                </div>
            </div>
        <% } else { %>
            <!-- Cart Items Section -->
            <div class="row">
                <div class="col-lg-8 mb-4">
                    <div class="card">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h5 class="mb-0">Cart Items (<%= cartCount %>)</h5>
                            <a href="<%=request.getContextPath()%>/clear-cart" class="btn btn-sm btn-outline-danger">
                                <i class="fas fa-trash-alt me-1"></i> Clear Cart
                            </a>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-dark">
                                    <thead>
                                        <tr>
                                            <th>Product</th>
                                            <th>Price</th>
                                            <th>Quantity</th>
                                            <th>Total</th>
                                            <th></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% for (Map.Entry<String, Integer> entry : cart.entrySet()) {
                                            String bookId = entry.getKey();
                                            int quantity = entry.getValue();
                                            Book book = cartBooks.get(bookId);

                                            if (book != null) {
                                                double itemPrice = book.getDiscountedPrice();
                                                double itemTotal = itemPrice * quantity;

                                                // Get book cover path
                                                String coverPath = request.getContextPath() + "/book-covers/" + book.getCoverImagePath();
                                                if (book.getCoverImagePath() == null || book.getCoverImagePath().equals("default_cover.jpg")) {
                                                    coverPath = request.getContextPath() + "/book-covers/default_cover.jpg";
                                                }

                                                // Determine book type
                                                String bookType = "";
                                                String badgeClass = "";
                                                if (book instanceof EBook) {
                                                    bookType = "E-Book";
                                                    badgeClass = "ebook-badge";
                                                } else if (book instanceof PhysicalBook) {
                                                    bookType = "Physical Book";
                                                    badgeClass = "physical-badge";
                                                }
                                        %>
                                        <tr>
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <img src="<%= coverPath %>" alt="<%= book.getTitle() %>" class="cart-item-img me-3">
                                                    <div>
                                                        <h6><%= book.getTitle() %></h6>
                                                        <p class="text-muted mb-1">by <%= book.getAuthor() %></p>
                                                        <% if (!bookType.isEmpty()) { %>
                                                            <span class="badge book-type-badge <%= badgeClass %>"><%= bookType %></span>
                                                        <% } %>
                                                    </div>
                                                </div>
                                            </td>
                                            <td class="price">$<%= String.format("%.2f", itemPrice) %></td>
                                            <td>
                                                <form action="<%=request.getContextPath()%>/update-cart" method="post" class="quantity-control">
                                                    <input type="hidden" name="bookId" value="<%= bookId %>">
                                                    <button type="submit" name="action" value="decrease">-</button>
                                                    <input type="text" name="quantity" value="<%= quantity %>" readonly>
                                                    <button type="submit" name="action" value="increase">+</button>
                                                </form>
                                            </td>
                                            <td class="price">$<%= String.format("%.2f", itemTotal) %></td>
                                            <td>
                                                <form action="<%=request.getContextPath()%>/update-cart" method="post">
                                                    <input type="hidden" name="bookId" value="<%= bookId %>">
                                                    <button type="submit" name="action" value="remove" class="btn btn-sm btn-outline-danger">
                                                        <i class="fas fa-times"></i>
                                                    </button>
                                                </form>
                                            </td>
                                        </tr>
                                        <% } } %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Cart Summary -->
                <div class="col-lg-4">
                    <div class="cart-summary sticky-top" style="top: 20px;">
                        <h5 class="mb-4">Order Summary</h5>

                        <div class="d-flex justify-content-between mb-2">
                            <span>Subtotal:</span>
                            <span class="price">$<%= String.format("%.2f", cartTotal) %></span>
                        </div>

                        <div class="d-flex justify-content-between mb-2">
                            <span>Shipping:</span>
                            <span>Free</span>
                        </div>

                        <div class="d-flex justify-content-between mb-2">
                            <span>Tax:</span>
                            <span class="price">$<%= String.format("%.2f", cartTotal * 0.07) %></span>
                        </div>

                        <hr>

                        <div class="d-flex justify-content-between mb-4">
                            <strong>Total:</strong>
                            <strong class="price">$<%= String.format("%.2f", cartTotal + (cartTotal * 0.07)) %></strong>
                        </div>

                        <div class="d-grid gap-2">
                            <a href="<%=request.getContextPath()%>/checkout" class="btn btn-accent btn-lg">
                                <i class="fas fa-credit-card me-2"></i> Proceed to Checkout
                            </a>
                            <a href="<%=request.getContextPath()%>/books" class="btn btn-outline-light">
                                <i class="fas fa-arrow-left me-2"></i> Continue Shopping
                            </a>
                        </div>
                    </div>
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
</body>
</html>
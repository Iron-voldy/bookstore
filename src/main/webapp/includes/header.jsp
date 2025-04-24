<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.bookstore.model.cart.CartManager" %>
<%@ page import="com.bookstore.model.user.User" %>
<%@ page import="com.bookstore.model.user.PremiumUser" %>
<%@ page import="com.bookstore.model.wishlist.WishlistManager" %>

<%
// Initialize cart count if not already set
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
    } else {
        cartCount = 0;
    }

    // Set in session
    session.setAttribute("cartCount", cartCount);
}

// Initialize wishlist count
Integer wishlistCount = (Integer) session.getAttribute("wishlistCount");
if (wishlistCount == null) {
    String userId = (String) session.getAttribute("userId");

    if (userId != null) {
        // Get wishlist count from WishlistManager
        WishlistManager wishlistManager = new WishlistManager(application);
        int totalItems = 0;

        // Get all wishlists for the user
        java.util.List<com.bookstore.model.wishlist.Wishlist> userWishlists = wishlistManager.getUserWishlists(userId);

        // Count all items in all wishlists
        for (com.bookstore.model.wishlist.Wishlist wishlist : userWishlists) {
            totalItems += wishlist.getItemCount();
        }

        wishlistCount = totalItems;
    } else {
        wishlistCount = 0;
    }

    // Set in session
    session.setAttribute("wishlistCount", wishlistCount);
}

// Check if user is logged in
User currentUser = (User) session.getAttribute("user");
boolean isLoggedIn = (currentUser != null);
boolean isPremium = (currentUser instanceof PremiumUser);
String username = isLoggedIn ? currentUser.getUsername() : "";
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
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

        .premium-badge {
            background: linear-gradient(135deg, #B68C1A, #FFD700);
            color: #333;
            padding: 3px 8px;
            border-radius: 15px;
            font-weight: bold;
            font-size: 0.8rem;
            display: inline-block;
            margin-left: 10px;
        }

        /* Additional custom styles */
    </style>

    <!-- Specific page title can be set dynamically -->
    <title>${param.pageTitle != null ? param.pageTitle : 'BookVerse - Your Online Bookstore'}</title>
</head>
<body>
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
                        <a class="nav-link ${pageContext.request.requestURI eq '/index.jsp' ? 'active' : ''}" href="<%=request.getContextPath()%>/">Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${pageContext.request.requestURI.contains('/books') ? 'active' : ''}" href="<%=request.getContextPath()%>/books">Books</a>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            Categories
                        </a>
                        <ul class="dropdown-menu dropdown-menu-dark" aria-labelledby="navbarDropdown">
                            <li><a class="dropdown-item" href="<%=request.getContextPath()%>/genre?genre=Fiction">Fiction</a></li>
                            <li><a class="dropdown-item" href="<%=request.getContextPath()%>/genre?genre=Non-Fiction">Non-Fiction</a></li>
                            <li><a class="dropdown-item" href="<%=request.getContextPath()%>/genre?genre=Mystery">Mystery</a></li>
                            <li><a class="dropdown-item" href="<%=request.getContextPath()%>/genre?genre=Science Fiction">Science Fiction</a></li>
                            <li><a class="dropdown-item" href="<%=request.getContextPath()%>/genre?genre=Fantasy">Fantasy</a></li>
                            <li><a class="dropdown-item" href="<%=request.getContextPath()%>/genre?genre=Romance">Romance</a></li>
                            <li><a class="dropdown-item" href="<%=request.getContextPath()%>/genre?genre=Thriller">Thriller</a></li>
                        </ul>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${pageContext.request.requestURI.contains('/top-books') ? 'active' : ''}" href="<%=request.getContextPath()%>/top-books">Top Books</a>
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
                    <% if (isLoggedIn) { %>
                        <!-- Wishlist Dropdown -->
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle ${pageContext.request.requestURI.contains('/wishlist') ? 'active' : ''}"
                               href="#" id="wishlistDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="fas fa-heart me-1"></i> Wishlists
                                <% if (wishlistCount > 0) { %>
                                    <span class="badge bg-accent rounded-pill"><%= wishlistCount %></span>
                                <% } %>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-dark" aria-labelledby="wishlistDropdown">
                                <li>
                                    <a class="dropdown-item" href="<%=request.getContextPath()%>/wishlists">
                                        <i class="fas fa-list me-2"></i> My Wishlists
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item" href="<%=request.getContextPath()%>/wishlists?action=create">
                                        <i class="fas fa-plus me-2"></i> Create New Wishlist
                                    </a>
                                </li>
                            </ul>
                        </li>

                        <!-- Cart -->
                        <li class="nav-item">
                            <a class="nav-link ${pageContext.request.requestURI.contains('/cart') ? 'active' : ''}" href="<%=request.getContextPath()%>/cart">
                                <i class="fas fa-shopping-cart"></i>
                                <% if (cartCount > 0) { %>
                                <span class="badge bg-accent rounded-pill"><%= cartCount %></span>
                                <% } %>
                            </a>
                        </li>

                        <!-- User Profile Dropdown -->
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle ${pageContext.request.requestURI.contains('/user/') ? 'active' : ''}"
                               href="#" id="userDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="fas fa-user-circle me-1"></i> <%= username %>
                                <% if (isPremium) { %>
                                <span class="premium-badge">PREMIUM</span>
                                <% } %>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-dark" aria-labelledby="userDropdown">
                                <li><a class="dropdown-item" href="<%=request.getContextPath()%>/user/profile.jsp">My Profile</a></li>
                                <li><a class="dropdown-item" href="<%=request.getContextPath()%>/order-history">My Orders</a></li>
                                <li><a class="dropdown-item" href="<%=request.getContextPath()%>/wishlists">My Wishlists</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item" href="<%=request.getContextPath()%>/logout">Logout</a></li>
                            </ul>
                        </li>
                    <% } else { %>
                        <!-- Guest User Menu -->
                        <li class="nav-item">
                            <a class="nav-link ${pageContext.request.requestURI.contains('/cart') ? 'active' : ''}" href="<%=request.getContextPath()%>/cart">
                                <i class="fas fa-shopping-cart"></i>
                                <% if (cartCount > 0) { %>
                                <span class="badge bg-accent rounded-pill"><%= cartCount %></span>
                                <% } %>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link ${pageContext.request.requestURI.contains('/login') ? 'active' : ''}" href="<%=request.getContextPath()%>/login">Login</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link ${pageContext.request.requestURI.contains('/register') ? 'active' : ''}" href="<%=request.getContextPath()%>/register">Register</a>
                        </li>
                    <% } %>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Flash Messages -->
    <div class="container mt-3">
        <c:if test="${not empty sessionScope.successMessage}">
            <div class="alert alert-custom alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i> ${sessionScope.successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <c:remove var="successMessage" scope="session" />
        </c:if>

        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-custom alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i> ${sessionScope.errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <c:remove var="errorMessage" scope="session" />
        </c:if>
    </div>

    <!-- Main Content Placeholder -->
    <%= request.getAttribute("pageContent") != null ? request.getAttribute("pageContent") : "" %>
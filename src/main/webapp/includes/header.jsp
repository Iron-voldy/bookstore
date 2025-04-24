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
                        <!-- Add more genres as needed -->
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
                <!-- Wishlist icon (only shown for logged-in users) -->
                <li class="nav-item">
                    <a class="nav-link ${pageContext.request.requestURI.contains('/wishlist') ? 'active' : ''}" href="<%=request.getContextPath()%>/wishlists">
                        <i class="fas fa-heart"></i>
                        <% if (wishlistCount > 0) { %>
                        <span class="badge bg-accent rounded-pill"><%= wishlistCount %></span>
                        <% } %>
                    </a>
                </li>
                <% } %>

                <li class="nav-item">
                    <a class="nav-link ${pageContext.request.requestURI.contains('/cart') ? 'active' : ''}" href="<%=request.getContextPath()%>/cart">
                        <i class="fas fa-shopping-cart"></i>
                        <% if (cartCount > 0) { %>
                        <span class="badge bg-accent rounded-pill"><%= cartCount %></span>
                        <% } %>
                    </a>
                </li>
                <% if (isLoggedIn) { %>
                <!-- Logged in user menu -->
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle ${pageContext.request.requestURI.contains('/user/') ? 'active' : ''}" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="fas fa-user-circle me-1"></i> <%= username %>
                        <% if (isPremium) { %>
                        <span class="premium-badge">PREMIUM</span>
                        <% } %>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-dark" aria-labelledby="userDropdown">
                        <li><a class="dropdown-item" href="<%=request.getContextPath()%>/user/profile.jsp">My Profile</a></li>
                        <li><a class="dropdown-item" href="<%=request.getContextPath()%>/order-history">My Orders</a></li>
                        <li><a class="dropdown-item" href="<%=request.getContextPath()%>/wishlists">My Wishlists</a></li>
                        <li><a class="dropdown-item" href="<%=request.getContextPath()%>/user-reviews">My Reviews</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="<%=request.getContextPath()%>/logout">Logout</a></li>
                    </ul>
                </li>
                <% } else { %>
                <!-- Guest user menu -->
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
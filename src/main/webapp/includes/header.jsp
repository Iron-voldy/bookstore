<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.bookstore.model.cart.CartManager" %>
<%@ page import="com.bookstore.model.user.User" %>
<%@ page import="com.bookstore.model.user.PremiumUser" %>
<%@ page import="com.bookstore.model.wishlist.WishlistManager" %>
<%@ page import="com.bookstore.model.book.BookManager" %>
<%@ page import="com.bookstore.model.book.Book" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.TreeSet" %>

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
        wishlistCount = wishlistManager.getTotalUserWishlistItemsCount(userId);
    } else {
        wishlistCount = 0;
    }

    // Set in session
    session.setAttribute("wishlistCount", wishlistCount);
}

// Check if user is logged in
User currentUser = (User) session.getAttribute("user");
boolean isLoggedIn = (currentUser != null);
boolean isPremium = false;

if (isLoggedIn && currentUser instanceof PremiumUser) {
    isPremium = true;
}
String username = isLoggedIn ? currentUser.getUsername() : "";

// Get genres for dropdown
BookManager bookManager = new BookManager(application);
Book[] allBooks = bookManager.getAllBooks();
Set<String> genres = new TreeSet<>();

for (Book book : allBooks) {
    if (book.getGenre() != null && !book.getGenre().isEmpty()) {
        genres.add(book.getGenre());
    }
}

// Determine current page for active navigation
String currentURI = request.getRequestURI();
String contextPath = request.getContextPath();
String pathInfo = request.getPathInfo() != null ? request.getPathInfo() : "";
String queryString = request.getQueryString() != null ? request.getQueryString() : "";
boolean isHomePage = currentURI.equals(contextPath + "/") || currentURI.endsWith("/index.jsp");
boolean isBooksPage = currentURI.contains("/books") || pathInfo.contains("/books");
boolean isBookDetailsPage = currentURI.contains("/book-details") || request.getParameter("id") != null;
boolean isGenrePage = currentURI.contains("/genre") || queryString.contains("genre=");
boolean isTopBooksPage = currentURI.contains("/top-books");
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
                    <a class="nav-link <%= isHomePage ? "active" : "" %>" href="<%=request.getContextPath()%>/">Home</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <%= isBooksPage ? "active" : "" %>" href="<%=request.getContextPath()%>/books">Books</a>
                </li>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle <%= isGenrePage ? "active" : "" %>" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                        Categories
                    </a>
                    <ul class="dropdown-menu dropdown-menu-dark" aria-labelledby="navbarDropdown">
                        <% for (String genre : genres) { %>
                            <li><a class="dropdown-item" href="<%=request.getContextPath()%>/genre?genre=<%= genre %>"><%= genre %></a></li>
                        <% } %>
                    </ul>
                </li>
                <li class="nav-item">
                    <a class="nav-link <%= isTopBooksPage ? "active" : "" %>" href="<%=request.getContextPath()%>/top-books">Top Books</a>
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
                        <a class="nav-link dropdown-toggle <%= currentURI.contains("/wishlist") ? "active" : "" %>" href="#" id="wishlistDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
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
                        <a class="nav-link <%= currentURI.contains("/cart") ? "active" : "" %>" href="<%=request.getContextPath()%>/cart">
                            <i class="fas fa-shopping-cart"></i>
                            <% if (cartCount > 0) { %>
                            <span class="badge bg-accent rounded-pill"><%= cartCount %></span>
                            <% } %>
                        </a>
                    </li>

                    <li class="nav-item">
                        <a class="nav-link <%= currentURI.contains("/order-history") ? "active" : "" %>" href="<%=request.getContextPath()%>/order-history">
                            My Orders
                        </a>
                    </li>

                    <!-- User Profile Dropdown -->
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle <%= currentURI.contains("/user/") ? "active" : "" %>" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
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
                        <a class="nav-link <%= currentURI.contains("/cart") ? "active" : "" %>" href="<%=request.getContextPath()%>/cart">
                            <i class="fas fa-shopping-cart"></i>
                            <% if (cartCount > 0) { %>
                            <span class="badge bg-accent rounded-pill"><%= cartCount %></span>
                            <% } %>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link <%= currentURI.contains("/login") ? "active" : "" %>" href="<%=request.getContextPath()%>/login">Login</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link <%= currentURI.contains("/register") ? "active" : "" %>" href="<%=request.getContextPath()%>/register">Register</a>
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

    <c:if test="${not empty sessionScope.infoMessage}">
        <div class="alert alert-custom alert-info alert-dismissible fade show" role="alert">
            <i class="fas fa-info-circle me-2"></i> ${sessionScope.infoMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="infoMessage" scope="session" />
    </c:if>
</div>
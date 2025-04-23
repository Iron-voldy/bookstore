<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.bookstore.model.cart.CartManager" %>

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
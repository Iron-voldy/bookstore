<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
    <title>BookVerse - Your Online Bookstore</title>
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

        .hero-section {
            position: relative;
            padding: 120px 0;
            background: linear-gradient(rgba(0, 0, 0, 0.7), rgba(0, 0, 0, 0.7)), url('https://source.unsplash.com/random/1600x900/?library') no-repeat center center;
            background-size: cover;
            color: white;
            text-align: center;
            margin-bottom: 50px;
        }

        .hero-content {
            max-width: 800px;
            margin: 0 auto;
        }

        .hero-title {
            font-size: 3.5rem;
            font-weight: 700;
            margin-bottom: 20px;
        }

        .hero-description {
            font-size: 1.25rem;
            margin-bottom: 30px;
        }

        .featured-books {
            padding: 50px 0;
        }

        .section-title {
            font-size: 2rem;
            font-weight: 600;
            margin-bottom: 40px;
            position: relative;
            padding-bottom: 15px;
        }

        .section-title:after {
            content: '';
            position: absolute;
            width: 100px;
            height: 4px;
            background-color: var(--accent-color);
            bottom: 0;
            left: 0;
        }

        .card {
            background-color: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 8px;
            overflow: hidden;
            transition: transform 0.3s;
            height: 100%;
        }

        .card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.3);
        }

        .card-img-top {
            height: 300px;
            object-fit: cover;
        }

        .book-badge {
            position: absolute;
            top: 10px;
            right: 10px;
            background-color: var(--accent-color);
            color: white;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
        }

        .rating i {
            color: gold;
        }

        .genres-section {
            padding: 50px 0;
        }

        .genre-card {
            height: 150px;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            background: linear-gradient(rgba(0, 0, 0, 0.7), rgba(0, 0, 0, 0.7)), url('https://source.unsplash.com/random/300x200/?books') no-repeat center center;
            background-size: cover;
            border-radius: 8px;
            overflow: hidden;
            transition: all 0.3s;
        }

        .genre-card:hover {
            transform: scale(1.05);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.3);
        }

        .genre-card a {
            display: block;
            width: 100%;
            height: 100%;
            color: white;
            font-size: 1.5rem;
            font-weight: 600;
            text-decoration: none;
            padding: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s;
        }

        .genre-card a:hover {
            background-color: rgba(138, 92, 245, 0.3);
        }

        .newsletter-section {
            padding: 80px 0;
            background-color: var(--secondary-dark);
            margin: 50px 0;
        }

        .newsletter-content {
            max-width: 600px;
            margin: 0 auto;
            text-align: center;
        }

        .newsletter-title {
            font-size: 2.5rem;
            margin-bottom: 20px;
        }

        .newsletter-form {
            display: flex;
            margin-top: 30px;
        }

        .newsletter-form input {
            flex: 1;
            padding: 15px 20px;
            border: none;
            border-radius: 4px 0 0 4px;
            background-color: var(--card-bg);
            color: var(--text-primary);
        }

        .newsletter-form button {
            padding: 0 25px;
            border: none;
            border-radius: 0 4px 4px 0;
            background-color: var(--accent-color);
            color: white;
            font-weight: 600;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .newsletter-form button:hover {
            background-color: var(--accent-hover);
        }

        .testimonials-section {
            padding: 50px 0;
        }

        .testimonial-card {
            text-align: center;
            padding: 30px;
        }

        .testimonial-card img {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            object-fit: cover;
            margin-bottom: 20px;
            border: 3px solid var(--accent-color);
        }

        .testimonial-text {
            font-style: italic;
            margin-bottom: 20px;
            position: relative;
            padding: 0 20px;
        }

        .testimonial-text:before,
        .testimonial-text:after {
            content: '"';
            font-size: 2rem;
            color: var(--accent-color);
            position: absolute;
        }

        .testimonial-text:before {
            left: 0;
            top: -10px;
        }

        .testimonial-text:after {
            right: 0;
            bottom: -20px;
        }

        .testimonial-author {
            font-weight: 600;
            margin-bottom: 5px;
        }

        .testimonial-role {
            color: var(--text-secondary);
            font-size: 0.9rem;
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

    // Get featured books
    BookManager bookManager = new BookManager(application);
    Book[] featuredBooks = bookManager.getFeaturedBooks();

    // If no featured books, get top rated books
    if (featuredBooks == null || featuredBooks.length == 0) {
        featuredBooks = bookManager.getTopRatedBooks(4);
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
                        <a class="nav-link active" href="<%=request.getContextPath()%>/">Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%=request.getContextPath()%>/books">Books</a>
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
                        <a class="nav-link" href="<%=request.getContextPath()%>/top-books">Top Books</a>
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
    <div class="container-fluid p-0">
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

        <!-- Hero Section -->
        <section class="hero-section">
            <div class="container">
                <div class="hero-content">
                    <h1 class="hero-title">Discover Your Next Favorite Book</h1>
                    <p class="hero-description">Browse our extensive collection of books for all ages and interests. From bestsellers to rare finds, we have something for everyone.</p>
                    <a href="<%=request.getContextPath()%>/books" class="btn btn-accent btn-lg">
                        <i class="fas fa-book me-2"></i> Browse Books
                    </a>
                </div>
            </div>
        </section>

        <!-- Featured Books Section -->
        <section class="featured-books">
            <div class="container">
                <h2 class="section-title">Featured Books</h2>
                <div class="row row-cols-1 row-cols-md-2 row-cols-lg-4 g-4">
                    <% for (Book book : featuredBooks) {
                        // Get cover image URL
                        String coverPath = request.getContextPath() + "/book-covers/" + book.getCoverImagePath();
                        if (book.getCoverImagePath() == null || book.getCoverImagePath().equals("default_cover.jpg")) {
                            coverPath = request.getContextPath() + "/book-covers/default_cover.jpg";
                        }

                        // Determine book type
                        String bookBadge = "";
                        if (book instanceof EBook) {
                            bookBadge = "E-Book";
                        } else if (book instanceof PhysicalBook) {
                            bookBadge = "Physical Book";
                        }
                    %>
                        <div class="col">
                            <div class="card h-100 position-relative">
                                <% if (!bookBadge.isEmpty()) { %>
                                    <span class="book-badge"><%= bookBadge %></span>
                                <% } %>
                                <img src="<%= coverPath %>" class="card-img-top" alt="<%= book.getTitle() %>">
                                <div class="card-body">
                                    <h5 class="card-title"><%= book.getTitle() %></h5>
                                    <p class="card-text text-muted">by <%= book.getAuthor() %></p>
                                    <div class="rating mb-2">
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
                                        <span class="ms-1">(<%= String.format("%.1f", rating) %>)</span>
                                    </div>
                                    <p class="card-text fw-bold text-accent">$<%= String.format("%.2f", book.getDiscountedPrice()) %></p>
                                </div>
                                <div class="card-footer d-grid">
                                    <a href="<%=request.getContextPath()%>/book-details?id=<%= book.getId() %>" class="btn btn-accent">View Details</a>
                                </div>
                            </div>
                        </div>
                    <% } %>
                </div>
                <div class="text-center mt-4">
                    <a href="<%=request.getContextPath()%>/books" class="btn btn-outline-light btn-lg">
                        View All Books <i class="fas fa-arrow-right ms-2"></i>
                    </a>
                </div>
            </div>
        </section>

        <!-- Book Genres Section -->
        <section class="genres-section">
            <div class="container">
                <h2 class="section-title">Browse by Genre</h2>
                <div class="row row-cols-1 row-cols-md-3 row-cols-lg-4 g-4">
                    <div class="col">
                        <div class="genre-card" style="background-image: url('https://source.unsplash.com/random/300x200/?fiction')">
                            <a href="<%=request.getContextPath()%>/genre?genre=Fiction">Fiction</a>
                        </div>
                    </div>
                    <div class="col">
                        <div class="genre-card" style="background-image: url('https://source.unsplash.com/random/300x200/?nonfiction')">
                            <a href="<%=request.getContextPath()%>/genre?genre=Non-Fiction">Non-Fiction</a>
                        </div>
                    </div>
                    <div class="col">
                        <div class="genre-card" style="background-image: url('https://source.unsplash.com/random/300x200/?mystery')">
                            <a href="<%=request.getContextPath()%>/genre?genre=Mystery">Mystery</a>
                        </div>
                    </div>
                    <div class="col">
                        <div class="genre-card" style="background-image: url('https://source.unsplash.com/random/300x200/?scifi')">
                            <a href="<%=request.getContextPath()%>/genre?genre=Science Fiction">Science Fiction</a>
                        </div>
                    </div>
                    <div class="col">
                        <div class="genre-card" style="background-image: url('https://source.unsplash.com/random/300x200/?fantasy')">
                            <a href="<%=request.getContextPath()%>/genre?genre=Fantasy">Fantasy</a>
                        </div>
                    </div>
                    <div class="col">
                        <div class="genre-card" style="background-image: url('https://source.unsplash.com/random/300x200/?romance')">
                            <a href="<%=request.getContextPath()%>/genre?genre=Romance">Romance</a>
                        </div>
                    </div>
                    <div class="col">
                        <div class="genre-card" style="background-image: url('https://source.unsplash.com/random/300x200/?thriller')">
                            <a href="<%=request.getContextPath()%>/genre?genre=Thriller">Thriller</a>
                        </div>
                    </div>
                    <div class="col">
                        <div class="genre-card" style="background-image: url('https://source.unsplash.com/random/300x200/?biography')">
                            <a href="<%=request.getContextPath()%>/genre?genre=Biography">Biography</a>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Newsletter Section -->
        <section class="newsletter-section">
            <div class="container">
                <div class="newsletter-content">
                    <h2 class="newsletter-title">Subscribe to Our Newsletter</h2>
                    <p>Stay updated with our latest releases, exclusive offers, and literary events. Sign up now and get 10% off your first order!</p>
                    <form class="newsletter-form">
                        <input type="email" placeholder="Your email address" required>
                        <button type="submit">Subscribe</button>
                    </form>
                </div>
            </div>
        </section>

        <!-- Testimonials Section -->
        <section class="testimonials-section">
            <div class="container">
                <h2 class="section-title">What Our Customers Say</h2>
                <div class="row">
                    <div class="col-md-4">
                        <div class="testimonial-card card h-100">
                            <img src="https://randomuser.me/api/portraits/women/32.jpg" alt="Sarah J.">
                            <p class="testimonial-text">BookVerse has become my go-to for all my reading needs. The selection is vast, and the delivery is always prompt!</p>
                            <h5 class="testimonial-author">Sarah J.</h5>
                            <p class="testimonial-role">Avid Reader</p>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="testimonial-card card h-100">
                            <img src="https://randomuser.me/api/portraits/men/44.jpg" alt="Michael T.">
                            <p class="testimonial-text">I love the e-book selection here. The instant download feature is so convenient, and the prices are better than competitors.</p>
                            <h5 class="testimonial-author">Michael T.</h5>
                            <p class="testimonial-role">Tech Enthusiast</p>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="testimonial-card card h-100">
                            <img src="https://randomuser.me/api/portraits/women/68.jpg" alt="Emma R.">
                            <p class="testimonial-text">The recommendations are spot on! I've discovered so many new authors and genres I wouldn't have found elsewhere.</p>
                            <h5 class="testimonial-author">Emma R.</h5>
                            <p class="testimonial-role">Book Club Organizer</p>
                        </div>
                    </div>
                </div>
            </div>
        </section>
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
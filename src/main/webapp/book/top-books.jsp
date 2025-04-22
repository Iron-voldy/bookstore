<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.bookstore.model.book.Book" %>
<%@ page import="com.bookstore.model.book.BookManager" %>
<%@ page import="com.bookstore.model.book.EBook" %>
<%@ page import="com.bookstore.model.book.PhysicalBook" %>
<%@ page import="com.bookstore.util.QuickSort" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Top Rated Books - BookVerse</title>
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
            background: linear-gradient(rgba(0, 0, 0, 0.7), rgba(0, 0, 0, 0.7)), url('https://source.unsplash.com/random/1600x900/?books') no-repeat center center/cover;
            padding: 100px 0;
            margin-bottom: 40px;
            text-align: center;
            color: white;
        }

        .hero-title {
            font-size: 3rem;
            font-weight: 700;
            margin-bottom: 20px;
        }

        .hero-description {
            font-size: 1.2rem;
            max-width: 800px;
            margin: 0 auto;
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
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
        }

        .rating i {
            color: gold;
        }

        .book-rank {
            position: absolute;
            top: 10px;
            left: 10px;
            width: 30px;
            height: 30px;
            background-color: var(--accent-color);
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 1rem;
            z-index: 1;
        }

        .book-cover {
            height: 250px;
            object-fit: cover;
        }

        .section-title {
            position: relative;
            margin-bottom: 30px;
            padding-bottom: 15px;
        }

        .section-title:after {
            content: '';
            position: absolute;
            width: 100px;
            height: 3px;
            background-color: var(--accent-color);
            bottom: 0;
            left: 0;
        }

        .price {
            font-weight: bold;
            font-size: 1.2rem;
            color: var(--accent-color);
        }

        .old-price {
            text-decoration: line-through;
            color: var(--text-secondary);
            font-size: 0.9rem;
        }

        .tab-content {
            padding-top: 20px;
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
    </style>
</head>
<body>
    <%
        // Get BookManager
        BookManager bookManager = new BookManager(application);
        Book[] allBooks = bookManager.getAllBooks();

        // Get top rated books using QuickSort
        QuickSort.sort(allBooks, (b1, b2) -> Double.compare(b2.getAverageRating(), b1.getAverageRating()));

        // Get top 10 books
        int topCount = Math.min(10, allBooks.length);
        Book[] topRatedBooks = new Book[topCount];
        System.arraycopy(allBooks, 0, topRatedBooks, 0, topCount);

        // Get newest arrivals
        QuickSort.sort(allBooks, (b1, b2) -> b2.getAddedDate().compareTo(b1.getAddedDate()));

        // Get top 10 newest books
        Book[] newestBooks = new Book[topCount];
        System.arraycopy(allBooks, 0, newestBooks, 0, topCount);

        // Get featured books
        java.util.List<Book> featuredList = new java.util.ArrayList<>();
        for (Book book : allBooks) {
            if (book.isFeatured()) {
                featuredList.add(book);
                if (featuredList.size() >= 10) break;
            }
        }
        Book[] featuredBooks = featuredList.toArray(new Book[0]);
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
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            Categories
                        </a>
                        <ul class="dropdown-menu dropdown-menu-dark" aria-labelledby="navbarDropdown">
                            <%
                                // Collect all genres for dropdown
                                java.util.Set<String> genres = new java.util.TreeSet<>();
                                for (Book book : allBooks) {
                                    if (book.getGenre() != null && !book.getGenre().isEmpty()) {
                                        genres.add(book.getGenre());
                                    }
                                }

                                // Show genres in dropdown
                                for (String genre : genres) {
                            %>
                                <li><a class="dropdown-item" href="<%=request.getContextPath()%>/genre?genre=<%= genre %>"><%= genre %></a></li>
                            <% } %>
                        </ul>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="<%=request.getContextPath()%>/top-books">Top Books</a>
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
                            <span class="badge bg-accent rounded-pill">0</span>
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

    <!-- Hero Section -->
    <section class="hero-section">
        <div class="container">
            <h1 class="hero-title">Discover Our Top Books</h1>
            <p class="hero-description">Explore the highest-rated books, newest arrivals, and staff-curated featured titles across all categories.</p>
        </div>
    </section>

    <!-- Main Content -->
    <div class="container">
        <!-- Books Tabs -->
        <ul class="nav nav-tabs" id="booksTab" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active" id="top-rated-tab" data-bs-toggle="tab" data-bs-target="#top-rated" type="button" role="tab" aria-controls="top-rated" aria-selected="true">Top Rated</button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="newest-tab" data-bs-toggle="tab" data-bs-target="#newest" type="button" role="tab" aria-controls="newest" aria-selected="false">Newest Arrivals</button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="featured-tab" data-bs-toggle="tab" data-bs-target="#featured" type="button" role="tab" aria-controls="featured" aria-selected="false">Featured</button>
            </li>
        </ul>

        <div class="tab-content" id="booksTabContent">
            <!-- Top Rated Books Tab -->
            <div class="tab-pane fade show active" id="top-rated" role="tabpanel" aria-labelledby="top-rated-tab">
                <h2 class="section-title">Top Rated Books</h2>

                <div class="row row-cols-1 row-cols-md-2 row-cols-lg-5 g-4">
                    <% for (int i = 0; i < topRatedBooks.length; i++) {
                        Book book = topRatedBooks[i];

                        // Get cover image URL
                        String coverPath = request.getContextPath() + "/book-covers/" + book.getCoverImagePath();
                        if (book.getCoverImagePath() == null || book.getCoverImagePath().equals("default_cover.jpg")) {
                            coverPath = request.getContextPath() + "/book-covers/default_cover.jpg";
                        }
                    %>
                        <div class="col">
                            <div class="card h-100 position-relative">
                                <div class="book-rank"><%= i+1 %></div>
                                <img src="<%= coverPath %>" class="book-cover" alt="<%= book.getTitle() %>">
                                <div class="card-body">
                                    <h5 class="card-title"><%= book.getTitle() %></h5>
                                    <p class="card-text text-muted">by <%= book.getAuthor() %></p>

                                    <!-- Rating Stars -->
                                    <div class="rating mb-2">
                                        <%
                                            double rating = book.getAverageRating();
                                            for (int j = 1; j <= 5; j++) {
                                                if (j <= rating) {
                                        %>
                                            <i class="fas fa-star"></i>
                                        <% } else if (j - 0.5 <= rating) { %>
                                            <i class="fas fa-star-half-alt"></i>
                                        <% } else { %>
                                            <i class="far fa-star"></i>
                                        <% } } %>
                                        <span class="ms-1"><%= String.format("%.1f", rating) %></span>
                                    </div>

                                    <!-- Price Display -->
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div class="price">
                                            $<%= String.format("%.2f", book.getPrice()) %>
                                        </div>

                                        <!-- Book Type -->
                                        <% if (book instanceof EBook) { %>
                                            <span class="badge bg-primary">E-Book</span>
                                        <% } else if (book instanceof PhysicalBook) { %>
                                            <span class="badge bg-accent">Physical</span>
                                        <% } %>
                                    </div>
                                </div>
                                <div class="card-footer d-grid">
                                    <a href="<%=request.getContextPath()%>/book-details?id=<%= book.getId() %>" class="btn btn-accent">View Details</a>
                                </div>
                            </div>
                        </div>
                    <% } %>
                </div>
            </div>

            <!-- Newest Arrivals Tab -->
            <div class="tab-pane fade" id="newest" role="tabpanel" aria-labelledby="newest-tab">
                <h2 class="section-title">Newest Arrivals</h2>

                <div class="row row-cols-1 row-cols-md-2 row-cols-lg-5 g-4">
                    <% for (int i = 0; i < newestBooks.length; i++) {
                        Book book = newestBooks[i];

                        // Get cover image URL
                        String coverPath = request.getContextPath() + "/book-covers/" + book.getCoverImagePath();
                        if (book.getCoverImagePath() == null || book.getCoverImagePath().equals("default_cover.jpg")) {
                            coverPath = request.getContextPath() + "/book-covers/default_cover.jpg";
                        }

                        // Format date added
                        String dateAdded = "";
                        if (book.getAddedDate() != null) {
                            java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat("MMM d, yyyy");
                            dateAdded = dateFormat.format(book.getAddedDate());
                        }
                    %>
                        <div class="col">
                            <div class="card h-100">
                                <img src="<%= coverPath %>" class="book-cover" alt="<%= book.getTitle() %>">
                                <div class="card-body">
                                    <h5 class="card-title"><%= book.getTitle() %></h5>
                                    <p class="card-text text-muted">by <%= book.getAuthor() %></p>

                                    <!-- Date Added -->
                                    <p class="text-muted small">
                                        <i class="far fa-calendar-alt me-1"></i> Added on <%= dateAdded %>
                                    </p>

                                    <!-- Rating Stars -->
                                    <div class="rating mb-2">
                                        <%
                                            double rating = book.getAverageRating();
                                            for (int j = 1; j <= 5; j++) {
                                                if (j <= rating) {
                                        %>
                                            <i class="fas fa-star"></i>
                                        <% } else if (j - 0.5 <= rating) { %>
                                            <i class="fas fa-star-half-alt"></i>
                                        <% } else { %>
                                            <i class="far fa-star"></i>
                                        <% } } %>
                                        <span class="ms-1"><%= String.format("%.1f", rating) %></span>
                                    </div>

                                    <!-- Price Display -->
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div class="price">
                                            $<%= String.format("%.2f", book.getPrice()) %>
                                        </div>

                                        <!-- Book Type -->
                                        <% if (book instanceof EBook) { %>
                                            <span class="badge bg-primary">E-Book</span>
                                        <% } else if (book instanceof PhysicalBook) { %>
                                            <span class="badge bg-accent">Physical</span>
                                        <% } %>
                                    </div>
                                </div>
                                <div class="card-footer d-grid">
                                    <a href="<%=request.getContextPath()%>/book-details?id=<%= book.getId() %>" class="btn btn-accent">View Details</a>
                                </div>
                            </div>
                        </div>
                    <% } %>
                </div>
            </div>

            <!-- Featured Books Tab -->
            <div class="tab-pane fade" id="featured" role="tabpanel" aria-labelledby="featured-tab">
                <h2 class="section-title">Featured Books</h2>

                <% if (featuredBooks.length == 0) { %>
                    <div class="text-center py-5">
                        <i class="fas fa-exclamation-circle fa-3x mb-3" style="color: var(--text-secondary);"></i>
                        <h4>No Featured Books</h4>
                        <p class="text-muted">Our staff hasn't featured any books yet. Check back soon!</p>
                    </div>
                <% } else { %>
                    <div class="row row-cols-1 row-cols-md-2 row-cols-lg-5 g-4">
                        <% for (Book book : featuredBooks) {
                            // Get cover image URL
                            String coverPath = request.getContextPath() + "/book-covers/" + book.getCoverImagePath();
                            if (book.getCoverImagePath() == null || book.getCoverImagePath().equals("default_cover.jpg")) {
                                coverPath = request.getContextPath() + "/book-covers/default_cover.jpg";
                            }
                        %>
                            <div class="col">
                                <div class="card h-100">
                                    <img src="<%= coverPath %>" class="book-cover" alt="<%= book.getTitle() %>">
                                    <div class="card-body">
                                        <h5 class="card-title"><%= book.getTitle() %></h5>
                                        <p class="card-text text-muted">by <%= book.getAuthor() %></p>

                                        <!-- Rating Stars -->
                                        <div class="rating mb-2">
                                            <%
                                                double rating = book.getAverageRating();
                                                for (int j = 1; j <= 5; j++) {
                                                    if (j <= rating) {
                                            %>
                                                <i class="fas fa-star"></i>
                                            <% } else if (j - 0.5 <= rating) { %>
                                                <i class="fas fa-star-half-alt"></i>
                                            <% } else { %>
                                                <i class="far fa-star"></i>
                                            <% } } %>
                                            <span class="ms-1"><%= String.format("%.1f", rating) %></span>
                                        </div>

                                        <!-- Price Display -->
                                        <div class="d-flex justify-content-between align-items-center">
                                            <div class="price">
                                                $<%= String.format("%.2f", book.getPrice()) %>
                                            </div>

                                            <!-- Book Type -->
                                            <% if (book instanceof EBook) { %>
                                                <span class="badge bg-primary">E-Book</span>
                                            <% } else if (book instanceof PhysicalBook) { %>
                                                <span class="badge bg-accent">Physical</span>
                                            <% } %>
                                        </div>
                                    </div>
                                    <div class="card-footer d-grid">
                                        <a href="<%=request.getContextPath()%>/book-details?id=<%= book.getId() %>" class="btn btn-accent">View Details</a>
                                    </div>
                                </div>
                            </div>
                        <% } %>
                    </div>
                <% } %>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="bg-dark text-light py-4 mt-5">
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
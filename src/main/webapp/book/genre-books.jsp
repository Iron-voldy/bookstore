<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.bookstore.model.book.Book" %>
<%@ page import="com.bookstore.model.book.BookManager" %>
<%@ page import="com.bookstore.util.QuickSort" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <%
        // Get genre parameter
        String genre = request.getParameter("genre");
        if (genre == null || genre.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/books");
            return;
        }

        // Get book manager and fetch books by genre
        BookManager bookManager = new BookManager(application);
        Book[] genreBooks = bookManager.searchByGenre(genre);

        // Sort by average rating (highest first) using QuickSort
        QuickSort.sort(genreBooks, (b1, b2) -> Double.compare(b2.getAverageRating(), b1.getAverageRating()));

        // Get top books (up to 5) for featured section
        int topBooksCount = Math.min(5, genreBooks.length);
        Book[] topBooks = new Book[topBooksCount];
        System.arraycopy(genreBooks, 0, topBooks, 0, topBooksCount);
    %>

    <title><%= genre %> Books - BookVerse</title>
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
            transition: transform 0.3s, box-shadow 0.3s;
            height: 100%;
            overflow: hidden;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
        }

        .hero-section {
            background: linear-gradient(rgba(0, 0, 0, 0.7), rgba(0, 0, 0, 0.7)), url('https://source.unsplash.com/random/1200x400/?<%= genre.toLowerCase() %>-books') no-repeat center center/cover;
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

        .book-cover {
            height: 250px;
            object-fit: cover;
            border-bottom: 1px solid var(--border-color);
        }

        .featured-book-cover {
            height: 400px;
            object-fit: cover;
            border-radius: 8px;
        }

        .rating i {
            color: gold;
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

        .top-book {
            margin-bottom: 30px;
        }

        .top-book-meta {
            display: flex;
            align-items: center;
            margin: 10px 0;
        }

        .top-book-meta .author {
            margin-right: 20px;
        }

        .book-description {
            margin: 15px 0;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .all-books-grid {
            margin-top: 60px;
        }

        .genre-tag {
            display: inline-block;
            padding: 5px 10px;
            margin: 3px;
            background-color: rgba(138, 92, 245, 0.2);
            border: 1px solid var(--accent-color);
            border-radius: 20px;
            font-size: 0.8rem;
            text-decoration: none;
            color: var(--text-primary);
            transition: all 0.3s;
        }

        .genre-tag:hover {
            background-color: var(--accent-color);
            color: white;
        }

        .no-books-message {
            text-align: center;
            padding: 50px 0;
        }
    </style>
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
                        <a class="nav-link" href="<%=request.getContextPath()%>/">Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="<%=request.getContextPath()%>/books">Books</a>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            Categories
                        </a>
                        <ul class="dropdown-menu dropdown-menu-dark" aria-labelledby="navbarDropdown">
                            <%
                                // Get all genres for dropdown
                                String[] allGenres = new String[0];
                                for (Book book : bookManager.getAllBooks()) {
                                    if (book.getGenre() != null && !book.getGenre().isEmpty()) {
                                        boolean exists = false;
                                        for (String existingGenre : allGenres) {
                                            if (existingGenre.equals(book.getGenre())) {
                                                exists = true;
                                                break;
                                            }
                                        }
                                        if (!exists) {
                                            String[] newGenres = new String[allGenres.length + 1];
                                            System.arraycopy(allGenres, 0, newGenres, 0, allGenres.length);
                                            newGenres[allGenres.length] = book.getGenre();
                                            allGenres = newGenres;
                                        }
                                    }
                                }

                                // Add menu items for each genre
                                for (String g : allGenres) {
                            %>
                                <li><a class="dropdown-item <%= g.equals(genre) ? "active" : "" %>" href="<%=request.getContextPath()%>/genre?genre=<%= g %>"><%= g %></a></li>
                            <% } %>
                        </ul>
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
            <h1 class="hero-title"><%= genre %> Books</h1>
            <p class="hero-description">Explore our collection of the best <%= genre %> books available. From classics to new releases, find your next favorite read!</p>
        </div>
    </section>

    <!-- Main Content -->
    <div class="container">
        <% if (genreBooks.length == 0) { %>
            <!-- No Books Message -->
            <div class="no-books-message">
                <i class="fas fa-book-open fa-4x mb-3" style="color: var(--border-color);"></i>
                <h3>No books found in the <%= genre %> category</h3>
                <p class="text-muted">Please check back later or explore other categories.</p>
                <a href="<%=request.getContextPath()%>/books" class="btn btn-accent mt-3">Browse All Books</a>
            </div>
        <% } else { %>
            <!-- Top Books Section -->
            <section class="top-books-section">
                <h2 class="section-title">Top <%= genre %> Books</h2>

                <% if (topBooks.length > 0) {
                    // Display the first book as featured
                    Book featuredBook = topBooks[0];
                    String featuredCoverPath = request.getContextPath() + "/book-covers/" + featuredBook.getCoverImagePath();
                    if (featuredBook.getCoverImagePath() == null || featuredBook.getCoverImagePath().equals("default_cover.jpg")) {
                        featuredCoverPath = request.getContextPath() + "/book-covers/default_cover.jpg";
                    }
                %>
                    <!-- Featured Book -->
                    <div class="row featured-book">
                        <div class="col-md-4 mb-4">
                            <img src="<%= featuredCoverPath %>" alt="<%= featuredBook.getTitle() %>" class="img-fluid featured-book-cover">
                        </div>
                        <div class="col-md-8">
                            <h3><%= featuredBook.getTitle() %></h3>
                            <div class="top-book-meta">
                                <div class="author">
                                    <i class="fas fa-user me-2"></i> <%= featuredBook.getAuthor() %>
                                </div>
                                <div class="rating">
                                    <%
                                        double rating = featuredBook.getAverageRating();
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
                                    <span class="text-muted">(<%= featuredBook.getNumberOfRatings() %> reviews)</span>
                                </div>
                            </div>
                            <p class="book-description">
                                <%= featuredBook.getDescription() != null ? featuredBook.getDescription() : "No description available." %>
                            </p>
                            <div class="price mb-3">
                                $<%= String.format("%.2f", featuredBook.getPrice()) %>
                            </div>
                            <div class="d-grid gap-2 d-md-block">
                                <a href="<%=request.getContextPath()%>/book-details?id=<%= featuredBook.getId() %>" class="btn btn-accent me-md-2">
                                    <i class="fas fa-info-circle me-2"></i> View Details
                                </a>
                                <a href="<%=request.getContextPath()%>/add-to-cart?bookId=<%= featuredBook.getId() %>&quantity=1" class="btn btn-outline-light">
                                    <i class="fas fa-cart-plus me-2"></i> Add to Cart
                                </a>
                            </div>
                        </div>
                    </div>
                <% } %>

                <!-- Other Top Books -->
                <% if (topBooks.length > 1) { %>
                    <div class="row">
                        <%
                            // Skip the first book (already featured) and show the rest
                            for (int i = 1; i < topBooks.length; i++) {
                                Book book = topBooks[i];
                                String coverPath = request.getContextPath() + "/book-covers/" + book.getCoverImagePath();
                                if (book.getCoverImagePath() == null || book.getCoverImagePath().equals("default_cover.jpg")) {
                                    coverPath = request.getContextPath() + "/book-covers/default_cover.jpg";
                                }
                        %>
                            <div class="col-md-6 top-book">
                                <div class="card h-100">
                                    <div class="row g-0">
                                        <div class="col-4">
                                            <img src="<%= coverPath %>" class="img-fluid rounded-start h-100" style="object-fit: cover;" alt="<%= book.getTitle() %>">
                                        </div>
                                        <div class="col-8">
                                            <div class="card-body d-flex flex-column h-100">
                                                <h5 class="card-title"><%= book.getTitle() %></h5>
                                                <p class="card-text text-muted">by <%= book.getAuthor() %></p>
                                                <!-- Rating -->
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
                                                <!-- Price -->
                                                <div class="price mt-auto mb-2">
                                                    $<%= String.format("%.2f", book.getPrice()) %>
                                                </div>
                                                <a href="<%=request.getContextPath()%>/book-details?id=<%= book.getId() %>" class="btn btn-sm btn-accent">View Details</a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        <% } %>
                    </div>
                <% } %>
            </section>

            <!-- All Books in this Genre -->
            <section class="all-books-grid">
                <h2 class="section-title">All <%= genre %> Books</h2>
                <div class="row row-cols-1 row-cols-md-2 row-cols-lg-4 g-4">
                    <% for (Book book : genreBooks) {
                        String coverPath = request.getContextPath() + "/book-covers/" + book.getCoverImagePath();
                        if (book.getCoverImagePath() == null || book.getCoverImagePath().equals("default_cover.jpg")) {
                            coverPath = request.getContextPath() + "/book-covers/default_cover.jpg";
                        }
                    %>
                        <div class="col">
                            <div class="card h-100">
                                <img src="<%= coverPath %>" class="card-img-top book-cover" alt="<%= book.getTitle() %>">
                                <div class="card-body">
                                    <h5 class="card-title"><%= book.getTitle() %></h5>
                                    <p class="card-text text-muted">by <%= book.getAuthor() %></p>

                                    <!-- Rating Stars -->
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
                                        <span class="ms-1"><%= String.format("%.1f", rating) %></span>
                                    </div>

                                    <!-- Price Display -->
                                    <div class="price">
                                        $<%= String.format("%.2f", book.getPrice()) %>
                                    </div>
                                </div>
                                <div class="card-footer d-grid">
                                    <a href="<%=request.getContextPath()%>/book-details?id=<%= book.getId() %>" class="btn btn-accent">View Details</a>
                                </div>
                            </div>
                        </div>
                    <% } %>
                </div>
            </section>

            <!-- Related Genres -->
            <section class="related-genres mt-5">
                <h4>Related Genres</h4>
                <div class="mb-4">
                    <%
                        // Display some related genres (demonstration - in a real app, you'd have related genres data)
                        String[] relatedGenres = {"Fiction", "Thriller", "Mystery", "Romance", "Science Fiction", "Biography", "History", "Fantasy"};
                        for (String relatedGenre : relatedGenres) {
                            if (!relatedGenre.equals(genre)) {
                    %>
                        <a href="<%=request.getContextPath()%>/genre?genre=<%= relatedGenre %>" class="genre-tag"><%= relatedGenre %></a>
                    <%
                            }
                        }
                    %>
                </div>
            </section>
        <% } %>
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
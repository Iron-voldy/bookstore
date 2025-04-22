<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="com.bookstore.model.book.Book" %>
<%@ page import="com.bookstore.model.book.BookManager" %>
<%@ page import="com.bookstore.model.book.EBook" %>
<%@ page import="com.bookstore.model.book.PhysicalBook" %>
<%@ page import="com.bookstore.util.QuickSort" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="java.util.Comparator" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Catalog - BookVerse</title>
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

        .card-title {
            color: var(--text-primary);
            font-weight: 600;
        }

        .card-text {
            color: var(--text-secondary);
        }

        .book-cover {
            height: 250px;
            object-fit: cover;
            border-bottom: 1px solid var(--border-color);
        }

        .book-type-badge {
            position: absolute;
            top: 10px;
            right: 10px;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 0.8rem;
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

        .filters-card {
            background-color: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            position: sticky;
            top: 20px;
        }

        .form-control, .form-select {
            background-color: var(--secondary-dark);
            border: 1px solid var(--border-color);
            color: var(--text-primary);
        }

        .form-control:focus, .form-select:focus {
            background-color: var(--secondary-dark);
            color: var(--text-primary);
            border-color: var(--accent-color);
        }

        .genre-tag {
            display: inline-block;
            padding: 5px 10px;
            margin: 3px;
            background-color: rgba(138, 92, 245, 0.2);
            border: 1px solid var(--accent-color);
            border-radius: 20px;
            font-size: 0.8rem;
            cursor: pointer;
            transition: all 0.3s;
        }

        .genre-tag:hover {
            background-color: var(--accent-color);
            color: white;
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

        .pagination-container {
            display: flex;
            justify-content: center;
            margin-top: 20px;
        }

        .page-link {
            background-color: var(--secondary-dark);
            border-color: var(--border-color);
            color: var(--text-primary);
        }

        .page-item.active .page-link {
            background-color: var(--accent-color);
            border-color: var(--accent-color);
        }

        .no-results {
            text-align: center;
            padding: 50px 0;
        }
    </style>
</head>
<body>
    <%
        // Get books from BookManager
        BookManager bookManager = new BookManager(application);
        Book[] allBooks = bookManager.getAllBooks();

        // Get filter parameters
        String searchQuery = request.getParameter("search");
        String genreFilter = request.getParameter("genre");
        String typeFilter = request.getParameter("type");
        String sortBy = request.getParameter("sort");
        String minPriceStr = request.getParameter("minPrice");
        String maxPriceStr = request.getParameter("maxPrice");

        // Default sorting is by title
        if (sortBy == null || sortBy.isEmpty()) {
            sortBy = "titleAsc";
        }

        // Filter books based on search query
        Book[] filteredBooks = allBooks;

        // Apply search filter if provided
        if (searchQuery != null && !searchQuery.isEmpty()) {
            Book[] titleResults = bookManager.searchByTitle(searchQuery);
            Book[] authorResults = bookManager.searchByAuthor(searchQuery);

            // Combine results
            java.util.Map<String, Book> resultMap = new java.util.HashMap<>();
            for (Book book : titleResults) {
                resultMap.put(book.getId(), book);
            }
            for (Book book : authorResults) {
                resultMap.put(book.getId(), book);
            }

            filteredBooks = resultMap.values().toArray(new Book[0]);
        }

        // Apply genre filter
        if (genreFilter != null && !genreFilter.isEmpty()) {
            java.util.List<Book> genreFiltered = new java.util.ArrayList<>();
            for (Book book : filteredBooks) {
                if (book.getGenre() != null && book.getGenre().equalsIgnoreCase(genreFilter)) {
                    genreFiltered.add(book);
                }
            }
            filteredBooks = genreFiltered.toArray(new Book[0]);
        }

        // Apply type filter
        if (typeFilter != null && !typeFilter.isEmpty()) {
            java.util.List<Book> typeFiltered = new java.util.ArrayList<>();
            for (Book book : filteredBooks) {
                if (typeFilter.equals("ebook") && book instanceof EBook) {
                    typeFiltered.add(book);
                } else if (typeFilter.equals("physical") && book instanceof PhysicalBook) {
                    typeFiltered.add(book);
                }
            }
            filteredBooks = typeFiltered.toArray(new Book[0]);
        }

        // Apply price filter
        double minPrice = 0;
        double maxPrice = Double.MAX_VALUE;

        if (minPriceStr != null && !minPriceStr.isEmpty()) {
            try {
                minPrice = Double.parseDouble(minPriceStr);
            } catch (NumberFormatException e) {
                // Use default
            }
        }

        if (maxPriceStr != null && !maxPriceStr.isEmpty()) {
            try {
                maxPrice = Double.parseDouble(maxPriceStr);
            } catch (NumberFormatException e) {
                // Use default
            }
        }

        if (minPrice > 0 || maxPrice < Double.MAX_VALUE) {
            java.util.List<Book> priceFiltered = new java.util.ArrayList<>();
            for (Book book : filteredBooks) {
                double price = book.getPrice();
                if (price >= minPrice && price <= maxPrice) {
                    priceFiltered.add(book);
                }
            }
            filteredBooks = priceFiltered.toArray(new Book[0]);
        }

        // Sort books using QuickSort
        Comparator<Book> comparator = null;

        switch (sortBy) {
            case "titleAsc":
                comparator = (b1, b2) -> b1.getTitle().compareToIgnoreCase(b2.getTitle());
                break;
            case "titleDesc":
                comparator = (b1, b2) -> b2.getTitle().compareToIgnoreCase(b1.getTitle());
                break;
            case "priceAsc":
                comparator = (b1, b2) -> Double.compare(b1.getPrice(), b2.getPrice());
                break;
            case "priceDesc":
                comparator = (b1, b2) -> Double.compare(b2.getPrice(), b1.getPrice());
                break;
            case "ratingDesc":
                comparator = (b1, b2) -> Double.compare(b2.getAverageRating(), b1.getAverageRating());
                break;
            case "newest":
                comparator = (b1, b2) -> b2.getAddedDate().compareTo(b1.getAddedDate());
                break;
            default:
                comparator = (b1, b2) -> b1.getTitle().compareToIgnoreCase(b2.getTitle());
        }

        QuickSort.sort(filteredBooks, comparator);

        // Collect all genres for the filter sidebar
        java.util.Set<String> genres = new java.util.TreeSet<>();
        for (Book book : allBooks) {
            if (book.getGenre() != null && !book.getGenre().isEmpty()) {
                genres.add(book.getGenre());
            }
        }

        // Pagination
        int booksPerPage = 12;
        int totalBooks = filteredBooks.length;
        int totalPages = (int) Math.ceil((double) totalBooks / booksPerPage);

        int currentPage = 1;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                currentPage = Integer.parseInt(pageStr);
                if (currentPage < 1) currentPage = 1;
                if (currentPage > totalPages) currentPage = totalPages;
            } catch (NumberFormatException e) {
                // Use default
            }
        }

        // Calculate start and end indices for current page
        int startIndex = (currentPage - 1) * booksPerPage;
        int endIndex = Math.min(startIndex + booksPerPage, totalBooks);

        // Get books for current page
        Book[] currentPageBooks = new Book[0];
        if (totalBooks > 0) {
            currentPageBooks = Arrays.copyOfRange(filteredBooks, startIndex, endIndex);
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
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            Categories
                        </a>
                        <ul class="dropdown-menu dropdown-menu-dark" aria-labelledby="navbarDropdown">
                            <% for (String genre : genres) { %>
                                <li><a class="dropdown-item" href="<%=request.getContextPath()%>/books?genre=<%= genre %>"><%= genre %></a></li>
                            <% } %>
                        </ul>
                    </li>
                </ul>

                <!-- Search Form -->
                <form class="d-flex me-3" action="<%=request.getContextPath()%>/books" method="get">
                    <div class="input-group">
                        <input class="form-control" type="search" name="search" placeholder="Search books..." value="<%= searchQuery != null ? searchQuery : "" %>">
                        <button class="btn btn-outline-light" type="submit">
                            <i class="fas fa-search"></i>
                        </button>
                    </div>
                </form>

                <!-- User Menu - could be replaced with session-based user check -->
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

    <!-- Main Content -->
    <div class="container my-5">
        <!-- Page Title -->
        <h1 class="mb-4">
            <% if (genreFilter != null && !genreFilter.isEmpty()) { %>
                <%= genreFilter %> Books
            <% } else if (typeFilter != null && !typeFilter.isEmpty()) { %>
                <%= typeFilter.equals("ebook") ? "E-Books" : "Physical Books" %>
            <% } else if (searchQuery != null && !searchQuery.isEmpty()) { %>
                Search Results for "<%= searchQuery %>"
            <% } else { %>
                All Books
            <% } %>
        </h1>

        <div class="row">
            <!-- Filters Sidebar -->
            <div class="col-md-3 mb-4">
                <div class="filters-card p-3">
                    <h5 class="mb-3">Filters</h5>

                    <form action="<%=request.getContextPath()%>/books" method="get" id="filterForm">
                        <!-- Preserve search query if present -->
                        <% if (searchQuery != null && !searchQuery.isEmpty()) { %>
                            <input type="hidden" name="search" value="<%= searchQuery %>">
                        <% } %>

                        <!-- Book Type Filter -->
                        <div class="mb-3">
                            <label class="form-label">Book Type</label>
                            <select class="form-select form-select-sm" name="type" onchange="this.form.submit()">
                                <option value="" <%= typeFilter == null || typeFilter.isEmpty() ? "selected" : "" %>>All Types</option>
                                <option value="physical" <%= "physical".equals(typeFilter) ? "selected" : "" %>>Physical Books</option>
                                <option value="ebook" <%= "ebook".equals(typeFilter) ? "selected" : "" %>>E-Books</option>
                            </select>
                        </div>

                        <!-- Genre Filter -->
                        <div class="mb-3">
                            <label class="form-label">Genre</label>
                            <select class="form-select form-select-sm" name="genre" onchange="this.form.submit()">
                                <option value="" <%= genreFilter == null || genreFilter.isEmpty() ? "selected" : "" %>>All Genres</option>
                                <% for (String genre : genres) { %>
                                    <option value="<%= genre %>" <%= genre.equals(genreFilter) ? "selected" : "" %>><%= genre %></option>
                                <% } %>
                            </select>
                        </div>

                        <!-- Price Range Filter -->
                        <div class="mb-3">
                            <label class="form-label">Price Range</label>
                            <div class="row g-2">
                                <div class="col-6">
                                    <div class="input-group input-group-sm">
                                        <span class="input-group-text">$</span>
                                        <input type="number" class="form-control form-control-sm" name="minPrice" placeholder="Min" value="<%= minPriceStr != null ? minPriceStr : "" %>" min="0" step="0.01">
                                    </div>
                                </div>
                                <div class="col-6">
                                    <div class="input-group input-group-sm">
                                        <span class="input-group-text">$</span>
                                        <input type="number" class="form-control form-control-sm" name="maxPrice" placeholder="Max" value="<%= maxPriceStr != null ? maxPriceStr : "" %>" min="0" step="0.01">
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Sort Options -->
                        <div class="mb-3">
                            <label class="form-label">Sort By</label>
                            <select class="form-select form-select-sm" name="sort" onchange="this.form.submit()">
                                <option value="titleAsc" <%= "titleAsc".equals(sortBy) ? "selected" : "" %>>Title (A-Z)</option>
                                <option value="titleDesc" <%= "titleDesc".equals(sortBy) ? "selected" : "" %>>Title (Z-A)</option>
                                <option value="priceAsc" <%= "priceAsc".equals(sortBy) ? "selected" : "" %>>Price (Low to High)</option>
                                <option value="priceDesc" <%= "priceDesc".equals(sortBy) ? "selected" : "" %>>Price (High to Low)</option>
                                <option value="ratingDesc" <%= "ratingDesc".equals(sortBy) ? "selected" : "" %>>Highest Rated</option>
                                <option value="newest" <%= "newest".equals(sortBy) ? "selected" : "" %>>Newest Arrivals</option>
                            </select>
                        </div>

                        <button type="submit" class="btn btn-accent btn-sm w-100">Apply Filters</button>
                        <a href="<%=request.getContextPath()%>/books" class="btn btn-outline-light btn-sm w-100 mt-2">Reset Filters</a>
                    </form>

                    <!-- Popular Genres Quick Links -->
                    <div class="mt-4">
                        <h6>Popular Genres</h6>
                        <div>
                            <%
                                // Display up to 8 genres as quick links
                                int genreCount = 0;
                                for (String genre : genres) {
                                    if (genreCount++ < 8) {
                            %>
                                <a href="<%=request.getContextPath()%>/books?genre=<%= genre %>" class="genre-tag"><%= genre %></a>
                            <%
                                    }
                                }
                            %>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Books Grid -->
            <div class="col-md-9">
                <% if (currentPageBooks.length == 0) { %>
                    <!-- No Results Message -->
                    <div class="no-results">
                        <i class="fas fa-search fa-4x mb-3" style="color: var(--border-color);"></i>
                        <h4>No books found</h4>
                        <p class="text-muted">Try adjusting your search or filter to find what you're looking for.</p>
                        <a href="<%=request.getContextPath()%>/books" class="btn btn-accent mt-2">View All Books</a>
                    </div>
                <% } else { %>
                    <!-- Books Grid -->
                    <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
                        <% for (Book book : currentPageBooks) {
                            // Determine book type for badge
                            String badgeClass = "";
                            String badgeText = "";

                            if (book instanceof EBook) {
                                badgeClass = "ebook-badge";
                                badgeText = "E-Book";
                            } else if (book instanceof PhysicalBook) {
                                badgeClass = "physical-badge";
                                badgeText = "Physical";
                            }

                            // Get cover image URL
                            String coverPath = request.getContextPath() + "/book-covers/" + book.getCoverImagePath();
                            if (book.getCoverImagePath() == null || book.getCoverImagePath().equals("default_cover.jpg")) {
                                coverPath = request.getContextPath() + "/book-covers/default_cover.jpg";
                            }
                        %>
                            <div class="col">
                                <div class="card h-100">
                                    <% if (!badgeText.isEmpty()) { %>
                                        <span class="book-type-badge <%= badgeClass %>"><%= badgeText %></span>
                                    <% } %>
                                    <img src="<%= coverPath %>" class="book-cover" alt="<%= book.getTitle() %>">
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
                                        <div class="d-flex justify-content-between align-items-center">
                                            <div>
                                                <% if (book instanceof EBook || book instanceof PhysicalBook) {
                                                    double discountedPrice = book.getDiscountedPrice();
                                                    if (discountedPrice < book.getPrice()) {
                                                %>
                                                    <span class="old-price me-2">$<%= String.format("%.2f", book.getPrice()) %></span>
                                                    <span class="price">$<%= String.format("%.2f", discountedPrice) %></span>
                                                <% } else { %>
                                                    <span class="price">$<%= String.format("%.2f", book.getPrice()) %></span>
                                                <% } } else { %>
                                                    <span class="price">$<%= String.format("%.2f", book.getPrice()) %></span>
                                                <% } %>
                                            </div>

                                            <!-- Availability Badge -->
                                            <% if (book instanceof EBook) { %>
                                                <span class="badge bg-success">Available</span>
                                            <% } else { %>
                                                <% if (book.getQuantity() > 0) { %>
                                                    <span class="badge bg-success">In Stock</span>
                                                <% } else { %>
                                                    <span class="badge bg-danger">Out of Stock</span>
                                                <% } %>
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

                    <!-- Pagination -->
                    <% if (totalPages > 1) { %>
                        <div class="pagination-container">
                            <nav aria-label="Page navigation">
                                <ul class="pagination">
                                    <!-- Previous Button -->
                                    <li class="page-item <%= (currentPage == 1) ? "disabled" : "" %>">
                                        <a class="page-link" href="<%=request.getContextPath()%>/books?page=<%= currentPage-1
                                            %><%= searchQuery != null ? "&search="+searchQuery : ""
                                            %><%= genreFilter != null ? "&genre="+genreFilter : ""
                                            %><%= typeFilter != null ? "&type="+typeFilter : ""
                                            %><%= sortBy != null ? "&sort="+sortBy : ""
                                            %><%= minPriceStr != null ? "&minPrice="+minPriceStr : ""
                                            %><%= maxPriceStr != null ? "&maxPrice="+maxPriceStr : ""
                                            %>" aria-label="Previous">
                                            <span aria-hidden="true">&laquo;</span>
                                        </a>
                                    </li>

                                    <!-- Page Numbers -->
                                    <%
                                        // Show max 5 page links
                                        int startPage = Math.max(1, currentPage - 2);
                                        int endPage = Math.min(totalPages, startPage + 4);

                                        if (endPage - startPage < 4 && startPage > 1) {
                                            startPage = Math.max(1, endPage - 4);
                                        }

                                        for (int i = startPage; i <= endPage; i++) {
                                    %>
                                        <li class="page-item <%= (i == currentPage) ? "active" : "" %>">
                                            <a class="page-link" href="<%=request.getContextPath()%>/books?page=<%= i
                                                %><%= searchQuery != null ? "&search="+searchQuery : ""
                                                %><%= genreFilter != null ? "&genre="+genreFilter : ""
                                                %><%= typeFilter != null ? "&type="+typeFilter : ""
                                                %><%= sortBy != null ? "&sort="+sortBy : ""
                                                %><%= minPriceStr != null ? "&minPrice="+minPriceStr : ""
                                                %><%= maxPriceStr != null ? "&maxPrice="+maxPriceStr : ""
                                                %>"><%= i %></a>
                                        </li>
                                    <% } %>

                                    <!-- Next Button -->
                                    <li class="page-item <%= (currentPage == totalPages) ? "disabled" : "" %>">
                                        <a class="page-link" href="<%=request.getContextPath()%>/books?page=<%= currentPage+1
                                            %><%= searchQuery != null ? "&search="+searchQuery : ""
                                            %><%= genreFilter != null ? "&genre="+genreFilter : ""
                                            %><%= typeFilter != null ? "&type="+typeFilter : ""
                                            %><%= sortBy != null ? "&sort="+sortBy : ""
                                            %><%= minPriceStr != null ? "&minPrice="+minPriceStr : ""
                                            %><%= maxPriceStr != null ? "&maxPrice="+maxPriceStr : ""
                                            %>" aria-label="Next">
                                            <span aria-hidden="true">&raquo;</span>
                                        </a>
                                    </li>
                                </ul>
                            </nav>
                        </div>
                    <% } %>
                <% } %>
            </div>
        </div>
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
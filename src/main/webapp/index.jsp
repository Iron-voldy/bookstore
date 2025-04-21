<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BookVerse - Online Bookstore</title>
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
            margin: 0;
            padding: 0;
            min-height: 100vh;
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

        .hero-section {
            background: linear-gradient(rgba(0, 0, 0, 0.7), rgba(0, 0, 0, 0.7)), url('https://images.unsplash.com/photo-1507842217343-583bb7270b66?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80') no-repeat center center/cover;
            height: 550px;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            color: white;
            padding: 0 20px;
        }

        .hero-content h1 {
            font-size: 3.5rem;
            margin-bottom: 20px;
            font-weight: 700;
        }

        .hero-content p {
            font-size: 1.2rem;
            margin-bottom: 30px;
            max-width: 700px;
            margin-left: auto;
            margin-right: auto;
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
            margin-bottom: 20px;
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

        .badge-accent {
            background-color: var(--accent-color);
            color: white;
        }

        .section-title {
            font-weight: 700;
            margin-bottom: 40px;
            text-align: center;
            position: relative;
            padding-bottom: 15px;
        }

        .section-title:after {
            content: '';
            position: absolute;
            width: 100px;
            height: 3px;
            background-color: var(--accent-color);
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
        }

        .book-card {
            height: 100%;
        }

        .book-card .card-img-top {
            height: 300px;
            object-fit: cover;
        }

        .rating i {
            color: gold;
        }

        .price {
            font-weight: bold;
            font-size: 1.2rem;
            color: var(--accent-color);
        }

        footer {
            background-color: var(--secondary-dark);
            color: var(--text-secondary);
            padding: 50px 0 30px;
            margin-top: 50px;
        }

        .social-icons a {
            color: var(--text-primary);
            font-size: 1.5rem;
            margin: 0 10px;
            transition: color 0.3s;
        }

        .social-icons a:hover {
            color: var(--accent-color);
        }

        .footer-links a {
            color: var(--text-secondary);
            text-decoration: none;
            transition: color 0.3s;
        }

        .footer-links a:hover {
            color: var(--accent-color);
            text-decoration: underline;
        }

        .alert-custom {
            background-color: var(--secondary-dark);
            color: var(--text-primary);
            border: 1px solid var(--border-color);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .alert-success {
            border-left: 4px solid var(--success-color);
        }

        .alert-danger {
            border-left: 4px solid var(--danger-color);
        }

        .alert-warning {
            border-left: 4px solid var(--warning-color);
        }
    </style>
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark sticky-top">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/">
                <i class="fas fa-book-open me-2"></i>BookVerse
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/">Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/search-book">Books</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/view-recommendations">Recommendations</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#contact">Contact</a>
                    </li>
                </ul>

                <!-- Search Form -->
                <form class="d-flex mx-auto" action="${pageContext.request.contextPath}/search-book" method="get">
                    <div class="input-group">
                        <input class="form-control" type="search" name="searchQuery" placeholder="Search books..." aria-label="Search" style="background-color: var(--secondary-dark); color: var(--text-primary); border-color: var(--border-color);">
                        <button class="btn btn-outline-light" type="submit">
                            <i class="fas fa-search"></i>
                        </button>
                    </div>
                </form>

                <!-- User Menu -->
                <ul class="navbar-nav ms-auto">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/view-cart">
                                    <i class="fas fa-shopping-cart"></i> Cart
                                    <span class="badge rounded-pill badge-accent">
                                        ${sessionScope.cartCount != null ? sessionScope.cartCount : 0}
                                    </span>
                                </a>
                            </li>
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                    <i class="fas fa-user-circle me-1"></i> ${sessionScope.username}
                                </a>
                                <ul class="dropdown-menu dropdown-menu-dark" aria-labelledby="navbarDropdown">
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/update-profile">My Profile</a></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/order-history">My Orders</a></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/user-reviews">My Reviews</a></li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Logout</a></li>
                                </ul>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <!-- Just use the absolute path -->
                            <li class="nav-item">
                                <a class="nav-link" href="/onlinebookstore/user/login.jsp">Login</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="/onlinebookstore/user/register.jsp">Register</a>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Flash Messages -->
    <c:if test="${not empty sessionScope.successMessage}">
        <div class="container mt-3">
            <div class="alert alert-custom alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i> ${sessionScope.successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </div>
        <c:remove var="successMessage" scope="session" />
    </c:if>

    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="container mt-3">
            <div class="alert alert-custom alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i> ${sessionScope.errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </div>
        <c:remove var="errorMessage" scope="session" />
    </c:if>

    <!-- Hero Section -->
    <section class="hero-section">
        <div class="hero-content">
            <h1>Discover Your Next Favorite Book</h1>
            <p>Explore our vast collection of books from bestsellers to classics. Find your perfect read and get it delivered to your doorstep.</p>
            <a href="${pageContext.request.contextPath}/search-book" class="btn btn-accent btn-lg">
                <i class="fas fa-book me-2"></i> Browse Books
            </a>
        </div>
    </section>

    <!-- Featured Books Section -->
    <section class="py-5">
        <div class="container">
            <h2 class="section-title">Featured Books</h2>
            <div class="row">
                <!-- Featured Book 1 -->
                <div class="col-md-4 mb-4">
                    <div class="card book-card">
                        <img src="https://images.unsplash.com/photo-1544947950-fa07a98d237f?ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80" class="card-img-top" alt="Book Cover">
                        <div class="card-body">
                            <h5 class="card-title">The Silent Patient</h5>
                            <p class="text-muted">Alex Michaelides</p>
                            <div class="rating mb-2">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star-half-alt"></i>
                                <span class="ms-1">4.5</span>
                            </div>
                            <p class="card-text">A psychological thriller about a woman's act of violence against her husband and her subsequent silence.</p>
                            <div class="d-flex justify-content-between align-items-center mt-3">
                                <span class="price">$14.99</span>
                                <button class="btn btn-sm btn-accent">
                                    <i class="fas fa-shopping-cart me-1"></i> Add to Cart
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Featured Book 2 -->
                <div class="col-md-4 mb-4">
                    <div class="card book-card">
                        <img src="https://images.unsplash.com/photo-1541963463532-d68292c34b19?ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80" class="card-img-top" alt="Book Cover">
                        <div class="card-body">
                            <h5 class="card-title">Educated</h5>
                            <p class="text-muted">Tara Westover</p>
                            <div class="rating mb-2">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <span class="ms-1">4.9</span>
                            </div>
                            <p class="card-text">A memoir about a young girl who, kept out of school, leaves her survivalist family and goes on to earn a PhD.</p>
                            <div class="d-flex justify-content-between align-items-center mt-3">
                                <span class="price">$12.99</span>
                                <button class="btn btn-sm btn-accent">
                                    <i class="fas fa-shopping-cart me-1"></i> Add to Cart
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Featured Book 3 -->
                <div class="col-md-4 mb-4">
                    <div class="card book-card">
                        <img src="https://images.unsplash.com/photo-1497633762265-9d179a990aa6?ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80" class="card-img-top" alt="Book Cover">
                        <div class="card-body">
                            <h5 class="card-title">Where the Crawdads Sing</h5>
                            <p class="text-muted">Delia Owens</p>
                            <div class="rating mb-2">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="far fa-star"></i>
                                <span class="ms-1">4.0</span>
                            </div>
                            <p class="card-text">A novel about an abandoned girl who raised herself in the marshes of North Carolina.</p>
                            <div class="d-flex justify-content-between align-items-center mt-3">
                                <span class="price">$15.99</span>
                                <button class="btn btn-sm btn-accent">
                                    <i class="fas fa-shopping-cart me-1"></i> Add to Cart
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Categories Section -->
    <section class="py-5" style="background-color: var(--secondary-dark);">
        <div class="container">
            <h2 class="section-title">Browse by Category</h2>
            <div class="row">
                <div class="col-md-3 col-6 mb-4">
                    <div class="card text-center">
                        <div class="card-body">
                            <i class="fas fa-book fa-3x mb-3" style="color: var(--accent-color);"></i>
                            <h5 class="card-title">Fiction</h5>
                            <p class="card-text">Explore worlds of imagination</p>
                            <a href="#" class="btn btn-sm btn-accent">Browse</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-3 col-6 mb-4">
                    <div class="card text-center">
                        <div class="card-body">
                            <i class="fas fa-atom fa-3x mb-3" style="color: var(--accent-color);"></i>
                            <h5 class="card-title">Science</h5>
                            <p class="card-text">Discover the universe</p>
                            <a href="#" class="btn btn-sm btn-accent">Browse</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-3 col-6 mb-4">
                    <div class="card text-center">
                        <div class="card-body">
                            <i class="fas fa-heart fa-3x mb-3" style="color: var(--accent-color);"></i>
                            <h5 class="card-title">Romance</h5>
                            <p class="card-text">Love stories that captivate</p>
                            <a href="#" class="btn btn-sm btn-accent">Browse</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-3 col-6 mb-4">
                    <div class="card text-center">
                        <div class="card-body">
                            <i class="fas fa-laptop-code fa-3x mb-3" style="color: var(--accent-color);"></i>
                            <h5 class="card-title">Technology</h5>
                            <p class="card-text">The future of innovation</p>
                            <a href="#" class="btn btn-sm btn-accent">Browse</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Latest Books Section -->
    <section class="py-5">
        <div class="container">
            <h2 class="section-title">Latest Arrivals</h2>
            <div class="row">
                <!-- Latest Book 1 -->
                <div class="col-md-3 col-6 mb-4">
                    <div class="card book-card h-100">
                        <img src="https://images.unsplash.com/photo-1589998059171-988d887df646?ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80" class="card-img-top" alt="Book Cover">
                        <div class="card-body">
                            <h5 class="card-title">The Midnight Library</h5>
                            <p class="text-muted">Matt Haig</p>
                            <div class="rating mb-2">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star-half-alt"></i>
                                <span class="ms-1">4.5</span>
                            </div>
                            <span class="badge bg-success mb-2">New</span>
                            <span class="d-block price mt-2">$16.99</span>
                        </div>
                    </div>
                </div>

                <!-- Latest Book 2 -->
                <div class="col-md-3 col-6 mb-4">
                    <div class="card book-card h-100">
                        <img src="https://images.unsplash.com/photo-1544947950-fa07a98d237f?ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80" class="card-img-top" alt="Book Cover">
                        <div class="card-body">
                            <h5 class="card-title">Atomic Habits</h5>
                            <p class="text-muted">James Clear</p>
                            <div class="rating mb-2">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <span class="ms-1">5.0</span>
                            </div>
                            <span class="badge bg-success mb-2">New</span>
                            <span class="d-block price mt-2">$11.99</span>
                        </div>
                    </div>
                </div>

                <!-- Latest Book 3 -->
                <div class="col-md-3 col-6 mb-4">
                    <div class="card book-card h-100">
                        <img src="https://images.unsplash.com/photo-1543002588-bfa74002ed7e?ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80" class="card-img-top" alt="Book Cover">
                        <div class="card-body">
                            <h5 class="card-title">Project Hail Mary</h5>
                            <p class="text-muted">Andy Weir</p>
                            <div class="rating mb-2">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="far fa-star"></i>
                                <span class="ms-1">4.0</span>
                            </div>
                            <span class="badge bg-success mb-2">New</span>
                            <span class="d-block price mt-2">$14.99</span>
                        </div>
                    </div>
                </div>

                <!-- Latest Book 4 -->
                <div class="col-md-3 col-6 mb-4">
                    <div class="card book-card h-100">
                        <img src="https://images.unsplash.com/photo-1512820790803-83ca734da794?ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80" class="card-img-top" alt="Book Cover">
                        <div class="card-body">
                            <h5 class="card-title">The Four Winds</h5>
                            <p class="text-muted">Kristin Hannah</p>
                            <div class="rating mb-2">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star-half-alt"></i>
                                <i class="far fa-star"></i>
                                <span class="ms-1">3.5</span>
                            </div>
                            <span class="badge bg-success mb-2">New</span>
                            <span class="d-block price mt-2">$13.99</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Testimonials Section -->
    <section class="py-5" style="background-color: var(--secondary-dark);">
        <div class="container">
            <h2 class="section-title">What Our Customers Say</h2>
            <div class="row">
                <div class="col-md-4 mb-4">
                    <div class="card">
                        <div class="card-body">
                            <div class="d-flex align-items-center mb-3">
                                <img src="https://randomuser.me/api/portraits/women/32.jpg" class="rounded-circle me-3" width="60" alt="Customer">
                                <div>
                                    <h5 class="card-title mb-0">Sarah Johnson</h5>
                                    <div class="rating">
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                    </div>
                                </div>
                            </div>
                            <p class="card-text">"I've been buying books from BookVerse for over a year now. Their selection is amazing and delivery is always on time. Highly recommend!"</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4 mb-4">
                    <div class="card">
                        <div class="card-body">
                            <div class="d-flex align-items-center mb-3">
                                <img src="https://randomuser.me/api/portraits/men/44.jpg" class="rounded-circle me-3" width="60" alt="Customer">
                                <div>
                                    <h5 class="card-title mb-0">Michael Chen</h5>
                                    <div class="rating">
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star-half-alt"></i>
                                    </div>
                                </div>
                            </div>
                            <p class="card-text">"The recommendation system is spot on! Found so many books I wouldn't have discovered otherwise. Customer service is excellent too."</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4 mb-4">
                    <div class="card">
                        <div class="card-body">
                            <div class="d-flex align-items-center mb-3">
                                <img src="https://randomuser.me/api/portraits/women/68.jpg" class="rounded-circle me-3" width="60" alt="Customer">
                                <div>
                                    <h5 class="card-title mb-0">Emily Rodriguez</h5>
                                    <div class="rating">
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="far fa-star"></i>
                                    </div>
                                </div>
                            </div>
                            <p class="card-text">"As an avid reader, I appreciate the wide range of genres available. The prices are competitive and the regular sales are great!"</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Newsletter Section -->
    <section class="py-5">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-md-8">
                    <div class="card">
                        <div class="card-body text-center py-5">
                            <h3 class="card-title">Subscribe to Our Newsletter</h3>
                            <p class="card-text">Stay updated with our latest book releases, promotions, and literary events.</p>
                            <form class="row g-3 justify-content-center">
                                <div class="col-md-8">
                                    <input type="email" class="form-control" placeholder="Your email address" style="background-color: var(--secondary-dark); color: var(--text-primary); border-color: var(--border-color);">
                                </div>
                                <div class="col-auto">
                                    <button type="submit" class="btn btn-accent">Subscribe</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Contact Section -->
    <section id="contact" class="py-5" style="background-color: var(--secondary-dark);">
        <div class="container">
            <h2 class="section-title">Contact Us</h2>
            <div class="row">
                <div class="col-md-6 mb-4">
                    <div class="card h-100">
                        <div class="card-body">
                            <h3 class="card-title mb-4">Get In Touch</h3>
                            <form>
                                <div class="mb-3">
                                    <label for="name" class="form-label">Name</label>
                                    <input type="text" class="form-control" id="name" placeholder="Your name" style="background-color: var(--card-bg); color: var(--text-primary); border-color: var(--border-color);">
                                </div>
                                <div class="mb-3">
                                    <label for="email" class="form-label">Email</label>
                                    <input type="email" class="form-control" id="email" placeholder="Your email" style="background-color: var(--card-bg); color: var(--text-primary); border-color: var(--border-color);">
                                </div>
                                <div class="mb-3">
                                    <label for="subject" class="form-label">Subject</label>
                                    <input type="text" class="form-control" id="subject" placeholder="Subject" style="background-color: var(--card-bg); color: var(--text-primary); border-color: var(--border-color);">
                                </div>
                                <div class="mb-3">
                                    <label for="message" class="form-label">Message</label>
                                    <textarea class="form-control" id="message" rows="4" placeholder="Your message" style="background-color: var(--card-bg); color: var(--text-primary); border-color: var(--border-color);"></textarea>
                                </div>
                                <button type="submit" class="btn btn-accent">Send Message</button>
                            </form>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 mb-4">
                    <div class="card h-100">
                        <div class="card-body">
                            <h3 class="card-title mb-4">Our Information</h3>
                            <div class="mb-4">
                                <h5><i class="fas fa-map-marker-alt me-2" style="color: var(--accent-color);"></i> Address</h5>
                                <p class="ms-4">123 Book Street, Literary Lane<br>Reading City, RC 10101</p>
                            </div>
                            <div class="mb-4">
                                <h5><i class="fas fa-phone me-2" style="color: var(--accent-color);"></i> Phone</h5>
                                <p class="ms-4">+1 (555) 123-4567</p>
                            </div>
                            <div class="mb-4">
                                <h5><i class="fas fa-envelope me-2" style="color: var(--accent-color);"></i> Email</h5>
                                <p class="ms-4">info@bookverse.com</p>
                            </div>
                            <div class="mb-4">
                                <h5><i class="fas fa-clock me-2" style="color: var(--accent-color);"></i> Business Hours</h5>
                                <p class="ms-4">
                                    Monday - Friday: 9am - 8pm<br>
                                    Saturday: 10am - 6pm<br>
                                    Sunday: Closed
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer>
        <div class="container">
            <div class="row">
                <div class="col-md-4 mb-4">
                    <h5 class="mb-3 text-white">BookVerse</h5>
                    <p>Your one-stop destination for all book needs. From bestsellers to rare finds, we have everything a book lover could desire.</p>
                    <div class="social-icons mt-3">
                        <a href="#"><i class="fab fa-facebook-f"></i></a>
                        <a href="#"><i class="fab fa-twitter"></i></a>
                        <a href="#"><i class="fab fa-instagram"></i></a>
                        <a href="#"><i class="fab fa-pinterest"></i></a>
                    </div>
                </div>
                <div class="col-md-2 mb-4">
                    <h5 class="mb-3 text-white">Quick Links</h5>
                    <ul class="list-unstyled footer-links">
                        <li><a href="${pageContext.request.contextPath}/">Home</a></li>
                        <li><a href="${pageContext.request.contextPath}/search-book">Books</a></li>
                        <li><a href="${pageContext.request.contextPath}/view-recommendations">Recommendations</a></li>
                        <li><a href="#contact">Contact</a></li>
                    </ul>
                </div>
                <div class="col-md-2 mb-4">
                    <h5 class="mb-3 text-white">Categories</h5>
                    <ul class="list-unstyled footer-links">
                        <li><a href="#">Fiction</a></li>
                        <li><a href="#">Non-Fiction</a></li>
                        <li><a href="#">Science</a></li>
                        <li><a href="#">Biography</a></li>
                        <li><a href="#">Technology</a></li>
                        <li><a href="#">Children</a></li>
                    </ul>
                </div>
                <div class="col-md-4 mb-4">
                    <h5 class="mb-3 text-white">Download Our App</h5>
                    <p>Get access to exclusive offers and mobile-only features by downloading our app.</p>
                    <div class="app-links">
                        <a href="#" class="btn btn-outline-light me-2 mb-2"><i class="fab fa-google-play me-2"></i> Google Play</a>
                        <a href="#" class="btn btn-outline-light mb-2"><i class="fab fa-apple me-2"></i> App Store</a>
                    </div>
                </div>
            </div>
            <hr style="border-color: var(--border-color);">
            <div class="row">
                <div class="col-md-6 mb-3">
                    <p class="mb-0">&copy; 2023 BookVerse. All rights reserved.</p>
                </div>
                <div class="col-md-6 text-md-end mb-3">
                    <a href="#" class="me-3 text-light">Privacy Policy</a>
                    <a href="#" class="me-3 text-light">Terms of Service</a>
                    <a href="#" class="text-light">Shipping Policy</a>
                </div>
            </div>
        </div>
    </footer>

    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
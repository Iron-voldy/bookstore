<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.bookstore.model.book.Book" %>
<%@ page import="com.bookstore.model.user.User" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout - BookVerse</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <style>
        body {
            background-color: #121212;
            color: #f5f5f5;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .navbar {
            background-color: #1e1e1e;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.3);
        }
        .navbar-brand {
            font-weight: bold;
            color: #8a5cf5 !important;
        }
        .nav-link {
            color: #f5f5f5 !important;
            margin: 0 10px;
        }
        .nav-link.active {
            color: #8a5cf5 !important;
            font-weight: 500;
        }
        .btn-accent {
            background-color: #8a5cf5;
            color: white;
            border: none;
        }
        .btn-accent:hover {
            background-color: #6e46c9;
        }
        .card {
            background-color: #252525;
            border: 1px solid #333333;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }
        .card-header {
            background-color: #1e1e1e;
            color: #f5f5f5;
            font-weight: 600;
        }
        .table-dark {
            background-color: #252525;
            color: #f5f5f5;
        }
        .table-dark th, .table-dark td {
            border-color: #333333;
        }
        .form-control {
            background-color: #1e1e1e;
            border: 1px solid #333333;
            color: #f5f5f5;
        }
        .form-control:focus {
            background-color: #1e1e1e;
            color: #f5f5f5;
            border-color: #8a5cf5;
        }
        .alert-custom {
            background-color: #1e1e1e;
            color: #f5f5f5;
            border: 1px solid #333333;
        }
        .alert-success {
            border-left: 4px solid #4caf50;
        }
        .alert-danger {
            border-left: 4px solid #d64045;
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
                        <a class="nav-link" href="<%=request.getContextPath()%>/books">Books</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%=request.getContextPath()%>/contact">Contact</a>
                    </li>
                </ul>
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <a class="nav-link active" href="<%=request.getContextPath()%>/cart">
                            <i class="fas fa-shopping-cart"></i>
                            <%
                            Integer cartCount = (Integer)session.getAttribute("cartCount");
                            if (cartCount != null && cartCount > 0) {
                            %>
                            <span class="badge bg-accent rounded-pill"><%=cartCount%></span>
                            <% } %>
                        </a>
                    </li>
                    <%
                    String userId = (String)session.getAttribute("userId");
                    String username = (String)session.getAttribute("username");
                    if (userId != null) {
                    %>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="fas fa-user-circle me-1"></i> <%=username != null ? username : "My Account"%>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end dropdown-menu-dark" aria-labelledby="userDropdown">
                            <li><a class="dropdown-item" href="<%=request.getContextPath()%>/profile">My Profile</a></li>
                            <li><a class="dropdown-item" href="<%=request.getContextPath()%>/order-history">My Orders</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="<%=request.getContextPath()%>/logout">Logout</a></li>
                        </ul>
                    </li>
                    <% } else { %>
                    <li class="nav-item">
                        <a class="nav-link" href="<%=request.getContextPath()%>/login">Login</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%=request.getContextPath()%>/register">Register</a>
                    </li>
                    <% } %>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="container my-5">
        <!-- Flash Messages -->
        <% if (session.getAttribute("successMessage") != null) { %>
        <div class="alert alert-custom alert-success alert-dismissible fade show mb-4" role="alert">
            <i class="fas fa-check-circle me-2"></i> <%=session.getAttribute("successMessage")%>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <% session.removeAttribute("successMessage"); %>
        <% } %>

        <% if (session.getAttribute("errorMessage") != null) { %>
        <div class="alert alert-custom alert-danger alert-dismissible fade show mb-4" role="alert">
            <i class="fas fa-exclamation-circle me-2"></i> <%=session.getAttribute("errorMessage")%>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <% session.removeAttribute("errorMessage"); %>
        <% } %>

        <h2 class="mb-4"><i class="fas fa-shopping-cart me-2"></i>Checkout</h2>

        <!-- Breadcrumb -->
        <nav aria-label="breadcrumb" class="mb-4">
            <ol class="breadcrumb bg-dark p-3 rounded">
                <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/" class="text-light">Home</a></li>
                <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/cart" class="text-light">Cart</a></li>
                <li class="breadcrumb-item active text-white" aria-current="page">Checkout</li>
            </ol>
        </nav>

        <div class="row">
            <!-- Checkout Form -->
            <div class="col-lg-8 mb-4">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">Shipping & Billing Information</h5>
                    </div>
                    <div class="card-body">
                        <form action="<%=request.getContextPath()%>/checkout" method="post" id="checkoutForm">
                            <!-- Contact Information -->
                            <h6 class="mb-3">Contact Information</h6>
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="contactEmail" class="form-label">Email Address*</label>
                                    <%
                                    User user = (User)request.getAttribute("user");
                                    String email = "";
                                    if (user != null && user.getEmail() != null) {
                                        email = user.getEmail();
                                    }
                                    %>
                                    <input type="email" class="form-control" id="contactEmail" name="contactEmail"
                                           value="<%=email%>" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="contactPhone" class="form-label">Phone Number*</label>
                                    <input type="tel" class="form-control" id="contactPhone" name="contactPhone"
                                        placeholder="(123) 456-7890" required>
                                </div>
                            </div>

                            <!-- Shipping Address -->
                            <h6 class="mb-3 mt-4">Shipping Address</h6>
                            <div class="mb-3">
                                <label for="shippingAddress" class="form-label">Full Address*</label>
                                <textarea class="form-control" id="shippingAddress" name="shippingAddress" rows="3"
                                    placeholder="Street Address, City, State, Zip Code" required></textarea>
                            </div>

                            <!-- Billing Address -->
                            <h6 class="mb-3 mt-4">Billing Address</h6>
                            <div class="form-check mb-3">
                                <input class="form-check-input" type="checkbox" id="sameAsBilling" name="sameAsBilling">
                                <label class="form-check-label" for="sameAsBilling">
                                    Same as shipping address
                                </label>
                            </div>
                            <div id="billingAddressSection" class="mb-3">
                                <label for="billingAddress" class="form-label">Full Address*</label>
                                <textarea class="form-control" id="billingAddress" name="billingAddress" rows="3"
                                    placeholder="Street Address, City, State, Zip Code" required></textarea>
                            </div>

                            <div class="d-grid mt-4">
                                <button type="submit" class="btn btn-accent">
                                    <i class="fas fa-credit-card me-2"></i> Proceed to Payment
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Order Summary -->
            <div class="col-lg-4">
                <div class="card sticky-top" style="top: 20px">
                    <div class="card-header">
                        <h5 class="mb-0">Order Summary</h5>
                    </div>
                    <div class="card-body">
                        <!-- Cart Items -->
                        <div class="mb-3">
                            <%
                            Map<String, Integer> cart = (Map<String, Integer>)request.getAttribute("cart");
                            Map<String, Book> cartBooks = (Map<String, Book>)request.getAttribute("cartBooks");
                            int cartSize = cart != null ? cart.size() : 0;
                            %>
                            <h6 class="mb-3">Items in Cart (<%=cartSize%>)</h6>
                            <div class="table-responsive">
                                <table class="table table-sm table-dark">
                                    <tbody>
                                    <%
                                    if (cart != null && cartBooks != null) {
                                        for (Map.Entry<String, Integer> entry : cart.entrySet()) {
                                            String bookId = entry.getKey();
                                            Integer quantity = entry.getValue();
                                            Book book = cartBooks.get(bookId);
                                            if (book != null) {
                                                double bookPrice = book.getDiscountedPrice();
                                                double itemTotal = bookPrice * quantity;
                                    %>
                                        <tr>
                                            <td>
                                                <strong><%=book.getTitle()%></strong><br>
                                                <small class="text-muted">Qty: <%=quantity%></small>
                                            </td>
                                            <td class="text-end">
                                                $<fmt:formatNumber value="<%=itemTotal%>" pattern="0.00" />
                                            </td>
                                        </tr>
                                    <%
                                            }
                                        }
                                    }
                                    %>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <!-- Price Breakdown -->
                        <div class="mb-3">
                            <%
                            Double subtotal = (Double)request.getAttribute("subtotal");
                            Double tax = (Double)request.getAttribute("tax");
                            Double shipping = (Double)request.getAttribute("shipping");
                            Double total = (Double)request.getAttribute("total");

                            // Default values if attributes are null
                            if (subtotal == null) subtotal = 0.0;
                            if (tax == null) tax = 0.0;
                            if (shipping == null) shipping = 0.0;
                            if (total == null) total = 0.0;
                            %>
                            <div class="d-flex justify-content-between mb-2">
                                <span>Subtotal:</span>
                                <span>$<fmt:formatNumber value="<%=subtotal%>" pattern="0.00" /></span>
                            </div>
                            <div class="d-flex justify-content-between mb-2">
                                <span>Tax (7%):</span>
                                <span>$<fmt:formatNumber value="<%=tax%>" pattern="0.00" /></span>
                            </div>
                            <div class="d-flex justify-content-between mb-2">
                                <span>Shipping:</span>
                                <% if (shipping > 0) { %>
                                    <span>$<fmt:formatNumber value="<%=shipping%>" pattern="0.00" /></span>
                                <% } else { %>
                                    <span class="text-success">Free</span>
                                <% } %>
                            </div>
                            <hr>
                            <div class="d-flex justify-content-between fw-bold">
                                <span>Total:</span>
                                <span style="color: #8a5cf5;">$<fmt:formatNumber value="<%=total%>" pattern="0.00" /></span>
                            </div>
                        </div>
                    </div>
                    <div class="card-footer">
                        <a href="<%=request.getContextPath()%>/cart" class="btn btn-outline-light w-100">
                            <i class="fas fa-arrow-left me-2"></i> Back to Cart
                        </a>
                    </div>
                </div>
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

    <!-- JavaScript for handling "Same as shipping address" checkbox -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const sameAsBillingCheckbox = document.getElementById('sameAsBilling');
            const billingAddressSection = document.getElementById('billingAddressSection');
            const billingAddressTextarea = document.getElementById('billingAddress');
            const shippingAddressTextarea = document.getElementById('shippingAddress');

            sameAsBillingCheckbox.addEventListener('change', function() {
                if (this.checked) {
                    billingAddressTextarea.value = shippingAddressTextarea.value;
                    billingAddressSection.style.display = 'none';
                    billingAddressTextarea.required = false;
                } else {
                    billingAddressTextarea.value = '';
                    billingAddressSection.style.display = 'block';
                    billingAddressTextarea.required = true;
                }
            });

            // Also update billing address when shipping address changes if checkbox is checked
            shippingAddressTextarea.addEventListener('input', function() {
                if (sameAsBillingCheckbox.checked) {
                    billingAddressTextarea.value = this.value;
                }
            });
        });
    </script>
</body>
</html>
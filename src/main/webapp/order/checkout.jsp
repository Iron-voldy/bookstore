<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="com.bookstore.model.book.Book" %>
<%@ page import="java.util.Map" %>
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
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }

        .card-header {
            background-color: var(--secondary-dark);
            color: var(--text-primary);
            font-weight: 600;
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
            box-shadow: 0 0 0 0.25rem rgba(138, 92, 245, 0.25);
        }

        .form-check-input {
            background-color: var(--secondary-dark);
            border: 1px solid var(--border-color);
        }

        .form-check-input:checked {
            background-color: var(--accent-color);
            border-color: var(--accent-color);
        }

        .breadcrumb {
            background-color: var(--secondary-dark);
            padding: 10px 15px;
            border-radius: 5px;
        }

        .breadcrumb-item a {
            color: var(--text-secondary);
            text-decoration: none;
        }

        .breadcrumb-item.active {
            color: var(--text-primary);
        }

        .order-summary {
            background-color: var(--secondary-dark);
            border-radius: 8px;
            padding: 20px;
        }

        .price-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
        }

        .total-row {
            font-weight: bold;
            font-size: 1.1rem;
            border-top: 1px solid var(--border-color);
            padding-top: 10px;
            margin-top: 10px;
        }

        .table-dark {
            background-color: var(--card-bg);
            color: var(--text-primary);
        }

        .table-dark th,
        .table-dark td {
            border-color: var(--border-color);
        }

        .book-type-badge {
            font-size: 0.7rem;
            padding: 3px 8px;
            border-radius: 12px;
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
    </style>
</head>
<body>
    <!-- Header -->
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

                <!-- User Menu -->
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <a class="nav-link" href="<%=request.getContextPath()%>/cart">
                            <i class="fas fa-shopping-cart"></i>
                            <span class="badge bg-accent rounded-pill">${sessionScope.cartCount}</span>
                        </a>
                    </li>
                    <c:choose>
                        <c:when test="${empty sessionScope.userId}">
                            <li class="nav-item">
                                <a class="nav-link" href="<%=request.getContextPath()%>/login">Login</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="<%=request.getContextPath()%>/register">Register</a>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown">
                                    <i class="fas fa-user me-1"></i> My Account
                                </a>
                                <ul class="dropdown-menu dropdown-menu-dark">
                                    <li><a class="dropdown-item" href="<%=request.getContextPath()%>/profile">Profile</a></li>
                                    <li><a class="dropdown-item" href="<%=request.getContextPath()%>/order-history">Orders</a></li>
                                    <li><a class="dropdown-item" href="<%=request.getContextPath()%>/wishlists">Wishlists</a></li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item" href="<%=request.getContextPath()%>/logout">Logout</a></li>
                                </ul>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container my-5">
        <!-- Breadcrumb -->
        <nav aria-label="breadcrumb" class="mb-4">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/">Home</a></li>
                <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/cart">Cart</a></li>
                <li class="breadcrumb-item active" aria-current="page">Checkout</li>
            </ol>
        </nav>

        <h2 class="mb-4"><i class="fas fa-shopping-cart me-2"></i> Checkout</h2>

        <!-- Flash Messages -->
        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show mb-4" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i> ${sessionScope.errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <c:remove var="errorMessage" scope="session" />
        </c:if>

        <div class="row">
            <div class="col-lg-8 mb-4">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">Shipping & Contact Information</h5>
                    </div>
                    <div class="card-body">
                        <form action="<%=request.getContextPath()%>/checkout" method="post">
                            <!-- Contact Information -->
                            <div class="mb-4">
                                <h6>Contact Information</h6>
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="contactEmail" class="form-label">Email Address*</label>
                                        <input type="email" class="form-control" id="contactEmail" name="contactEmail"
                                               value="${user.email}" required>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="contactPhone" class="form-label">Phone Number*</label>
                                        <input type="tel" class="form-control" id="contactPhone" name="contactPhone"
                                               required>
                                    </div>
                                </div>
                            </div>

                            <!-- Shipping Address -->
                            <div class="mb-4">
                                <h6>Shipping Address</h6>
                                <div class="mb-3">
                                    <label for="shippingAddress" class="form-label">Full Address*</label>
                                    <textarea class="form-control" id="shippingAddress" name="shippingAddress"
                                              rows="3" required></textarea>
                                </div>
                            </div>

                            <!-- Billing Address -->
                            <div class="mb-4">
                                <h6>Billing Address</h6>
                                <div class="form-check mb-3">
                                    <input class="form-check-input" type="checkbox" id="sameAsBilling" name="sameAsBilling" checked>
                                    <label class="form-check-label" for="sameAsBilling">
                                        Same as shipping address
                                    </label>
                                </div>
                                <div id="billingAddressSection" style="display: none;">
                                    <div class="mb-3">
                                        <label for="billingAddress" class="form-label">Full Address*</label>
                                        <textarea class="form-control" id="billingAddress" name="billingAddress"
                                                  rows="3"></textarea>
                                    </div>
                                </div>
                            </div>

                            <div class="d-flex justify-content-between">
                                <a href="<%=request.getContextPath()%>/cart" class="btn btn-outline-light">
                                    <i class="fas fa-arrow-left me-2"></i> Back to Cart
                                </a>
                                <button type="submit" class="btn btn-accent">
                                    <i class="fas fa-credit-card me-2"></i> Continue to Payment
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <div class="col-lg-4">
                <div class="order-summary">
                    <h4 class="mb-4">Order Summary</h4>

                    <div class="table-responsive mb-3">
                        <table class="table table-dark table-sm">
                            <tbody>
                                <%-- Create a formatter for currency --%>
                                <% DecimalFormat df = new DecimalFormat("$#,##0.00"); %>

                                <%-- Get the cart and cart books from request --%>
                                <%
                                Map<String, Integer> cart = (Map<String, Integer>)request.getAttribute("cart");
                                Map<String, Book> cartBooks = (Map<String, Book>)request.getAttribute("cartBooks");

                                if (cart != null && cartBooks != null) {
                                    for (Map.Entry<String, Integer> entry : cart.entrySet()) {
                                        String bookId = entry.getKey();
                                        Integer quantity = entry.getValue();
                                        Book book = cartBooks.get(bookId);

                                        if (book != null) {
                                            // Calculate item total
                                            double itemTotal = book.getDiscountedPrice() * quantity;
                                %>
                                    <tr>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <div>
                                                    <p class="mb-0"><%= book.getTitle() %></p>
                                                    <small class="text-muted">
                                                        Qty: <%= quantity %>
                                                        <% if (book.getClass().getSimpleName().equals("EBook")) { %>
                                                            <span class="badge ebook-badge ms-1">E-Book</span>
                                                        <% } else if (book.getClass().getSimpleName().equals("PhysicalBook")) { %>
                                                            <span class="badge physical-badge ms-1">Physical</span>
                                                        <% } %>
                                                    </small>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="text-end">
                                            <%= df.format(itemTotal) %>
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

                    <div class="price-row">
                        <span>Subtotal:</span>
                        <span>
                            <%
                            try {
                                Object subtotalObj = request.getAttribute("subtotal");
                                double subtotal = 0.0;

                                if (subtotalObj instanceof Double) {
                                    subtotal = (Double)subtotalObj;
                                } else if (subtotalObj != null) {
                                    subtotal = Double.parseDouble(subtotalObj.toString());
                                }

                                out.print(df.format(subtotal));
                            } catch (Exception e) {
                                out.print("$0.00");
                            }
                            %>
                        </span>
                    </div>
                    <div class="price-row">
                        <span>Tax (7%):</span>
                        <span>
                            <%
                            try {
                                Object taxObj = request.getAttribute("tax");
                                double tax = 0.0;

                                if (taxObj instanceof Double) {
                                    tax = (Double)taxObj;
                                } else if (taxObj != null) {
                                    tax = Double.parseDouble(taxObj.toString());
                                }

                                out.print(df.format(tax));
                            } catch (Exception e) {
                                out.print("$0.00");
                            }
                            %>
                        </span>
                    </div>
                    <div class="price-row">
                        <span>Shipping:</span>
                        <%
                        boolean hasShippingCost = false;
                        try {
                            Object shippingObj = request.getAttribute("shipping");
                            double shipping = 0.0;

                            if (shippingObj instanceof Double) {
                                shipping = (Double)shippingObj;
                            } else if (shippingObj != null) {
                                shipping = Double.parseDouble(shippingObj.toString());
                            }

                            hasShippingCost = shipping > 0;

                            if (hasShippingCost) {
                        %>
                            <span><%= df.format(shipping) %></span>
                        <%
                            } else {
                        %>
                            <span class="text-success">Free</span>
                        <%
                            }
                        } catch (Exception e) {
                        %>
                            <span class="text-success">Free</span>
                        <%
                        }
                        %>
                    </div>

                    <div class="price-row total-row">
                        <span>Total:</span>
                        <span>
                            <%
                            try {
                                Object totalObj = request.getAttribute("total");
                                double total = 0.0;

                                if (totalObj instanceof Double) {
                                    total = (Double)totalObj;
                                } else if (totalObj != null) {
                                    total = Double.parseDouble(totalObj.toString());
                                }

                                out.print(df.format(total));
                            } catch (Exception e) {
                                out.print("$0.00");
                            }
                            %>
                        </span>
                    </div>
                </div>
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
    <script>
        // Toggle billing address section
        document.getElementById('sameAsBilling').addEventListener('change', function() {
            let billingSection = document.getElementById('billingAddressSection');
            let billingAddressField = document.getElementById('billingAddress');

            if (this.checked) {
                billingSection.style.display = 'none';
                billingAddressField.required = false;
            } else {
                billingSection.style.display = 'block';
                billingAddressField.required = true;
            }
        });
    </script>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Details - BookVerse</title>
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
        .card {
            background-color: #252525;
            border: 1px solid #333333;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            margin-bottom: 20px;
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
        .btn-primary {
            background-color: #8a5cf5;
            border-color: #8a5cf5;
        }
        .btn-primary:hover {
            background-color: #6e46c9;
            border-color: #6e46c9;
        }
        .btn-outline-light:hover {
            color: #121212;
            background-color: #f8f9fa;
        }
    </style>
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/">
                <i class="fas fa-book-open me-2"></i>BookVerse
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/">Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/books">Books</a>
                    </li>
                </ul>
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/cart">
                            <i class="fas fa-shopping-cart"></i>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/order-history">
                            Orders
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/logout">Logout</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container my-5">
        <!-- Breadcrumb -->
        <nav aria-label="breadcrumb" class="mb-4">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Home</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/order-history">Order History</a></li>
                <li class="breadcrumb-item active" aria-current="page">Order Details</li>
            </ol>
        </nav>

        <h2 class="mb-4">
            <i class="fas fa-file-invoice me-2"></i>
            Order #${order.orderId.substring(0, 8)}
            <c:choose>
                <c:when test="${order.status == 'PENDING'}">
                    <span class="badge bg-warning text-dark ms-2">Pending</span>
                </c:when>
                <c:when test="${order.status == 'PROCESSING'}">
                    <span class="badge bg-primary ms-2">Processing</span>
                </c:when>
                <c:when test="${order.status == 'SHIPPED'}">
                    <span class="badge bg-info text-dark ms-2">Shipped</span>
                </c:when>
                <c:when test="${order.status == 'DELIVERED'}">
                    <span class="badge bg-success ms-2">Delivered</span>
                </c:when>
                <c:when test="${order.status == 'CANCELLED'}">
                    <span class="badge bg-danger ms-2">Cancelled</span>
                </c:when>
            </c:choose>
        </h2>

        <!-- Order Actions -->
        <div class="mb-4">
            <c:if test="${order.canCancel()}">
                <button type="button" class="btn btn-outline-danger" data-bs-toggle="modal" data-bs-target="#cancelOrderModal">
                    <i class="fas fa-times-circle me-2"></i> Cancel Order
                </button>
            </c:if>
            <a href="${pageContext.request.contextPath}/order-history" class="btn btn-outline-light ms-2">
                <i class="fas fa-arrow-left me-2"></i> Back to Orders
            </a>
        </div>

        <div class="row">
            <!-- Order Details -->
            <div class="col-lg-8">
                <div class="card mb-4">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">Order Items</h5>
                        <span class="text-muted small">
                            Placed on
                            <c:if test="${not empty order.orderDate}">
                                <fmt:formatDate value="${order.orderDate}" pattern="MMMM d, yyyy h:mm a" />
                            </c:if>
                        </span>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-dark">
                                <thead>
                                    <tr>
                                        <th>Product</th>
                                        <th>Quantity</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="item" items="${order.items}">
                                        <tr>
                                            <td>
                                                <strong>${item.title}</strong><br>
                                                <small class="text-muted">by ${item.author}</small>
                                                <c:if test="${not empty item.bookType}">
                                                    <br>
                                                    <c:choose>
                                                        <c:when test="${item.bookType == 'EBOOK'}">
                                                            <span class="badge bg-primary">E-Book</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-secondary">Physical Book</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:if>
                                            </td>
                                            <td>${item.quantity}</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>

                        <div class="mt-3">
                            <div class="d-flex justify-content-between mb-2">
                                <span>Subtotal:</span>
                                <span>$<fmt:formatNumber value="${order.subtotal}" pattern="0.00" /></span>
                            </div>
                            <div class="d-flex justify-content-between mb-2">
                                <span>Tax:</span>
                                <span>$<fmt:formatNumber value="${order.tax}" pattern="0.00" /></span>
                            </div>
                            <div class="d-flex justify-content-between mb-2">
                                <span>Shipping:</span>
                                <span>$<fmt:formatNumber value="${order.shippingCost}" pattern="0.00" /></span>
                            </div>
                            <hr>
                            <div class="d-flex justify-content-between fw-bold">
                                <span>Total:</span>
                                <span>$<fmt:formatNumber value="${order.total}" pattern="0.00" /></span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Order Summary Sidebar -->
            <div class="col-lg-4">
                <!-- Shipping Information -->
                <div class="card mb-4">
                    <div class="card-header">
                        <h5 class="mb-0">Shipping Information</h5>
                    </div>
                    <div class="card-body">
                        <h6>Shipping Address</h6>
                        <p class="mb-3">${order.shippingAddress}</p>

                        <h6>Contact Information</h6>
                        <p class="mb-1"><i class="fas fa-envelope me-2 text-muted"></i> ${order.contactEmail}</p>
                        <p class="mb-0"><i class="fas fa-phone me-2 text-muted"></i> ${order.contactPhone}</p>
                    </div>
                </div>

                <!-- Need Help? -->
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">Need Help?</h5>
                    </div>
                    <div class="card-body">
                        <div class="d-grid gap-2">
                            <a href="${pageContext.request.contextPath}/contact" class="btn btn-outline-light">
                                <i class="fas fa-headset me-2"></i> Contact Support
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Cancel Order Modal -->
    <div class="modal fade" id="cancelOrderModal" tabindex="-1" aria-labelledby="cancelOrderModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content bg-dark text-light">
                <div class="modal-header">
                    <h5 class="modal-title" id="cancelOrderModalLabel">Cancel Order</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to cancel this order?</p>
                    <p><strong>Order #${order.orderId.substring(0, 8)}</strong></p>
                    <p class="text-danger">This action cannot be undone.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-light" data-bs-dismiss="modal">No, Keep Order</button>
                    <form action="${pageContext.request.contextPath}/cancel-order" method="post">
                        <input type="hidden" name="orderId" value="${order.orderId}">
                        <button type="submit" class="btn btn-danger">Yes, Cancel Order</button>
                    </form>
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
                    <p>Your one-stop destination for all your literary needs.</p>
                </div>
                <div class="col-md-4 mb-3">
                    <h5>Quick Links</h5>
                    <ul class="list-unstyled">
                        <li><a href="${pageContext.request.contextPath}/" class="text-decoration-none text-light">Home</a></li>
                        <li><a href="${pageContext.request.contextPath}/books" class="text-decoration-none text-light">Books</a></li>
                        <li><a href="${pageContext.request.contextPath}/contact" class="text-decoration-none text-light">Contact Us</a></li>
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
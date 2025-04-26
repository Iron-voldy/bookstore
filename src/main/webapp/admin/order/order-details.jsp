<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Details - Admin Dashboard - BookVerse</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #3a0ca3;
            --secondary-color: #4cc9f0;
            --accent-color: #7209b7;
            --success-color: #4caf50;
            --warning-color: #ff9800;
            --danger-color: #f44336;
            --dark-color: #343a40;
            --light-color: #f8f9fa;
        }

        body {
            background-color: #f5f5f5;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .sidebar {
            background-color: var(--dark-color);
            color: white;
            height: 100vh;
            position: fixed;
            padding-top: 20px;
        }

        .sidebar .nav-link {
            color: rgba(255, 255, 255, 0.8);
            padding: 10px 20px;
            margin: 5px 0;
            border-radius: 5px;
        }

        .sidebar .nav-link:hover, .sidebar .nav-link.active {
            background-color: rgba(255, 255, 255, 0.1);
            color: white;
        }

        .sidebar .nav-link i {
            margin-right: 10px;
            width: 20px;
            text-align: center;
        }

        .main-content {
            margin-left: 250px;
            padding: 20px;
        }

        .order-status {
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: bold;
        }

        .status-pending {
            background-color: #ffc107;
            color: #212529;
        }

        .status-processing {
            background-color: #17a2b8;
            color: white;
        }

        .status-shipped {
            background-color: #007bff;
            color: white;
        }

        .status-delivered {
            background-color: #28a745;
            color: white;
        }

        .status-cancelled {
            background-color: #dc3545;
            color: white;
        }

        .table-responsive {
            overflow-x: auto;
        }

        .card {
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            border: none;
            margin-bottom: 20px;
        }

        .card-header {
            background-color: #f8f9fa;
            border-bottom: 1px solid #e9ecef;
            font-weight: bold;
        }

        .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }

        .btn-primary:hover {
            background-color: #2e0a83;
            border-color: #2e0a83;
        }

        .btn-success {
            background-color: var(--success-color);
            border-color: var(--success-color);
        }

        .btn-danger {
            background-color: var(--danger-color);
            border-color: var(--danger-color);
        }

        .btn-warning {
            background-color: var(--warning-color);
            border-color: var(--warning-color);
        }

        .alert-custom {
            padding: 10px 15px;
            margin-bottom: 20px;
            border: 1px solid transparent;
            border-radius: 4px;
        }

        .alert-success {
            color: #155724;
            background-color: #d4edda;
            border-color: #c3e6cb;
        }

        .alert-danger {
            color: #721c24;
            background-color: #f8d7da;
            border-color: #f5c6cb;
        }
    </style>
</head>
<body>
    <!-- Sidebar -->
    <div class="sidebar col-md-3 col-lg-2 d-md-block">
        <div class="text-center mb-4">
            <h4>BookVerse Admin</h4>
        </div>
        <ul class="nav flex-column">
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">
                    <i class="fas fa-tachometer-alt"></i> Dashboard
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/admin/manage-books.jsp">
                    <i class="fas fa-book"></i> Books
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link active" href="${pageContext.request.contextPath}/admin/orders">
                    <i class="fas fa-shopping-cart"></i> Orders
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/admin/manage-users.jsp">
                    <i class="fas fa-users"></i> Users
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/admin/manage-admins">
                    <i class="fas fa-user-shield"></i> Admins
                </a>
            </li>
            <li class="nav-item mt-5">
                <a class="nav-link" href="${pageContext.request.contextPath}/admin/logout">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </a>
            </li>
        </ul>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <!-- Flash Messages -->
        <c:if test="${not empty sessionScope.successMessage}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i> ${sessionScope.successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <c:remove var="successMessage" scope="session" />
        </c:if>

        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i> ${sessionScope.errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <c:remove var="errorMessage" scope="session" />
        </c:if>

        <!-- Page Header -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2><i class="fas fa-file-invoice me-2"></i> Order Details</h2>
            <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-outline-secondary">
                <i class="fas fa-arrow-left me-2"></i> Back to Orders
            </a>
        </div>

        <!-- Order Information -->
        <div class="card mb-4">
            <div class="card-header d-flex justify-content-between align-items-center">
                <span>Order #${order.orderId}</span>
                <span class="order-status status-${order.status.name().toLowerCase()}">${order.status.displayName}</span>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-6">
                        <h5>Order Information</h5>
                        <table class="table table-borderless">
                            <tr>
                                <th>Order Date:</th>
                                <td><fmt:formatDate value="${order.orderDate}" pattern="MMMM d, yyyy h:mm a" /></td>
                            </tr>
                            <tr>
                                <th>Order Status:</th>
                                <td><span class="order-status status-${order.status.name().toLowerCase()}">${order.status.displayName}</span></td>
                            </tr>
                            <c:if test="${not empty order.trackingNumber}">
                                <tr>
                                    <th>Tracking Number:</th>
                                    <td>${order.trackingNumber}</td>
                                </tr>
                            </c:if>
                            <c:if test="${not empty order.shippedDate}">
                                <tr>
                                    <th>Shipped Date:</th>
                                    <td><fmt:formatDate value="${order.shippedDate}" pattern="MMMM d, yyyy" /></td>
                                </tr>
                            </c:if>
                            <c:if test="${not empty order.deliveredDate}">
                                <tr>
                                    <th>Delivered Date:</th>
                                    <td><fmt:formatDate value="${order.deliveredDate}" pattern="MMMM d, yyyy" /></td>
                                </tr>
                            </c:if>
                        </table>
                    </div>
                    <div class="col-md-6">
                        <h5>Customer Information</h5>
                        <table class="table table-borderless">
                            <tr>
                                <th>Customer Name:</th>
                                <td>${customer.fullName}</td>
                            </tr>
                            <tr>
                                <th>Email:</th>
                                <td>${order.contactEmail}</td>
                            </tr>
                            <tr>
                                <th>Phone:</th>
                                <td>${order.contactPhone}</td>
                            </tr>
                            <tr>
                                <th>User ID:</th>
                                <td>${order.userId}</td>
                            </tr>
                        </table>
                    </div>
                </div>

                <div class="row mt-3">
                    <div class="col-md-6">
                        <h5>Shipping Address</h5>
                        <p class="border p-2">${order.shippingAddress}</p>
                    </div>
                    <div class="col-md-6">
                        <h5>Billing Address</h5>
                        <p class="border p-2">${order.billingAddress}</p>
                    </div>
                </div>

                <div class="row mt-3">
                    <div class="col-md-12">
                        <h5>Payment Information</h5>
                        <c:choose>
                            <c:when test="${not empty order.payment}">
                                <table class="table table-borderless">
                                    <tr>
                                        <th>Payment Method:</th>
                                        <td>${order.payment.paymentMethod.displayName}</td>
                                    </tr>
                                    <tr>
                                        <th>Transaction ID:</th>
                                        <td>${order.payment.transactionId}</td>
                                    </tr>
                                    <tr>
                                        <th>Payment Date:</th>
                                        <td><fmt:formatDate value="${order.payment.paymentDate}" pattern="MMMM d, yyyy h:mm a" /></td>
                                    </tr>
                                    <tr>
                                        <th>Payment Status:</th>
                                        <td>
                                            <c:choose>
                                                <c:when test="${order.payment.successful}">
                                                    <span class="badge bg-success">Successful</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-danger">Failed</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>Payment Details:</th>
                                        <td>${order.payment.paymentDetails}</td>
                                    </tr>
                                </table>
                            </c:when>
                            <c:otherwise>
                                <p class="text-muted">No payment information available.</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="row mt-3">
                    <div class="col-md-12">
                        <h5>Order Items</h5>
                        <div class="table-responsive">
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th>Product</th>
                                        <th>Type</th>
                                        <th class="text-end">Price</th>
                                        <th class="text-center">Quantity</th>
                                        <th class="text-end">Total</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="item" items="${order.items}">
                                        <tr>
                                            <td>
                                                <strong>${item.title}</strong><br>
                                                <small class="text-muted">by ${item.author}</small>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${item.bookType eq 'EBOOK'}">
                                                        <span class="badge bg-primary">E-Book</span>
                                                    </c:when>
                                                    <c:when test="${item.bookType eq 'PHYSICAL'}">
                                                        <span class="badge bg-info">Physical Book</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">Book</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-end">$<fmt:formatNumber value="${item.discountedPrice}" pattern="0.00" /></td>
                                            <td class="text-center">${item.quantity}</td>
                                            <td class="text-end">$<fmt:formatNumber value="${item.subtotal}" pattern="0.00" /></td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                                <tfoot>
                                    <tr>
                                        <td colspan="4" class="text-end"><strong>Subtotal:</strong></td>
                                        <td class="text-end">$<fmt:formatNumber value="${order.subtotal}" pattern="0.00" /></td>
                                    </tr>
                                    <tr>
                                        <td colspan="4" class="text-end"><strong>Tax:</strong></td>
                                        <td class="text-end">$<fmt:formatNumber value="${order.tax}" pattern="0.00" /></td>
                                    </tr>
                                    <tr>
                                        <td colspan="4" class="text-end"><strong>Shipping:</strong></td>
                                        <td class="text-end">$<fmt:formatNumber value="${order.shippingCost}" pattern="0.00" /></td>
                                    </tr>
                                    <tr>
                                        <td colspan="4" class="text-end"><strong>Total:</strong></td>
                                        <td class="text-end"><strong>$<fmt:formatNumber value="${order.total}" pattern="0.00" /></strong></td>
                                    </tr>
                                </tfoot>
                            </table>
                        </div>
                    </div>
                </div>

                <div class="row mt-3">
                    <div class="col-md-12">
                        <h5>Order Notes</h5>
                        <textarea class="form-control" id="orderNotes" rows="3" readonly>${order.notes}</textarea>
                    </div>
                </div>
            </div>
        </div>

        <!-- Update Order Status -->
        <div class="card">
            <div class="card-header">
                <h5 class="mb-0">Update Order Status</h5>
            </div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/admin/update-order-status" method="post">
                    <input type="hidden" name="orderId" value="${order.orderId}">

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="status" class="form-label">Order Status</label>
                            <select class="form-select" id="status" name="status" required>
                                <c:forEach var="status" items="${statuses}">
                                    <option value="${status}" ${order.status eq status ? 'selected' : ''}>${status.displayName}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label for="trackingNumber" class="form-label">Tracking Number</label>
                            <input type="text" class="form-control" id="trackingNumber" name="trackingNumber"
                                   value="${order.trackingNumber}" placeholder="Enter tracking number">
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="notes" class="form-label">Order Notes</label>
                        <textarea class="form-control" id="notes" name="notes" rows="3"
                                  placeholder="Add notes about this order">${order.notes}</textarea>
                    </div>

                    <div class="d-flex justify-content-between">
                        <div>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save me-2"></i> Update Order
                            </button>
                        </div>
                        <div>
                            <c:if test="${order.status ne 'DELIVERED' and order.status ne 'CANCELLED'}">
                                <button type="button" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#cancelOrderModal">
                                    <i class="fas fa-times me-2"></i> Cancel Order
                                </button>
                            </c:if>
                            <button type="button" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#deleteOrderModal">
                                <i class="fas fa-trash me-2"></i> Delete Order
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Cancel Order Modal -->
    <div class="modal fade" id="cancelOrderModal" tabindex="-1" aria-labelledby="cancelOrderModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="cancelOrderModalLabel">Cancel Order</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to cancel this order? This will update the order status to 'Cancelled' and return items to inventory.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <form action="${pageContext.request.contextPath}/admin/update-order-status" method="post">
                        <input type="hidden" name="orderId" value="${order.orderId}">
                        <input type="hidden" name="status" value="CANCELLED">
                        <button type="submit" class="btn btn-danger">Cancel Order</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Delete Order Modal -->
    <div class="modal fade" id="deleteOrderModal" tabindex="-1" aria-labelledby="deleteOrderModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="deleteOrderModalLabel">Delete Order</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p class="text-danger">Warning: This action cannot be undone. Are you sure you want to permanently delete this order?</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <form action="${pageContext.request.contextPath}/admin/delete-order" method="post">
                        <input type="hidden" name="orderId" value="${order.orderId}">
                        <input type="hidden" name="confirm" value="yes">
                        <button type="submit" class="btn btn-danger">Delete Order</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
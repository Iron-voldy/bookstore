<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Order - Admin Dashboard - BookVerse</title>
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
            <h2><i class="fas fa-edit me-2"></i> Update Order Status</h2>
            <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-outline-secondary">
                <i class="fas fa-arrow-left me-2"></i> Back to Orders
            </a>
        </div>

        <!-- Order Basic Information -->
        <div class="card mb-4">
            <div class="card-header d-flex justify-content-between align-items-center">
                <span>Order #${order.orderId}</span>
                <span class="order-status status-${order.status.name().toLowerCase()}">${order.status.displayName}</span>
            </div>
            <div class="card-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <h5>Order Summary</h5>
                                    <table class="table table-borderless">
                                        <tr>
                                            <th>Order Date:</th>
                                            <td><fmt:formatDate value="${order.orderDate}" pattern="MMMM d, yyyy h:mm a" /></td>
                                        </tr>
                                        <tr>
                                            <th>Customer Name:</th>
                                            <td>${customer.fullName}</td>
                                        </tr>
                                        <tr>
                                            <th>Total Items:</th>
                                            <td>${order.totalItems}</td>
                                        </tr>
                                        <tr>
                                            <th>Order Total:</th>
                                            <td>$<fmt:formatNumber value="${order.total}" pattern="0.00" /></td>
                                        </tr>
                                        <tr>
                                            <th>Current Status:</th>
                                            <td><span class="order-status status-${order.status.name().toLowerCase()}">${order.status.displayName}</span></td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="col-md-6">
                                    <h5>Status History</h5>
                                    <ul class="list-group">
                                        <li class="list-group-item d-flex justify-content-between align-items-center">
                                            <span>Created</span>
                                            <span><fmt:formatDate value="${order.orderDate}" pattern="MMM d, yyyy" /></span>
                                        </li>
                                        <c:if test="${order.payment != null && order.payment.successful}">
                                            <li class="list-group-item d-flex justify-content-between align-items-center">
                                                <span>Payment Received</span>
                                                <span><fmt:formatDate value="${order.payment.paymentDate}" pattern="MMM d, yyyy" /></span>
                                            </li>
                                        </c:if>
                                        <c:if test="${order.status.name() eq 'PROCESSING' || order.status.name() eq 'SHIPPED' || order.status.name() eq 'DELIVERED'}">
                                            <li class="list-group-item d-flex justify-content-between align-items-center">
                                                <span>Processing</span>
                                                <span>
                                                    <c:choose>
                                                        <c:when test="${order.payment != null && order.payment.successful}">
                                                            <fmt:formatDate value="${order.payment.paymentDate}" pattern="MMM d, yyyy" />
                                                        </c:when>
                                                        <c:otherwise>-</c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </li>
                                        </c:if>
                                        <c:if test="${order.status.name() eq 'SHIPPED' || order.status.name() eq 'DELIVERED'}">
                                            <li class="list-group-item d-flex justify-content-between align-items-center">
                                                <span>Shipped</span>
                                                <span>
                                                    <c:choose>
                                                        <c:when test="${order.shippedDate != null}">
                                                            <fmt:formatDate value="${order.shippedDate}" pattern="MMM d, yyyy" />
                                                        </c:when>
                                                        <c:otherwise>-</c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </li>
                                        </c:if>
                                        <c:if test="${order.status.name() eq 'DELIVERED'}">
                                            <li class="list-group-item d-flex justify-content-between align-items-center">
                                                <span>Delivered</span>
                                                <span>
                                                    <c:choose>
                                                        <c:when test="${order.deliveredDate != null}">
                                                            <fmt:formatDate value="${order.deliveredDate}" pattern="MMM d, yyyy" />
                                                        </c:when>
                                                        <c:otherwise>-</c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </li>
                                        </c:if>
                                        <c:if test="${order.status.name() eq 'CANCELLED'}">
                                            <li class="list-group-item d-flex justify-content-between align-items-center list-group-item-danger">
                                                <span>Cancelled</span>
                                                <span>-</span>
                                            </li>
                                        </c:if>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Update Order Form -->
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0">Update Order Status</h5>
                        </div>
                        <div class="card-body">
                            <form action="${pageContext.request.contextPath}/admin/update-order-status" method="post">
                                <input type="hidden" name="orderId" value="${order.orderId}">

                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="status" class="form-label">Change Order Status</label>
                                        <select class="form-select" id="status" name="status" required>
                                            <c:forEach var="status" items="${statuses}">
                                                <option value="${status}" ${order.status eq status ? 'selected' : ''}>${status.displayName}</option>
                                            </c:forEach>
                                        </select>
                                        <div class="form-text">
                                            Changing the status to "Shipped" will record the shipped date as today.
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="trackingNumber" class="form-label">Tracking Number</label>
                                        <input type="text" class="form-control" id="trackingNumber" name="trackingNumber"
                                               value="${order.trackingNumber}" placeholder="Enter tracking number">
                                        <div class="form-text">
                                            Required when status is "Shipped", optional otherwise.
                                        </div>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label for="notes" class="form-label">Add Notes</label>
                                    <textarea class="form-control" id="notes" name="notes" rows="3"
                                              placeholder="Add admin notes about this order (not visible to customer)">${order.notes}</textarea>
                                </div>

                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label">Status Quick Update</label>
                                            <div class="d-flex gap-2">
                                                <c:if test="${order.status.name() eq 'PENDING'}">
                                                    <button type="submit" name="status" value="PROCESSING" class="btn btn-info">
                                                        <i class="fas fa-clipboard-check me-2"></i> Mark as Processing
                                                    </button>
                                                </c:if>
                                                <c:if test="${order.status.name() eq 'PROCESSING'}">
                                                    <button type="submit" name="status" value="SHIPPED" class="btn btn-primary">
                                                        <i class="fas fa-shipping-fast me-2"></i> Mark as Shipped
                                                    </button>
                                                </c:if>
                                                <c:if test="${order.status.name() eq 'SHIPPED'}">
                                                    <button type="submit" name="status" value="DELIVERED" class="btn btn-success">
                                                        <i class="fas fa-check-circle me-2"></i> Mark as Delivered
                                                    </button>
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6 text-end">
                                        <c:if test="${order.status.name() ne 'CANCELLED' and order.status.name() ne 'DELIVERED'}">
                                            <button type="button" class="btn btn-danger me-2" data-bs-toggle="modal" data-bs-target="#cancelOrderModal">
                                                <i class="fas fa-ban me-2"></i> Cancel Order
                                            </button>
                                        </c:if>
                                    </div>
                                </div>

                                <hr>

                                <div class="d-flex justify-content-between">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-save me-2"></i> Save Changes
                                    </button>
                                    <a href="${pageContext.request.contextPath}/admin/order-details?orderId=${order.orderId}" class="btn btn-outline-secondary">
                                        <i class="fas fa-eye me-2"></i> View Full Order Details
                                    </a>
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
                                <p>Are you sure you want to cancel this order? This will:</p>
                                <ul>
                                    <li>Change the order status to "Cancelled"</li>
                                    <li>Return items to inventory (for physical books)</li>
                                    <li>Make the order non-deliverable</li>
                                </ul>
                                <p class="text-danger">This action cannot be undone.</p>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                <form action="${pageContext.request.contextPath}/admin/update-order-status" method="post">
                                    <input type="hidden" name="orderId" value="${order.orderId}">
                                    <input type="hidden" name="status" value="CANCELLED">
                                    <input type="hidden" name="notes" value="${order.notes}${empty order.notes ? '' : '&#10;'}[Admin cancelled order on <fmt:formatDate value='<%=new java.util.Date()%>' pattern='yyyy-MM-dd'/>]">
                                    <button type="submit" class="btn btn-danger">Cancel Order</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Bootstrap Bundle with Popper -->
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
                <script>
                    // When status is changed to SHIPPED, prompt for tracking number if empty
                    document.getElementById('status').addEventListener('change', function() {
                        const trackingInput = document.getElementById('trackingNumber');
                        if (this.value === 'SHIPPED' && trackingInput.value.trim() === '') {
                            trackingInput.classList.add('border-danger');
                            alert('Please enter a tracking number when marking as shipped.');
                        } else {
                            trackingInput.classList.remove('border-danger');
                        }
                    });
                </script>
            </body>
            </html>
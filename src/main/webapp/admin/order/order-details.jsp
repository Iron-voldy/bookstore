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
            --primary-dark: #121212;
            --secondary-dark: #1e1e1e;
            --accent-color: #8a5cf5;
            --accent-hover: #6e46c9;
            --text-primary: #f5f5f5;
            --text-secondary: #b0b0b0;
            --danger-color: #d64045;
            --success-color: #4caf50;
            --warning-color: #ff9800;
            --info-color: #2196F3;
            --card-bg: #252525;
            --border-color: #333333;
        }

        body {
            background-color: var(--primary-dark);
            color: var(--text-primary);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .sidebar {
            background-color: var(--secondary-dark);
            min-height: 100vh;
            position: fixed;
            top: 0;
            left: 0;
            width: 250px;
            padding-top: 20px;
            z-index: 100;
        }

        .sidebar-brand {
            padding: 15px 20px;
            margin-bottom: 20px;
            border-bottom: 1px solid var(--border-color);
        }

        .sidebar-brand a {
            color: var(--accent-color);
            text-decoration: none;
            font-weight: bold;
            font-size: 1.2rem;
        }

        .sidebar-menu {
            padding: 0;
            list-style: none;
        }

        .sidebar-menu li {
            margin-bottom: 5px;
        }

        .sidebar-menu a {
            display: block;
            padding: 12px 20px;
            color: var(--text-primary);
            text-decoration: none;
            transition: all 0.3s;
        }

        .sidebar-menu a:hover,
        .sidebar-menu a.active {
            background-color: rgba(138, 92, 245, 0.1);
            color: var(--accent-color);
            border-left: 4px solid var(--accent-color);
        }

        .sidebar-menu a.active {
            font-weight: 500;
        }

        .sidebar-menu i {
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

        .status-PENDING {
            background-color: #ffc107;
            color: #212529;
        }

        .status-PROCESSING {
            background-color: #17a2b8;
            color: white;
        }

        .status-SHIPPED {
            background-color: #007bff;
            color: white;
        }

        .status-DELIVERED {
            background-color: #28a745;
            color: white;
        }

        .status-CANCELLED {
            background-color: #dc3545;
            color: white;
        }

        .card {
            background-color: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .card-header {
            background-color: var(--secondary-dark);
            border-bottom: 1px solid var(--border-color);
            padding: 15px 20px;
        }

        .table-dark {
            background-color: var(--card-bg);
            color: var(--text-primary);
        }

        .table-dark th,
        .table-dark td {
            border-color: var(--border-color);
        }

        .btn-accent {
            background-color: var(--accent-color);
            color: white;
            border: none;
        }

        .btn-accent:hover {
            background-color: var(--accent-hover);
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

        .border {
            border-color: var(--border-color) !important;
        }

        .text-muted {
            color: var(--text-secondary) !important;
        }
    </style>
</head>
<body>
    <!-- Sidebar -->
    <div class="sidebar">
        <div class="sidebar-brand">
            <a href="${pageContext.request.contextPath}/admin/dashboard">
                <i class="fas fa-book-open me-2"></i> BookVerse Admin
            </a>
        </div>
        <ul class="sidebar-menu">
            <li>
                <a href="${pageContext.request.contextPath}/admin/dashboard">
                    <i class="fas fa-tachometer-alt"></i> Dashboard
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/admin/manage-books.jsp">
                    <i class="fas fa-book"></i> Books
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/admin/orders" class="active">
                    <i class="fas fa-shopping-cart"></i> Orders
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/admin/manage-users.jsp">
                    <i class="fas fa-users"></i> Users
                </a>
            </li>
            <c:if test="${sessionScope.isSuperAdmin}">
                <li>
                    <a href="${pageContext.request.contextPath}/admin/manage-admins">
                        <i class="fas fa-user-shield"></i> Admins
                    </a>
                </li>
            </c:if>
            <li>
                <a href="${pageContext.request.contextPath}/admin/logout">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </a>
            </li>
        </ul>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <!-- Flash Messages -->
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

        <!-- Page Header -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2><i class="fas fa-file-invoice me-2"></i> Order Details</h2>
            <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-outline-light">
                <i class="fas fa-arrow-left me-2"></i> Back to Orders
            </a>
        </div>

        <!-- Order Information -->
        <div class="card mb-4">
            <div class="card-header d-flex justify-content-between align-items-center">
                <span>Order #${order.orderId.substring(0, 8)}</span>
                <span class="order-status status-${order.status}">
                    <c:choose>
                        <c:when test="${order.status == 'PENDING'}">Pending</c:when>
                        <c:when test="${order.status == 'PROCESSING'}">Processing</c:when>
                        <c:when test="${order.status == 'SHIPPED'}">Shipped</c:when>
                        <c:when test="${order.status == 'DELIVERED'}">Delivered</c:when>
                        <c:when test="${order.status == 'CANCELLED'}">Cancelled</c:when>
                        <c:otherwise>${order.status}</c:otherwise>
                    </c:choose>
                </span>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-6">
                        <h5>Order Information</h5>
                        <table class="table table-borderless">
                            <tr>
                                <th>Order Date:</th>
                                <td>
                                    <c:if test="${order.orderDate != null}">
                                        <fmt:formatDate value="${order.orderDate}" pattern="MMMM d, yyyy h:mm a" />
                                    </c:if>
                                </td>
                            </tr>
                            <tr>
                                <th>Order Status:</th>
                                <td>
                                    <span class="order-status status-${order.status}">
                                        <c:choose>
                                            <c:when test="${order.status == 'PENDING'}">Pending</c:when>
                                            <c:when test="${order.status == 'PROCESSING'}">Processing</c:when>
                                            <c:when test="${order.status == 'SHIPPED'}">Shipped</c:when>
                                            <c:when test="${order.status == 'DELIVERED'}">Delivered</c:when>
                                            <c:when test="${order.status == 'CANCELLED'}">Cancelled</c:when>
                                            <c:otherwise>${order.status}</c:otherwise>
                                        </c:choose>
                                    </span>
                                </td>
                            </tr>
                            <c:if test="${order.trackingNumber != null && not empty order.trackingNumber}">
                                <tr>
                                    <th>Tracking Number:</th>
                                    <td>${order.trackingNumber}</td>
                                </tr>
                            </c:if>
                            <c:if test="${order.shippedDate != null}">
                                <tr>
                                    <th>Shipped Date:</th>
                                    <td><fmt:formatDate value="${order.shippedDate}" pattern="MMMM d, yyyy" /></td>
                                </tr>
                            </c:if>
                            <c:if test="${order.deliveredDate != null}">
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
                                <td>${customer != null ? customer.fullName : "N/A"}</td>
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
                        <c:if test="${order.payment != null}">
                            <table class="table table-borderless">
                                <tr>
                                    <th>Payment Method:</th>
                                    <td>${order.payment.paymentMethod != null ? order.payment.paymentMethod.displayName : "N/A"}</td>
                                </tr>
                                <tr>
                                    <th>Transaction ID:</th>
                                    <td>${order.payment.transactionId}</td>
                                </tr>
                                <tr>
                                    <th>Payment Date:</th>
                                    <td>
                                        <c:if test="${order.payment.paymentDate != null}">
                                            <fmt:formatDate value="${order.payment.paymentDate}" pattern="MMMM d, yyyy h:mm a" />
                                        </c:if>
                                    </td>
                                </tr>
                                <tr>
                                    <th>Payment Status:</th>
                                    <td>
                                        <c:if test="${order.payment.successful}">
                                            <span class="badge bg-success">Successful</span>
                                        </c:if>
                                        <c:if test="${!order.payment.successful}">
                                            <span class="badge bg-danger">Failed</span>
                                        </c:if>
                                    </td>
                                </tr>
                                <tr>
                                    <th>Payment Details:</th>
                                    <td>${order.payment.paymentDetails}</td>
                                </tr>
                            </table>
                        </c:if>
                        <c:if test="${order.payment == null}">
                            <p class="text-muted">No payment information available.</p>
                        </c:if>
                    </div>
                </div>

                <div class="row mt-3">
                    <div class="col-md-12">
                        <h5>Order Items</h5>
                        <div class="table-responsive">
                            <table class="table table-dark table-striped">
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
                                    <c:if test="${not empty order.items}">
                                        <c:forEach var="item" items="${order.items}">
                                            <tr>
                                                <td>
                                                    <strong>${item.title != null ? item.title : 'Unknown'}</strong><br>
                                                    <small class="text-muted">by ${item.author != null ? item.author : 'Unknown'}</small>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${item.bookType == 'EBOOK'}">
                                                            <span class="badge bg-primary">E-Book</span>
                                                        </c:when>
                                                        <c:when test="${item.bookType == 'PHYSICAL'}">
                                                            <span class="badge bg-info">Physical Book</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-secondary">Book</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="text-end">$<fmt:formatNumber value="${item.discountedPrice}" pattern="0.00" /></td>
                                                <td class="text-center">${item.quantity}</td>
                                                <td class="text-end">$<fmt:formatNumber value="${item.quantity * item.discountedPrice}" pattern="0.00" /></td>
                                            </tr>
                                        </c:forEach>
                                    </c:if>
                                    <c:if test="${empty order.items}">
                                        <tr>
                                            <td colspan="5" class="text-center">No items found in this order</td>
                                        </tr>
                                    </c:if>
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
                        <textarea class="form-control" id="orderNotes" rows="3" readonly>${order.notes != null ? order.notes : ""}</textarea>
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
                                    <option value="${status}" ${order.status == status ? "selected" : ""}>
                                        ${status.displayName}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label for="trackingNumber" class="form-label">Tracking Number</label>
                            <input type="text" class="form-control" id="trackingNumber" name="trackingNumber"
                                   value="${order.trackingNumber != null ? order.trackingNumber : ""}" placeholder="Enter tracking number">
                            <div class="form-text text-muted">Required when status is "Shipped"</div>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="notes" class="form-label">Order Notes</label>
                        <textarea class="form-control" id="notes" name="notes" rows="3"
                                  placeholder="Add notes about this order">${order.notes != null ? order.notes : ""}</textarea>
                    </div>

                    <div class="d-flex justify-content-between">
                        <div>
                            <button type="submit" class="btn btn-accent">
                                <i class="fas fa-save me-2"></i> Update Order
                            </button>
                        </div>
                        <div>
                            <c:if test="${order.status != 'DELIVERED' && order.status != 'CANCELLED'}">
                                <button type="button" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#cancelOrderModal">
                                    <i class="fas fa-times me-2"></i> Cancel Order
                                </button>
                            </c:if>
                            <c:if test="${sessionScope.isSuperAdmin}">
                                <button type="button" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#deleteOrderModal">
                                    <i class="fas fa-trash me-2"></i> Delete Order
                                </button>
                            </c:if>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Cancel Order Modal -->
    <div class="modal fade" id="cancelOrderModal" tabindex="-1" aria-labelledby="cancelOrderModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content bg-dark text-white">
                <div class="modal-header">
                    <h5 class="modal-title" id="cancelOrderModalLabel">Cancel Order</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
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

    <!-- Delete Order Modal -->
    <div class="modal fade" id="deleteOrderModal" tabindex="-1" aria-labelledby="deleteOrderModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content bg-dark text-white">
                <div class="modal-header">
                    <h5 class="modal-title" id="deleteOrderModalLabel">Delete Order</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p class="text-danger">Warning: This action cannot be undone. Are you sure you want to permanently delete this order?</p>
                    <p>Deleting an order will remove all associated information including payment details and order items.</p>
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
    <script>
        // When status is changed to SHIPPED, validate tracking number
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
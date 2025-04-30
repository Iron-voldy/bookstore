<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Details - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container py-4">
        <h2>Order Details</h2>

        <!-- Back Button -->
        <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-secondary mb-4">
            <i class="fas fa-arrow-left"></i> Back to Orders
        </a>

        <!-- Debug Information -->
        <div class="card mb-4">
            <div class="card-header bg-info text-white">
                <h5 class="mb-0">Debug Information</h5>
            </div>
            <div class="card-body">
                <p><strong>Order is null:</strong> ${order == null}</p>
                <p><strong>Request attributes:</strong></p>
                <ul>
                <c:forEach var="attrName" items="${pageContext.request.attributeNames}">
                    <li>${attrName}</li>
                </c:forEach>
                </ul>
            </div>
        </div>

        <c:choose>
            <c:when test="${order == null}">
                <div class="alert alert-danger">
                    <h4>Order not found</h4>
                    <p>The requested order could not be found or the data is not available.</p>
                </div>
            </c:when>
            <c:otherwise>
                <!-- Basic Order Info -->
                <div class="card mb-4">
                    <div class="card-header">
                        <h5 class="mb-0">Order #${order.orderId}</h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <p><strong>Order ID:</strong> ${order.orderId}</p>
                                <p><strong>User ID:</strong> ${order.userId}</p>
                                <p><strong>Status:</strong> ${order.status}</p>
                                <p><strong>Order Date:</strong> ${order.orderDate}</p>
                                <p><strong>Subtotal:</strong> $${order.subtotal}</p>
                                <p><strong>Tax:</strong> $${order.tax}</p>
                                <p><strong>Shipping:</strong> $${order.shippingCost}</p>
                                <p><strong>Total:</strong> $${order.total}</p>
                            </div>
                            <div class="col-md-6">
                                <p><strong>Email:</strong> ${order.contactEmail}</p>
                                <p><strong>Phone:</strong> ${order.contactPhone}</p>
                                <p><strong>Shipping Address:</strong> ${order.shippingAddress}</p>
                                <p><strong>Billing Address:</strong> ${order.billingAddress}</p>
                                <c:if test="${not empty order.trackingNumber}">
                                    <p><strong>Tracking #:</strong> ${order.trackingNumber}</p>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Order Items -->
                <div class="card mb-4">
                    <div class="card-header">
                        <h5 class="mb-0">Order Items</h5>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${empty order.items}">
                                <p class="text-muted">No items found in this order.</p>
                            </c:when>
                            <c:otherwise>
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th>Product</th>
                                            <th>Type</th>
                                            <th>Price</th>
                                            <th>Qty</th>
                                            <th>Total</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="item" items="${order.items}">
                                            <tr>
                                                <td>${item.title} <br><small>${item.author}</small></td>
                                                <td>${item.bookType}</td>
                                                <td>$${item.price}</td>
                                                <td>${item.quantity}</td>
                                                <td>$${item.price * item.quantity}</td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="d-flex gap-2 mb-4">
                    <c:if test="${order.status != 'CANCELLED' && order.status != 'DELIVERED'}">
                        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#updateStatusModal">
                            Update Status
                        </button>
                    </c:if>

                    <c:if test="${sessionScope.isSuperAdmin}">
                        <button type="button" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#deleteOrderModal">
                            Delete Order
                        </button>
                    </c:if>
                </div>

                <!-- Update Status Modal -->
                <div class="modal fade" id="updateStatusModal" tabindex="-1" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">Update Order Status</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <form action="${pageContext.request.contextPath}/admin/update-order-status" method="post">
                                <div class="modal-body">
                                    <input type="hidden" name="orderId" value="${order.orderId}">

                                    <div class="mb-3">
                                        <label for="status" class="form-label">Status</label>
                                        <select class="form-select" id="status" name="status" required>
                                            <option value="PENDING" ${order.status == 'PENDING' ? 'selected' : ''}>Pending</option>
                                            <option value="PROCESSING" ${order.status == 'PROCESSING' ? 'selected' : ''}>Processing</option>
                                            <option value="SHIPPED" ${order.status == 'SHIPPED' ? 'selected' : ''}>Shipped</option>
                                            <option value="DELIVERED" ${order.status == 'DELIVERED' ? 'selected' : ''}>Delivered</option>
                                            <option value="CANCELLED" ${order.status == 'CANCELLED' ? 'selected' : ''}>Cancelled</option>
                                        </select>
                                    </div>

                                    <div class="mb-3">
                                        <label for="trackingNumber" class="form-label">Tracking Number</label>
                                        <input type="text" class="form-control" id="trackingNumber" name="trackingNumber"
                                            value="${order.trackingNumber}" placeholder="Enter tracking number if shipping">
                                    </div>

                                    <div class="mb-3">
                                        <label for="notes" class="form-label">Add Notes</label>
                                        <textarea class="form-control" id="notes" name="notes" rows="3"
                                                placeholder="Add notes about this status update"></textarea>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                    <button type="submit" class="btn btn-primary">Update Status</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- Delete Order Modal -->
                <div class="modal fade" id="deleteOrderModal" tabindex="-1" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">Delete Order</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <p>Are you sure you want to delete this order? This action cannot be undone.</p>
                                <div class="alert alert-danger">
                                    <i class="fas fa-exclamation-triangle me-2"></i> Warning: This will permanently remove all order data.
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                <form action="${pageContext.request.contextPath}/admin/delete-order" method="post">
                                    <input type="hidden" name="orderId" value="${order.orderId}">
                                    <input type="hidden" name="confirm" value="yes">
                                    <button type="submit" class="btn btn-danger">Delete Order</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- FontAwesome -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/js/all.min.js"></script>
</body>
</html>
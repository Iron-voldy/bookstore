<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/includes/header.jsp">
    <jsp:param name="pageTitle" value="Order Details - BookVerse" />
</jsp:include>

<div class="container my-5">
    <!-- Breadcrumb -->
    <nav aria-label="breadcrumb" class="mb-4">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Home</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/order-history">Order History</a></li>
            <li class="breadcrumb-item active" aria-current="page">Order #${order.orderId.substring(0, 8)}</li>
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

    <!-- Order Progress -->
    <div class="card mb-4">
        <div class="card-body">
            <div class="row">
                <div class="col-12">
                    <ul class="progress-indicator">
                        <li class="completed">
                            <span class="bubble"></span>
                            <span class="text">Order Placed</span>
                            <span class="date"><fmt:formatDate value="${order.orderDate}" pattern="MMM d, yyyy" /></span>
                        </li>
                        <li class="${order.status == 'PENDING' ? 'active' : (order.status == 'PROCESSING' || order.status == 'SHIPPED' || order.status == 'DELIVERED' ? 'completed' : '')}">
                            <span class="bubble"></span>
                            <span class="text">Processing</span>
                        </li>
                        <li class="${order.status == 'SHIPPED' || order.status == 'DELIVERED' ? 'completed' : (order.status == 'CANCELLED' ? 'danger' : '')}">
                            <span class="bubble"></span>
                            <span class="text">Shipped</span>
                            <c:if test="${order.shippedDate != null}">
                                <span class="date"><fmt:formatDate value="${order.shippedDate}" pattern="MMM d, yyyy" /></span>
                            </c:if>
                        </li>
                        <li class="${order.status == 'DELIVERED' ? 'completed' : (order.status == 'CANCELLED' ? 'danger' : '')}">
                            <span class="bubble"></span>
                            <span class="text">Delivered</span>
                            <c:if test="${order.deliveredDate != null}">
                                <span class="date"><fmt:formatDate value="${order.deliveredDate}" pattern="MMM d, yyyy" /></span>
                            </c:if>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <!-- Order Details -->
        <div class="col-lg-8">
            <div class="card mb-4">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">Order Items</h5>
                    <span class="text-muted small">
                        Placed on <fmt:formatDate value="${order.orderDate}" pattern="MMMM d, yyyy h:mm a" />
                    </span>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-dark">
                            <thead>
                                <tr>
                                    <th>Product</th>
                                    <th>Price</th>
                                    <th>Quantity</th>
                                    <th class="text-end">Total</th>
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
                                                <span class="badge ${item.bookType == 'EBOOK' ? 'bg-primary' : 'bg-accent'}">
                                                    ${item.bookType == 'EBOOK' ? 'E-Book' : 'Physical Book'}
                                                </span>
                                            </c:if>
                                        </td>
                                        <td>$<fmt:formatNumber value="${item.discountedPrice}" pattern="0.00" /></td>
                                        <td>${item.quantity}</td>
                                        <td class="text-end">$<fmt:formatNumber value="${item.discountedPrice * item.quantity}" pattern="0.00" /></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                            <tfoot>
                                <tr>
                                    <td colspan="3" class="text-end">Subtotal:</td>
                                    <td class="text-end">$<fmt:formatNumber value="${order.subtotal}" pattern="0.00" /></td>
                                </tr>
                                <tr>
                                    <td colspan="3" class="text-end">Tax:</td>
                                    <td class="text-end">$<fmt:formatNumber value="${order.tax}" pattern="0.00" /></td>
                                </tr>
                                <tr>
                                    <td colspan="3" class="text-end">Shipping:</td>
                                    <td class="text-end">$<fmt:formatNumber value="${order.shippingCost}" pattern="0.00" /></td>
                                </tr>
                                <tr>
                                    <td colspan="3" class="text-end fw-bold">Total:</td>
                                    <td class="text-end fw-bold text-accent">$<fmt:formatNumber value="${order.total}" pattern="0.00" /></td>
                                </tr>
                            </tfoot>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Shipping Information -->
            <c:if test="${not empty order.trackingNumber && order.status == 'SHIPPED'}">
                <div class="card mb-4">
                    <div class="card-header">
                        <h5 class="mb-0">Shipping Information</h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <h6>Tracking Number</h6>
                                <p class="mb-0">${order.trackingNumber}</p>
                            </div>
                            <div class="col-md-6">
                                <h6>Shipped Date</h6>
                                <p class="mb-0"><fmt:formatDate value="${order.shippedDate}" pattern="MMMM d, yyyy" /></p>
                            </div>
                        </div>

                        <div class="mt-3">
                            <a href="#" class="btn btn-sm btn-outline-light" target="_blank">
                                <i class="fas fa-truck me-1"></i> Track Package
                            </a>
                        </div>
                    </div>
                </div>
            </c:if>

            <!-- E-Book Download Section -->
            <c:if test="${order.status != 'CANCELLED' && order.status != 'PENDING'}">
                <c:set var="hasEbooks" value="false" />
                <c:forEach var="item" items="${order.items}">
                    <c:if test="${item.bookType == 'EBOOK'}">
                        <c:set var="hasEbooks" value="true" />
                    </c:if>
                </c:forEach>

                <c:if test="${hasEbooks}">
                    <div class="card mb-4">
                        <div class="card-header">
                            <h5 class="mb-0">E-Book Downloads</h5>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-dark">
                                    <thead>
                                        <tr>
                                            <th>Title</th>
                                            <th>Author</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="item" items="${order.items}">
                                            <c:if test="${item.bookType == 'EBOOK'}">
                                                <tr>
                                                    <td>${item.title}</td>
                                                    <td>${item.author}</td>
                                                    <td>
                                                        <a href="#" class="btn btn-sm btn-accent">
                                                            <i class="fas fa-download me-1"></i> Download
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:if>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </c:if>
            </c:if>
        </div>

        <!-- Order Summary Sidebar -->
        <div class="col-lg-4">
            <!-- Payment Information -->
            <div class="card mb-4">
                <div class="card-header">
                    <h5 class="mb-0">Payment Information</h5>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${order.payment != null && order.payment.successful}">
                            <div class="d-flex align-items-center mb-3">
                                <div class="me-3">
                                    <i class="fas fa-check-circle text-success fa-2x"></i>
                                </div>
                                <div>
                                    <h6 class="mb-0">Payment Successful</h6>
                                    <p class="text-muted mb-0 small">
                                        <fmt:formatDate value="${order.payment.paymentDate}" pattern="MMMM d, yyyy h:mm a" />
                                    </p>
                                </div>
                            </div>

                            <div class="mb-3">
                                <h6>Payment Method</h6>
                                <p class="mb-0">
                                    ${order.payment.paymentMethod.displayName}
                                    <c:if test="${not empty order.payment.paymentDetails}">
                                        <br><small class="text-muted">${order.payment.paymentDetails}</small>
                                    </c:if>
                                </p>
                            </div>

                            <div>
                                <h6>Transaction ID</h6>
                                <p class="mb-0 text-muted small">${order.payment.transactionId}</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="d-flex align-items-center mb-3">
                                <div class="me-3">
                                    <i class="fas fa-exclamation-circle text-warning fa-2x"></i>
                                </div>
                                <div>
                                    <h6 class="mb-0">Payment Pending</h6>
                                    <p class="text-muted mb-0 small">
                                        Please complete payment to process your order.
                                    </p>
                                </div>
                            </div>

                            <a href="${pageContext.request.contextPath}/process-payment" class="btn btn-accent">
                                <i class="fas fa-credit-card me-2"></i> Complete Payment
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

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
                        <button class="btn btn-outline-light" data-bs-toggle="modal" data-bs-target="#returnModal">
                            <i class="fas fa-undo me-2"></i> Return or Exchange
                        </button>
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

<!-- Return Modal -->
<div class="modal fade" id="returnModal" tabindex="-1" aria-labelledby="returnModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content bg-dark text-light">
            <div class="modal-header">
                <h5 class="modal-title" id="returnModalLabel">Return or Exchange</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>To initiate a return or exchange for this order, please contact our customer support team.</p>
                <p>Our team will guide you through the return process and provide you with a return shipping label if needed.</p>
                <div class="mt-3">
                    <h6>Return Policy:</h6>
                    <ul>
                        <li>Returns must be initiated within 30 days of delivery</li>
                        <li>Books must be in original condition</li>
                        <li>E-books are eligible for return only if not downloaded</li>
                    </ul>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-light" data-bs-dismiss="modal">Close</button>
                <a href="${pageContext.request.contextPath}/contact" class="btn btn-accent">
                    <i class="fas fa-headset me-2"></i> Contact Support
                </a>
            </div>
        </div>
    </div>
</div>

<style>
    /* Progress Indicator Styles */
    .progress-indicator {
        display: flex;
        list-style: none;
        padding: 0;
        margin: 0;
        justify-content: space-between;
    }

    .progress-indicator li {
        flex: 1;
        position: relative;
        text-align: center;
        padding: 0 10px;
    }

    .progress-indicator li:not(:last-child):after {
        content: '';
        position: absolute;
        top: 15px;
        left: 50%;
        width: 100%;
        height: 2px;
        background-color: var(--border-color);
        z-index: 1;
    }

    .progress-indicator li.completed:not(:last-child):after {
        background-color: var(--accent-color);
    }

    .progress-indicator li.danger:not(:last-child):after {
        background-color: var(--danger-color);
    }

    .progress-indicator .bubble {
        width: 30px;
        height: 30px;
        border-radius: 50%;
        background-color: var(--card-bg);
        border: 2px solid var(--border-color);
        display: block;
        margin: 0 auto 10px;
        position: relative;
        z-index: 2;
    }

    .progress-indicator li.completed .bubble {
        background-color: var(--accent-color);
        border-color: var(--accent-color);
    }

    .progress-indicator li.active .bubble {
        border-color: var(--accent-color);
        border-width: 3px;
    }

    .progress-indicator li.danger .bubble {
        background-color: var(--danger-color);
        border-color: var(--danger-color);
    }

    .progress-indicator .text {
        display: block;
        font-weight: 500;
        margin-bottom: 5px;
    }

    .progress-indicator .date {
        display: block;
        font-size: 0.8rem;
        color: var(--text-secondary);
    }
</style>

<jsp:include page="/includes/footer.jsp" />
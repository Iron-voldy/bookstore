<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/includes/header.jsp">
    <jsp:param name="pageTitle" value="Order Confirmation - BookVerse" />
</jsp:include>

<div class="container my-5">
    <div class="text-center mb-5">
        <div class="mb-4">
            <i class="fas fa-check-circle text-success" style="font-size: 5rem;"></i>
        </div>
        <h1 class="mb-3">Thank You for Your Order!</h1>
        <p class="lead">Your order has been received and is being processed.</p>

        <div class="d-inline-block mt-3 p-3 bg-dark rounded">
            <p class="mb-0">Order Number: <strong class="text-accent">#${order.orderId.substring(0, 8)}</strong></p>
            <p class="small text-muted mb-0">Please save this order number for your reference.</p>
        </div>
    </div>

    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card mb-4">
                <div class="card-header">
                    <h5 class="mb-0">Order Summary</h5>
                </div>
                <div class="card-body">
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <h6>Order Date</h6>
                            <p><fmt:formatDate value="${order.orderDate}" pattern="MMMM d, yyyy h:mm a" /></p>

                            <h6>Payment Method</h6>
                            <p>
                                <c:choose>
                                    <c:when test="${order.payment != null && order.payment.paymentMethod != null}">
                                        ${order.payment.paymentMethod.displayName}
                                        <c:if test="${not empty order.payment.paymentDetails}">
                                            <br><small class="text-muted">${order.payment.paymentDetails}</small>
                                        </c:if>
                                    </c:when>
                                    <c:otherwise>Payment Pending</c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                        <div class="col-md-6">
                            <h6>Shipping Address</h6>
                            <p class="mb-0">${order.shippingAddress}</p>
                        </div>
                    </div>

                    <!-- Order Items -->
                    <h6 class="mb-3">Order Items</h6>
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

            <div class="alert alert-info" role="alert">
                <div class="d-flex">
                    <div class="me-3">
                        <i class="fas fa-info-circle fa-2x"></i>
                    </div>
                    <div>
                        <h5 class="alert-heading">What's Next?</h5>
                        <p class="mb-0">You will receive an email confirmation shortly. We will notify you once your order has been shipped.</p>
                        <p class="mb-0">Physical books typically ship within 1-2 business days. E-books are available for immediate download from your account.</p>
                    </div>
                </div>
            </div>

            <div class="d-flex justify-content-between mt-4">
                <a href="${pageContext.request.contextPath}/" class="btn btn-outline-light">
                    <i class="fas fa-home me-2"></i> Continue Shopping
                </a>
                <a href="<%=request.getContextPath()%>/order-details?orderId=${order.orderId}" class="btn btn-accent">
                    <i class="fas fa-file-alt me-2"></i> View Order Details
                </a>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
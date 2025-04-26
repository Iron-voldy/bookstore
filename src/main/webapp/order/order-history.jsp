<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/includes/header.jsp">
    <jsp:param name="pageTitle" value="Order History - BookVerse" />
</jsp:include>

<div class="container my-5">
    <h2 class="mb-4"><i class="fas fa-history me-2"></i>Order History</h2>

    <!-- Filter Controls -->
    <div class="card mb-4">
        <div class="card-body">
            <form action="${pageContext.request.contextPath}/order-history" method="get" class="row g-3 align-items-end">
                <div class="col-md-4">
                    <label for="status" class="form-label">Filter by Status</label>
                    <select class="form-select" id="status" name="status" onchange="this.form.submit()">
                        <option value="" ${empty statusFilter ? 'selected' : ''}>All Orders</option>
                        <c:forEach var="status" items="${statuses}">
                            <option value="${status}" ${status == statusFilter ? 'selected' : ''}>
                                ${status.displayName}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-2 d-flex align-items-end">
                    <a href="${pageContext.request.contextPath}/order-history" class="btn btn-outline-light">
                        <i class="fas fa-sync-alt me-1"></i> Reset
                    </a>
                </div>
            </form>
        </div>
    </div>

    <!-- Orders List -->
    <c:choose>
        <c:when test="${empty orders}">
            <div class="card">
                <div class="card-body text-center py-5">
                    <i class="fas fa-shopping-bag fa-4x mb-3" style="color: var(--border-color);"></i>
                    <h3>No Orders Found</h3>
                    <p class="text-muted">You haven't placed any orders yet.</p>
                    <a href="${pageContext.request.contextPath}/books" class="btn btn-accent mt-2">
                        <i class="fas fa-shopping-cart me-2"></i> Start Shopping
                    </a>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="table-responsive">
                <table class="table table-dark table-hover">
                    <thead>
                        <tr>
                            <th>Order #</th>
                            <th>Date</th>
                            <th>Items</th>
                            <th>Total</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="order" items="${orders}">
                            <tr>
                                <td>${order.orderId.substring(0, 8)}</td>
                                <td><fmt:formatDate value="${order.orderDate}" pattern="MMM d, yyyy" /></td>
                                <td>${order.totalItems} item(s)</td>
                                <td>$<fmt:formatNumber value="${order.total}" pattern="0.00" /></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${order.status == 'PENDING'}">
                                            <span class="badge bg-warning text-dark">Pending</span>
                                        </c:when>
                                        <c:when test="${order.status == 'PROCESSING'}">
                                            <span class="badge bg-primary">Processing</span>
                                        </c:when>
                                        <c:when test="${order.status == 'SHIPPED'}">
                                            <span class="badge bg-info text-dark">Shipped</span>
                                        </c:when>
                                        <c:when test="${order.status == 'DELIVERED'}">
                                            <span class="badge bg-success">Delivered</span>
                                        </c:when>
                                        <c:when test="${order.status == 'CANCELLED'}">
                                            <span class="badge bg-danger">Cancelled</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary">${order.status}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/order-details?orderId=${order.orderId}"
                                       class="btn btn-sm btn-accent">
                                        <i class="fas fa-eye me-1"></i> View
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="/includes/footer.jsp" />
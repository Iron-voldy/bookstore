<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Details - Admin Dashboard</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        /* Existing styles remain the same */
    </style>
</head>
<body>
    <%
        // Safe date formatting
        SimpleDateFormat fullDateFormat = new SimpleDateFormat("MMMM d, yyyy h:mm a");
    %>
    <div class="container order-details-container">
        <div class="card">
            <!-- Header remains the same -->
            <div class="card-body">
                <!-- Previous sections remain the same -->

                <!-- Order Items Section with Safe Numeric Handling -->
                <div class="row mb-4">
                    <div class="col-12">
                        <h5>Order Items</h5>
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
                                <c:choose>
                                    <c:when test="${not empty order.items}">
                                        <c:forEach var="item" items="${order.items}">
                                            <tr>
                                                <td>
                                                    <strong>${item.title}</strong><br>
                                                    <small class="text-muted">${item.author}</small>
                                                </td>
                                                <td>
                                                    <span class="badge
                                                        ${item.bookType == 'EBOOK' ? 'bg-primary' :
                                                          item.bookType == 'PHYSICAL' ? 'bg-success' : 'bg-secondary'}">
                                                        ${item.bookType}
                                                    </span>
                                                </td>
                                                <td class="text-end">
                                                    <fmt:formatNumber value="${item.discountedPrice > 0 ? item.discountedPrice : item.price}" pattern="$0.00"/>
                                                </td>
                                                <td class="text-center">${item.quantity}</td>
                                                <td class="text-end">
                                                    <fmt:formatNumber value="${(item.discountedPrice > 0 ? item.discountedPrice : item.price) * item.quantity}" pattern="$0.00"/>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="5" class="text-center">No items in this order</td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                            <tfoot>
                                <tr>
                                    <td colspan="4" class="text-end"><strong>Subtotal:</strong></td>
                                    <td class="text-end">
                                        <c:choose>
                                            <c:when test="${calculatedSubtotal != null && calculatedSubtotal > 0}">
                                                <fmt:formatNumber value="${calculatedSubtotal}" pattern="$0.00"/>
                                            </c:when>
                                            <c:when test="${order.subtotal != null && order.subtotal > 0}">
                                                <fmt:formatNumber value="${order.subtotal}" pattern="$0.00"/>
                                            </c:when>
                                            <c:otherwise>
                                                $0.00
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" class="text-end"><strong>Tax:</strong></td>
                                    <td class="text-end">
                                        <c:choose>
                                            <c:when test="${calculatedTax != null && calculatedTax > 0}">
                                                <fmt:formatNumber value="${calculatedTax}" pattern="$0.00"/>
                                            </c:when>
                                            <c:when test="${order.tax != null && order.tax > 0}">
                                                <fmt:formatNumber value="${order.tax}" pattern="$0.00"/>
                                            </c:when>
                                            <c:otherwise>
                                                $0.00
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" class="text-end"><strong>Total:</strong></td>
                                    <td class="text-end">
                                        <strong>
                                            <c:choose>
                                                <c:when test="${calculatedTotal != null && calculatedTotal > 0}">
                                                    <fmt:formatNumber value="${calculatedTotal}" pattern="$0.00"/>
                                                </c:when>
                                                <c:when test="${order.total != null && order.total > 0}">
                                                    <fmt:formatNumber value="${order.total}" pattern="$0.00"/>
                                                </c:when>
                                                <c:otherwise>
                                                    $0.00
                                                </c:otherwise>
                                            </c:choose>
                                        </strong>
                                    </td>
                                </tr>
                            </tfoot>
                        </table>
                    </div>
                </div>

                <!-- Rest of the page remains the same -->
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
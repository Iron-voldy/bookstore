<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/includes/header.jsp">
    <jsp:param name="pageTitle" value="Checkout - BookVerse" />
</jsp:include>

<div class="container my-5">
    <h2 class="mb-4"><i class="fas fa-shopping-cart me-2"></i>Checkout</h2>

    <!-- Breadcrumb -->
    <nav aria-label="breadcrumb" class="mb-4">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Home</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/cart">Cart</a></li>
            <li class="breadcrumb-item active" aria-current="page">Checkout</li>
        </ol>
    </nav>

    <div class="row">
        <!-- Checkout Form -->
        <div class="col-lg-8 mb-4">
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0">Shipping & Billing Information</h5>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/checkout" method="post">
                        <!-- Contact Information -->
                        <h6 class="mb-3">Contact Information</h6>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="contactEmail" class="form-label">Email Address*</label>
                                <input type="email" class="form-control" id="contactEmail" name="contactEmail"
                                    value="${user.email}" required>
                            </div>
                            <div class="col-md-6">
                                <label for="contactPhone" class="form-label">Phone Number*</label>
                                <input type="tel" class="form-control" id="contactPhone" name="contactPhone"
                                    placeholder="(123) 456-7890" required>
                            </div>
                        </div>

                        <!-- Shipping Address -->
                        <h6 class="mb-3 mt-4">Shipping Address</h6>
                        <div class="mb-3">
                            <label for="shippingAddress" class="form-label">Full Address*</label>
                            <textarea class="form-control" id="shippingAddress" name="shippingAddress" rows="3"
                                placeholder="Street Address, City, State, Zip Code" required></textarea>
                        </div>

                        <!-- Billing Address -->
                        <h6 class="mb-3 mt-4">Billing Address</h6>
                        <div class="form-check mb-3">
                            <input class="form-check-input" type="checkbox" id="sameAsBilling" name="sameAsBilling">
                            <label class="form-check-label" for="sameAsBilling">
                                Same as shipping address
                            </label>
                        </div>
                        <div id="billingAddressSection" class="mb-3">
                            <label for="billingAddress" class="form-label">Full Address*</label>
                            <textarea class="form-control" id="billingAddress" name="billingAddress" rows="3"
                                placeholder="Street Address, City, State, Zip Code" required></textarea>
                        </div>

                        <div class="d-grid mt-4">
                            <form action="<%=request.getContextPath()%>/process-payment" method="post">
                                <!-- Existing form content -->
                                <button type="submit" class="btn btn-accent">
                                    <i class="fas fa-credit-card me-2"></i> Proceed to Payment
                                </button>
                            </form>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Order Summary -->
        <div class="col-lg-4">
            <div class="card sticky-top" style="top: 20px">
                <div class="card-header">
                    <h5 class="mb-0">Order Summary</h5>
                </div>
                <div class="card-body">
                    <!-- Cart Items -->
                    <div class="mb-3">
                        <h6 class="mb-3">Items in Cart (${cart.size()})</h6>
                        <div class="table-responsive">
                            <table class="table table-sm table-dark">
                                <c:forEach var="item" items="${cart}">
                                    <c:set var="book" value="${cartBooks[item.key]}" />
                                    <tr>
                                        <td>
                                            <strong>${book.title}</strong><br>
                                            <small class="text-muted">Qty: ${item.value}</small>
                                        </td>
                                        <td class="text-end">
                                            $<fmt:formatNumber value="${book.discountedPrice * item.value}" pattern="0.00" />
                                        </td>
                                    </tr>
                                </c:forEach>
                            </table>
                        </div>
                    </div>

                    <!-- Price Breakdown -->
                    <div class="mb-3">
                        <div class="d-flex justify-content-between mb-2">
                            <span>Subtotal:</span>
                            <span>$<fmt:formatNumber value="${subtotal}" pattern="0.00" /></span>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span>Tax (7%):</span>
                            <span>$<fmt:formatNumber value="${tax}" pattern="0.00" /></span>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span>Shipping:</span>
                            <c:choose>
                                <c:when test="${shipping > 0}">
                                    <span>$<fmt:formatNumber value="${shipping}" pattern="0.00" /></span>
                                </c:when>
                                <c:otherwise>
                                    <span class="text-success">Free</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <hr>
                        <div class="d-flex justify-content-between fw-bold">
                            <span>Total:</span>
                            <span class="text-accent">$<fmt:formatNumber value="${total}" pattern="0.00" /></span>
                        </div>
                    </div>
                </div>
                <div class="card-footer">
                    <a href="${pageContext.request.contextPath}/cart" class="btn btn-outline-light w-100">
                        <i class="fas fa-arrow-left me-2"></i> Back to Cart
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    // Toggle billing address section based on checkbox
    document.getElementById('sameAsBilling').addEventListener('change', function() {
        const billingSection = document.getElementById('billingAddressSection');
        billingSection.style.display = this.checked ? 'none' : 'block';

        if (this.checked) {
            document.getElementById('billingAddress').value = document.getElementById('shippingAddress').value;
        } else {
            document.getElementById('billingAddress').value = '';
        }
    });

    // Update billing address when shipping address changes (if checkbox is checked)
    document.getElementById('shippingAddress').addEventListener('input', function() {
        if (document.getElementById('sameAsBilling').checked) {
            document.getElementById('billingAddress').value = this.value;
        }
    });
</script>

<jsp:include page="/includes/footer.jsp" />
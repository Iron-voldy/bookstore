<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.bookstore.model.order.Order" %>
<%@ page import="com.bookstore.model.order.OrderItem" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Order Details</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <h1>Order Details</h1>

        <%
        Order order = (Order)request.getAttribute("order");
        if (order == null) {
        %>
            <div class="alert alert-danger">Order not found</div>
        <%
        } else {
            // Format for currency
            DecimalFormat df = new DecimalFormat("0.00");

            // Format for dates
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        %>
            <div class="card mb-4">
                <div class="card-header">
                    <h3>Order #<%= order.getOrderId() %></h3>
                    <div>Status: <%= order.getStatus() %></div>
                </div>
                <div class="card-body">
                    <h4>Basic Information</h4>
                    <table class="table">
                        <tr>
                            <th>Order ID:</th>
                            <td><%= order.getOrderId() %></td>
                        </tr>
                        <tr>
                            <th>User ID:</th>
                            <td><%= order.getUserId() %></td>
                        </tr>
                        <tr>
                            <th>Order Date:</th>
                            <td><%= order.getOrderDate() != null ? dateFormat.format(order.getOrderDate()) : "N/A" %></td>
                        </tr>
                        <tr>
                            <th>Contact Email:</th>
                            <td><%= order.getContactEmail() %></td>
                        </tr>
                        <tr>
                            <th>Contact Phone:</th>
                            <td><%= order.getContactPhone() %></td>
                        </tr>
                        <tr>
                            <th>Shipping Address:</th>
                            <td><%= order.getShippingAddress() %></td>
                        </tr>
                        <tr>
                            <th>Billing Address:</th>
                            <td><%= order.getBillingAddress() %></td>
                        </tr>
                    </table>

                    <h4 class="mt-4">Order Items</h4>
                    <% if (order.getItems() == null || order.getItems().isEmpty()) { %>
                        <div class="alert alert-warning">No items in this order</div>
                    <% } else { %>
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>Product</th>
                                    <th>Type</th>
                                    <th>Price</th>
                                    <th>Quantity</th>
                                    <th>Subtotal</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (OrderItem item : order.getItems()) { %>
                                    <tr>
                                        <td>
                                            <strong><%= item.getTitle() %></strong>
                                            <% if (item.getAuthor() != null && !item.getAuthor().isEmpty()) { %>
                                                <br><small>by <%= item.getAuthor() %></small>
                                            <% } %>
                                        </td>
                                        <td><%= item.getBookType() %></td>
                                        <td>
                                            <% if (item.getPrice() > item.getDiscountedPrice()) { %>
                                                <s>$<%= df.format(item.getPrice()) %></s><br>
                                            <% } %>
                                            $<%= df.format(item.getDiscountedPrice()) %>
                                        </td>
                                        <td><%= item.getQuantity() %></td>
                                        <td>$<%= df.format(item.getQuantity() * item.getDiscountedPrice()) %></td>
                                    </tr>
                                <% } %>
                            </tbody>
                            <tfoot>
                                <tr>
                                    <td colspan="4" class="text-end"><strong>Subtotal:</strong></td>
                                    <td>$<%= df.format(order.getSubtotal()) %></td>
                                </tr>
                                <tr>
                                    <td colspan="4" class="text-end"><strong>Tax:</strong></td>
                                    <td>$<%= df.format(order.getTax()) %></td>
                                </tr>
                                <tr>
                                    <td colspan="4" class="text-end"><strong>Shipping:</strong></td>
                                    <td>$<%= df.format(order.getShippingCost()) %></td>
                                </tr>
                                <tr>
                                    <td colspan="4" class="text-end"><strong>Total:</strong></td>
                                    <td><strong>$<%= df.format(order.getTotal()) %></strong></td>
                                </tr>
                            </tfoot>
                        </table>
                    <% } %>

                    <div class="mt-4">
                        <% if (order.getStatus() != null && !order.getStatus().equals("CANCELLED") && !order.getStatus().equals("DELIVERED")) { %>
                            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#updateStatusModal">
                                Update Status
                            </button>
                        <% } %>

                        <%-- Check if user is super admin --%>
                        <% Boolean isSuperAdmin = (Boolean)session.getAttribute("isSuperAdmin");
                           if (isSuperAdmin != null && isSuperAdmin) { %>
                            <button class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#deleteOrderModal">
                                Delete Order
                            </button>
                        <% } %>
                    </div>
                </div>
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
                                <input type="hidden" name="orderId" value="<%= order.getOrderId() %>">

                                <div class="mb-3">
                                    <label for="status" class="form-label">Status</label>
                                    <select class="form-select" id="status" name="status" required>
                                        <option value="PENDING" <%= "PENDING".equals(order.getStatus()) ? "selected" : "" %>>Pending</option>
                                        <option value="PROCESSING" <%= "PROCESSING".equals(order.getStatus()) ? "selected" : "" %>>Processing</option>
                                        <option value="SHIPPED" <%= "SHIPPED".equals(order.getStatus()) ? "selected" : "" %>>Shipped</option>
                                        <option value="DELIVERED" <%= "DELIVERED".equals(order.getStatus()) ? "selected" : "" %>>Delivered</option>
                                        <option value="CANCELLED" <%= "CANCELLED".equals(order.getStatus()) ? "selected" : "" %>>Cancelled</option>
                                    </select>
                                </div>

                                <div class="mb-3">
                                    <label for="trackingNumber" class="form-label">Tracking Number</label>
                                    <input type="text" class="form-control" id="trackingNumber" name="trackingNumber"
                                           value="<%= order.getTrackingNumber() != null ? order.getTrackingNumber() : "" %>"
                                           placeholder="Enter tracking number if shipping">
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
                                <input type="hidden" name="orderId" value="<%= order.getOrderId() %>">
                                <input type="hidden" name="confirm" value="yes">
                                <button type="submit" class="btn btn-danger">Delete Order</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        <% } %>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
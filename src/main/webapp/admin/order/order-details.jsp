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
     <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

       <style>
        body {
            background-color: #f8f9fa;
        }
        .card {
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        .back-button {
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1>Order Details</h1>
            <a href="<%= request.getContextPath() %>/admin/orders" class="btn btn-secondary back-button">
                Back to Orders
            </a>
        </div>

        <%
        // Check for messages in session
        String successMessage = (String)session.getAttribute("successMessage");
        if (successMessage != null) {
        %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <%= successMessage %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <%
            session.removeAttribute("successMessage");
        }

        String errorMessage = (String)session.getAttribute("errorMessage");
        if (errorMessage != null) {
        %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <%= errorMessage %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <%
            session.removeAttribute("errorMessage");
        }

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

            // Order status styling
            String statusBadgeClass = "bg-secondary";
            if (order.getStatus() != null) {
                if (order.getStatus().equals("PENDING")) {
                    statusBadgeClass = "bg-warning text-dark";
                } else if (order.getStatus().equals("PROCESSING")) {
                    statusBadgeClass = "bg-primary";
                } else if (order.getStatus().equals("SHIPPED")) {
                    statusBadgeClass = "bg-info";
                } else if (order.getStatus().equals("DELIVERED")) {
                    statusBadgeClass = "bg-success";
                } else if (order.getStatus().equals("CANCELLED")) {
                    statusBadgeClass = "bg-danger";
                }
            }
        %>
            <div class="card mb-4">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h3 class="mb-0">Order #<%= order.getOrderId() %></h3>
                    <span class="badge <%= statusBadgeClass %>"><%= order.getStatus() %></span>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6">
                            <h4>Order Information</h4>
                            <table class="table table-striped">
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
                                <% if (order.getShippedDate() != null) { %>
                                <tr>
                                    <th>Shipped Date:</th>
                                    <td><%= dateFormat.format(order.getShippedDate()) %></td>
                                </tr>
                                <% } %>
                                <% if (order.getDeliveredDate() != null) { %>
                                <tr>
                                    <th>Delivered Date:</th>
                                    <td><%= dateFormat.format(order.getDeliveredDate()) %></td>
                                </tr>
                                <% } %>
                                <% if (order.getTrackingNumber() != null && !order.getTrackingNumber().isEmpty()) { %>
                                <tr>
                                    <th>Tracking Number:</th>
                                    <td><%= order.getTrackingNumber() %></td>
                                </tr>
                                <% } %>
                            </table>
                        </div>
                        <div class="col-md-6">
                            <h4>Customer Information</h4>
                            <table class="table table-striped">
                                <tr>
                                    <th>Email:</th>
                                    <td><%= order.getContactEmail() != null ? order.getContactEmail() : "N/A" %></td>
                                </tr>
                                <tr>
                                    <th>Phone:</th>
                                    <td><%= order.getContactPhone() != null ? order.getContactPhone() : "N/A" %></td>
                                </tr>
                                <tr>
                                    <th>Shipping Address:</th>
                                    <td><%= order.getShippingAddress() != null ? order.getShippingAddress() : "N/A" %></td>
                                </tr>
                                <tr>
                                    <th>Billing Address:</th>
                                    <td><%= order.getBillingAddress() != null ? order.getBillingAddress() : "N/A" %></td>
                                </tr>
                                <%
                                Object customerObj = request.getAttribute("customer");
                                if (customerObj != null) {
                                    try {
                                        com.bookstore.model.user.User customer = (com.bookstore.model.user.User)customerObj;
                                %>
                                <tr>
                                    <th>Customer Name:</th>
                                    <td><%= customer.getFullName() %></td>
                                </tr>
                                <%
                                    } catch (Exception e) {
                                        // Handle the exception silently
                                    }
                                }
                                %>
                            </table>
                        </div>
                    </div>

                    <h4 class="mt-4">Order Items</h4>
                    <% if (order.getItems() == null || order.getItems().isEmpty()) { %>
                        <div class="alert alert-warning">No items in this order</div>
                    <% } else { %>
                        <div class="table-responsive">
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th>Product</th>
                                        <th>Type</th>
                                        <th>Price</th>
                                        <th class="text-center">Quantity</th>
                                        <th class="text-end">Subtotal</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (OrderItem item : order.getItems()) { %>
                                        <tr>
                                            <td>
                                                <strong><%= item.getTitle() %></strong>
                                                <% if (item.getAuthor() != null && !item.getAuthor().isEmpty()) { %>
                                                    <br><small class="text-muted">by <%= item.getAuthor() %></small>
                                                <% } %>
                                            </td>
                                            <td><span class="badge bg-secondary"><%= item.getBookType() %></span></td>
                                            <td>
                                                <% if (item.getPrice() > item.getDiscountedPrice()) { %>
                                                    <s class="text-muted">$<%= df.format(item.getPrice()) %></s><br>
                                                <% } %>
                                                $<%= df.format(item.getDiscountedPrice()) %>
                                            </td>
                                            <td class="text-center"><%= item.getQuantity() %></td>
                                            <td class="text-end">$<%= df.format(item.getQuantity() * item.getDiscountedPrice()) %></td>
                                        </tr>
                                    <% } %>
                                </tbody>
                                <tfoot class="table-light">
                                    <tr>
                                        <td colspan="4" class="text-end"><strong>Subtotal:</strong></td>
                                        <td class="text-end">$<%= df.format(order.getSubtotal()) %></td>
                                    </tr>
                                    <tr>
                                        <td colspan="4" class="text-end"><strong>Tax:</strong></td>
                                        <td class="text-end">$<%= df.format(order.getTax()) %></td>
                                    </tr>
                                    <tr>
                                        <td colspan="4" class="text-end"><strong>Shipping:</strong></td>
                                        <td class="text-end">$<%= df.format(order.getShippingCost()) %></td>
                                    </tr>
                                    <tr>
                                        <td colspan="4" class="text-end"><strong>Total:</strong></td>
                                        <td class="text-end"><strong>$<%= df.format(order.getTotal()) %></strong></td>
                                    </tr>
                                </tfoot>
                            </table>
                        </div>
                    <% } %>

                    <% if (order.getNotes() != null && !order.getNotes().isEmpty()) { %>
                    <div class="card mt-4">
                        <div class="card-header bg-dark text-white">
                            <h5 class="mb-0">Order Notes</h5>
                        </div>
                        <div class="card-body">
                            <pre class="mb-0"><%= order.getNotes() %></pre>
                        </div>
                    </div>
                    <% } %>

                    <div class="mt-4 d-flex gap-2">
                        <% if (order.getStatus() != null && !order.getStatus().equals("CANCELLED") && !order.getStatus().equals("DELIVERED")) { %>
                            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#updateStatusModal">
                                <i class="fas fa-edit me-2"></i> Update Status
                            </button>
                        <% } %>

                        <%-- Check if user is super admin --%>
                        <% Boolean isSuperAdmin = (Boolean)session.getAttribute("isSuperAdmin");
                           if (isSuperAdmin != null && isSuperAdmin) { %>
                            <button class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#deleteOrderModal">
                                <i class="fas fa-trash me-2"></i> Delete Order
                            </button>
                        <% } %>

                        <button type="button" class="btn btn-outline-secondary" onclick="window.print()">
                            <i class="fas fa-print me-2"></i> Print Order
                        </button>
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
                        <form action="<%= request.getContextPath() %>/admin/update-order-status" method="post">
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
                                    <div class="form-text">Required when marking as Shipped.</div>
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
                            <form action="<%= request.getContextPath() %>/admin/delete-order" method="post">
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

    <script src="<%= request.getContextPath() %>/assets/js/bootstrap.bundle.min.js"></script>
    <script>
        // JavaScript to handle tracking number requirement for shipped status
        document.addEventListener('DOMContentLoaded', function() {
            const statusSelect = document.getElementById('status');
            const trackingInput = document.getElementById('trackingNumber');

            if (statusSelect && trackingInput) {
                statusSelect.addEventListener('change', function() {
                    if (this.value === 'SHIPPED') {
                        trackingInput.setAttribute('required', 'required');
                        trackingInput.parentElement.classList.add('required');
                    } else {
                        trackingInput.removeAttribute('required');
                        trackingInput.parentElement.classList.remove('required');
                    }
                });

                // Initialize on page load
                if (statusSelect.value === 'SHIPPED') {
                    trackingInput.setAttribute('required', 'required');
                    trackingInput.parentElement.classList.add('required');
                }
            }
        });
    </script>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="com.bookstore.model.order.Order" %>
<%@ page import="com.bookstore.model.order.OrderStatus" %>
<%@ page import="com.bookstore.model.order.OrderItem" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.NumberFormat" %>

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
    <%
    // Get data from request attributes
    Order order = (Order)request.getAttribute("order");
    Object customer = request.getAttribute("customer");
    OrderStatus[] statuses = (OrderStatus[])request.getAttribute("statuses");

    // Get context path for URLs
    String contextPath = request.getContextPath();

    // Format values
    SimpleDateFormat dateFormat = new SimpleDateFormat("MMMM d, yyyy h:mm a");
    SimpleDateFormat dateOnlyFormat = new SimpleDateFormat("MMMM d, yyyy");
    NumberFormat currencyFormat = NumberFormat.getCurrencyInstance();

    // Get order ID substring
    String orderIdShort = "";
    if (order != null && order.getOrderId() != null) {
        orderIdShort = order.getOrderId().substring(0, Math.min(8, order.getOrderId().length()));
    }

    // Get status display
    String statusDisplay = order != null && order.getStatus() != null ? order.getStatus().name() : "UNKNOWN";

    // Get order values with default fallbacks
    double subtotal = order != null ? order.getSubtotal() : 0.0;
    double tax = order != null ? order.getTax() : 0.0;
    double shipping = order != null ? order.getShippingCost() : 0.0;
    double total = order != null ? order.getTotal() : 0.0;

    String notes = order != null && order.getNotes() != null ? order.getNotes() : "";
    String tracking = order != null && order.getTrackingNumber() != null ? order.getTrackingNumber() : "";
    %>

    <!-- Sidebar -->
    <div class="sidebar">
        <div class="sidebar-brand">
            <a href="<%= contextPath %>/admin/dashboard">
                <i class="fas fa-book-open me-2"></i> BookVerse Admin
            </a>
        </div>
        <ul class="sidebar-menu">
            <li>
                <a href="<%= contextPath %>/admin/dashboard">
                    <i class="fas fa-tachometer-alt"></i> Dashboard
                </a>
            </li>
            <li>
                <a href="<%= contextPath %>/admin/manage-books.jsp">
                    <i class="fas fa-book"></i> Books
                </a>
            </li>
            <li>
                <a href="<%= contextPath %>/admin/orders" class="active">
                    <i class="fas fa-shopping-cart"></i> Orders
                </a>
            </li>
            <li>
                <a href="<%= contextPath %>/admin/manage-users.jsp">
                    <i class="fas fa-users"></i> Users
                </a>
            </li>
            <c:if test="${sessionScope.isSuperAdmin}">
                <li>
                    <a href="<%= contextPath %>/admin/manage-admins">
                        <i class="fas fa-user-shield"></i> Admins
                    </a>
                </li>
            </c:if>
            <li>
                <a href="<%= contextPath %>/admin/logout">
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
            <a href="<%= contextPath %>/admin/orders" class="btn btn-outline-light">
                <i class="fas fa-arrow-left me-2"></i> Back to Orders
            </a>
        </div>

        <!-- Order Information -->
        <div class="card mb-4">
            <div class="card-header d-flex justify-content-between align-items-center">
                <span>Order #<%= orderIdShort %></span>
                <span class="order-status status-<%= statusDisplay %>">
                    <% if (order != null && order.getStatus() != null) {
                        switch(order.getStatus()) {
                            case PENDING: %>
                                Pending
                                <% break;
                            case PROCESSING: %>
                                Processing
                                <% break;
                            case SHIPPED: %>
                                Shipped
                                <% break;
                            case DELIVERED: %>
                                Delivered
                                <% break;
                            case CANCELLED: %>
                                Cancelled
                                <% break;
                            default: %>
                                <%= order.getStatus() %>
                        <% }
                    } else { %>
                        Unknown
                    <% } %>
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
                                    <% if (order != null && order.getOrderDate() != null) { %>
                                        <%= dateFormat.format(order.getOrderDate()) %>
                                    <% } else { %>
                                        N/A
                                    <% } %>
                                </td>
                            </tr>
                            <tr>
                                <th>Order Status:</th>
                                <td>
                                    <span class="order-status status-<%= statusDisplay %>">
                                        <% if (order != null && order.getStatus() != null) {
                                            switch(order.getStatus()) {
                                                case PENDING: %>
                                                    Pending
                                                    <% break;
                                                case PROCESSING: %>
                                                    Processing
                                                    <% break;
                                                case SHIPPED: %>
                                                    Shipped
                                                    <% break;
                                                case DELIVERED: %>
                                                    Delivered
                                                    <% break;
                                                case CANCELLED: %>
                                                    Cancelled
                                                    <% break;
                                                default: %>
                                                    <%= order.getStatus() %>
                                            <% }
                                        } else { %>
                                            Unknown
                                        <% } %>
                                    </span>
                                </td>
                            </tr>
                            <% if (order != null && order.getTrackingNumber() != null && !order.getTrackingNumber().isEmpty()) { %>
                                <tr>
                                    <th>Tracking Number:</th>
                                    <td><%= order.getTrackingNumber() %></td>
                                </tr>
                            <% } %>
                            <% if (order != null && order.getShippedDate() != null) { %>
                                <tr>
                                    <th>Shipped Date:</th>
                                    <td><%= dateOnlyFormat.format(order.getShippedDate()) %></td>
                                </tr>
                            <% } %>
                            <% if (order != null && order.getDeliveredDate() != null) { %>
                                <tr>
                                    <th>Delivered Date:</th>
                                    <td><%= dateOnlyFormat.format(order.getDeliveredDate()) %></td>
                                </tr>
                            <% } %>
                        </table>
                    </div>
                    <div class="col-md-6">
                        <h5>Customer Information</h5>
                        <table class="table table-borderless">
                            <tr>
                                <th>Customer Name:</th>
                                <td>
                                    <% if (request.getAttribute("customer") != null) { %>
                                        <%= ((Object)request.getAttribute("customer")).toString() %>
                                    <% } else { %>
                                        N/A
                                    <% } %>
                                </td>
                            </tr>
                            <tr>
                                <th>Email:</th>
                                <td><%= order != null ? order.getContactEmail() : "N/A" %></td>
                            </tr>
                            <tr>
                                <th>Phone:</th>
                                <td><%= order != null ? order.getContactPhone() : "N/A" %></td>
                            </tr>
                            <tr>
                                <th>User ID:</th>
                                <td><%= order != null ? order.getUserId() : "N/A" %></td>
                            </tr>
                        </table>
                    </div>
                </div>

                <div class="row mt-3">
                    <div class="col-md-6">
                        <h5>Shipping Address</h5>
                        <p class="border p-2"><%= order != null ? order.getShippingAddress() : "N/A" %></p>
                    </div>
                    <div class="col-md-6">
                        <h5>Billing Address</h5>
                        <p class="border p-2"><%= order != null ? order.getBillingAddress() : "N/A" %></p>
                    </div>
                </div>

                <div class="row mt-3">
                    <div class="col-md-12">
                        <h5>Payment Information</h5>
                        <% if (order != null && order.getPayment() != null) { %>
                            <table class="table table-borderless">
                                <tr>
                                    <th>Payment Method:</th>
                                    <td>
                                        <%= order.getPayment().getPaymentMethod() != null ?
                                            order.getPayment().getPaymentMethod().getDisplayName() : "N/A" %>
                                    </td>
                                </tr>
                                <tr>
                                    <th>Transaction ID:</th>
                                    <td><%= order.getPayment().getTransactionId() %></td>
                                </tr>
                                <tr>
                                    <th>Payment Date:</th>
                                    <td>
                                        <% if (order.getPayment().getPaymentDate() != null) { %>
                                            <%= dateFormat.format(order.getPayment().getPaymentDate()) %>
                                        <% } else { %>
                                            N/A
                                        <% } %>
                                    </td>
                                </tr>
                                <tr>
                                    <th>Payment Status:</th>
                                    <td>
                                        <% if (order.getPayment().isSuccessful()) { %>
                                            <span class="badge bg-success">Successful</span>
                                        <% } else { %>
                                            <span class="badge bg-danger">Failed</span>
                                        <% } %>
                                    </td>
                                </tr>
                                <tr>
                                    <th>Payment Details:</th>
                                    <td><%= order.getPayment().getPaymentDetails() %></td>
                                </tr>
                            </table>
                        <% } else { %>
                            <p class="text-muted">No payment information available.</p>
                        <% } %>
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
                                    <% if (order != null && order.getItems() != null && !order.getItems().isEmpty()) {
                                        for (OrderItem item : order.getItems()) { %>
                                            <tr>
                                                <td>
                                                    <strong><%= item.getTitle() != null ? item.getTitle() : "Unknown" %></strong><br>
                                                    <small class="text-muted">by <%= item.getAuthor() != null ? item.getAuthor() : "Unknown" %></small>
                                                </td>
                                                <td>
                                                    <% if (item.getBookType() != null) {
                                                        if (item.getBookType().equals("EBOOK")) { %>
                                                            <span class="badge bg-primary">E-Book</span>
                                                        <% } else if (item.getBookType().equals("PHYSICAL")) { %>
                                                            <span class="badge bg-info">Physical Book</span>
                                                        <% } else { %>
                                                            <span class="badge bg-secondary">Book</span>
                                                        <% }
                                                    } else { %>
                                                        <span class="badge bg-secondary">Book</span>
                                                    <% } %>
                                                </td>
                                                <td class="text-end">
                                                    <%= currencyFormat.format(item.getDiscountedPrice()) %>
                                                </td>
                                                <td class="text-center"><%= item.getQuantity() %></td>
                                                <td class="text-end">
                                                    <%= currencyFormat.format(item.getQuantity() * item.getDiscountedPrice()) %>
                                                </td>
                                            </tr>
                                        <% }
                                    } else { %>
                                        <tr>
                                            <td colspan="5" class="text-center">No items found in this order</td>
                                        </tr>
                                    <% } %>
                                </tbody>
                                <tfoot>
                                    <tr>
                                        <td colspan="4" class="text-end"><strong>Subtotal:</strong></td>
                                        <td class="text-end"><%= currencyFormat.format(subtotal) %></td>
                                    </tr>
                                    <tr>
                                        <td colspan="4" class="text-end"><strong>Tax:</strong></td>
                                        <td class="text-end"><%= currencyFormat.format(tax) %></td>
                                    </tr>
                                    <tr>
                                        <td colspan="4" class="text-end"><strong>Shipping:</strong></td>
                                        <td class="text-end"><%= currencyFormat.format(shipping) %></td>
                                    </tr>
                                    <tr>
                                        <td colspan="4" class="text-end"><strong>Total:</strong></td>
                                        <td class="text-end"><strong><%= currencyFormat.format(total) %></strong></td>
                                    </tr>
                                </tfoot>
                            </table>
                        </div>
                    </div>
                </div>

                <div class="row mt-3">
                    <div class="col-md-12">
                        <h5>Order Notes</h5>
                        <textarea class="form-control" id="orderNotes" rows="3" readonly><%= notes %></textarea>
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
                <form action="<%= contextPath %>/admin/update-order-status" method="post">
                    <input type="hidden" name="orderId" value="<%= order != null ? order.getOrderId() : "" %>">

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="status" class="form-label">Order Status</label>
                            <select class="form-select" id="status" name="status" required>
                                <% if (statuses != null) {
                                    for (OrderStatus status : statuses) { %>
                                        <option value="<%= status %>"
                                            <%= (order != null && order.getStatus() == status) ? "selected" : "" %>>
                                            <%= status.getDisplayName() %>
                                        </option>
                                    <% }
                                } %>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label for="trackingNumber" class="form-label">Tracking Number</label>
                            <input type="text" class="form-control" id="trackingNumber" name="trackingNumber"
                                   value="<%= tracking %>" placeholder="Enter tracking number">
                            <div class="form-text text-muted">Required when status is "Shipped"</div>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="notes" class="form-label">Order Notes</label>
                        <textarea class="form-control" id="notes" name="notes" rows="3"
                                  placeholder="Add notes about this order"><%= notes %></textarea>
                    </div>

                    <div class="d-flex justify-content-between">
                        <div>
                            <button type="submit" class="btn btn-accent">
                                <i class="fas fa-save me-2"></i> Update Order
                            </button>
                        </div>
                        <div>
                            <% if (order != null && order.getStatus() != OrderStatus.DELIVERED &&
                                   order.getStatus() != OrderStatus.CANCELLED) { %>
                                <button type="button" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#cancelOrderModal">
                                    <i class="fas fa-times me-2"></i> Cancel Order
                                </button>
                            <% } %>
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
                    <form action="<%= contextPath %>/admin/update-order-status" method="post">
                        <input type="hidden" name="orderId" value="<%= order != null ? order.getOrderId() : "" %>">
                        <input type="hidden" name="status" value="CANCELLED">
                        <input type="hidden" name="notes" value="<%= notes %>${empty notes ? '' : '&#10;'}[Admin cancelled order on <fmt:formatDate value='<%=new java.util.Date()%>' pattern='yyyy-MM-dd'/>]">
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
                    <form action="<%= contextPath %>/admin/delete-order" method="post">
                        <input type="hidden" name="orderId" value="<%= order != null ? order.getOrderId() : "" %>">
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
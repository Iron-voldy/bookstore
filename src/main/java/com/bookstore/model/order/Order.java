package com.bookstore.model.order;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

/**
 * Represents a customer order
 */
public class Order implements Comparable<Order> {
    private String orderId;
    private String userId;
    private Date orderDate;
    private OrderStatus status;
    private List<OrderItem> items;
    private double subtotal;
    private double tax;
    private double shippingCost;
    private double total;
    private String shippingAddress;
    private String billingAddress;
    private String contactEmail;
    private String contactPhone;
    private Payment payment;
    private String trackingNumber;
    private Date shippedDate;
    private Date deliveredDate;
    private String notes;

    /**
     * Constructor with all fields
     */
    public Order(String orderId, String userId, Date orderDate, OrderStatus status,
                 List<OrderItem> items, double subtotal, double tax, double shippingCost,
                 double total, String shippingAddress, String billingAddress,
                 String contactEmail, String contactPhone, Payment payment,
                 String trackingNumber, Date shippedDate, Date deliveredDate, String notes) {
        this.orderId = orderId;
        this.userId = userId;
        this.orderDate = orderDate;
        this.status = status;
        this.items = items;
        this.subtotal = subtotal;
        this.tax = tax;
        this.shippingCost = shippingCost;
        this.total = total;
        this.shippingAddress = shippingAddress;
        this.billingAddress = billingAddress;
        this.contactEmail = contactEmail;
        this.contactPhone = contactPhone;
        this.payment = payment;
        this.trackingNumber = trackingNumber;
        this.shippedDate = shippedDate;
        this.deliveredDate = deliveredDate;
        this.notes = notes;
    }

    /**
     * Constructor with essential fields
     */
    public Order(String userId, List<OrderItem> items, String shippingAddress,
                 String billingAddress, String contactEmail, String contactPhone) {
        this.orderId = UUID.randomUUID().toString();
        this.userId = userId;
        this.orderDate = new Date();
        this.status = OrderStatus.PENDING;
        this.items = items;
        this.shippingAddress = shippingAddress;
        this.billingAddress = billingAddress;
        this.contactEmail = contactEmail;
        this.contactPhone = contactPhone;

        // Calculate totals
        calculateTotals();
    }

    /**
     * Default constructor
     */
    public Order() {
        this.orderId = UUID.randomUUID().toString();
        this.orderDate = new Date();
        this.status = OrderStatus.PENDING;
        this.items = new ArrayList<>();
    }

    // Getters and Setters
    public String getOrderId() {
        return orderId;
    }

    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public Date getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(Date orderDate) {
        this.orderDate = orderDate;
    }

    public OrderStatus getStatus() {
        return status;
    }

    public void setStatus(OrderStatus status) {
        this.status = status;
    }

    public List<OrderItem> getItems() {
        return items;
    }

    public void setItems(List<OrderItem> items) {
        this.items = items;
        calculateTotals();
    }

    public double getSubtotal() {
        return subtotal;
    }

    public void setSubtotal(double subtotal) {
        this.subtotal = subtotal;
    }

    public double getTax() {
        return tax;
    }

    public void setTax(double tax) {
        this.tax = tax;
    }

    public double getShippingCost() {
        return shippingCost;
    }

    public void setShippingCost(double shippingCost) {
        this.shippingCost = shippingCost;
    }

    public double getTotal() {
        return total;
    }

    public void setTotal(double total) {
        this.total = total;
    }

    public String getShippingAddress() {
        return shippingAddress;
    }

    public void setShippingAddress(String shippingAddress) {
        this.shippingAddress = shippingAddress;
    }

    public String getBillingAddress() {
        return billingAddress;
    }

    public void setBillingAddress(String billingAddress) {
        this.billingAddress = billingAddress;
    }

    public String getContactEmail() {
        return contactEmail;
    }

    public void setContactEmail(String contactEmail) {
        this.contactEmail = contactEmail;
    }

    public String getContactPhone() {
        return contactPhone;
    }

    public void setContactPhone(String contactPhone) {
        this.contactPhone = contactPhone;
    }

    public Payment getPayment() {
        return payment;
    }

    public void setPayment(Payment payment) {
        this.payment = payment;
    }

    public String getTrackingNumber() {
        return trackingNumber;
    }

    public void setTrackingNumber(String trackingNumber) {
        this.trackingNumber = trackingNumber;
    }

    public Date getShippedDate() {
        return shippedDate;
    }

    public void setShippedDate(Date shippedDate) {
        this.shippedDate = shippedDate;
    }

    public Date getDeliveredDate() {
        return deliveredDate;
    }

    public void setDeliveredDate(Date deliveredDate) {
        this.deliveredDate = deliveredDate;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    // Methods
    /**
     * Add an item to the order
     */
    public void addItem(OrderItem item) {
        if (items == null) {
            items = new ArrayList<>();
        }
        items.add(item);
        calculateTotals();
    }

    /**
     * Remove an item from the order
     */
    public boolean removeItem(String bookId) {
        if (items == null) {
            return false;
        }

        boolean removed = items.removeIf(item -> item.getBookId().equals(bookId));
        if (removed) {
            calculateTotals();
        }
        return removed;
    }

    /**
     * Calculate subtotal, tax, and total
     */
    public void calculateTotals() {
        if (items == null) {
            subtotal = 0;
            tax = 0;
            total = 0;
            return;
        }

        // Calculate subtotal
        subtotal = 0;
        for (OrderItem item : items) {
            subtotal += item.getSubtotal();
        }

        // Calculate tax (7% sales tax)
        tax = subtotal * 0.07;

        // Calculate total
        total = subtotal + tax + shippingCost;
    }

    /**
     * Check if the order can be cancelled
     */
    public boolean canCancel() {
        return status == OrderStatus.PENDING || status == OrderStatus.PROCESSING;
    }

    /**
     * Get the total number of items in the order
     */
    public int getTotalItems() {
        if (items == null) {
            return 0;
        }

        int count = 0;
        for (OrderItem item : items) {
            count += item.getQuantity();
        }
        return count;
    }

    /**
     * Compare orders by date (for sorting)
     */
    @Override
    public int compareTo(Order other) {
        return other.orderDate.compareTo(this.orderDate); // Newest first
    }

    /**
     * Convert order to string representation for file storage
     */
    public String toFileString() {
        return orderId + "|" +
                userId + "|" +
                (orderDate != null ? orderDate.getTime() : "0") + "|" +
                (status != null ? status.name() : "") + "|" +
                subtotal + "|" +
                tax + "|" +
                shippingCost + "|" +
                total + "|" +
                (shippingAddress != null ? shippingAddress.replace("|", "{{PIPE}}") : "") + "|" +
                (billingAddress != null ? billingAddress.replace("|", "{{PIPE}}") : "") + "|" +
                (contactEmail != null ? contactEmail : "") + "|" +
                (contactPhone != null ? contactPhone : "") + "|" +
                (trackingNumber != null ? trackingNumber : "") + "|" +
                (shippedDate != null ? shippedDate.getTime() : "0") + "|" +
                (deliveredDate != null ? deliveredDate.getTime() : "0") + "|" +
                (notes != null ? notes.replace("|", "{{PIPE}}") : "");
    }

    /**
     * Convert order items to string representation
     */
    public String itemsToFileString() {
        if (items == null || items.isEmpty()) {
            return "";
        }

        StringBuilder sb = new StringBuilder();
        for (OrderItem item : items) {
            sb.append(orderId).append(",")
                    .append(item.toFileString())
                    .append("\n");
        }
        return sb.toString();
    }

    /**
     * Create order from string representation (from file)
     */
    public static Order fromFileString(String fileString) {
        String[] parts = fileString.split("\\|");
        if (parts.length >= 16) {
            Order order = new Order();
            order.setOrderId(parts[0]);
            order.setUserId(parts[1]);

            long orderDateLong = Long.parseLong(parts[2]);
            if (orderDateLong > 0) {
                order.setOrderDate(new Date(orderDateLong));
            }

            if (!parts[3].isEmpty()) {
                order.setStatus(OrderStatus.valueOf(parts[3]));
            }

            order.setSubtotal(Double.parseDouble(parts[4]));
            order.setTax(Double.parseDouble(parts[5]));
            order.setShippingCost(Double.parseDouble(parts[6]));
            order.setTotal(Double.parseDouble(parts[7]));
            order.setShippingAddress(parts[8].replace("{{PIPE}}", "|"));
            order.setBillingAddress(parts[9].replace("{{PIPE}}", "|"));
            order.setContactEmail(parts[10]);
            order.setContactPhone(parts[11]);
            order.setTrackingNumber(parts[12]);

            long shippedDateLong = Long.parseLong(parts[13]);
            if (shippedDateLong > 0) {
                order.setShippedDate(new Date(shippedDateLong));
            }

            long deliveredDateLong = Long.parseLong(parts[14]);
            if (deliveredDateLong > 0) {
                order.setDeliveredDate(new Date(deliveredDateLong));
            }

            order.setNotes(parts[15].replace("{{PIPE}}", "|"));

            return order;
        }
        return null;
    }

    /**
     * Add items to order from file string representation
     */
    public static void addItemsFromFileString(Order order, String itemsString) {
        if (order == null || itemsString == null || itemsString.isEmpty()) {
            return;
        }

        String[] lines = itemsString.split("\n");
        List<OrderItem> items = new ArrayList<>();

        for (String line : lines) {
            String[] parts = line.split(",", 2); // Split into orderId and rest
            if (parts.length >= 2 && parts[0].equals(order.getOrderId())) {
                OrderItem item = OrderItem.fromFileString(parts[1]);
                if (item != null) {
                    items.add(item);
                }
            }
        }

        order.setItems(items);
    }

    @Override
    public String toString() {
        return "Order{" +
                "orderId='" + orderId + '\'' +
                ", userId='" + userId + '\'' +
                ", orderDate=" + orderDate +
                ", status=" + status +
                ", items=" + (items != null ? items.size() : 0) +
                ", total=" + total +
                '}';
    }
}
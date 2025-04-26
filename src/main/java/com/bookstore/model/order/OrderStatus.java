package com.bookstore.model.order;

/**
 * Enum representing the possible statuses of an order
 */
public enum OrderStatus {
    PENDING("Pending"),
    PROCESSING("Processing"),
    SHIPPED("Shipped"),
    DELIVERED("Delivered"),
    CANCELLED("Cancelled");

    private final String displayName;

    OrderStatus(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }

    @Override
    public String toString() {
        return displayName;
    }

    /**
     * Convert string representation to enum
     */
    public static OrderStatus fromString(String text) {
        for (OrderStatus status : OrderStatus.values()) {
            if (status.name().equalsIgnoreCase(text) ||
                    status.getDisplayName().equalsIgnoreCase(text)) {
                return status;
            }
        }
        return null;
    }
}
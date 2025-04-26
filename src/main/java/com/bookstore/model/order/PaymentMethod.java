package com.bookstore.model.order;

/**
 * Enum representing the possible payment methods
 */
public enum PaymentMethod {
    CREDIT_CARD("Credit Card"),
    DEBIT_CARD("Debit Card"),
    PAYPAL("PayPal"),
    BANK_TRANSFER("Bank Transfer");

    private final String displayName;

    PaymentMethod(String displayName) {
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
    public static PaymentMethod fromString(String text) {
        for (PaymentMethod method : PaymentMethod.values()) {
            if (method.name().equalsIgnoreCase(text) ||
                    method.getDisplayName().equalsIgnoreCase(text)) {
                return method;
            }
        }
        return null;
    }
}
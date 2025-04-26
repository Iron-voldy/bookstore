package com.bookstore.model.order;

import java.util.Date;
import java.util.UUID;

/**
 * Represents a payment for an order
 */
public class Payment {
    private String paymentId;
    private String orderId;
    private double amount;
    private PaymentMethod paymentMethod;
    private String transactionId;
    private Date paymentDate;
    private boolean successful;
    private String paymentDetails; // Card last 4 digits or PayPal email, etc.

    /**
     * Constructor with all fields
     */
    public Payment(String paymentId, String orderId, double amount, PaymentMethod paymentMethod,
                   String transactionId, Date paymentDate, boolean successful, String paymentDetails) {
        this.paymentId = paymentId;
        this.orderId = orderId;
        this.amount = amount;
        this.paymentMethod = paymentMethod;
        this.transactionId = transactionId;
        this.paymentDate = paymentDate;
        this.successful = successful;
        this.paymentDetails = paymentDetails;
    }

    /**
     * Constructor with essential fields
     */
    public Payment(String orderId, double amount, PaymentMethod paymentMethod) {
        this.paymentId = UUID.randomUUID().toString();
        this.orderId = orderId;
        this.amount = amount;
        this.paymentMethod = paymentMethod;
        this.paymentDate = new Date();
        this.successful = false;
    }

    /**
     * Default constructor
     */
    public Payment() {
        this.paymentId = UUID.randomUUID().toString();
        this.paymentDate = new Date();
        this.successful = false;
    }

    // Getters and Setters
    public String getPaymentId() {
        return paymentId;
    }

    public void setPaymentId(String paymentId) {
        this.paymentId = paymentId;
    }

    public String getOrderId() {
        return orderId;
    }

    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public PaymentMethod getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(PaymentMethod paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(String transactionId) {
        this.transactionId = transactionId;
    }

    public Date getPaymentDate() {
        return paymentDate;
    }

    public void setPaymentDate(Date paymentDate) {
        this.paymentDate = paymentDate;
    }

    public boolean isSuccessful() {
        return successful;
    }

    public void setSuccessful(boolean successful) {
        this.successful = successful;
    }

    public String getPaymentDetails() {
        return paymentDetails;
    }

    public void setPaymentDetails(String paymentDetails) {
        this.paymentDetails = paymentDetails;
    }

    /**
     * Convert payment to string representation for file storage
     */
    public String toFileString() {
        return paymentId + "," +
                orderId + "," +
                amount + "," +
                (paymentMethod != null ? paymentMethod.name() : "") + "," +
                (transactionId != null ? transactionId : "") + "," +
                (paymentDate != null ? paymentDate.getTime() : "0") + "," +
                successful + "," +
                (paymentDetails != null ? paymentDetails.replace(",", "{{COMMA}}") : "");
    }

    /**
     * Create payment from string representation (from file)
     */
    public static Payment fromFileString(String fileString) {
        String[] parts = fileString.split(",");
        if (parts.length >= 8) {
            Payment payment = new Payment();
            payment.setPaymentId(parts[0]);
            payment.setOrderId(parts[1]);
            payment.setAmount(Double.parseDouble(parts[2]));

            if (!parts[3].isEmpty()) {
                payment.setPaymentMethod(PaymentMethod.valueOf(parts[3]));
            }

            payment.setTransactionId(parts[4]);

            long paymentDateLong = Long.parseLong(parts[5]);
            if (paymentDateLong > 0) {
                payment.setPaymentDate(new Date(paymentDateLong));
            }

            payment.setSuccessful(Boolean.parseBoolean(parts[6]));
            payment.setPaymentDetails(parts[7].replace("{{COMMA}}", ","));

            return payment;
        }
        return null;
    }

    @Override
    public String toString() {
        return "Payment{" +
                "paymentId='" + paymentId + '\'' +
                ", orderId='" + orderId + '\'' +
                ", amount=" + amount +
                ", paymentMethod=" + paymentMethod +
                ", successful=" + successful +
                '}';
    }
}
package com.bookstore.model.user;

import java.util.Date;

/**
 * RegularUser class representing a standard user with basic privileges
 */
public class RegularUser extends User {
    private static final int ORDER_LIMIT = 5;
    private int loyaltyPoints;

    // Constructor with all fields
    public RegularUser(String userId, String username, String password, String email, String fullName,
                       Date registrationDate, Date lastLoginDate, int loyaltyPoints) {
        super(userId, username, password, email, fullName, registrationDate, lastLoginDate);
        this.loyaltyPoints = loyaltyPoints;
    }

    // Constructor with essential fields
    public RegularUser(String userId, String username, String password, String email, String fullName) {
        super(userId, username, password, email, fullName);
        this.loyaltyPoints = 0;
    }

    // Default constructor
    public RegularUser() {
        super();
        this.loyaltyPoints = 0;
    }

    // Getters and setters
    public int getLoyaltyPoints() {
        return loyaltyPoints;
    }

    public void setLoyaltyPoints(int loyaltyPoints) {
        this.loyaltyPoints = loyaltyPoints;
    }

    // Add loyalty points
    public void addLoyaltyPoints(int points) {
        this.loyaltyPoints += points;
    }

    // Use loyalty points
    public boolean useLoyaltyPoints(int points) {
        if (points <= loyaltyPoints) {
            loyaltyPoints -= points;
            return true;
        }
        return false;
    }

    @Override
    public int getOrderLimit() {
        return ORDER_LIMIT;
    }

    // Calculate shipping fee (regular users pay standard rate)
    public double calculateShippingFee(double orderTotal) {
        if (orderTotal >= 35.0) {
            return 0.0; // Free shipping for orders over $35
        }
        return 4.99; // Standard shipping fee
    }

    @Override
    public String toFileString() {
        return "REGULAR," + super.toFileString() + "," + loyaltyPoints;
    }

    // Create RegularUser from string representation (from file)
    public static RegularUser fromFileString(String fileString) {
        String[] parts = fileString.split(",");
        if (parts.length >= 8 && parts[0].equals("REGULAR")) {
            RegularUser user = new RegularUser();
            user.setUserId(parts[1]);
            user.setUsername(parts[2]);
            user.setPassword(parts[3]);
            user.setEmail(parts[4]);
            user.setFullName(parts[5]);
            user.setRegistrationDate(new Date(Long.parseLong(parts[6])));

            long lastLoginTime = Long.parseLong(parts[7]);
            if (lastLoginTime > 0) {
                user.setLastLoginDate(new Date(lastLoginTime));
            }

            if (parts.length > 8) {
                user.setLoyaltyPoints(Integer.parseInt(parts[8]));
            }

            return user;
        }
        return null;
    }

    @Override
    public String toString() {
        return "RegularUser{" +
                "userId='" + getUserId() + '\'' +
                ", username='" + getUsername() + '\'' +
                ", email='" + getEmail() + '\'' +
                ", fullName='" + getFullName() + '\'' +
                ", registrationDate=" + getRegistrationDate() +
                ", lastLoginDate=" + getLastLoginDate() +
                ", loyaltyPoints=" + loyaltyPoints +
                '}';
    }
}
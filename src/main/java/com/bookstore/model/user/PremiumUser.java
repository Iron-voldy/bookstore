package com.bookstore.model.user;

import java.util.Calendar;
import java.util.Date;

/**
 * PremiumUser class representing a premium user with extended privileges
 */
public class PremiumUser extends User {
    private static final int ORDER_LIMIT = 10;
    private Date subscriptionExpiryDate;
    private String membershipTier; // "SILVER", "GOLD", or "PLATINUM"
    private int rewardPoints;

    // Constructor with all fields
    public PremiumUser(String userId, String username, String password, String email, String fullName,
                       Date registrationDate, Date lastLoginDate, Date subscriptionExpiryDate,
                       String membershipTier, int rewardPoints) {
        super(userId, username, password, email, fullName, registrationDate, lastLoginDate);
        this.subscriptionExpiryDate = subscriptionExpiryDate;
        this.membershipTier = membershipTier;
        this.rewardPoints = rewardPoints;
    }

    // Constructor with essential fields
    public PremiumUser(String userId, String username, String password, String email, String fullName) {
        super(userId, username, password, email, fullName);
        // Set default expiry date to one year from now
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.YEAR, 1);
        this.subscriptionExpiryDate = cal.getTime();
        this.membershipTier = "SILVER";
        this.rewardPoints = 100; // Welcome bonus
    }

    // Default constructor
    public PremiumUser() {
        super();
        // Set default expiry date to one year from now
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.YEAR, 1);
        this.subscriptionExpiryDate = cal.getTime();
        this.membershipTier = "SILVER";
        this.rewardPoints = 0;
    }

    // Getters and setters
    public Date getSubscriptionExpiryDate() {
        return subscriptionExpiryDate;
    }

    public void setSubscriptionExpiryDate(Date subscriptionExpiryDate) {
        this.subscriptionExpiryDate = subscriptionExpiryDate;
    }

    public String getMembershipTier() {
        return membershipTier;
    }

    public void setMembershipTier(String membershipTier) {
        this.membershipTier = membershipTier;
    }

    public int getRewardPoints() {
        return rewardPoints;
    }

    public void setRewardPoints(int rewardPoints) {
        this.rewardPoints = rewardPoints;
    }

    // Check if premium subscription is active
    public boolean isSubscriptionActive() {
        return subscriptionExpiryDate.after(new Date());
    }

    // Add reward points
    public void addRewardPoints(int points) {
        this.rewardPoints += points;
    }

    // Use reward points
    public boolean useRewardPoints(int points) {
        if (points <= rewardPoints) {
            rewardPoints -= points;
            return true;
        }
        return false;
    }

    // Get discount rate based on membership tier
    public double getDiscountRate() {
        switch (membershipTier) {
            case "PLATINUM":
                return 0.15; // 15% discount
            case "GOLD":
                return 0.10; // 10% discount
            case "SILVER":
            default:
                return 0.05; // 5% discount
        }
    }

    @Override
    public int getOrderLimit() {
        return ORDER_LIMIT;
    }

    // Calculate shipping fee (premium users get free shipping)
    public double calculateShippingFee(double orderTotal) {
        return 0.0; // Free shipping for all premium members
    }

    // Extend subscription by specified number of months
    public void extendSubscription(int months) {
        Calendar cal = Calendar.getInstance();
        cal.setTime(subscriptionExpiryDate);
        cal.add(Calendar.MONTH, months);
        subscriptionExpiryDate = cal.getTime();
    }

    // Upgrade membership tier
    public boolean upgradeTier(String newTier) {
        if ("GOLD".equals(newTier) || "PLATINUM".equals(newTier)) {
            this.membershipTier = newTier;
            return true;
        }
        return false;
    }

    @Override
    public String toFileString() {
        return "PREMIUM," + super.toFileString() + "," +
                subscriptionExpiryDate.getTime() + "," +
                membershipTier + "," + rewardPoints;
    }

    // Create PremiumUser from string representation (from file)
    public static PremiumUser fromFileString(String fileString) {
        String[] parts = fileString.split(",");
        if (parts.length >= 10 && parts[0].equals("PREMIUM")) {
            PremiumUser user = new PremiumUser();
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

            user.setSubscriptionExpiryDate(new Date(Long.parseLong(parts[8])));
            user.setMembershipTier(parts[9]);

            if (parts.length > 10) {
                user.setRewardPoints(Integer.parseInt(parts[10]));
            }

            return user;
        }
        return null;
    }

    @Override
    public String toString() {
        return "PremiumUser{" +
                "userId='" + getUserId() + '\'' +
                ", username='" + getUsername() + '\'' +
                ", email='" + getEmail() + '\'' +
                ", fullName='" + getFullName() + '\'' +
                ", registrationDate=" + getRegistrationDate() +
                ", lastLoginDate=" + getLastLoginDate() +
                ", subscriptionExpiryDate=" + subscriptionExpiryDate +
                ", membershipTier='" + membershipTier + '\'' +
                ", rewardPoints=" + rewardPoints +
                '}';
    }
}
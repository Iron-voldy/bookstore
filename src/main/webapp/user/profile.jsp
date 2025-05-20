<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.bookstore.model.user.User" %>
<%@ page import="com.bookstore.model.user.PremiumUser" %>
<%@ page import="com.bookstore.model.user.RegularUser" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page errorPage="/error/error.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - BookVerse</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Custom CSS -->
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
            --card-bg: #252525;
            --border-color: #333333;
        }

        body {
            background-color: var(--primary-dark);
            color: var(--text-primary);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        .navbar {
            background-color: var(--secondary-dark);
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.3);
        }

        .navbar-brand {
            font-weight: bold;
            color: var(--accent-color) !important;
        }

        .nav-link {
            color: var(--text-primary) !important;
            margin: 0 10px;
            position: relative;
        }

        .nav-link:after {
            content: '';
            position: absolute;
            width: 0;
            height: 2px;
            bottom: 0;
            left: 0;
            background-color: var(--accent-color);
            transition: width 0.3s;
        }

        .nav-link:hover:after {
            width: 100%;
        }

        .nav-link.active {
            color: var(--accent-color) !important;
            font-weight: 500;
        }

        .nav-link.active:after {
            width: 100%;
        }

        .btn-accent {
            background-color: var(--accent-color);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            font-weight: 500;
            transition: all 0.3s;
        }

        .btn-accent:hover {
            background-color: var(--accent-hover);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(138, 92, 245, 0.3);
        }

        .btn-outline-accent {
            color: var(--accent-color);
            background-color: transparent;
            border: 1px solid var(--accent-color);
            padding: 10px 20px;
            border-radius: 5px;
            font-weight: 500;
            transition: all 0.3s;
        }

        .btn-outline-accent:hover {
            background-color: var(--accent-color);
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(138, 92, 245, 0.3);
        }

        /* Add new style for the delete button */
        .btn-outline-danger {
            color: var(--danger-color);
            background-color: transparent;
            border: 1px solid var(--danger-color);
            padding: 10px 20px;
            border-radius: 5px;
            font-weight: 500;
            transition: all 0.3s;
        }

        .btn-outline-danger:hover {
            background-color: var(--danger-color);
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(214, 64, 69, 0.3);
        }

        .btn-danger {
            background-color: var(--danger-color);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            font-weight: 500;
            transition: all 0.3s;
        }

        .btn-danger:hover {
            background-color: #b32e33;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(214, 64, 69, 0.3);
        }

        .card {
            background-color: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
        }

        .card-header {
            background-color: var(--secondary-dark);
            color: var(--text-primary);
            font-weight: 600;
            padding: 15px 20px;
            border-bottom: 1px solid var(--border-color);
        }

        .alert-custom {
            background-color: var(--secondary-dark);
            color: var(--text-primary);
            border: 1px solid var(--border-color);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .alert-success {
            border-left: 4px solid var(--success-color);
        }

        .alert-danger {
            border-left: 4px solid var(--danger-color);
        }

        .alert-warning {
            border-left: 4px solid var(--warning-color);
        }

        .content-container {
            flex: 1 0 auto;
            padding: 40px 0;
        }

        .premium-badge {
            background: linear-gradient(135deg, #B68C1A, #FFD700);
            color: #333;
            padding: 3px 8px;
            border-radius: 15px;
            font-weight: bold;
            font-size: 0.8rem;
            display: inline-block;
            margin-left: 10px;
        }

        .user-avatar {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            overflow: hidden;
            border: 3px solid var(--accent-color);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
            margin: 0 auto 20px;
        }

        .info-item {
            display: flex;
            margin-bottom: 15px;
        }

        .info-label {
            width: 140px;
            font-weight: 500;
            color: var(--text-secondary);
        }

        .info-value {
            flex-grow: 1;
            color: var(--text-primary);
        }

        .stat-card {
            background-color: rgba(138, 92, 245, 0.1);
            border: 1px solid rgba(138, 92, 245, 0.2);
            border-radius: 10px;
            padding: 20px;
            text-align: center;
            transition: transform 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-5px);
        }

        .stat-number {
            font-size: 2rem;
            font-weight: bold;
            color: var(--accent-color);
            margin: 10px 0;
        }

        footer {
            margin-top: auto;
            background-color: var(--secondary-dark);
            color: var(--text-secondary);
            padding: 20px 0;
        }

        /* Add modal styles */
        .modal-content {
            background-color: var(--card-bg);
            color: var(--text-primary);
            border: 1px solid var(--border-color);
        }

        .modal-header, .modal-footer {
            border-color: var(--border-color);
        }

        .form-control {
            background-color: var(--secondary-dark);
            border: 1px solid var(--border-color);
            color: var(--text-primary);
        }

        .form-control:focus {
            background-color: var(--secondary-dark);
            border-color: var(--accent-color);
            box-shadow: 0 0 0 0.25rem rgba(138, 92, 245, 0.25);
            color: var(--text-primary);
        }

        .password-toggle {
            cursor: pointer;
        }
    </style>
</head>
<body>
    <%
    // Debug information
    System.out.println("Profile.jsp: Page execution started");
    System.out.println("Profile.jsp: Session ID: " + session.getId());

    // Get the user object from session
    User currentUser = null;
    boolean isLoggedIn = false;
    boolean isPremium = false;
    boolean isRegular = false;

    // Default values for user info
    String fullName = "Guest";
    String username = "guest";
    String email = "Not available";
    String registrationDate = "N/A";
    String lastLoginDate = "N/A";
    String membershipTier = "N/A";
    String subscriptionExpiry = "N/A";
    int rewardPoints = 0;
    int loyaltyPoints = 0;
    boolean subscriptionActive = false;

    try {
        currentUser = (User)session.getAttribute("user");
        System.out.println("Profile.jsp: User from session: " + (currentUser != null ? currentUser.getUsername() : "null"));

        if (currentUser != null) {
            isLoggedIn = true;
            isPremium = (currentUser instanceof PremiumUser);
            isRegular = (currentUser instanceof RegularUser);

            fullName = currentUser.getFullName();
            username = currentUser.getUsername();
            email = currentUser.getEmail();

            // Format dates
            SimpleDateFormat dateFormat = new SimpleDateFormat("MMMM dd, yyyy");
            registrationDate = currentUser.getRegistrationDate() != null ?
                dateFormat.format(currentUser.getRegistrationDate()) : "N/A";

            lastLoginDate = currentUser.getLastLoginDate() != null ?
                dateFormat.format(currentUser.getLastLoginDate()) : "N/A";

            // Premium user specific info
            if (isPremium) {
                PremiumUser premiumUser = (PremiumUser)currentUser;
                membershipTier = premiumUser.getMembershipTier();
                subscriptionExpiry = premiumUser.getSubscriptionExpiryDate() != null ?
                    dateFormat.format(premiumUser.getSubscriptionExpiryDate()) : "N/A";
                rewardPoints = premiumUser.getRewardPoints();
                subscriptionActive = premiumUser.isSubscriptionActive();
                System.out.println("Profile.jsp: User is Premium");
            }

            // Regular user specific info
            if (isRegular) {
                RegularUser regularUser = (RegularUser)currentUser;
                loyaltyPoints = regularUser.getLoyaltyPoints();
                System.out.println("Profile.jsp: User is Regular");
            }
        } else {
            System.out.println("Profile.jsp: No user in session, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
    } catch(Exception e) {
        System.err.println("Profile.jsp: Error retrieving user data: " + e.getMessage());
        e.printStackTrace();
    %>
        <div class="container mt-5">
            <div class="alert alert-danger" role="alert">
                <h4 class="alert-heading">Error Loading Profile</h4>
                <p>There was an error loading your profile data: <%= e.getMessage() %></p>
                <hr>
                <p class="mb-0">Please try <a href="<%= request.getContextPath() %>/login">logging in again</a> or contact support if the problem persists.</p>
            </div>
        </div>
    <%
        return;
    }
    %>

    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container">
            <a class="navbar-brand" href="<%=request.getContextPath()%>/">
                <i class="fas fa-book-open me-2"></i>BookVerse
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="<%=request.getContextPath()%>/">Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%=request.getContextPath()%>/search-book">Books</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%=request.getContextPath()%>/view-recommendations">Recommendations</a>
                    </li>
                </ul>

                <!-- User Menu -->
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="<%=request.getContextPath()%>/view-cart">
                            <i class="fas fa-shopping-cart"></i> Cart
                            <span class="badge rounded-pill" style="background-color: var(--accent-color);">
                                <%
                                Integer cartCount = (Integer)session.getAttribute("cartCount");
                                out.print(cartCount != null ? cartCount : 0);
                                %>
                            </span>
                        </a>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle active" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="fas fa-user-circle me-1"></i> <%= username %>
                            <% if (isPremium) { %>
                                <span class="premium-badge">PREMIUM</span>
                            <% } %>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-dark" aria-labelledby="navbarDropdown">
                            <li><a class="dropdown-item active" href="<%=request.getContextPath()%>/user/profile.jsp">My Profile</a></li>
                            <li><a class="dropdown-item" href="<%=request.getContextPath()%>/order-history">My Orders</a></li>
                            <li><a class="dropdown-item" href="<%=request.getContextPath()%>/user-reviews">My Reviews</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="<%=request.getContextPath()%>/logout">Logout</a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>


    <!-- Flash Messages -->
    <c:if test="${not empty successMessage || not empty sessionScope.successMessage}">
        <div class="container mt-3">
            <div class="alert alert-custom alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i> ${not empty successMessage ? successMessage : sessionScope.successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </div>
        <c:remove var="successMessage" scope="session" />
    </c:if>

    <c:if test="${not empty errorMessage || not empty sessionScope.errorMessage}">
        <div class="container mt-3">
            <div class="alert alert-custom alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i> ${not empty errorMessage ? errorMessage : sessionScope.errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </div>
        <c:remove var="errorMessage" scope="session" />
    </c:if>

    <!-- Main Content -->
    <div class="content-container">
        <div class="container">
            <div class="row">
                <!-- User Info Card -->
                <div class="col-lg-4 mb-4">
                    <div class="card">
                        <div class="card-body text-center">
                            <div class="user-avatar">
                                <img src="https://ui-avatars.com/api/?name=<%= fullName %>&background=8a5cf5&color=fff&size=150" alt="User Avatar" class="img-fluid">
                            </div>
                            <h4><%= fullName %></h4>
                            <p class="text-muted mb-1">@<%= username %></p>
                            <p class="text-muted mb-4">
                                <% if (isPremium) { %>
                                    <span class="premium-badge">PREMIUM</span> Member
                                    <br>
                                    <span class="small"><%= membershipTier %> Tier</span>
                                <% } else { %>
                                    Regular Member
                                <% } %>
                            </p>
                            <div class="d-grid gap-2">
                                <a href="<%=request.getContextPath()%>/update-profile" class="btn btn-accent">
                                    <i class="fas fa-user-edit me-1"></i> Edit Profile
                                </a>
                                <% if (isRegular) { %>
                                <a href="<%=request.getContextPath()%>/upgrade-to-premium" class="btn btn-outline-accent">
                                    <i class="fas fa-crown me-1"></i> Upgrade to Premium
                                </a>
                                <% } else if (isPremium) { %>
                                <button type="button" class="btn btn-outline-accent" data-bs-toggle="modal" data-bs-target="#changeTierModal">
                                    <i class="fas fa-award me-1"></i> Change Membership Tier
                                </button>
                                <% } %>
                                <!-- Add Delete Account Button Here -->
                                <button type="button" class="btn btn-outline-danger" data-bs-toggle="modal" data-bs-target="#deleteAccountModal">
                                    <i class="fas fa-user-times me-1"></i> Delete Account
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Stats Cards -->
                    <div class="row mt-4">
                        <div class="col-6 mb-4">
                            <div class="stat-card">
                                <div><i class="fas fa-book fa-lg"></i></div>
                                <div class="stat-number">0</div>
                                <div>Books Ordered</div>
                            </div>
                        </div>
                        <div class="col-6 mb-4">
                            <div class="stat-card">
                                <div><i class="fas fa-star fa-lg"></i></div>
                                <div class="stat-number">0</div>
                                <div>Reviews</div>
                            </div>
                        </div>
                        <div class="col-12 mb-4">
                            <div class="stat-card">
                                <div>
                                    <% if (isPremium) { %>
                                        <i class="fas fa-gem fa-lg"></i> Reward Points
                                    <% } else { %>
                                        <i class="fas fa-heart fa-lg"></i> Loyalty Points
                                    <% } %>
                                </div>
                                <div class="stat-number">
                                    <% if (isPremium) { %>
                                        <%= rewardPoints %>
                                    <% } else { %>
                                        <%= loyaltyPoints %>
                                    <% } %>
                                </div>
                                <div>
                                    <% if (isPremium) { %>
                                        Use for discounts
                                    <% } else { %>
                                        Earn more with purchases
                                    <% } %>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- User Details Card -->
                <div class="col-lg-8">
                    <div class="card mb-4">
                        <div class="card-header">
                            <h5 class="mb-0"><i class="fas fa-user me-2"></i> Account Information</h5>
                        </div>
                        <div class="card-body">
                            <div class="info-item">
                                <div class="info-label">Full Name:</div>
                                <div class="info-value"><%= fullName %></div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">Username:</div>
                                <div class="info-value"><%= username %></div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">Email:</div>
                                <div class="info-value"><%= email %></div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">Account Type:</div>
                                <div class="info-value">
                                    <% if (isPremium) { %>
                                        Premium <span class="premium-badge">PREMIUM</span>
                                    <% } else { %>
                                        Regular
                                    <% } %>
                                </div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">Member Since:</div>
                                <div class="info-value"><%= registrationDate %></div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">Last Login:</div>
                                <div class="info-value"><%= lastLoginDate %></div>
                            </div>

                            <% if (isPremium) { %>
                                <hr style="background-color: var(--border-color);">
                                <h6 class="mb-3">Premium Membership Details</h6>

                                <div class="info-item">
                                    <div class="info-label">Membership Tier:</div>
                                    <div class="info-value"><%= membershipTier %></div>
                                </div>
                                <div class="info-item">
                                    <div class="info-label">Status:</div>
                                    <div class="info-value">
                                        <% if (subscriptionActive) { %>
                                            <span class="text-success"><i class="fas fa-check-circle me-1"></i> Active</span>
                                        <% } else { %>
                                            <span class="text-danger"><i class="fas fa-times-circle me-1"></i> Inactive</span>
                                        <% } %>
                                    </div>
                                </div>
                                <div class="info-item">
                                    <div class="info-label">Expiry Date:</div>
                                    <div class="info-value"><%= subscriptionExpiry %></div>
                                </div>
                                <div class="info-item">
                                    <div class="info-label">Reward Points:</div>
                                    <div class="info-value"><%= rewardPoints %></div>
                                </div>
                                <div class="info-item">
                                    <div class="info-label">Discount Rate:</div>
                                    <div class="info-value">
                                        <%
                                            PremiumUser premiumUser = (PremiumUser)currentUser;
                                            double discountRate = premiumUser.getDiscountRate() * 100;
                                        %>
                                        <%= discountRate %>%
                                    </div>
                                </div>
                            <% } else if (isRegular) { %>
                                <hr style="background-color: var(--border-color);">
                                <h6 class="mb-3">Regular Membership Details</h6>

                                <div class="info-item">
                                    <div class="info-label">Loyalty Points:</div>
                                    <div class="info-value"><%= loyaltyPoints %></div>
                                </div>
                                <div class="alert alert-custom alert-info mt-3" role="alert">
                                    <i class="fas fa-info-circle me-2"></i>
                                    Upgrade to Premium to enjoy discounts, free shipping, and exclusive content!
                                </div>
                            <% } %>

                        </div>
                    </div>

                    <!-- Recent Orders Card -->
                    <div class="card mb-4">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h5 class="mb-0"><i class="fas fa-shopping-bag me-2"></i> Recent Orders</h5>
                            <a href="<%=request.getContextPath()%>/order-history" class="btn btn-sm btn-outline-accent">
                                View All
                            </a>
                        </div>
                        <div class="card-body">
                            <div class="text-center py-4">
                                <i class="fas fa-shopping-bag fa-3x mb-3" style="color: var(--text-secondary);"></i>
                                <p>You haven't placed any orders yet.</p>
                                <a href="<%=request.getContextPath()%>/search-book" class="btn btn-sm btn-accent">
                                    Browse Books
                                </a>
                            </div>
                        </div>
                    </div>

                    <!-- Recent Reviews Card -->
                    <div class="card">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h5 class="mb-0"><i class="fas fa-star me-2"></i> Recent Reviews</h5>
                            <a href="<%=request.getContextPath()%>/user-reviews" class="btn btn-sm btn-outline-accent">
                                View All
                            </a>
                        </div>
                        <div class="card-body">
                            <div class="text-center py-4">
                                <i class="fas fa-star fa-3x mb-3" style="color: var(--text-secondary);"></i>
                                <p>You haven't submitted any reviews yet.</p>
                                <a href="<%=request.getContextPath()%>/search-book" class="btn btn-sm btn-accent">
                                    Find Books to Review
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Change Tier Modal -->
    <% if (isPremium) { %>
    <div class="modal fade" id="changeTierModal" tabindex="-1" aria-labelledby="changeTierModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content" style="background-color: var(--card-bg); color: var(--text-primary);">
                <div class="modal-header" style="border-color: var(--border-color);">
                    <h5 class="modal-title" id="changeTierModalLabel">Change Membership Tier</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form action="<%=request.getContextPath()%>/update-tier" method="post">
                        <div class="mb-3">
                            <label class="form-label">Current Tier</label>
                            <input type="text" class="form-control" value="<%= membershipTier %>" disabled>
                        </div>
                        <div class="mb-3">
                            <label for="newTier" class="form-label">Select New Tier</label>
                            <select class="form-select" id="newTier" name="newTier" style="background-color: var(--secondary-dark); color: var(--text-primary); border-color: var(--border-color);">
                                <option value="SILVER" <%= membershipTier.equals("SILVER") ? "selected" : "" %>>Silver ($9.99/month)</option>
                                <option value="GOLD" <%= membershipTier.equals("GOLD") ? "selected" : "" %>>Gold ($14.99/month)</option>
                                <option value="PLATINUM" <%= membershipTier.equals("PLATINUM") ? "selected" : "" %>>Platinum ($19.99/month)</option>
                            </select>
                        </div>
                        <hr style="background-color: var(--border-color);">
                        <div class="d-grid">
                            <button type="submit" class="btn btn-accent">
                                <i class="fas fa-save me-2"></i> Update Membership
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <% } %>

    <!-- Add Delete Account Modal -->
    <div class="modal fade" id="deleteAccountModal" tabindex="-1" aria-labelledby="deleteAccountModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content" style="background-color: var(--card-bg); color: var(--text-primary);">
                <div class="modal-header" style="border-color: var(--border-color);">
<h5 class="modal-title" id="deleteAccountModalLabel">Delete Account</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="alert alert-custom alert-danger" role="alert">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        <strong>Warning:</strong> This action cannot be undone. All your data including orders, reviews, and preferences will be permanently deleted.
                    </div>
                    <p>Please enter your password to confirm account deletion:</p>
                    <form action="<%=request.getContextPath()%>/delete-user" method="post" id="deleteAccountForm">
                        <div class="mb-3">
                            <label for="confirmPassword" class="form-label">Password</label>
                            <div class="input-group">
                                <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                                <span class="input-group-text password-toggle" onclick="togglePasswordVisibility('confirmPassword', 'toggleDeleteIcon')">
                                    <i class="fas fa-eye" id="toggleDeleteIcon"></i>
                                </span>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer" style="border-color: var(--border-color);">
                    <button type="button" class="btn btn-outline-accent" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-danger" onclick="document.getElementById('deleteAccountForm').submit();">
                        <i class="fas fa-user-times me-1"></i> Delete My Account
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer>
        <div class="container">
            <div class="row">
                <div class="col-md-6 text-center text-md-start">
                    <p class="mb-0">&copy; 2023 BookVerse. All rights reserved.</p>
                </div>
                <div class="col-md-6 text-center text-md-end">
                    <a href="#" class="me-3 text-light">Privacy Policy</a>
                    <a href="#" class="text-light">Terms of Service</a>
                </div>
            </div>
        </div>
    </footer>

    <!-- Bootstrap Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Add JavaScript for password toggle -->
    <script>
        // Toggle password visibility
        function togglePasswordVisibility(inputId, iconId) {
            const passwordInput = document.getElementById(inputId);
            const toggleIcon = document.getElementById(iconId);

            if (passwordInput.type === 'password') {
                passwordInput.type = 'text';
                toggleIcon.classList.remove('fa-eye');
                toggleIcon.classList.add('fa-eye-slash');
            } else {
                passwordInput.type = 'password';
                toggleIcon.classList.remove('fa-eye-slash');
                toggleIcon.classList.add('fa-eye');
            }
        }
    </script>
</body>
</html>
package com.bookstore.servlet.admin;

import java.io.IOException;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.bookstore.model.admin.Admin;
import com.bookstore.model.admin.AdminManager;
import com.bookstore.model.book.Book;
import com.bookstore.model.book.BookManager;
import com.bookstore.model.book.EBook;
import com.bookstore.model.book.PhysicalBook;
import com.bookstore.model.user.User;
import com.bookstore.model.user.UserManager;
import com.bookstore.model.order.OrderManager;
import com.bookstore.model.order.OrderStatus;

/**
 * Servlet for handling admin dashboard
 */
@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests - display admin dashboard
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check admin authentication
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        // Get admin information
        String adminId = (String) session.getAttribute("adminId");
        AdminManager adminManager = new AdminManager(getServletContext());
        Admin admin = adminManager.getAdminById(adminId);

        if (admin == null) {
            // Admin not found (should not happen)
            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        // Collect statistics for dashboard
        // 1. Book statistics
        BookManager bookManager = new BookManager(getServletContext());
        int totalBooks = bookManager.getBooksCount();

        // Count physical books and ebooks
        int physicalBookCount = 0;
        int ebookCount = 0;
        int featuredBookCount = 0;
        int lowStockCount = 0; // Books with quantity <= 5

        Book[] allBooks = bookManager.getAllBooks();
        for (Book book : allBooks) {
            if (book instanceof PhysicalBook) {
                physicalBookCount++;
                if (book.getQuantity() <= 5) {
                    lowStockCount++;
                }
            } else if (book instanceof EBook) {
                ebookCount++;
            }

            if (book.isFeatured()) {
                featuredBookCount++;
            }
        }

        // 2. User statistics
        UserManager userManager = new UserManager(getServletContext());
        int totalUsers = userManager.getUserCount();
        int premiumUserCount = userManager.getPremiumUserCount();
        int regularUserCount = totalUsers - premiumUserCount;

        // 3. Admin statistics
        int totalAdmins = adminManager.getAdminCount();
        int superAdminCount = adminManager.getSuperAdminCount();
        int regularAdminCount = totalAdmins - superAdminCount;

        // 4. Order statistics
        OrderManager orderManager = new OrderManager(getServletContext());
        Map<OrderStatus, Integer> orderCounts = orderManager.getOrderCountsByStatus();
        double totalSales = orderManager.getTotalSales();
        int pendingOrders = orderCounts.getOrDefault(OrderStatus.PENDING, 0);
        int processingOrders = orderCounts.getOrDefault(OrderStatus.PROCESSING, 0);
        int shippedOrders = orderCounts.getOrDefault(OrderStatus.SHIPPED, 0);
        int deliveredOrders = orderCounts.getOrDefault(OrderStatus.DELIVERED, 0);
        int cancelledOrders = orderCounts.getOrDefault(OrderStatus.CANCELLED, 0);
        int totalOrders = pendingOrders + processingOrders + shippedOrders + deliveredOrders + cancelledOrders;

        // Set attributes for the dashboard
        request.setAttribute("admin", admin);

        // Book statistics
        request.setAttribute("totalBooks", totalBooks);
        request.setAttribute("physicalBookCount", physicalBookCount);
        request.setAttribute("ebookCount", ebookCount);
        request.setAttribute("featuredBookCount", featuredBookCount);
        request.setAttribute("lowStockCount", lowStockCount);

        // User statistics
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("premiumUserCount", premiumUserCount);
        request.setAttribute("regularUserCount", regularUserCount);

        // Admin statistics
        request.setAttribute("totalAdmins", totalAdmins);
        request.setAttribute("superAdminCount", superAdminCount);
        request.setAttribute("regularAdminCount", regularAdminCount);

        // Order statistics
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("pendingOrders", pendingOrders);
        request.setAttribute("processingOrders", processingOrders);
        request.setAttribute("shippedOrders", shippedOrders);
        request.setAttribute("deliveredOrders", deliveredOrders);
        request.setAttribute("cancelledOrders", cancelledOrders);
        request.setAttribute("totalSales", totalSales);

        // Forward to dashboard page
        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }
}
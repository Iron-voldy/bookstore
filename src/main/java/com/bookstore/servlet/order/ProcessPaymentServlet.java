package com.bookstore.servlet.order;

import java.io.IOException;
import java.util.Date;
import java.util.UUID;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.bookstore.model.order.Order;
import com.bookstore.model.order.OrderManager;
import com.bookstore.model.order.Payment;
import com.bookstore.model.order.PaymentMethod;

/**
 * Servlet for handling payment processing
 */
@WebServlet("/process-payment")
public class ProcessPaymentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests - display payment form
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // Check if user is logged in
        if (session.getAttribute("userId") == null) {
            session.setAttribute("errorMessage", "Please log in to process payment");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Check if there's a current order
        String orderId = (String) session.getAttribute("currentOrderId");
        if (orderId == null) {
            session.setAttribute("errorMessage", "No pending order found");
            response.sendRedirect(request.getContextPath() + "/checkout");
            return;
        }

        // Get order details
        OrderManager orderManager = new OrderManager(getServletContext());
        Order order = orderManager.getOrderById(orderId);

        if (order == null) {
            session.setAttribute("errorMessage", "Order not found");
            response.sendRedirect(request.getContextPath() + "/checkout");
            return;
        }

        // Set order in request
        request.setAttribute("order", order);

        // Forward to payment form
        request.getRequestDispatcher("/order/payment-form.jsp").forward(request, response);
    }

    /**
     * Handles POST requests - process payment
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // Check if user is logged in
        if (session.getAttribute("userId") == null) {
            session.setAttribute("errorMessage", "Please log in to process payment");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Check if there's a current order
        String orderId = (String) session.getAttribute("currentOrderId");
        if (orderId == null) {
            session.setAttribute("errorMessage", "No pending order found");
            response.sendRedirect(request.getContextPath() + "/checkout");
            return;
        }

        // Get order details
        OrderManager orderManager = new OrderManager(getServletContext());
        Order order = orderManager.getOrderById(orderId);

        if (order == null) {
            session.setAttribute("errorMessage", "Order not found");
            response.sendRedirect(request.getContextPath() + "/checkout");
            return;
        }

        // Get payment form data
        String paymentMethod = request.getParameter("paymentMethod");
        String cardNumber = request.getParameter("cardNumber");
        String cardName = request.getParameter("cardName");
        String expiryDate = request.getParameter("expiryDate");
        String cvv = request.getParameter("cvv");

        // Validate payment data (simplified)
        if (paymentMethod == null || paymentMethod.trim().isEmpty() ||
                cardNumber == null || cardNumber.trim().isEmpty() ||
                cardName == null || cardName.trim().isEmpty() ||
                expiryDate == null || expiryDate.trim().isEmpty() ||
                cvv == null || cvv.trim().isEmpty()) {

            session.setAttribute("errorMessage", "All payment fields are required");
            response.sendRedirect(request.getContextPath() + "/process-payment");
            return;
        }

        try {
            // Create Payment object
            Payment payment = new Payment();
            payment.setOrderId(orderId);
            payment.setAmount(order.getTotal());

            // Set payment method
            PaymentMethod method = PaymentMethod.fromString(paymentMethod);
            if (method == null) {
                method = PaymentMethod.CREDIT_CARD; // Default
            }
            payment.setPaymentMethod(method);

            // In a real application, you would process the payment with a payment gateway
            // For this example, we'll simulate a successful payment
            payment.setSuccessful(true);
            payment.setTransactionId("TX" + UUID.randomUUID().toString().substring(0, 8));
            payment.setPaymentDate(new Date());

            // Store last 4 digits of card
            String lastFourDigits = cardNumber.length() > 4 ?
                    cardNumber.substring(cardNumber.length() - 4) : cardNumber;
            payment.setPaymentDetails("Card ending in " + lastFourDigits);

            // Add payment to order
            boolean paymentAdded = orderManager.addPayment(orderId, payment);

            if (paymentAdded) {
                // Clear the current order ID from session
                session.removeAttribute("currentOrderId");

                // Set success message
                session.setAttribute("successMessage", "Your order has been placed successfully!");

                // Redirect to order confirmation
                response.sendRedirect(request.getContextPath() + "/order-confirmation?orderId=" + orderId);
            } else {
                session.setAttribute("errorMessage", "Failed to process payment. Please try again.");
                response.sendRedirect(request.getContextPath() + "/process-payment");
            }

        } catch (Exception e) {
            System.err.println("Error processing payment: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/process-payment");
        }
    }
}
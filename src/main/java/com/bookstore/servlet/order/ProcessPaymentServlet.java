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
            session.setAttribute("redirectAfterLogin", request.getContextPath() + "/process-payment");
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

        // Check if order belongs to user
        String userId = (String) session.getAttribute("userId");
        if (!order.getUserId().equals(userId)) {
            session.setAttribute("errorMessage", "You do not have permission to access this order");
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

        // Check if order belongs to user
        String userId = (String) session.getAttribute("userId");
        if (!order.getUserId().equals(userId)) {
            session.setAttribute("errorMessage", "You do not have permission to access this order");
            response.sendRedirect(request.getContextPath() + "/checkout");
            return;
        }

        try {
            // Get payment form data
            String paymentMethodStr = request.getParameter("paymentMethod");

            // Validate payment method
            PaymentMethod paymentMethod;
            try {
                paymentMethod = PaymentMethod.valueOf(paymentMethodStr);
            } catch (IllegalArgumentException e) {
                paymentMethod = PaymentMethod.CREDIT_CARD; // Default fallback
            }

            // Create Payment object
            Payment payment = new Payment();
            payment.setPaymentId(UUID.randomUUID().toString());
            payment.setOrderId(orderId);
            payment.setAmount(order.getTotal());
            payment.setPaymentMethod(paymentMethod);
            payment.setPaymentDate(new Date());

            // For credit/debit card payments, extract info
            if (paymentMethod == PaymentMethod.CREDIT_CARD || paymentMethod == PaymentMethod.DEBIT_CARD) {
                String cardNumber = request.getParameter("cardNumber");
                String cardName = request.getParameter("cardName");

                // Validate card inputs
                if (cardNumber == null || cardNumber.trim().isEmpty() ||
                        cardName == null || cardName.trim().isEmpty()) {
                    session.setAttribute("errorMessage", "Card information is required");
                    response.sendRedirect(request.getContextPath() + "/process-payment");
                    return;
                }

                // Store last 4 digits of card for reference
                String lastFourDigits = "";
                cardNumber = cardNumber.replaceAll("\\s+", "");
                if (cardNumber.length() > 4) {
                    lastFourDigits = cardNumber.substring(cardNumber.length() - 4);
                } else {
                    lastFourDigits = cardNumber;
                }

                // Set payment details
                payment.setPaymentDetails("Card ending in " + lastFourDigits);
            }

            // For demo purposes, always mark payment as successful
            payment.setSuccessful(true);

            // Generate a transaction ID
            payment.setTransactionId("TX" + UUID.randomUUID().toString().substring(0, 8));

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
            session.setAttribute("errorMessage", "An error occurred during payment processing: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/process-payment");
        }
    }
}
package com.bookstore.filter;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Filter to check if admin is logged in for admin pages
 */
@WebFilter(urlPatterns = {"/admin/*"})
public class AdminAuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization code if needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        // Get the requested URL
        String requestURI = httpRequest.getRequestURI();

        // Allow access to login page and resources without authentication
        if (requestURI.endsWith("/admin/login") ||
                requestURI.endsWith("/admin/login.jsp") ||
                requestURI.contains("/resources/") ||
                requestURI.contains("/css/") ||
                requestURI.contains("/js/") ||
                requestURI.contains("/images/")) {

            chain.doFilter(request, response);
            return;
        }

        // Check if the admin is logged in
        boolean isLoggedIn = (session != null && session.getAttribute("adminId") != null);

        if (isLoggedIn) {
            // Admin is logged in, continue with the request
            chain.doFilter(request, response);
        } else {
            // Admin is not logged in, redirect to login page
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/admin/login");
        }
    }

    @Override
    public void destroy() {
        // Cleanup code if needed
    }
}
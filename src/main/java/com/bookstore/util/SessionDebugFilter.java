package com.bookstore.util;

import java.io.IOException;
import java.util.Enumeration;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

/**
 * Filter for debugging session attributes
 */
public class SessionDebugFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Nothing to initialize
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        String uri = httpRequest.getRequestURI();

        System.out.println("===== Session Debug =====");
        System.out.println("URI: " + uri);

        HttpSession session = httpRequest.getSession(false);
        if (session != null) {
            System.out.println("Session exists - ID: " + session.getId());
            System.out.println("Session attributes:");

            Enumeration<String> attributeNames = session.getAttributeNames();
            boolean hasAttributes = false;

            while (attributeNames.hasMoreElements()) {
                hasAttributes = true;
                String name = attributeNames.nextElement();
                Object value = session.getAttribute(name);
                System.out.println("  " + name + " = " + value);
            }

            if (!hasAttributes) {
                System.out.println("  No attributes found");
            }
        } else {
            System.out.println("No session exists");
        }
        System.out.println("=========================");

        // Continue with the filter chain
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Nothing to destroy
    }
}
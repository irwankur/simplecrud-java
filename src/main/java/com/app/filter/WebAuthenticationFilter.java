package com.app.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/*")
public class WebAuthenticationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("WebAuthenticationFilter initialized");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String path = requestURI.substring(contextPath.length());

        System.out.println("Filter path: " + path);

        // URLs that don't require authentication
        if (path.startsWith("/login") ||
                path.startsWith("/logout") ||
                path.startsWith("/css/") ||
                path.startsWith("/bcrypt-test") ||
                path.startsWith("/js/") ||
                path.startsWith("/api/") ||
                path.startsWith("/images/") ||
                path.equals("") ||
                path.endsWith(".css") ||
                path.endsWith(".js") ||
                path.endsWith(".jpg") ||
                path.endsWith(".png")) {

            chain.doFilter(request, response);
            return;
        }

        // Check if user is logged in
        HttpSession session = httpRequest.getSession(false);
        boolean isLoggedIn = (session != null && session.getAttribute("user") != null);

        if (isLoggedIn) {
            // User is logged in, continue request
            chain.doFilter(request, response);
        } else {
            // User is not logged in, redirect to login page
            System.out.println("Unauthorized access to: " + path + ", redirecting to login");
            httpResponse.sendRedirect(contextPath + "/login");
        }
    }

    @Override
    public void destroy() {
        System.out.println("WebAuthenticationFilter destroyed");
    }
}
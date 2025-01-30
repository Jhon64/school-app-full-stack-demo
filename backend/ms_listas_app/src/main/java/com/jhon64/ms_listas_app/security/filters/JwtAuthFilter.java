package com.jhon64.ms_listas_app.security.filters;

import java.io.IOException;

import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;
import org.springframework.web.servlet.HandlerExceptionResolver;

import com.jhon64.ms_listas_app.security.services.JWTService;
import org.springframework.security.core.Authentication;

import jakarta.inject.Qualifier;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Component
public class JwtAuthFilter extends OncePerRequestFilter {
    // private final HandlerExceptionResolver handlerExceptionResolver;

    private final JWTService jwtService;
    private final UserDetailsService userDetailsService;

    public JwtAuthFilter(
            JWTService jwtService,
            UserDetailsService userDetailsService//,
            // HandlerExceptionResolver handlerExceptionResolver
            ) {
        this.jwtService = jwtService;
        this.userDetailsService = userDetailsService;
        // this.handlerExceptionResolver = handlerExceptionResolver;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {

        final String authHead = request.getHeader("Authorization");
        if (authHead == null || !authHead.startsWith("Bearer ")) {
            // response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            // response.setContentType("application/json");
            // String message = "token de autorización no encontrado ";
            // int statusCode = HttpServletResponse.SC_FORBIDDEN;
            // String dataJson="{\"data\":null, \"message\":\"" + message +
            // "\",\"statusCode\": " + statusCode + ", \"timestamp\": " +
            // System.currentTimeMillis() + ",\"error\":\"Forbidden\"}";
            // response.getWriter().write("{\"status\":\"forbidden\",\"data\":"+dataJson+"}");
            // handlerExceptionResolver.resolveException(request, response, null, new
            // Exception(message));
            filterChain.doFilter(request, response);
            return;
        }

        try {
            final String jwt = authHead.substring(7);
            final String userEmail = jwtService.extractUsername(jwt);

            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

            if (userEmail != null && authentication == null) {
            UserDetails userDetails =
            this.userDetailsService.loadUserByUsername(userEmail);

            if (jwtService.isTokenValid(jwt, userDetails)) {
            UsernamePasswordAuthenticationToken authToken = new
            UsernamePasswordAuthenticationToken(
            userDetails,
            null,
            userDetails.getAuthorities()
            );

            authToken.setDetails(new
            WebAuthenticationDetailsSource().buildDetails(request));
            SecurityContextHolder.getContext().setAuthentication(authToken);
            }
            }

            filterChain.doFilter(request, response);
        } catch (Exception e) {
            // filterChain.doFilter(request, response);
            // response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.setContentType("application/json");
            String message = e.getMessage();
            int statusCode = HttpServletResponse.SC_UNAUTHORIZED;
            String dataJson = "{\"data\":null, \"message\":" + message + ",\"status\": " + statusCode
                    + ", \"timestamp\": " + System.currentTimeMillis() + ",\"error\":\"Forbidden\"}";
            response.getWriter().write("{\"status\":\"unauthorized\",\"data\":" + dataJson + "}");
            // response.getWriter().write(dataJson);
            // this.handlerExceptionResolver.resolveException(request, response, null, e);
            // filterChain.doFilter(request, response);
        }
    }

}

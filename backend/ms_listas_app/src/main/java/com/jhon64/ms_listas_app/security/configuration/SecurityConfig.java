package com.jhon64.ms_listas_app.security.configuration;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import com.jhon64.ms_listas_app.security.filters.JwtAuthFilter;

@Configuration
// @EnableWebSecurity
public class SecurityConfig {

        @Autowired
        private CustomUserDetailsService customUserDetailsService;

        @Autowired
        private PasswordEncoder passwordEncoder;
        @Autowired
        JwtAuthFilter jwtAuthorizationFilter;
     
        // @Bean
        // public AuthenticationManager
        // authenticationManager(AuthenticationConfiguration config) throws Exception {
        // return config.getAuthenticationManager();
        // }
  
        @Bean
        public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
                 AuthenticationManagerBuilder auth = http.getSharedObject(
                 AuthenticationManagerBuilder.class
                 );
                 auth.userDetailsService(customUserDetailsService)
                 .passwordEncoder(passwordEncoder);
                 AuthenticationManager authenticationManager = auth.build();

                http.securityMatcher("/v1/**")
                                .csrf(AbstractHttpConfigurer::disable)
                                .authorizeHttpRequests(autorizeRequest -> autorizeRequest
                                                .requestMatchers("/v1/usuarios/login")
                                                .permitAll()
                                                .anyRequest().authenticated())
                                                .addFilterAfter(jwtAuthorizationFilter,UsernamePasswordAuthenticationFilter.class)
                 .sessionManagement(sess ->
                 sess.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                 .authenticationManager(authenticationManager)
                ;

                // return http.build();

                System.out.println("estoy en filter chain");

                return http.build();
        }

        @Bean
        CorsConfigurationSource corsConfigurationSource() {
                CorsConfiguration configuration = new CorsConfiguration();

                configuration.setAllowedOrigins(List.of("http://localhost:8005"));
                configuration.setAllowedMethods(List.of("GET", "POST"));
                configuration.setAllowedHeaders(List.of("Authorization", "Content-Type"));

                UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();

                source.registerCorsConfiguration("/**", configuration);

                return source;
        }

}

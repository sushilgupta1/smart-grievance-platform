package com.sushil.grievance.security;

import java.io.IOException;
import java.util.List;

import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.web.filter.OncePerRequestFilter;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class JwtFilter extends OncePerRequestFilter {

	@Override
	protected void doFilterInternal(HttpServletRequest req, HttpServletResponse response, FilterChain chain)
			throws ServletException, IOException {

		String path = req.getRequestURI();

		if (path.startsWith("/auth/login") || path.startsWith("/auth/register") || path.startsWith("/grievance/track")
				|| path.startsWith("/grievance/feed") || path.startsWith("/grievance/uploads/") || path.startsWith("/grievance/internal/") ||  path.startsWith("/actuator") || path.startsWith("/ws")) {
			chain.doFilter(req, response);
			return;
		}

		String authHeader = req.getHeader("Authorization");

		if (authHeader != null && authHeader.startsWith("Bearer ")) {

			String token = authHeader.substring(7);

			try {
				String email = JwtUtil.validateToken(token);
				String role = JwtUtil.extractRole(token);

				UsernamePasswordAuthenticationToken authentication = new UsernamePasswordAuthenticationToken(email,
						null, List.of(new SimpleGrantedAuthority("ROLE_" + role)));

				authentication.setDetails(new WebAuthenticationDetailsSource().buildDetails(req));

				System.out.println("Authorities: " + authentication.getAuthorities());

				SecurityContextHolder.getContext().setAuthentication(authentication);

			} catch (Exception e) {
				response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
				return;
			}

		} else {
			response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
			return;
		}

		chain.doFilter(req, response);
	}
}

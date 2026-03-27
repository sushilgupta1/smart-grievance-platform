package com.sushil.auth.security;

import java.io.IOException;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class JwtFilter implements Filter {

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {
		
		
		HttpServletRequest req=(HttpServletRequest) request;
		
		String path = req.getRequestURI();
		
		if(path.startsWith("/auth/login") || path.startsWith("/auth/register"))
		{
			chain.doFilter(request, response);
			return;
		}
		
		String authHeader = req.getHeader("Authorization");
		
		if(authHeader == null || !authHeader.startsWith("Bearer "))
		{
			((HttpServletResponse)response).setStatus(HttpServletResponse.SC_UNAUTHORIZED);
			return;
			
		}
		
		String token = authHeader.substring(7);
		
		try {
			JwtUtil.validateToken(token);
			chain.doFilter(request, response);
		} catch (Exception e) {
			((HttpServletResponse)response).setStatus(HttpServletResponse.SC_UNAUTHORIZED);
		}
		
		
	}

}

package com.sushil.gateway.filter;

import java.util.List;

import org.springframework.cloud.gateway.filter.GatewayFilterChain;
import org.springframework.cloud.gateway.filter.GlobalFilter;
import org.springframework.core.Ordered;
import org.springframework.http.HttpStatus;
import org.springframework.http.server.reactive.ServerHttpRequest;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ServerWebExchange;

import com.sushil.gateway.security.JwtUtil;

import io.jsonwebtoken.Claims;
import reactor.core.publisher.Mono;

@Component
public class JwtAuthFilter implements GlobalFilter, Ordered{

	
	
	private final List<String> openEndpoints = List.of( "/auth/login",
	        "/auth/register",
	        "/auth/verify-registration",
	        "/auth/forgot-password",
	        "/auth/reset-password",
	        "/grievance/track",
	        "/grievance/feed",
	        "/grievance/uploads/",
	        "/grievance/internal/",
	        "/actuator");
	
	
	@Override
	public int getOrder() {
		return -1;
	}

	@Override
	public Mono<Void> filter(ServerWebExchange exchange, GatewayFilterChain chain) {
		
		String path=exchange.getRequest().getURI().getPath();
		
		for(String open: openEndpoints)
		{
			if(path.startsWith(open))
				return chain.filter(exchange);
		}
		
		String authHeader= exchange.getRequest().getHeaders().getFirst("Authorization");
		
		if(authHeader==null || !authHeader.startsWith("Bearer "))
		{
			exchange.getResponse().setStatusCode(HttpStatus.UNAUTHORIZED);
			return exchange.getResponse().setComplete();
		}
		
		String token= authHeader.substring(7);
		
		try {
			
			Claims claims= JwtUtil.validateToken(token);
			
			ServerHttpRequest mutatedRequest=exchange.getRequest().mutate()
					.header("X-User-Email", claims.getSubject())
					.header("X-User-Role", (String) claims.get("role"))
					.build();
			
			return chain.filter(exchange.mutate().request(mutatedRequest).build());
			
		} catch (Exception e) {
			
			exchange.getResponse().setStatusCode(HttpStatus.UNAUTHORIZED);
			return exchange.getResponse().setComplete();
		}
		
		
	}
	
	

}

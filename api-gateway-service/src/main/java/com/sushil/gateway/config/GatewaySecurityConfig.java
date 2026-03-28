package com.sushil.gateway.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.web.server.ServerHttpSecurity;
import org.springframework.security.web.server.SecurityWebFilterChain;

@Configuration
public class GatewaySecurityConfig {

	@Bean
	public SecurityWebFilterChain filterChain(ServerHttpSecurity http) throws Exception
	{
		http
		.csrf(csrf->csrf.disable())
		.authorizeExchange(exchange->exchange.anyExchange().permitAll());
		
		return http.build();
	}
}

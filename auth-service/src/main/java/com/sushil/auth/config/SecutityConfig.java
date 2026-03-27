package com.sushil.auth.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

import com.sushil.auth.security.JwtFilter;

import jakarta.servlet.Filter;

@Configuration
public class SecutityConfig {
	
	@Bean
	public Filter jwtFilter()
	{
		return new JwtFilter();
	}
	
	
	@Bean
	public SecurityFilterChain securityFilterChain(HttpSecurity http)throws Exception
	{
		http.csrf(csrf->csrf.disable())
		.authorizeHttpRequests(auth->auth.requestMatchers("/auth/login","/auth/register")
				.permitAll().anyRequest().authenticated())
		.addFilterBefore(jwtFilter(), UsernamePasswordAuthenticationFilter.class);
		
		return http.build();
	}

}

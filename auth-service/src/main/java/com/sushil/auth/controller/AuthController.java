package com.sushil.auth.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.service.annotation.GetExchange;

import com.sushil.auth.dto.LoginRequest;
import com.sushil.auth.dto.RegisterRequest;
import com.sushil.auth.service.AuthService;

@RestController
@RequestMapping("/auth")
public class AuthController {

	@Autowired
	private AuthService authService;
	
	@PostMapping("/login")
	public String login(@RequestBody LoginRequest request)
	{
		return authService.login(request);
	}
	
	@PostMapping("/register")
	public String register(@RequestBody RegisterRequest request)
	{
		return authService.register(request);
	}
}

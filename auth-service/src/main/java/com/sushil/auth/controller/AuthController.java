package com.sushil.auth.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.sushil.auth.dto.LoginRequest;
import com.sushil.auth.dto.RegisterRequest;
import com.sushil.auth.service.AuthService;

@RestController
@RequestMapping("/auth")
public class AuthController {

	@Autowired
	private AuthService authService;
	
	@GetMapping("/test")
	public String test()
	{
		var authentication = SecurityContextHolder.getContext().getAuthentication();
		System.out.println("Auth: "+authentication);
		return "Auth service working";
	}
	
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

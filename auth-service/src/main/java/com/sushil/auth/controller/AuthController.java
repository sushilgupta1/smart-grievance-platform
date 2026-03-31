package com.sushil.auth.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.sushil.auth.dto.LoginRequest;
import com.sushil.auth.dto.PromoteRequest;
import com.sushil.auth.dto.RegisterRequest;
import com.sushil.auth.service.AuthService;

import jakarta.validation.Valid;

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
	public String register(@Valid @RequestBody RegisterRequest request)
	{
		return authService.register(request);
	}
	
	@PutMapping("/promote")
	public String promote(@Valid @RequestBody PromoteRequest request)
	{
		var authentication = SecurityContextHolder.getContext().getAuthentication();
		boolean isAdmin = authentication.getAuthorities().stream().anyMatch(a-> a.getAuthority().equals("ROLE_ADMIN"));
		
		if(!isAdmin)
		{
			throw new RuntimeException("Unauthorized: only superAdmins can promote users");
		}
		return authService.promoteUser(request, authentication.getName());
	}
}

package com.sushil.auth.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
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
import com.sushil.auth.dto.VerifyOtpRequest;
import com.sushil.auth.service.AuthService;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/auth")
public class AuthController {

	@Autowired
	private AuthService authService;

	@GetMapping("/test")
	public String test() {
		var authentication = SecurityContextHolder.getContext().getAuthentication();
		System.out.println("Auth: " + authentication);
		return "Auth service working";
	}

	@PostMapping("/login")
	public ResponseEntity<?> login(@RequestBody LoginRequest request) {
		try {
			return ResponseEntity.ok(authService.login(request));
		} catch (Exception e) {
			return ResponseEntity.status(403).body(e.getMessage());
		}
	}

	@PostMapping("/register")
	public ResponseEntity<?> register(@Valid @RequestBody RegisterRequest request) {
		try {
			return ResponseEntity.ok(authService.register(request));
		} catch (Exception e) {
			return ResponseEntity.status(400).body(e.getMessage());
		}
	}

	@PutMapping("/promote")
	public String promote(@Valid @RequestBody PromoteRequest request) {
		var authentication = SecurityContextHolder.getContext().getAuthentication();
		boolean isAdmin = authentication.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));

		if (!isAdmin) {
			throw new RuntimeException("Unauthorized: only superAdmins can promote users");
		}
		return authService.promoteUser(request, authentication.getName());
	}
	
	@PostMapping("/verify-registration")
	public ResponseEntity<?> verifyRegistration(@RequestBody VerifyOtpRequest request)
	{
		try {
			return ResponseEntity.ok(authService.verifyRegistration(request.getEmail(), request.getOtp()));
		} catch (RuntimeException e) {
			return ResponseEntity.status(400).body(e.getMessage());
		}
		
	}
	
	@PostMapping("/forgot-password")
	public ResponseEntity<?> forgotPassword(@RequestBody Map<String,String> request)
	{
		try {
			return ResponseEntity.ok(authService.requestPasswordReset(request.get("email")));
		} catch (RuntimeException e) {
			return ResponseEntity.status(400).body(e.getMessage());
		}
	}
	
	@PostMapping("/reset-password")
	public ResponseEntity<?> resetPassword(@RequestBody Map<String, String> request)
	{
		try {
			VerifyOtpRequest dto =new VerifyOtpRequest();
			dto.setEmail(request.get("email"));
			dto.setOtp(request.get("token"));
			return ResponseEntity.ok(authService.resetPassword(dto, request.get("newPassword")));
		} catch (RuntimeException e) {
			return ResponseEntity.status(400).body(e.getMessage());
		
		}
	}
}

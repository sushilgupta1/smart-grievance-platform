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

import com.sushil.auth.dto.ForgotPasswordRequest;
import com.sushil.auth.dto.LoginRequest;
import com.sushil.auth.dto.PromoteRequest;
import com.sushil.auth.dto.RegisterRequest;
import com.sushil.auth.dto.ResetPasswordRequest;
import com.sushil.auth.dto.UpdateProfileRequest;
import com.sushil.auth.dto.VerifyOtpRequest;
import com.sushil.auth.service.AuthService;

import jakarta.validation.Valid;
import lombok.val;

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
	public ResponseEntity<?> forgotPassword(@Valid @RequestBody ForgotPasswordRequest request)
	{
		try {
			return ResponseEntity.ok(authService.requestPasswordReset(request.getEmail()));
		} catch (RuntimeException e) {
			return ResponseEntity.status(400).body(e.getMessage());
		}
	}
	
	@PostMapping("/reset-password")
	public ResponseEntity<?> resetPassword(@Valid @RequestBody ResetPasswordRequest request)
	{
		try {
			VerifyOtpRequest dto =new VerifyOtpRequest();
			dto.setEmail(request.getEmail());
			dto.setOtp(request.getToken());
			return ResponseEntity.ok(authService.resetPassword(dto, request.getNewPassword()));
		} catch (RuntimeException e) {
			return ResponseEntity.status(400).body(e.getMessage());
		
		}
	}
	
	@PostMapping("/update")
	public ResponseEntity<?> updateProfile(@Valid @RequestBody UpdateProfileRequest request)
	{
		try {
			String email=SecurityContextHolder.getContext().getAuthentication().getName();
			return ResponseEntity.ok(authService.updateProfile(email, request));
		} catch (RuntimeException e) {
			return ResponseEntity.status(400).body(e.getMessage());
		}
	}
	
	@GetMapping("/me")
	public ResponseEntity<?> getProfile()
	{
		try {
			String email=SecurityContextHolder.getContext().getAuthentication().getName();
			return ResponseEntity.ok(authService.getProfile(email));
		} catch (RuntimeException e) {
			return ResponseEntity.status(400).body(e.getMessage());
		
		}
	}
}

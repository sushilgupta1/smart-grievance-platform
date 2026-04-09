package com.sushil.auth.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ResetPasswordRequest {
	
	@NotBlank(message = "email is required")
	@Email(message = "Invalid email format")
	private String email;
	
	@NotBlank(message = "Token is required")
	@Size(min = 6, max = 6, message = "Token must be exactly 6 digits")
	private String token;
	
	
	@NotBlank(message = "New Password is required")
	@Size(min = 6, message = "Password must be at least 6 characters")
	private String newPassword;

}

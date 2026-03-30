package com.sushil.auth.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class RegisterRequest {
	
	@NotBlank(message = "username cannot be empty")
	@Size(min = 3, max = 50, message = "Username must be between 3 and 50 characters")
	private String username;
	
	@NotBlank(message = "Email is required")
	@Email(message = "Please provide a valid email address format")
	private String email;
	
	@NotBlank(message = "Password cannot be empty")
	@Size(min = 6, message = "password must be at least 6 characters long")
	private String password;
	
	@NotBlank(message = "Mobile number is required")
	@Size(min = 10, max = 15, message = "Mobile number must be between 10 and 15 digits")
	private String mobileNumber;
	

}

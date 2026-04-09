package com.sushil.auth.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UpdateProfileRequest {
	
	@NotBlank(message = "Mobile number cannot be blank")
	@Pattern(regexp = "^[0-9]{10,15}$", message = "Invalid mobile number format")
	private String mobileNumber;

	
}

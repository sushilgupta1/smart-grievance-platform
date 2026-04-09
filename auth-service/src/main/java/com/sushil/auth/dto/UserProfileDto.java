package com.sushil.auth.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UserProfileDto {
	
	private String email;
	private String username;
	private String role;
	private String mobileNumber;
	private String department;
	private boolean isVerified;
	

}

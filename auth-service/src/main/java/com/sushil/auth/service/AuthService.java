package com.sushil.auth.service;

import org.springframework.stereotype.Service;

import com.sushil.auth.dto.RegisterRequest;

@Service
public class AuthService {
	
	public String register(RegisterRequest request)
	{
		return "User Registered: "+request.getUsername();
	}

}

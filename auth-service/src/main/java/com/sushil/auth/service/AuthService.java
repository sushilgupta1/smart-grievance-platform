package com.sushil.auth.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sushil.auth.dto.LoginRequest;
import com.sushil.auth.dto.RegisterRequest;
import com.sushil.auth.entity.User;
import com.sushil.auth.repository.UserRepository;
import com.sushil.auth.security.JwtUtil;

@Service
public class AuthService {
	
	@Autowired
	private UserRepository userRepository;
	
	public String login(LoginRequest request)
	{
		User user = userRepository.findByEmail(request.getEmail())
				.orElse(null);
		
		if(user == null || !user.getPassword().equals(request.getPassword()))
		return "Invalid Credentials";
		
		return JwtUtil.generateToken(user.getEmail());
		
	}
	
	
	public String register(RegisterRequest request)
	{
		User user= new User();
		user.setUsername(request.getUsername());
		user.setEmail(request.getEmail());
		user.setPassword(request.getPassword());
		
		userRepository.save(user);
		
		return "User saved in DB";
		
		 
	}

}

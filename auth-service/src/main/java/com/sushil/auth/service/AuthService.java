package com.sushil.auth.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sushil.auth.dto.RegisterRequest;
import com.sushil.auth.entity.User;
import com.sushil.auth.repository.UserRepository;

@Service
public class AuthService {
	
	@Autowired
	private UserRepository userRepository;
	
	
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

package com.sushil.auth.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.sushil.auth.dto.LoginRequest;
import com.sushil.auth.dto.RegisterRequest;
import com.sushil.auth.entity.User;
import com.sushil.auth.kafka.KafkaProducerService;
import com.sushil.auth.repository.UserRepository;
import com.sushil.auth.security.JwtUtil;

@Service
public class AuthService {
	
	@Autowired
	private UserRepository userRepository;
	
	@Autowired
	private PasswordEncoder passwordEncoder;
	
	@Autowired
	private KafkaProducerService kafkaProducerService;
	
	public String login(LoginRequest request)
	{
		User user = userRepository.findByEmail(request.getEmail())
				.orElse(null);
		System.out.println("Input password: " + request.getPassword());
		System.out.println("DB password: " + user.getPassword());
		
		if (user == null || !passwordEncoder.matches(request.getPassword(), user.getPassword())) {
		    return "Invalid credentials";
		}
		
		return JwtUtil.generateToken(user.getEmail(),user.getRole());
		
	}
	
	
	public String register(RegisterRequest request)
	{
		User user= new User();
		user.setUsername(request.getUsername());
		user.setEmail(request.getEmail());
		user.setPassword(passwordEncoder.encode(request.getPassword()));
		user.setRole("USER");
		userRepository.save(user);
		
		kafkaProducerService.sendMessage("User Registered: "+request.getEmail());
		
		return "User saved in DB";
		
		 
	}

}

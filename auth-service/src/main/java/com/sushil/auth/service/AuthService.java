package com.sushil.auth.service;

import java.util.Random;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.sushil.auth.dto.LoginRequest;
import com.sushil.auth.dto.PromoteRequest;
import com.sushil.auth.dto.RegisterRequest;
import com.sushil.auth.dto.UpdateProfileRequest;
import com.sushil.auth.dto.UserProfileDto;
import com.sushil.auth.dto.VerifyOtpRequest;
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
		
		if (user == null || !passwordEncoder.matches(request.getPassword(), user.getPassword())) {
		    throw new RuntimeException("Invalid credentials");
		}
		
		if(!user.isVerified())
		{
			throw new RuntimeException("Account not verified. Please verify your OTP.");
		}
		
		return JwtUtil.generateToken(user.getEmail(),user.getRole());
		
	}
	
	
	public String register(RegisterRequest request)
	{
		User user = userRepository.findByEmail(request.getEmail()).orElse(null);
		if(user!=null)
		{
			if(user.isVerified())
			throw new RuntimeException("Email is already registered");
			System.out.println("Recycling unverified account for "+request.getEmail());
		}
		else {
			
			user= new User();
			user.setEmail(request.getEmail());
		}
		
		user.setUsername(request.getUsername());
		user.setPassword(passwordEncoder.encode(request.getPassword()));
		user.setRole("USER");
		user.setMobileNumber(request.getMobileNumber());
		
		String generatedOtp = String.format("%06d", new Random().nextInt(999999));
		user.setVerified(false);
		user.setOtp(generatedOtp);
		
		userRepository.save(user);
		
		System.out.println("================================");
		System.out.println("New regestration OTP for: "+user.getEmail());
		System.out.println("OTP CODE: "+generatedOtp);
		System.out.println("================================");
		
		return "Registratiion Authorized. Awaiting Email verification";
		
		
		 
	}
	
	public String verifyRegistration(String email, String otp)
	{
		User user=userRepository.findByEmail(email).orElseThrow(()->new RuntimeException("User not found"));
		
		if(user.isVerified())
		{
			throw new RuntimeException("User is already verified");
		}
		
		if(user.getOtp()!=null && user.getOtp().equals(otp))
		{
			user.setVerified(true);
			user.setOtp(null);
			userRepository.save(user);
			
			String kafkaPayload = String.format("{\"email\": \"%s\", \"mobile\": \"%s\"}", user.getEmail(), user.getMobileNumber());
			
			kafkaProducerService.sendMessage(kafkaPayload);
			
			return "OTP verified Successfully!";
			
		}
		else
		{
			throw new RuntimeException("Invalid Registration OTP Code!");
		}
	}
	
	public String requestPasswordReset(String email)
	{
		User user = userRepository.findByEmail(email).orElse(null);
		
		if(user==null|| !user.isVerified())
		{
			throw new RuntimeException("Verified account noy found for this email...");
		}
		
		String resetToken= String.format("%06d", new Random().nextInt(999999));
		user.setOtp(resetToken);
		userRepository.save(user);
		
		 System.out.println("=========================================");
	     System.out.println(" PASSWORD RESET TOKEN FOR: " + user.getEmail());
	     System.out.println(" RESET TOKEN: " + resetToken);
	     System.out.println("=========================================");
	        
	     return "Reset token generated. Check your console.";
	}
	
	public String resetPassword(VerifyOtpRequest request, String newPassword)
	{
		User user=userRepository.findByEmail(request.getEmail()).orElseThrow(()->new RuntimeException("User not found...") );
		
		if(user.getOtp()!=null && user.getOtp().equals(request.getOtp()))
		{
			user.setPassword(passwordEncoder.encode(newPassword)); 
			user.setOtp(null);
			userRepository.save(user);
			
			return "Password successfully reset!";
		}
		else
		{
			throw new RuntimeException("Invalid or expired reset token");
		}
	}
	
	public String promoteUser(PromoteRequest request, String adminEmail)
	{
		User user= userRepository.findByEmail(request.getEmail()).orElseThrow(()->new RuntimeException("User not found"));
		
		user.setRole(request.getRole());
		user.setDepartment(request.getDepartment());
		
		userRepository.save(user);
		
		String kafkaPayload =  String.format("{\"email\": \"%s\", \"mobile\": \"%s\", \"role\": \"%s\", \"department\": \"%s\"}", 
				user.getEmail(), user.getMobileNumber(), user.getRole(), user.getDepartment());
		
		kafkaProducerService.sendMessage(kafkaPayload);
		
		return "User "+user.getEmail()+" successfully promoted to "+ user.getRole();
	
	}
	
	public String updateProfile(String authenticatedEmail, UpdateProfileRequest request)
	{
		User user = userRepository.findByEmail(authenticatedEmail).orElseThrow(()->new RuntimeException("User not found"));
		
		user.setMobileNumber(request.getMobileNumber());
		userRepository.save(user);
		
		 // Notify Grievance-Service that the mobile number is updated so that in grievance table number must also be updated via kafka
        String kafkaPayload = String.format("{\"email\": \"%s\", \"mobile\": \"%s\"}", user.getEmail(), user.getMobileNumber());
        kafkaProducerService.sendMessage(kafkaPayload);
        
        return "Profile update successfully";
		
	}
	
	public UserProfileDto getProfile(String email)
	{
		User user = userRepository.findByEmail(email).orElseThrow(()->new RuntimeException("User not found..."));
		
		UserProfileDto dto =new UserProfileDto();
		dto.setEmail(user.getEmail());
		dto.setUsername(user.getUsername());
		dto.setRole(user.getRole());
		dto.setMobileNumber(user.getMobileNumber());
		dto.setDepartment(user.getDepartment());
		dto.setVerified(user.isVerified());
		
		return dto;
	}

}

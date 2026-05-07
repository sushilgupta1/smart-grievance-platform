package com.sushil.notification.kafka;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Service;

import com.sushil.notification.service.EmailService;

@Service
public class KafkaConsumerService {

	@Autowired
	private EmailService emailService;
	
	@KafkaListener(topics = "auth-email-events", groupId = "notification-group")
	public void handleAuthEvents(String message)
	{
		String[] parts=message.split(",");
		if(parts.length==3)
		{
			String to=parts[0];
			String otp=parts[1];
			String subject=parts[2];
			
			 String htmlBody = "<div style='font-family: Arial; padding: 20px; border: 1px solid #e2e8f0; border-radius: 10px; max-width: 500px;'>" +
                     "<h2 style='color: #3b82f6;'>Smart Grievance Platform</h2>" +
                     "<p>Hello,</p>" +
                     "<p>Your secure One-Time Password (OTP) is:</p>" +
                     "<h1 style='background: #f1f5f9; padding: 10px; text-align: center; letter-spacing: 5px; color: #0f172a; border-radius: 5px;'>" + otp + "</h1>" +
                     "<p style='color: #64748b; font-size: 12px;'>This code is valid for 10 minutes. Do not share it with anyone.</p>" +
                     "</div>";
			 
			 emailService.sendHtmlMail(to, subject, htmlBody);
		}
	}
	
	@KafkaListener(topics = "grievance-events", groupId = "notification-group")
	public void handleGrievanceEvents(String message)
	{
		 System.out.println("Notification Engine Registered Grievance Event: " + message);
		
	}
}

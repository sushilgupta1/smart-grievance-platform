package com.sushil.notification.kafka;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Service;

import com.sushil.notification.service.EmailService;

@Service
public class KafkaConsumerService {

	@Autowired
	private EmailService emailService;
	
	@KafkaListener(topics = "user-events",groupId = "notification-group")
	public void consume(String message)
	{
		System.out.println("Received event: "+message);
		
		emailService.sendMail(message);
	}
}

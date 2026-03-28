package com.sushil.notification.service;

import org.springframework.stereotype.Service;

@Service
public class EmailService {

	public void sendMail(String message)
	{
		System.out.println("Sending Email....");
		System.out.println("Message : "+message);
		System.out.println("Email sent successfully....");
	}
}

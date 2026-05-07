package com.sushil.notification.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import jakarta.mail.internet.MimeMessage;


@Service
public class EmailService {

	@Autowired
	private JavaMailSender mailSender;
	
	@Value("${spring.mail.username}")
	private String fromEmail;
	
	
	public void sendHtmlMail(String to, String subject, String htmlBody)
	{
		try {
			
		MimeMessage message=mailSender.createMimeMessage();
		MimeMessageHelper helper=new MimeMessageHelper(message, true, "UTF-8");
		
		helper.setFrom(fromEmail);
		helper.setTo(to);
		helper.setSubject(subject);
		helper.setText(htmlBody,true);
		
		mailSender.send(message);
		System.out.println("Email successfully sent to: "+to);
		}
		catch (Exception e) {
			System.err.println("Failsed to send email to "+to+": "+e.getMessage());
		}
		
	}
}

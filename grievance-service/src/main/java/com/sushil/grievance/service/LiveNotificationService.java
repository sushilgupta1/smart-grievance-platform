package com.sushil.grievance.service;

import org.springframework.stereotype.Service;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
@Service
public class LiveNotificationService {

	@Autowired
	private SimpMessagingTemplate messagingTemplate;
	
	public void pushDashboardUpdate(String eventType, String message)
	{
		messagingTemplate.convertAndSend("/topic/dashboard", 
	            Map.of("type", eventType, "message", message, "timestamp", System.currentTimeMillis())
	        );
	}

}

package com.sushil.notification.kafka;

import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Service;

@Service
public class KafkaConsumerService {

	@KafkaListener(topics = "user-events",groupId = "notification-group")
	public void consume(String message)
	{
		System.out.println("Received event: "+message);
	}
}

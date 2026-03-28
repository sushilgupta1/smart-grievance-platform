package com.sushil.auth.kafka;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Service;

@Service
public class KafkaProducerService {
	
	@Autowired
	private KafkaTemplate<String, String> kafkaTemplate;
	
	private static final String TOPIC= "user-events";
	
	public void sendMessage(String msg)
	{
		kafkaTemplate.send(TOPIC,msg);
	}

}

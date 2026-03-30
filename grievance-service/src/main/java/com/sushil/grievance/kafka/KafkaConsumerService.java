package com.sushil.grievance.kafka;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.sushil.grievance.entity.CitizenReference;
import com.sushil.grievance.repository.CitizenReferenceRepository;

@Service
public class KafkaConsumerService {
	
	@Autowired
	private CitizenReferenceRepository citizenRepo;
	
	@KafkaListener(topics = "user-events", groupId = "grievance-group")
	public void consumeUserRegistration(String jsonMessage)
	{
		System.out.println("Kafka DB syncer caught message: "+jsonMessage);
		
		try {
			ObjectMapper mapper = new ObjectMapper();
			JsonNode payload = mapper.readTree(jsonMessage);
			
			String email= payload.path("email").asText();
			String mobile= payload.path("mobile").asText();
			
			if(!email.isEmpty() && !mobile.isEmpty())
			{
				CitizenReference citizen = new CitizenReference();
				citizen.setEmail(email);
				citizen.setUserMobile(mobile);
				
				citizenRepo.save(citizen);
				System.out.println("Synchronized Citizen Profile for: "+email);
			}
		} catch (Exception e) {

		System.err.println("Failed to parse Kafka Citizen Message: "+e.getMessage());
		}
	}

}

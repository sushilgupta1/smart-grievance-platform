package com.sushil.analytics.kafka;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.sushil.analytics.entity.TicketRecord;
import com.sushil.analytics.repository.TicketRecordRepository;

@Service
public class AnalyticsConsumer {

	@Autowired
	private TicketRecordRepository repository;
	
	private final ObjectMapper mapper=new ObjectMapper();
	
	@KafkaListener(topics = "analytics-events", groupId = "analytics-group")
	public void consumeEvent(String message)
	{
		try {
			 JsonNode node=mapper.readTree(message);
			 Long id=node.get("id").asLong();
			 String status=node.get("status").asText();
			 String dept=node.get("department").asText();
			 
			 
			 TicketRecord record= repository.findById(id).orElse(new TicketRecord());
			 record.setGrievanceId(id);
			 record.setStatus(status);
			 record.setDepartment(dept);
			 
			 repository.save(record);
			 System.out.println("Analytics DB Updated for Grievance #" + id);
		} catch (Exception e) {
			 System.err.println("Error parsing analytics event: " + e.getMessage());
		}
	}
}

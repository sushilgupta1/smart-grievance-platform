package com.sushil.grievance.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sushil.grievance.entity.Grievance;
import com.sushil.grievance.kafka.KafkaProducerService;
import com.sushil.grievance.repository.GrievanceRepository;

@Service
public class GrievanceService {
	
	@Autowired
	private GrievanceRepository repository;
	
	@Autowired
	private KafkaProducerService kafkaProducerService;
	
	public Grievance createGrievance(Grievance grievance)
	{
		grievance.setStatus("OPEN");
		Grievance saved= repository.save(grievance);
		
		kafkaProducerService.sendMessage("New Grievance Created: "+saved.getTitle()+" by "+saved.getUserEmail());
		
		return saved;
	}
	

}

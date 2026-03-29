package com.sushil.grievance.service;

import java.util.List;

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
	
	public Grievance createGrievance(Grievance grievance, String email)
	{
		grievance.setUserEmail(email);
		grievance.setStatus("OPEN");
		Grievance saved= repository.save(grievance);
		
		kafkaProducerService.sendMessage("New Grievance Created: "+saved.getTitle()+" by "+email);
		
		return saved;
	}
	
	public Grievance assignGrievance(Long id, String admin)
	{
		Grievance g = repository.findById(id).orElseThrow();
		g.setAssignedTo(admin);
		g.setStatus("IN_PROGRESS");
		
		return repository.save(g);
	}
	
	public Grievance updateStatus(Long id, String status, String remarks)
	{
		Grievance g = repository.findById(id).orElseThrow();
		g.setStatus(status);
		g.setRemarks(remarks);
		return repository.save(g);
	}
	
	
	public List<Grievance> getMyGrievances(String email)
	{
		return repository.findByUserEmail(email);
	}

	public List<Grievance> getAllGrievance()
	{
		return repository.findAll();
	}
}

package com.sushil.grievance.service;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.sushil.grievance.dto.GrievanceRequest;
import com.sushil.grievance.dto.ResolveRequest;
import com.sushil.grievance.entity.CitizenReference;
import com.sushil.grievance.entity.Grievance;
import com.sushil.grievance.exception.ResourceNotFoundException;
import com.sushil.grievance.kafka.KafkaProducerService;
import com.sushil.grievance.repository.CitizenReferenceRepository;
import com.sushil.grievance.repository.GrievanceRepository;

@Service
public class GrievanceService {
	
	@Autowired
	private GrievanceRepository repository;
	
	@Autowired
	private CitizenReferenceRepository citizenRepo;
	
	@Autowired
	private KafkaProducerService kafkaProducerService;
	
	@Autowired
	private GeminiAiService geminiAiService;
	
	public Grievance createGrievance(GrievanceRequest request, String email)
	{
		Grievance grievance=new Grievance();
		grievance.setTitle(request.getTitle());
		grievance.setDescription(request.getDescription());
		
		grievance.setAttachmentUrl(request.getAttachmentUrl());
		grievance.setLocationCoordinates(request.getLocationCoordinates());
		
		grievance.setUserEmail(email);
	
		CitizenReference citizen =citizenRepo.findById(email).orElse(null);
		if(citizen!=null)
		{
			grievance.setUserMobile(citizen.getUserMobile());
		}
		
		grievance.setStatus("OPEN");
		grievance.setCreatedAt(LocalDateTime.now());
		grievance.setResolutionDeadline(LocalDateTime.now().plusDays(7));
		
		try {
			String aiResponse = geminiAiService.analyzeGrievance(request.getDescription());
			
			// Bulletproof JSON extractor: LLMs often add text like "Here is your JSON:"
			int startIndex = aiResponse.indexOf("{");
			int endIndex = aiResponse.lastIndexOf("}");
			if (startIndex != -1 && endIndex != -1) {
			    aiResponse = aiResponse.substring(startIndex, endIndex + 1);
			}

			ObjectMapper mapper = new ObjectMapper();
			mapper.configure(JsonParser.Feature.ALLOW_SINGLE_QUOTES, true);
			JsonNode aiJson = mapper.readTree(aiResponse);
			
			grievance.setCategory(aiJson.path("category").asText("Other"));
			grievance.setPriorityScore(aiJson.path("priorityScore").asInt(1));
			
		} catch (Exception e) {
			System.err.println("AI engine failed to process. Defaulting to safe values. Reason: " + e.getMessage());
			e.printStackTrace();
			grievance.setCategory("Unassigned");
			grievance.setPriorityScore(1);
		}
		
		
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
	
	public List<Grievance> getByStatus(String status)
	{
		return repository.findByStatus(status);
	}
	
	public Grievance getById(Long id)
	{
		return repository.findById(id).orElseThrow(()->new ResourceNotFoundException("Grievance not found"));
	}
	
	public Grievance updateResolution(Long id, ResolveRequest request) {
		Grievance g = repository.findById(id).orElseThrow();
		
		g.setStatus(request.getStatus());
		g.setRemarks(request.getRemarks());
		
		g.setPublicPostDescription(request.getPublicPostDescription());
		g.setResolvedAttachmentUrl(request.getResolveAttachmentUrl());
		
		Grievance saved = repository.save(g);
		
		if("RESOLVED".equalsIgnoreCase(request.getStatus()))
		{
			kafkaProducerService.sendMessage("Grievance #"+id+" was resolved and published to the public feed!");
		}
		return saved;
		
		
	}
}

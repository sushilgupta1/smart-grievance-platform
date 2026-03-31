package com.sushil.grievance.service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.BeanUtils;
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
		
		try {
			List<CitizenReference> availableOfficers = citizenRepo.findByRoleAndDepartment("OFFICER", grievance.getCategory());
			if (availableOfficers != null && !availableOfficers.isEmpty()) {
				String bestOfficerEmail = null;
				long lowestWorkload = Long.MAX_VALUE;
				
				for (CitizenReference officer : availableOfficers) {
					long currentLoad = repository.countActiveTicketsForOfficer(officer.getEmail());
					if (currentLoad < lowestWorkload) {
						lowestWorkload = currentLoad;
						bestOfficerEmail = officer.getEmail();
					}
				}
				
				if (bestOfficerEmail != null) {
					grievance.setAssignedTo(bestOfficerEmail);
					System.out.println("Assigned ticket to least-loaded officer: " + bestOfficerEmail + " (Load: " + lowestWorkload + ")");
				}
			} else {
			    System.out.println("No officers available for department: " + grievance.getCategory());
			}
		} catch(Exception e) {
			System.err.println("Officer Routing Failed: " + e.getMessage());
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
		List<Grievance> origionalGrievances = repository.findByUserEmail(email);
		List<Grievance> securedGrievances = new ArrayList<>();
		
		for(Grievance g: origionalGrievances)
		{
			Grievance safeClone=new Grievance();
			BeanUtils.copyProperties(g, safeClone);
			safeClone.setRemarks(null);
			securedGrievances.add(safeClone);
		}
		return securedGrievances;
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
	
	public List<Grievance> getAssignedGrievance(String officerEmail)
	{
		return repository.findByAssignedTo(officerEmail);
	}
	
	
	public Grievance updateResolution(Long id, ResolveRequest request) {
		Grievance g = repository.findById(id).orElseThrow();
		
		g.setStatus(request.getStatus());
		g.setRemarks(request.getRemarks());
		
		g.setPublicPostDescription(request.getPublicPostDescription());
		g.setResolvedAttachmentUrl(request.getResolveAttachmentUrl());
		g.setCitizenMessage(request.getCitizenMessage());
		Grievance saved = repository.save(g);
		
		if("RESOLVED".equalsIgnoreCase(request.getStatus()))
		{
			kafkaProducerService.sendMessage("Grievance #"+id+" was resolved and published to the public feed!");
		}
		return saved;
		
		
	}
	
	public Grievance requestReassigment(Long id, String reason)
	{
		Grievance g=repository.findById(id).orElseThrow();
		g.setAssignedTo(null);
		g.setStatus("OPEN");
		g.setRemarks("REASSIGNMENT REQUESTED. Justification: "+reason);
		
		return repository.save(g);
	}
	
	public Grievance reopenGrievance(Long id, String reason, String citizenEmail)
	{
		Grievance g= repository.findById(id).orElseThrow();
		
		if(!g.getUserEmail().equalsIgnoreCase(citizenEmail))
		{
			throw new RuntimeException("Unauthorized: only the true owner can dispute this ticket");
		}
		
		g.setStatus("REOPENED");
		
		String currentRemark= g.getRemarks()==null?"":g.getRemarks()+"\n";
		String disputeText = (reason!=null && !reason.trim().isEmpty())?reason:"Issue was not resolved properly.";
		g.setRemarks(currentRemark+"CITIZEN DISPUTE FILED: "+disputeText);
		
		Grievance saved=repository.save(g);
		kafkaProducerService.sendMessage("URGENT: Grievance #"+id+" was RE-OPENED by the citizen!");
		
		return saved;
	}
}

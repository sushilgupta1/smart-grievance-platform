package com.sushil.grievance.service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.cache.annotation.Caching;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.sushil.grievance.dto.GrievanceRequest;
import com.sushil.grievance.dto.ResolveRequest;
import com.sushil.grievance.entity.CitizenReference;
import com.sushil.grievance.entity.Grievance;
import com.sushil.grievance.exception.ResourceNotFoundException;
import com.sushil.grievance.feign.ClassificationClient;
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
	private ClassificationClient classificationClient;
	
	@Autowired
	private FileStorageService fileStorageService;
	
	@Caching(evict = {
		    @CacheEvict(value = "allGrievances", allEntries = true),
		    @CacheEvict(value = "myGrievances", allEntries = true),
		    @CacheEvict(value = "officerGrievances", allEntries = true)
		})	public Grievance createGrievance(GrievanceRequest request, String email, MultipartFile file)
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
		
		if(file!=null && !file.isEmpty())
		{
			String fileName=fileStorageService.storeFile(file);
			grievance.setAttachmentUrl("/grievance/uploads/"+fileName);
		}
		else
		{
			grievance.setAttachmentUrl(null);
		}
		
		try {
			
			Map<String, String> requestPayload= new HashMap<>();
			requestPayload.put("description", request.getDescription());
			
			Map<String, Object> aiResponse= classificationClient.classifyGrievance(requestPayload);
			grievance.setCategory((String) aiResponse.getOrDefault("category", "Other"));
			
			Object scoreObj=aiResponse.get("priorityScore");
			int score=1;
			if(scoreObj instanceof Integer)
			{
				score=(Integer) scoreObj;
			} else if(scoreObj instanceof String)
			{
				score=Integer.parseInt((String)scoreObj);
			}
			grievance.setPriorityScore(score);

		} catch (Exception e) {
			System.err.println("Failed to reach CLASSIFICATION-SERVICE via Feign. Reason: " + e.getMessage());
			grievance.setCategory("Unassigned");
			grievance.setPriorityScore(1);
		}
		
		
		Grievance saved= repository.save(grievance);
		
		kafkaProducerService.sendMessage("New Grievance Created: "+saved.getTitle()+" by "+email);
		kafkaProducerService.sendClassifiedMessage(saved.getId() + ":" + saved.getCategory());
		kafkaProducerService.sendAnalyticsEvent(saved.getId(), saved.getStatus(), saved.getCategory());
		
		return saved;
	}
	
	@Caching(evict = {
		    @CacheEvict(value = "allGrievances", allEntries = true),
		    @CacheEvict(value = "myGrievances", allEntries = true),
		    @CacheEvict(value = "officerGrievances", allEntries = true)
		})
	public Grievance assignGrievance(Long id, String admin)
	{
		Grievance g = repository.findById(id).orElseThrow();
		g.setAssignedTo(admin);
		g.setStatus("IN_PROGRESS");
		
		kafkaProducerService.sendAnalyticsEvent(g.getId(), g.getStatus(), g.getCategory());
		
		return repository.save(g);
	}
	
	@Caching(evict = {
		    @CacheEvict(value = "allGrievances", allEntries = true),
		    @CacheEvict(value = "myGrievances", allEntries = true),
		    @CacheEvict(value = "officerGrievances", allEntries = true)
		})
	public Grievance updateStatus(Long id, String status, String remarks)
	{
		Grievance g = repository.findById(id).orElseThrow();
		g.setStatus(status);
		g.setRemarks(remarks);
		
		kafkaProducerService.sendAnalyticsEvent(g.getId(), g.getStatus(), g.getCategory());
		return repository.save(g);
	}
	
	@Cacheable(value = "myGrievances", key = "#email")
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

	@Cacheable(value = "allGrievance")
	public List<Grievance> getAllGrievance()
	{
		System.out.println(">>> CACHE MISS: Fetching all grievances from MySQL...");
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
	
	@Cacheable(value = "officerGrievances", key = "#officerEmail")
	public List<Grievance> getAssignedGrievance(String officerEmail)
	{
		return repository.findByAssignedTo(officerEmail);
	}
	
	@Caching(evict = {
		    @CacheEvict(value = "allGrievances", allEntries = true),
		    @CacheEvict(value = "myGrievances", allEntries = true),
		    @CacheEvict(value = "officerGrievances", allEntries = true)
		})
	public Grievance updateResolution(Long id, ResolveRequest request, MultipartFile file ) {
		Grievance g = repository.findById(id).orElseThrow();
		
		g.setStatus(request.getStatus());
		g.setRemarks(request.getRemarks());
		
		g.setPublicPostDescription(request.getPublicPostDescription());
		g.setResolvedAttachmentUrl(request.getResolveAttachmentUrl());
		g.setCitizenMessage(request.getCitizenMessage());
		
		if(file!=null && !file.isEmpty())
		{
			String fileName=fileStorageService.storeFile(file);
			g.setResolvedAttachmentUrl("/grievance/uploads/" + fileName);
		}
		else
		{
			g.setAttachmentUrl(null);
		}
		
		Grievance saved = repository.save(g);
		
		if("RESOLVED".equalsIgnoreCase(request.getStatus()))
		{
			kafkaProducerService.sendMessage("Grievance #"+id+" was resolved and published to the public feed!");
		}
		kafkaProducerService.sendAnalyticsEvent(saved.getId(), saved.getStatus(), saved.getCategory());
		return saved;
		
		
	}
	
	@Caching(evict = {
		    @CacheEvict(value = "allGrievances", allEntries = true),
		    @CacheEvict(value = "myGrievances", allEntries = true),
		    @CacheEvict(value = "officerGrievances", allEntries = true)
		})
	public Grievance requestReassigment(Long id, String reason)
	{
		Grievance g=repository.findById(id).orElseThrow();
		g.setAssignedTo(null);
		g.setStatus("OPEN");
		g.setRemarks("REASSIGNMENT REQUESTED. Justification: "+reason);
		
		kafkaProducerService.sendAnalyticsEvent(g.getId(), g.getStatus(), g.getCategory());
		return repository.save(g);
	}
	
	@Caching(evict = {
		    @CacheEvict(value = "allGrievances", allEntries = true),
		    @CacheEvict(value = "myGrievances", allEntries = true),
		    @CacheEvict(value = "officerGrievances", allEntries = true)
		})
	public Grievance reopenGrievance(Long id, String reason, String citizenEmail)
	{
		Grievance g= repository.findById(id).orElseThrow(()-> new RuntimeException("Grievance not found"));
		
		if(g.getReopenCount()>=1)
		{
			throw new RuntimeException("Maximum dispute limit exhausted. This ticket is permanently sealed.");
		}		
		
		if(!g.getUserEmail().equalsIgnoreCase(citizenEmail))
		{
			throw new RuntimeException("Unauthorized: only the true owner can dispute this ticket");
		}
		
		g.setReopenCount(g.getReopenCount()+1);
		g.setStatus("REOPENED");
		
		String currentRemark= g.getRemarks()==null?"":g.getRemarks()+"\n";
		String disputeText = (reason!=null && !reason.trim().isEmpty())?reason:"Issue was not resolved properly.";
		g.setRemarks(currentRemark+"CITIZEN DISPUTE FILED: "+disputeText);
		
		Grievance saved=repository.save(g);

		kafkaProducerService.sendMessage("URGENT: Grievance #"+id+" was RE-OPENED by the citizen!");
		kafkaProducerService.sendAnalyticsEvent(saved.getId(), saved.getStatus(), saved.getCategory());
		
		return saved;
	}
	
	public String findLeastLoadedOfficer(String department)
	{
		List<CitizenReference> availableOfficers= citizenRepo.findByRoleAndDepartment("OFFICER", department);
		
		if(availableOfficers==null || availableOfficers.isEmpty())
			return null;
		
		String bestOfficerEmail=null;
		long lowestWorkload=Long.MAX_VALUE;
		
		for(CitizenReference officer:availableOfficers)
		{
			long currentLoad= repository.countActiveTicketsForOfficer(officer.getEmail());
			if(currentLoad<lowestWorkload)
			{
				lowestWorkload=currentLoad;
				bestOfficerEmail=officer.getEmail();
				
			}
		}
		return bestOfficerEmail;
	}
}

package com.sushil.grievance.controller;

import java.util.List;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.sushil.grievance.dto.GrievanceRequest;
import com.sushil.grievance.dto.ResolveRequest;
import com.sushil.grievance.entity.Grievance;
import com.sushil.grievance.service.GrievanceService;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/grievance")
public class GrievanceController {

	@Autowired
	private GrievanceService service;

	@PostMapping
	public Grievance create(@Valid @RequestBody GrievanceRequest request) {
		String email = (String) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		return service.createGrievance(request, email);
	}

	@PutMapping("/assign/{id}")
	@PreAuthorize("hasRole('ADMIN')")
	public Grievance assign(@PathVariable Long id, @RequestParam String admin) {
		return service.assignGrievance(id, admin);
	}

	@PutMapping("status/{id}")
	@PreAuthorize("hasRole('ADMIN')")
	public Grievance updateStatus(@PathVariable Long id, @RequestParam String status, @RequestParam String remarks) {
		return service.updateStatus(id, status, remarks);
	}

	@GetMapping("/my")
	public List<Grievance> myGrievances() {
		String email = (String) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		return service.getMyGrievances(email);
	}

	@GetMapping("/all")
	@PreAuthorize("hasRole('ADMIN')")
	public List<Grievance> getAll() {
		return service.getAllGrievance();
	}

	@PostMapping("/status")
	@PreAuthorize("hasRole('ADMIN')")
	public List<Grievance> getByStatus(@RequestParam String status) {
		return service.getByStatus(status);
	}

	@GetMapping("/{id}")
	public Grievance getById(@PathVariable Long id) {
		return service.getById(id);
	}

	@GetMapping("/track")
	public Grievance trackPublicStatus(@RequestParam Long id, @RequestParam String email) {
		Grievance g = service.getById(id);

		if (!g.getUserEmail().equalsIgnoreCase(email)) {
			throw new RuntimeException("Unauthorized: Email does not match Grievance ID");
		}
		return g;
	}

	@GetMapping("/feed")
	public List<Grievance> getPublicFeed() {
		return service.getByStatus("RESOLVED");
	}
	
	@PutMapping("/{id}/status")
	@PreAuthorize("hasAnyRole('ADMIN', 'OFFICER')")
	public Grievance updateStatus(@PathVariable Long id, @RequestBody ResolveRequest request) {
		return service.updateResolution(id, request);
	}
	
	@GetMapping("/assigned")
	public ResponseEntity<List<Grievance>> getAssignedGrievance()
	{
		String adminEmail = SecurityContextHolder.getContext().getAuthentication().getName();
		return ResponseEntity.ok(service.getAssignedGrievance(adminEmail));
	}
	
	@PutMapping("/{id}/reassign")
	@PreAuthorize("hasAnyRole('ADMIN', 'OFFICER')")
	public Grievance reassign(@PathVariable Long id, @RequestParam String reason)
	{
		return service.requestReassigment(id, reason);
	}
	
	@PutMapping("/{id}/reopen")
	public Grievance reopenTicket(@PathVariable Long id, @RequestParam(required = false) String reason)
	{
		String citizenEmail = SecurityContextHolder.getContext().getAuthentication().getName();
		return service.reopenGrievance(id, reason, citizenEmail);
		
	}
}

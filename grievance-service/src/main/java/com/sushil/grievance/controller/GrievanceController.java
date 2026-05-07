package com.sushil.grievance.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
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
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

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

	@PostMapping(consumes = { "multipart/form-data" })
	public Grievance create(@Valid @RequestPart("grievance") GrievanceRequest request,
			@RequestPart(value = "file", required = false) MultipartFile file) {
		String email = (String) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		return service.createGrievance(request, email, file);
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

	@PutMapping(value = "/{id}/status", consumes = { "multipart/form-data" })
	@PreAuthorize("hasAnyRole('ADMIN', 'OFFICER')")
	public Grievance updateStatus(@PathVariable Long id, @RequestPart("resolution") ResolveRequest request,
			@RequestPart(value = "file", required = false) MultipartFile file) {
		return service.updateResolution(id, request, file);
	}

	@GetMapping("/assigned")
	public ResponseEntity<List<Grievance>> getAssignedGrievance() {
		String adminEmail = SecurityContextHolder.getContext().getAuthentication().getName();
		return ResponseEntity.ok(service.getAssignedGrievance(adminEmail));
	}

	@PutMapping("/{id}/reassign")
	@PreAuthorize("hasAnyRole('ADMIN', 'OFFICER')")
	public Grievance reassign(@PathVariable Long id, @RequestParam String reason) {
		return service.requestReassigment(id, reason);
	}

	@PutMapping("/{id}/reopen")
	public Grievance reopenTicket(@PathVariable Long id, @RequestParam(required = false) String reason) {
		String citizenEmail = SecurityContextHolder.getContext().getAuthentication().getName();
		return service.reopenGrievance(id, reason, citizenEmail);

	}
	
	@GetMapping("/internal/best-officer")
	public String getBestOfficer(@RequestParam String department)
	{
		return service.findLeastLoadedOfficer(department);
	}
	
	@PutMapping("/internal/assign/{id}")
	public ResponseEntity<Grievance> internalAssignGrievance(@PathVariable Long id, @RequestParam String admin)
	{
		return ResponseEntity.ok(service.assignGrievance(id, admin));
	}
}

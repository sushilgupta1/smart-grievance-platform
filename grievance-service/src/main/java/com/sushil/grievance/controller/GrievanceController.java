package com.sushil.grievance.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.sushil.grievance.entity.Grievance;
import com.sushil.grievance.service.GrievanceService;


@RestController
@RequestMapping("/grievance")
public class GrievanceController {
	
	@Autowired
	private GrievanceService service;

	@PostMapping
	public Grievance create(@RequestBody Grievance grievance)
	{
		String email=(String) SecurityContextHolder
				.getContext()
				.getAuthentication()
				.getPrincipal();
		return service.createGrievance(grievance,email);
	}
	
	@PutMapping("/assign/{id}")
	public Grievance assign(@PathVariable Long id, @RequestParam String admin)
	{
		return service.assignGrievance(id, admin);
	}
	
	@PutMapping("status/{id}")
	public Grievance updateStatus(@PathVariable Long id,@RequestParam String status,@RequestParam String remarks)
	{
		return service.updateStatus(id, status, remarks);
	}
	
	@GetMapping("/my")
	public List<Grievance> myGrievances()
	{
		String email=(String) SecurityContextHolder
				.getContext()
				.getAuthentication()
				.getPrincipal();
		return service.getMyGrievances(email);
	}
}

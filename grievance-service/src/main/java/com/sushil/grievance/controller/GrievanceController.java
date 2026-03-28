package com.sushil.grievance.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
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
		return service.createGrievance(grievance);
	}
}

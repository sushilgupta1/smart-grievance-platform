package com.sushil.grievance.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sushil.grievance.entity.Grievance;
import com.sushil.grievance.repository.GrievanceRepository;

@Service
public class GrievanceService {
	
	@Autowired
	private GrievanceRepository repository;
	
	public Grievance createGrievance(Grievance grievance)
	{
		grievance.setStatus("OPEN");
		return repository.save(grievance);
	}
	

}

package com.sushil.assignment.feign;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestParam;

@FeignClient(name = "grievance-service")
public interface GrievanceClient {
	
	@GetMapping("/grievance/internal/best-officer")
	String getBestOfficer(@RequestParam("department") String department);
	
	@PutMapping("/grievance/internal/assign/{id}")
	void assignGrievance(@PathVariable("id") Long id, @RequestParam("admin")String adminEmail);

}

package com.sushil.grievance.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.sushil.grievance.entity.CitizenReference;

public interface CitizenReferenceRepository extends JpaRepository<CitizenReference, String>{
	
	List<CitizenReference> findByRoleAndDepartment(String role, String department);

}

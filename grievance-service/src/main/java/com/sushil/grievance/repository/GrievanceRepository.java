package com.sushil.grievance.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.sushil.grievance.entity.Grievance;


public interface GrievanceRepository extends JpaRepository<Grievance, Long> {

	List<Grievance> findByUserEmail(String email);
	List<Grievance> findByStatus(String status);
	
	@Query("SELECT COUNT(g) FROM Grievance g WHERE g.assignedTo = :email AND g.status IN ('OPEN', 'IN PROGRESS')")
	long countActiveTicketsForOfficer(@Param("email") String email);
	
	List<Grievance> findByAssignedTo(String assignedTo);
}

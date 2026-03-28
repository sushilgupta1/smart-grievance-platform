package com.sushil.grievance.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.sushil.grievance.entity.Grievance;

public interface GrievanceRepository extends JpaRepository<Grievance, Long> {

}

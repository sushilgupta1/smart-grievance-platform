package com.sushil.analytics.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import com.sushil.analytics.entity.TicketRecord;

public interface TicketRecordRepository extends JpaRepository<TicketRecord, Long>{

	@Query("SELECT t.status, COUNT(t) FROM TicketRecord t GROUP BY t.status")
	List<Object[]> countByStatus();
	
	
	@Query("SELECT t.department, COUNT(t) FROM TicketRecord t GROUP BY t.department")
	List<Object[]> countByDepartment();
}

package com.sushil.analytics.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import lombok.Data;

@Entity
@Data
public class TicketRecord {

	@Id
	private Long grievanceId;
	
	private String status;
	
	private String department;
	
}

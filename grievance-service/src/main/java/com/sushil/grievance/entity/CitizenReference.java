package com.sushil.grievance.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "citizen_reference")
@Getter
@Setter
public class CitizenReference {
	
	@Id
	@Column(nullable = false, length = 100)
	private String email;

	@Column(name = "user_mobile", length = 15)
	private String userMobile;
	
	@Column(length = 20)
	private String role;
	
	@Column(length = 50)
	private String department;
	
}

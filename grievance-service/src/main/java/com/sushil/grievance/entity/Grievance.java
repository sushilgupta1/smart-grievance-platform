package com.sushil.grievance.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "grievances")
@Setter
@Getter
public class Grievance {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;
	
	@Column(nullable = false, length = 100)
	private String title;
	
	@Column(nullable = false, columnDefinition = "TEXT")
	private String description;
	
	@Column(nullable = false, length = 20)
	private String status;
	
	@Column(name = "user_email", nullable = false, length = 100)
	private String userEmail;
	
	@Column(name = "assigned_to", length = 100)
	private String assignedTo;
	
	@Column(columnDefinition = "TEXT")
	private String remarks;
	
	@Column(name = "attachment_url", columnDefinition = "LONGTEXT")
	private String attachmentUrl;
	
	@Column(name = "location_coordinates", length = 100)
	private String locationCoordinates;
	
	@Column(name = "priority_score")
	private Integer priorityScore;

}

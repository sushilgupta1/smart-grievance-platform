package com.sushil.grievance.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;


@Getter
@Setter
public class GrievanceRequest {
	
	@NotBlank(message = "Title is required")
	@Size(min = 3, max = 100, message = "Title must be between 5 and 100 characters")
	private String title;
	
	@NotBlank(message = "Description is required")
	@Size(min = 10, message = "Please provide more details in the description")
	private String description;
	
	private String attachmentUrl;
	private String locationCoordinates;
	
	
	

}

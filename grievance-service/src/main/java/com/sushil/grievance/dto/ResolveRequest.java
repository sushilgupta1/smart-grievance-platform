package com.sushil.grievance.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ResolveRequest {
	
	@NotBlank(message = "Status cannot be empty")
	private String status;
	
	private String remarks;
	
	private String resolveAttachmentUrl;
	
	private String publicPostDescription;

}

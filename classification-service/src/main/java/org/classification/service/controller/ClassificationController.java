package org.classification.service.controller;

import org.classification.service.dto.ClassificationRequest;
import org.classification.service.dto.ClassificationResponse;
import org.classification.service.service.GeminiAiService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/classify")
public class ClassificationController {

	@Autowired
	private GeminiAiService geminiAiService;
	
	@PostMapping
	public ClassificationResponse classyGrravience(@RequestBody ClassificationRequest request)
	{
		System.out.println("AI received classification request...");
		return geminiAiService.analyzeGrievance(request.getDescription());
	}
}

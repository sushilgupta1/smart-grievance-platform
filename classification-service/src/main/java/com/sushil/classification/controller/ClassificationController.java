package com.sushil.classification.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.sushil.classification.dto.ClassificationRequest;
import com.sushil.classification.dto.ClassificationResponse;
import com.sushil.classification.service.GeminiAiService;

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

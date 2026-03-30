package com.sushil.grievance.service;


import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

@Service
public class GeminiAiService {

	@Value("${gemini.api.key}")
	private String apiKey;
	
	 private static final String GEMINI_API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent";
	
	public String analyzeGrievance(String description)
	{
		RestTemplate restTemplate = new RestTemplate();
		 String prompt = "You are an AI assistant for a Smart City Grievance Platform. " +
                 "Read this citizen complaint: '" + description + "'. " +
                 "Analyze the severity and category. " +
                 "Reply EXACTLY in json format matching this structure, with nothing else: " +
                 "{\"category\": \"Water\", \"priorityScore\": 8}. " +
                 "Categories limits: Roads, Water, Electricity, Sanitation, Health, Public Safety, Transport, Utility, Other. " +
                 "PriorityScore scale: 1 (Lowest) to 10 (Highest). Give no markdown wrappers.";

		 String safePrompt = prompt.replace("\"", "'").replace("\n", " ");
	        String requestBody = "{\n" +
	                "  \"contents\": [\n" +
	                "    {\n" +
	                "      \"parts\": [\n" +
	                "        {\"text\": \"" + safePrompt + "\"}\n" +
	                "      ]\n" +
	                "    }\n" +
	                "  ]\n" +
	                "}";
	        
	        HttpHeaders headers = new HttpHeaders();
	        
	        headers.setContentType(MediaType.APPLICATION_JSON);
	        
	        HttpEntity<String> entity = new HttpEntity<>(requestBody, headers);
	        
	        try {
				String url = GEMINI_API_URL+"?key="+apiKey;
				ResponseEntity<String> response = restTemplate.postForEntity(url, entity, String.class);
				
				ObjectMapper mapper = new ObjectMapper();
				JsonNode root = mapper.readTree(response.getBody());
				
				String rawJsonResponse = root.path("candidates").get(0).path("content").path("parts").get(0).path("text").asText();
				
				 return rawJsonResponse.replace("```json", "").replace("```", "").trim();
			} catch (Exception e) {
				System.err.println("CRITICAL: Gemini AI Engine Offline - " + e.getMessage());
	            // Fallback: If AI fails, still allow the ticket to be created so the platform doesn't crash
	            return "{\"category\": \"Other\", \"priorityScore\": 1}";
			}
	}
}

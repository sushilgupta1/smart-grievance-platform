package com.sushil.grievance.feign;

import java.util.Map;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

@FeignClient(name = "classification-service")
public interface ClassificationClient {

	@PostMapping("/classify")
	Map<String, Object> classifyGrievance(@RequestBody Map<String , String> request);
}

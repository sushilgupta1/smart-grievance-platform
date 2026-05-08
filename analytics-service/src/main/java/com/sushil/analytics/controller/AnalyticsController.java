package com.sushil.analytics.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.sushil.analytics.service.DashboardService;

@RestController
@RequestMapping("/analytics")
public class AnalyticsController {

	@Autowired
	private DashboardService dashboardService;
	
	@GetMapping("/summary")
	public Map<String, Object> getSummary()
	{
		return dashboardService.getDashboardMetrics();
	}
}

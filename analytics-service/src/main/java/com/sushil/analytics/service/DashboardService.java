package com.sushil.analytics.service;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sushil.analytics.repository.TicketRecordRepository;

@Service
public class DashboardService {

	@Autowired
	private TicketRecordRepository repository;
	
	public Map<String, Object> getDashboardMetrics()
	{
		try {
			Map<String, Object> metrics= new HashMap<>();
			
			long total= repository.count();
			metrics.put("total", total);
			
			Map<String, Long> statusCount=new HashMap<>();
			long resolved=0, disputed=0,breached=0;
			
			for(Object[] row: repository.countByStatus())
			{
				String status = (String) row[0];
				// Use Number to safely catch Long, BigInteger, or Integer from COUNT()
				Long count = ((Number) row[1]).longValue();
				statusCount.put(status, count);
				
				if("RESOLVED".equalsIgnoreCase(status)) resolved+=count;
				if("REOPENED".equalsIgnoreCase(status)) disputed+=count;
				if(status!=null && status.contains("BREACH")) breached+=count;
			}
			metrics.put("statusCount", statusCount);
			metrics.put("resolved", resolved);
			metrics.put("disputed", disputed);
			metrics.put("breached", breached);
			
			Map<String, Long> departmentCount = new HashMap<>();
			for(Object[] row: repository.countByDepartment())
			{
				departmentCount.put((String)row[0], ((Number)row[1]).longValue());
			}
			
			metrics.put("categoryCount", departmentCount);
			
			return metrics;
		} catch (Exception e) {
			System.err.println("FATAL ERROR IN ANALYTICS DASHBOARD SERVICE: " + e.getMessage());
			e.printStackTrace();
			throw new RuntimeException("Failed to calculate analytics", e);
		}
	}
}

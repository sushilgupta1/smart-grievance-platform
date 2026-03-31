package com.sushil.grievance.service;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import com.sushil.grievance.entity.Grievance;
import com.sushil.grievance.kafka.KafkaProducerService;
import com.sushil.grievance.repository.GrievanceRepository;

@Service
public class SlaEscalationService {

	@Autowired
	private GrievanceRepository repository;
	
	@Autowired
	private KafkaProducerService  kafkaProducer;
	
	@Scheduled(fixedRate = 3600000)
	public void scanForSlaBreaches()
	{
		LocalDateTime deadline = LocalDateTime.now().minusMinutes(48);
		List<String> activeStatuses = Arrays.asList("OPEN","IN PROGRESS", "REOPENED");
		
		List<Grievance> breachedTickets= repository.findByStatusInAndCreatedAtBefore(activeStatuses,deadline);
		System.out.println(breachedTickets);
		for(Grievance g: breachedTickets)
		{
			System.out.println("SLA BREACH DETECTED: Grievance #"+g.getId());
			
			g.setStatus("ESCALATED_SLA_BREACH");
			
			String log=g.getRemarks()==null?"":g.getRemarks()+"\n";
			g.setRemarks(log+"AUTOMATED SYSTEM: SLA ESCALATION! Officer failed to permanently resolve this within 48 hours.");
			
			repository.save(g);
			kafkaProducer.sendMessage("CRITICAL SLA OVERDUE! Grievance #" + g.getId() + " assigned to " + (g.getAssignedTo() == null ? "Nobody" : g.getAssignedTo()) + " escalated to SuperAdmin!");
		}
	}
}

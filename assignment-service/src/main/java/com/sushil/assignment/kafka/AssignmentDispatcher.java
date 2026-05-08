package com.sushil.assignment.kafka;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Service;

import com.sushil.assignment.feign.GrievanceClient;

@Service
public class AssignmentDispatcher {

	@Autowired
	private GrievanceClient grievanceClient;
	
	@KafkaListener(topics = "grievance-classified", groupId = "assignment-group")
	public void handleNewGrievance(String message)
	{
		 System.out.println("DISPATCHER ALERT: Received -> " + message);
		 
		 try {
			
			 String[] parts=message.split(":");
			 Long grievanceId=Long.parseLong(parts[0]);
			 String department =parts[1];
			 
			 System.out.println("Calculating optimal officer for department: " + department + "...");
			 
			 String bestOfficerEmail= grievanceClient.getBestOfficer(department);
			 
			 if(bestOfficerEmail!=null && !bestOfficerEmail.isEmpty())
			 {
				 grievanceClient.assignGrievance(grievanceId, bestOfficerEmail);
				 System.out.println("SUCCESS: Dispatched Grievance #" + grievanceId + " to " + bestOfficerEmail);
	          } else 
	          {
	                System.out.println("WARNING: No officers available for " + department + ". Escalating to Admin!");
	          }
		} catch (Exception e) {
			System.err.println("Dispatch Failed: " + e.getMessage());
			}
		
	}
}

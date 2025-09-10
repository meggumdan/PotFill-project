package com.potfill.admin.managerdistrict.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.potfill.admin.managerdistrict.dao.ComplaintRepository;
import com.potfill.admin.managerdistrict.model.Complaint;
import com.potfill.admin.managerdistrict.model.DailyCount;

@Service
public class ComplaintServiceImpl implements ComplaintService {

	@Autowired
	ComplaintRepository complaintRepository;
	
	@Override
	public int getNewCount() {
		return complaintRepository.getNewCount();
	}

	@Override
	public int getProcessingCount() {
		return complaintRepository.getProcessingCount();
	}

	@Override
	public int getCompletedCount() {
		return complaintRepository.getCompletedCount();
	}

	@Override
    public List<DailyCount> getDailyCounts() {
		return complaintRepository.getDailyCounts();
	}
	
	@Override
	public List<Complaint> getEmergencyList() {
		return complaintRepository.getEmergencyList();
	}

}

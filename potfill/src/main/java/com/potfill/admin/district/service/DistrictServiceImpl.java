package com.potfill.admin.district.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.potfill.admin.district.dao.DistrictRepository;
import com.potfill.admin.district.model.Complaint;
import com.potfill.admin.district.model.DailyCount;

@Service
public class DistrictServiceImpl implements DistrictService {

	@Autowired
	DistrictRepository districtRepository;
	
	@Override
	public int getNewCount() {
		return districtRepository.getNewCount();
	}

	@Override
	public int getProcessingCount() {
		return districtRepository.getProcessingCount();
	}

	@Override
	public int getCompletedCount() {
		return districtRepository.getCompletedCount();
	}

	@Override
    public List<DailyCount> getDailyCounts() {
		return districtRepository.getDailyCounts();
	}
	
	@Override
	public List<Complaint> getEmergencyList() {
		return districtRepository.getEmergencyList();
	}

}

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
    public int getNewCount(String districtCode) {
        return districtRepository.getNewCount(districtCode);
    }

    @Override
    public int getProcessingCount(String districtCode) {
        return districtRepository.getProcessingCount(districtCode);
    }

    @Override
    public int getCompletedCount(String districtCode) {
        return districtRepository.getCompletedCount(districtCode);
    }

    @Override
    public List<DailyCount> getDailyCounts(String districtCode) {
        return districtRepository.getDailyCounts(districtCode);
    }

    @Override
    public List<Complaint> getEmergencyList(String districtCode) {
        return districtRepository.getEmergencyList(districtCode);
    }

}

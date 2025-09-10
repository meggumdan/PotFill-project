package com.potfill.admin.dashboard_overall.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.potfill.admin.dashboard_overall.dao.MajorPlaceRepository;
import com.potfill.admin.dashboard_overall.model.MajorPlace;

@Service
public class MajorPlaceServiceImpl implements MajorPlaceService {
    
    private static final Logger logger = LoggerFactory.getLogger(MajorPlaceServiceImpl.class);
    
    @Autowired
    private MajorPlaceRepository majorPlaceRepository;
    
    @Override
    public int getMajorPlacesCount() {
        return majorPlaceRepository.getMajorPlacesCount();
    }
    
    @Override
    public int insertMajorPlace(MajorPlace majorPlace) {
        return majorPlaceRepository.insertMajorPlace(majorPlace);
    }
}
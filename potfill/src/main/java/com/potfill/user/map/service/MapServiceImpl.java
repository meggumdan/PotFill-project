package com.potfill.user.map.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.potfill.user.map.dao.MapRepository;
import com.potfill.user.map.model.PotholeList;

@Service
public class MapServiceImpl implements MapService {
	@Autowired
	MapRepository mapRepository;
	
	@Override
	public List<PotholeList> getPotholeLists() {
		return mapRepository.getPotholeLists();
	}

}

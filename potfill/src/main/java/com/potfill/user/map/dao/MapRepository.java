package com.potfill.user.map.dao;

import java.util.List;

import com.potfill.user.map.model.PotholeList;

public interface MapRepository {
	// 현재 미해결, 또는 해결 중인 포트홀 리스트
	List<PotholeList> getPotholeLists();
	
}

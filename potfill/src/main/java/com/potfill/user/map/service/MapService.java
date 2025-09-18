/*
 * 작성자 : 김슬기
 * 설명 : 지도 관련 비즈니스 로직 인터페이스
 */
package com.potfill.user.map.service;

import java.util.List;

import com.potfill.user.map.model.PotholeList;

public interface MapService {
	// 현재 미해결, 또는 해결 중인 포트홀 리스트
	List<PotholeList> getPotholeLists();
	
}

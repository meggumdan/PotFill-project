package com.potfill.user.complaint.service;

import java.io.IOException;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.potfill.user.complaint.model.Complaint;

public interface UserComplaintService {

	// 신고 등록
	void saveComplaint(Complaint complaint, List<MultipartFile> photoFiles) throws IOException;

	// 나의 신고 내역 가져오기
	List<Complaint> findByNameAndPhone(String reporterName, String reporterNumber);

}

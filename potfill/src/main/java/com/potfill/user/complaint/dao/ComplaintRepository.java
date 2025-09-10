package com.potfill.user.complaint.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.potfill.user.complaint.model.Complaint;
import com.potfill.user.complaint.model.ComplaintPhoto;

@Mapper
public interface ComplaintRepository {

	public void insertComplaint(Complaint complaint);
	
	void insertComplaintPhoto(ComplaintPhoto photo);

	public List<Complaint> findByNameAndPhone(String reporterName, String reporterNumber);

}

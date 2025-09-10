package com.potfill.user.complaint.model;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class ComplaintPhoto {

	private Long photoId;
	private Long complaintId;
	private String fileUrl;
	private String originalName;
	private String storedName;
	private Timestamp createdAt;

}

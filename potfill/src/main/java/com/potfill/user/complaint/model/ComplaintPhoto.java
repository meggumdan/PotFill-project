/*
 * 작성자 : 정소영
 * 설명   : 포트홀 신고에 첨부된 사진 정보를 관리하는 모델
 */
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

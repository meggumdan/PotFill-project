package com.potfill.admin.district.model;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter @Setter
@ToString
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Complaint {
	private int complaintId;
	private String reporterName;
	private String reporterNumber;
	private String incidentAddress;
	private String districtCode;
	private String gu;
	private String dong;
	private double lat;
	private double lon;
	private double radius;
	private String h3Index;
	private double h3Res;
	private String reportContent;
	private Date createdAt;
	private int assignedAdminId;
	private String assignedDepartment;
	private int reportCount;
	
	// COMPLAINT_HISTORIES 테이블에서 상태 가져올 변수
	private String status;
	// AI가 판정할 위험도
	private int riskGrade;
}

package com.potfill.user.complaint.model;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class Complaint {

	    private Long complaintId;            // COMPLAINT_ID
	    private String reporterName;         // REPORTER_NAME
	    private String reporterNumber;       // REPORTER_NUMBER
	    private String incidentAddress;      // INCIDENT_ADDRESS
	    private String districtCode;         // DISTRICT_CODE
	    private String gu;                   // GU
	    private String dong;                 // DONG
	    private Double lat;                  // LAT (NUMBER(10,6))
	    private Double lon;                  // LON (NUMBER(10,6))
	    private Double radius;               // RADIUS (NUMBER(10,2))
	    private String h3Index;              // H3_INDEX
	    private Integer h3Res;               // H3_RES
	    private String reportContent;        // REPORT_CONTENT (CLOB)
	    private Timestamp createdAt;         // CREATED_AT (TIMESTAMP)
	    private Long assignedAdminId;        // ASSIGNED_ADMIN_ID
	    private String assignedDepartment;   // ASSIGNED_DEPARTMENT
	    private Integer reportCount;         // REPORT_COUNT
}

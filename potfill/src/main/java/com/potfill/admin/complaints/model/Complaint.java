package com.potfill.admin.complaints.model;

import java.sql.Timestamp;
import java.util.List;

import com.potfill.user.complaint.model.ComplaintPhoto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Complaint {

    private Long complaintId;
    private String reporterName;
    private String reporterNumber;
    private String incidentAddress;
    private String districtCode;
    private String gu;
    private String dong;
    private Double lat;
    private Double lon;
    private Double radius;
    private String h3Index;
    private Integer h3Res;
    private String reportContent;
    private Timestamp createdAt;
    private Long assignedAdminId;
    private String assignedDepartment;
    private Integer reportCount;
    
    private String riskLevel;
    private Integer riskScore;
    
    private String status;
    
    private List<ComplaintPhoto> photos;

}

package com.potfill.user.map.model;

import java.time.LocalDateTime;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Map {
    private Long complaintId;              // 민원ID
    private String reporterName;           // 신고자명
    private String reporterNumber;         // 신고자 연락처
    private String incidentAddress;        // 포트홀 주소
    private String districtCode;           // 행정관할
    private String gu;                     // 지역구
    private String dong;                   // 행정동
    private Double lat;                    // 위도(x)
    private Double lon;                    // 경도(y)
    private Double radius;                 // 위치 반경(미터)
    private String h3Index;                // H3ID
    private Integer h3Res;                 // H3 해상도
    private String reportContent;          // 신고 내용
    private LocalDateTime createdAt;       // 생성일시
    private Long assignedAdminId;          // 담당 관리자
    private String assignedDepartment;     // 배정 부서
    private Integer reportCount;           // 누적 신고수
    private String riskLevel;              // 위험 등급
    private Double riskScore;              // 위험 점수
}
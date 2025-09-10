package com.potfill.user.map.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class PotholeList {
    private String complaintId;        // 포트홀 주소
    private Double lat;                    // 위도(x)
    private Double lon;                    // 경도(y)
    private Integer reportCount;           // 누적 신고수
    private String districtCode;           // 행정관할
    private String riskLevel;              // 위험 등급
    private String statusComment;
    private String status;
}

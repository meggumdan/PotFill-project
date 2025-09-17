package com.potfill.admin.complaints.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ComplaintSearchRequestDto {

    // 페이징 정보
    private int page = 1;
    private int pageSize = 20;

    // 검색 조건
    private String searchType;
    private String searchKeyword;

    // 필터 조건
    private String status;
    private String riskLevel;
    private String gu;
    private String dong;
    private String period;

    // 정렬 조건
    private String sortBy = "created_at";
    private String sortOrder = "DESC";
    
    // MyBatis에서 사용할 페이징 계산 값
    // DTO 내부에서 로직을 가질 수 있습니다.
    public int getStartRow() {
        return (page - 1) * pageSize + 1;
    }

    public int getEndRow() {
        return page * pageSize;
    }
}
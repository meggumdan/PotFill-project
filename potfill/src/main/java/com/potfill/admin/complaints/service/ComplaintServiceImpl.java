package com.potfill.admin.complaints.service;

import java.io.IOException;
import java.io.OutputStream;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.potfill.admin.complaints.dao.ComplaintRepository;
import com.potfill.admin.complaints.model.Complaint;
import com.potfill.admin.complaints.model.ComplaintHistory;
import com.potfill.admin.complaints.model.ReportPhoto;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import java.io.IOException;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
@Service
public class ComplaintServiceImpl implements ComplaintService {
    
    @Autowired
    private ComplaintRepository complaintRepository;
    
    @Override
    public Map<String, Object> getComplaintListWithPaging(Map<String, Object> searchParams) {
        Map<String, Object> result = new HashMap<>();
        
        int page = searchParams.get("page") != null ? (Integer) searchParams.get("page") : 1;
        int pageSize = searchParams.get("pageSize") != null ? (Integer) searchParams.get("pageSize") : 20;

        //  시작 행과 끝 행 번호를 Java에서 미리 계산합니다.
        int startRow = (page - 1) * pageSize + 1;
        int endRow = page * pageSize;
        
        //  계산된 값을 Map에 넣습니다.
        searchParams.put("startRow", startRow);
        searchParams.put("endRow", endRow);
        
        List<Complaint> complaints = complaintRepository.getComplaintList(searchParams);
        int totalCount = complaintRepository.getComplaintCount(searchParams);
        
        result.put("complaints", complaints);
        result.put("totalCount", totalCount);
        result.put("currentPage", page);
        result.put("pageSize", pageSize);
        result.put("totalPages", (int) Math.ceil((double) totalCount / pageSize));
        
        return result;
    }
    
    @Override
    public Map<String, Object> getComplaintDetail(Long complaintId) {
        Map<String, Object> result = new HashMap<>();
        
        // 민원 기본 정보 조회
        Complaint complaint = complaintRepository.getComplaintById(complaintId);
        if (complaint == null) {
            return null;
        }
        
        // 민원 히스토리 조회
        List<ComplaintHistory> histories = complaintRepository.getComplaintHistories(complaintId);
        
        // 민원 사진 조회
        List<ReportPhoto> photos = complaintRepository.getComplaintPhotos(complaintId);
        
        // 중복 신고 확인
        List<Complaint> duplicateComplaints = null;
        if (complaint.getH3Index() != null) {
            duplicateComplaints = complaintRepository.getDuplicateComplaints(
                complaint.getH3Index(), complaintId);
        }
        
        result.put("complaint", complaint);
        result.put("histories", histories);
        result.put("photos", photos);
        result.put("duplicateComplaints", duplicateComplaints);
        
        return result;
    }
    
    @Override
    @Transactional
    public boolean updateComplaintStatus(Long complaintId, String status, String comment, Long adminId) {
        try {
            // 상태 업데이트
            int updated = complaintRepository.updateComplaintStatus(complaintId, status);
            
            if (updated > 0) {
                // 히스토리 기록
                ComplaintHistory history = ComplaintHistory.builder()
                    .complaintId(complaintId)
                    .adminId(adminId)
                    .status(status)
                    .statusComment(comment)
                    .createdAt(new Timestamp(System.currentTimeMillis()))
                    .build();
                
                complaintRepository.insertComplaintHistory(history);
                return true;
            }
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    @Override
    public boolean updateComplaintRisk(Long complaintId, String riskLevel) {
        try {
            int updated = complaintRepository.updateComplaintRisk(complaintId, riskLevel);
            return updated > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    @Override
    public boolean updateComplaintLocation(Long complaintId, Double lat, Double lon, String address) {
        try {
            int updated = complaintRepository.updateComplaintLocation(complaintId, lat, lon, address);
            return updated > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    @Override
    public List<Complaint> checkDuplicateComplaints(String h3Index, Long complaintId) {
        return complaintRepository.getDuplicateComplaints(h3Index, complaintId);
    }
    
    @Override
    public Map<String, Object> getDashboardStatistics(Long adminId) {
        return complaintRepository.getDashboardStats(adminId);
    }
//실제로 데이터를 조회하고 Apache POI를 이용해 엑셀 파일을 만드는
    @Override
    public void exportComplaintsToExcel(Map<String, Object> searchParams, OutputStream outputStream) throws IOException {
        // 1. 페이징 없이 모든 데이터 조회 (새로 만든 Repository 메소드 호출)
        List<Complaint> complaints = complaintRepository.getComplaintListForExport(searchParams);
        
        // 2. 엑셀 워크북 생성
        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("민원 목록");

            // 3. 헤더 셀 스타일 정의
            CellStyle headerCellStyle = workbook.createCellStyle();
            headerCellStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
            headerCellStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            Font headerFont = workbook.createFont();
            headerFont.setBold(true);
            headerCellStyle.setFont(headerFont);
            headerCellStyle.setAlignment(HorizontalAlignment.CENTER);

            // 4. 헤더 행 생성 (엑셀에 포함시킬 컬럼들)
            String[] headers = {"민원ID", "상태", "위험도", "신고자명", "연락처", "주소", "신고건수", "접수일"};
            Row headerRow = sheet.createRow(0);
            for (int i = 0; i < headers.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(headers[i]);
                cell.setCellStyle(headerCellStyle);
            }

            // 5. 데이터 행 생성
            int rowNum = 1;
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            for (Complaint complaint : complaints) {
                Row row = sheet.createRow(rowNum++);
                row.createCell(0).setCellValue(complaint.getComplaintId());
                row.createCell(1).setCellValue(complaint.getStatus());
                row.createCell(2).setCellValue(complaint.getRiskLevel());
                row.createCell(3).setCellValue(complaint.getReporterName());
                row.createCell(4).setCellValue(complaint.getReporterNumber());
                row.createCell(5).setCellValue(complaint.getIncidentAddress());
                row.createCell(6).setCellValue(complaint.getReportCount());
                // 날짜(Timestamp)는 포맷팅해서 넣어주는 것이 좋습니다.
                row.createCell(7).setCellValue(sdf.format(complaint.getCreatedAt()));
            }

            // 6. 컬럼 너비 자동 조정
            for (int i = 0; i < headers.length; i++) {
                sheet.autoSizeColumn(i);
            }

            // 7. OutputStream에 워크북 쓰기 (Controller로 전달됨)
            workbook.write(outputStream);
        }
    }
}
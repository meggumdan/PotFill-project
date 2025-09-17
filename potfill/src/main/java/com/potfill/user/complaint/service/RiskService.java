/*
 * 작성자 : 이지민 
 */
package com.potfill.user.complaint.service;

import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import com.potfill.user.complaint.dao.UserComplaintRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class RiskService {

    private final SizeCheckService sizeCheckService;
    private final UserComplaintRepository userComplaintRepository;

    @Async
    // Python AI 판정 모듈 호출을 비동기로 실행하여 결과 저장 (사용자 요청 지연 방지)
    public void analyzeAndSaveRisk(Long complaintId, String imagePath) {
        System.out.println(">>> 실행 스레드: " + Thread.currentThread().getName());

        try {
            // Python 실행 → 결과 받기
            String result = sizeCheckService.runPython(imagePath);

            // 면적, 최대폭 파싱
            double[] parsed = sizeCheckService.parseAreaAndWidth(result);
            double area = parsed[0];
            double maxWidth = parsed[1];

            // 위험도 등급 계산
            int riskGrade = calculateRiskGrade(area, maxWidth);

            System.out.println("[ "+complaintId + " ] 위험등급 : " + riskGrade);

            // DB 저장 (area 없이)
            userComplaintRepository.insertRisk(complaintId, riskGrade);

        } catch (Exception e) {
            e.printStackTrace();
            // 실패 시 기본값(0) 저장
            userComplaintRepository.insertRisk(complaintId, 0);
        }
    }


    // 위험등급 계산식
    private int calculateRiskGrade(double areaM2, double maxWidthM) {
        if (areaM2 <= 0.0) return 0;

        // 면적 비례 (2 제곱미터 → 10점, 2 제곱미터 이상은 10점으로 고정)
        double areaScore10 = Math.min(areaM2 / 2.0, 1.0) * 10.0;
        int grade = (int) Math.round(areaScore10);

        System.out.println(">>>>> [RiskService 실행] areaM2=" + areaM2 + ", grade=" + grade);
        return grade;
    }
}

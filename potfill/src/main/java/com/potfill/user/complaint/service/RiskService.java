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
    public void analyzeAndSaveRisk(Long complaintId, String imagePath) {
        System.out.println(">>> 실행 스레드: " + Thread.currentThread().getName());

        try {
            // Python 실행 → 결과 받기
            String result = sizeCheckService.runPython(imagePath);

            // 면적, 최대폭 파싱
            double[] parsed = parseAreaAndWidth(result);
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

    private double[] parseAreaAndWidth(String output) {
        String last = null;
        for (String line : output.split("\\R")) {
            if (line != null && !line.trim().isEmpty()) last = line.trim();
        }
        if (last == null) return new double[]{0.0, 0.0};

        String[] parts = last.split(",");
        try {
            double area = Double.parseDouble(parts[0].trim());
            double width = parts.length > 1 ? Double.parseDouble(parts[1].trim()) : 0.0;
            return new double[]{area, width};
        } catch (Exception e) {
            return new double[]{0.0, 0.0};
        }
    }

    /*
    private int calculateRiskGrade(double areaM2, double maxWidthM) {
        if (areaM2 <= 0.0 || maxWidthM <= 0.0) return 0;

        double[] targets = new double[]{0.16, 0.19, 0.235, 0.295, 0.315};
        double sigma = 0.03;

        double maxSim = 0.0;
        for (double t : targets) {
            double sim = Math.exp(-Math.pow(maxWidthM - t, 2) / (2 * sigma * sigma));
            if (sim > maxSim) maxSim = sim;
        }
        double tireScore10 = 10.0 * maxSim;
        double areaScore10 = Math.min(areaM2 / 0.5, 1.0) * 10.0;

        double finalScore = 0.8 * tireScore10 + 0.2 * areaScore10;
        int grade = (int) Math.round(finalScore);

        return Math.max(0, Math.min(10, grade));
    }
    */
    private int calculateRiskGrade(double areaM2, double maxWidthM) {
        if (areaM2 <= 0.0) return 0;

        // 면적 비례 (2㎡ → 10점, 2㎡ 이상은 10점 고정)
        double areaScore10 = Math.min(areaM2 / 2.0, 1.0) * 10.0;
        int grade = (int) Math.round(areaScore10);

        System.out.println(">>>>> [RiskService 실행] areaM2=" + areaM2 + ", grade=" + grade);
        return grade;
    }
}

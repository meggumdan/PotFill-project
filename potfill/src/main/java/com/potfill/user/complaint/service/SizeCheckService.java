// 지민
package com.potfill.user.complaint.service;

import java.io.BufferedReader;
import java.io.InputStreamReader;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Service
public class SizeCheckService {

	@Value("${python.executable}")
	private String pythonExe;

	@Value("${python.script}")
	private String scriptPath;

	@Value("${python.model}")
	private String modelPath;

	public String runPython(String imagePath) {
		StringBuilder result = new StringBuilder();
		try {
			ProcessBuilder pb = new ProcessBuilder(pythonExe, scriptPath, imagePath, modelPath);
			pb.redirectErrorStream(true);

			Process process = pb.start();
			try (BufferedReader br = new BufferedReader(new InputStreamReader(process.getInputStream(), "UTF-8"))) {
				String line;
				while ((line = br.readLine()) != null) {
					result.append(line).append("\n");
				}
			}

			int exitCode = process.waitFor();
			if (exitCode != 0) {
				result.append("Python script failed with exit code ").append(exitCode);
			}
		} catch (Exception e) {
			result.append("Error: ").append(e.getMessage());
		}
		
	    // Python 실행 결과 확인
	    System.out.println(">>> [runPython 결과]\n" + result.toString());
	    
	    return result.toString();
	}
	
	/** Python 출력에서 area, width 추출 */
	public double[] parseAreaAndWidth(String result) {
		String last = null;
		for (String line : result.split("\\R")) {
			if (line != null && !line.trim().isEmpty())
				last = line.trim();
		}
		
		System.out.println(">>> [파싱용 마지막 줄] " + last); // 마지막 줄 확인
		
		if (last == null)
			return new double[] { 0.0, 0.0 };

		String[] parts = last.split(",");
		try {
			double area = Double.parseDouble(parts[0].trim());
			double width = parts.length > 1 ? Double.parseDouble(parts[1].trim()) : 0.0;
			
			// 파싱 결과
	        System.out.println(">>> [파싱 결과] area=" + area + ", width=" + width);

			
			return new double[] { area, width };
		} catch (Exception e) {
			return new double[] { 0.0, 0.0 };
		}
	}

	/* 1. 면적 + 최대폭 기반 위험도 계산
	public int calculateRiskGrade(double areaM2, double maxWidthM) {
		if (areaM2 <= 0.0 || maxWidthM <= 0.0)
			return 0;

		// 타이어 폭 후보(미터)
		// 경차/소형 승용: 0.155 ~ 0.165 → 0.16 
		// 1톤 소형 트럭: ~0.185 ~ 0.195 → 0.19 
		// 중형 트럭: ~0.215 ~ 0.245 → 0.235 
		// 대형 트럭: ~0.275 ~ 0.315 → 0.295 (또는 0.315)
		double[] targets = new double[] { 0.16, 0.19, 0.235, 0.295, 0.315 };
		double sigma = 0.03;

		// 폭 유사도 계산
		double maxSim = 0.0;
		for (double t : targets) {
			double sim = Math.exp(-Math.pow(maxWidthM - t, 2) / (2 * sigma * sigma));
			if (sim > maxSim)
				maxSim = sim;
		}
		double tireScore10 = 10.0 * maxSim;

		// 면적 기반 점수
		double areaScore10 = Math.min(areaM2 / 0.5, 1.0) * 10.0;

		// 가중 합산
		double finalScore = 0.8 * tireScore10 + 0.2 * areaScore10;
		int grade = (int) Math.round(finalScore);
		
	    // 디버깅 출력
	    System.out.println(">>>>> areaM2      : " + areaM2);
	    System.out.println(">>>>> areaScore10 : " + areaScore10);
	    System.out.println(">>>>> tireScore10 : " + tireScore10);
	    System.out.println(">>>>> finalScore  : " + finalScore);
	    System.out.println(">>>>> grade       : " + grade);

		return Math.max(0, Math.min(10, grade));
	}
	*/
	
	/* 2. 면적 중심 가중합 
	public int calculateRiskGrade(double areaM2, double maxWidthM) {
	    if (areaM2 <= 0.0 || maxWidthM <= 0.0) return 0;

	    // 면적 점수 (0.5㎡ 이상이면 10점)
	    double areaScore10 = Math.min(areaM2 / 0.5, 1.0) * 10.0;

	    // 폭 점수 (기존 로직 유지)
	    double[] targets = {0.16, 0.19, 0.235, 0.295, 0.315};
	    double sigma = 0.03, maxSim = 0.0;
	    for (double t : targets) {
	        double sim = Math.exp(-Math.pow(maxWidthM - t, 2) / (2 * sigma * sigma));
	        maxSim = Math.max(maxSim, sim);
	    }
	    double tireScore10 = 10.0 * maxSim;

	    // 가중합 (면적 70%, 폭 30%)
	    double finalScore = 0.7 * areaScore10 + 0.3 * tireScore10;
	    int grade = (int) Math.round(finalScore);

	    System.out.println(">>>>> areaM2      : " + areaM2);
	    System.out.println(">>>>> areaScore10 : " + areaScore10);
	    System.out.println(">>>>> tireScore10 : " + tireScore10);
	    System.out.println(">>>>> finalScore  : " + finalScore);
	    System.out.println(">>>>> grade       : " + grade);

	    return Math.max(0, Math.min(10, grade));
	}
	*/
	
	// 3. 면적으로만
	/** 면적 기반 위험도 계산 (0~10, 2㎡ 기준)
	public int calculateRiskGrade(double areaM2, double maxWidthM) {
	    if (areaM2 <= 0.0) return 0;

	    // 면적 비례 (2㎡ → 10점, 2㎡ 이상은 10점 고정)
	    double areaScore10 = Math.min(areaM2 / 2.0, 1.0) * 10.0;

	    // 정수로 반올림
	    int grade = (int) Math.round(areaScore10);

	    // 디버깅 출력
	    System.out.println(">>>>> maxWidthM   : " + maxWidthM);
	    System.out.println(">>>>> areaM2      : " + areaM2);
	    System.out.println(">>>>> areaScore10 : " + areaScore10);
	    System.out.println(">>>>> grade       : " + grade);

	    return grade;
	} */


}
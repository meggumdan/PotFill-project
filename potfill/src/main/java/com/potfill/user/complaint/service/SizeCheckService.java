/*
 * 작성자 : 이지민 
 */
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

	// 이미지 분석을 위해 파이썬 모델을 실행하고 결과를 가져옴
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
	
    // 면적 반환
    public double[] parseAreaAndWidth(String output) {
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
}
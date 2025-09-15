package com.potfill.admin.complaints.service;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import com.potfill.admin.complaints.model.Complaint;
@Service
public class GeminiService {

    @Autowired
    private RestTemplate restTemplate;

    @Value("${gemini.api.key}")
    private String apiKey;

   
    private final String model = "gemini-1.5-flash-latest"; // 최신 Flash 모델

    public String summarizeText(Complaint complaint) {
        // 1. Gemini API 호출을 위한 URL 변경

        String apiUrl = String.format(
            "https://generativelanguage.googleapis.com/v1beta/models/%s:generateContent?key=%s",
            model, apiKey
        );

        // 2. HTTP 요청 헤더 설정 (이전과 동일)
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        // 3. API에 보낼 요청 본문(Body) 생성 (이전과 거의 동일)
       // String prompt = "다음 민원 내용을 세 문장으로 간결하게 요약해줘. 핵심 내용만 포함해줘. \n\n민원 내용: \"" + textToSummarize + "\"";
        String risk = complaint.getRiskLevel(); // "HIGH", "MEDIUM", "LOW" 등
        int duplicates = complaint.getReportCount();
        String contentText  = complaint.getReportContent();
        
        String prompt = String.format(
                """
                [임무]
                당신은 서울시 도로 안전 관제 AI입니다. 민원 정보를 분석하여 현장 담당자를 위한 **핵심 브리핑**을 생성합니다.

                [결과물 규칙]
                1.  **길이:** 전체 브리핑은 반드시 **총 2문장**으로 작성하세요.
                2.  **내용:** 첫 문장은 '위치'와 '핵심 문제'를, 두 번째 문장은 '위험도'와 '중복 신고'를 근거로 한 '조치 권고'를 자연스럽게 서술하세요.
                3.  **형식:** 제목, 날짜, 글머리 기호(-, •) 등을 절대 사용하지 말고, 오직 2개의 문장만 생성하세요.
                4.  **어조:** 기계적인 정보 나열이 아닌, 사람이 보고하는 것처럼 간결하고 명확한 문장으로 작성하세요.

                [분석할 민원 정보]
                - 중복 신고: %d회
                - 시스템 위험도: %s
                - 민원 내용: "%s"

                [브리핑 생성 시작]
                """,
                duplicates,
                risk,
                contentText
            );

        Map<String, Object> textPart = new HashMap<>();
        textPart.put("text", prompt);

        Map<String, Object> content = new HashMap<>();
        content.put("parts", Collections.singletonList(textPart));

        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("contents", Collections.singletonList(content));

        HttpEntity<Map<String, Object>> requestEntity = new HttpEntity<>(requestBody, headers);

        try {
            // 4. RestTemplate으로 API에 POST 요청 전송

            Map<String, Object> response = restTemplate.postForObject(apiUrl, requestEntity, Map.class);

            if (response == null || response.isEmpty()) {
                return "AI로부터 응답을 받지 못했습니다.";
            }

            // 5. 응답에서 요약된 텍스트만 추출 (구조는 이전과 매우 유사)
            Map<String, Object> firstCandidate = (Map<String, Object>) ((List<Object>) response.get("candidates")).get(0);
            Map<String, Object> contentMap = (Map<String, Object>) firstCandidate.get("content");
            String summary = (String) ((Map<String, Object>) ((List<Object>) contentMap.get("parts")).get(0)).get("text");

            return summary.trim();

        } catch (Exception e) {
            e.printStackTrace();
            return "AI 요약 중 오류가 발생했습니다: " + e.getMessage();
        }
    }
}
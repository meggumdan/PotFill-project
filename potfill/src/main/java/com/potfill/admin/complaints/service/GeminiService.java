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

@Service
public class GeminiService {

    @Autowired
    private RestTemplate restTemplate;

    @Value("${gemini.api.key}")
    private String apiKey;

    // [수정!] 더 간단한 'Google AI Gemini API' 엔드포인트를 사용합니다.
    private final String model = "gemini-1.5-flash-latest"; // 최신 Flash 모델

    public String summarizeText(String textToSummarize) {
        // 1. [수정!] Gemini API 호출을 위한 URL 변경
        // 프로젝트 ID나 location이 필요 없는 더 간단한 주소입니다.
        String apiUrl = String.format(
            "https://generativelanguage.googleapis.com/v1beta/models/%s:generateContent?key=%s",
            model, apiKey
        );

        // 2. HTTP 요청 헤더 설정 (이전과 동일)
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        // 3. API에 보낼 요청 본문(Body) 생성 (이전과 거의 동일)
        String prompt = "다음 민원 내용을 세 문장으로 간결하게 요약해줘. 핵심 내용만 포함해줘. \n\n민원 내용: \"" + textToSummarize + "\"";
        
        Map<String, Object> textPart = new HashMap<>();
        textPart.put("text", prompt);

        Map<String, Object> content = new HashMap<>();
        content.put("parts", Collections.singletonList(textPart));

        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("contents", Collections.singletonList(content));

        HttpEntity<Map<String, Object>> requestEntity = new HttpEntity<>(requestBody, headers);

        try {
            // 4. RestTemplate으로 API에 POST 요청 전송
            // [수정!] 이 API는 응답을 단일 Map 형태로 반환합니다. (List가 아님)
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
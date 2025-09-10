package com.potfill.admin.dashboard_overall.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.potfill.admin.dashboard_overall.service.MajorPlaceService;
import com.potfill.admin.dashboard_overall.model.MajorPlace;

import org.apache.poi.ss.usermodel.*;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("/admin")
public class DashboardOverallController {

	private static final Logger logger = LoggerFactory.getLogger(DashboardOverallController.class);

	@Autowired
	private MajorPlaceService majorPlaceService;

	/**
	 * 주요장소 업로드 페이지
	 */
	@RequestMapping(value = "/majorPlaceUpload", method = RequestMethod.GET)
	public String majorPlaceUploadPage(Model model) {
		logger.info("주요장소 업로드 페이지 접근");
		model.addAttribute("pageTitle", "주요장소 업로드");
		return "admin/dashboard_overall/majorPlaceUpload";
	}

	/**
	 * 엑셀 파일 업로드로 주요장소 일괄 등록
	 */
	@RequestMapping(value = "/uploadMajorPlaces", method = RequestMethod.POST)
	@ResponseBody
	public ResponseEntity<String> uploadMajorPlaces(@RequestParam("file") MultipartFile file) {
		try {
			logger.info("엑셀 파일 업로드 시작: {}", file.getOriginalFilename());

			if (file.isEmpty()) {
				return ResponseEntity.badRequest().body("{\"success\": false, \"message\": \"파일이 비어있습니다.\"}");
			}

			List<MajorPlace> places = parseExcelFile(file);

			if (places.isEmpty()) {
				return ResponseEntity.badRequest().body("{\"success\": false, \"message\": \"처리할 데이터가 없습니다.\"}");
			}

			int savedCount = 0;
			int errorCount = 0;

			for (MajorPlace place : places) {
				try {
					majorPlaceService.insertMajorPlace(place);
					savedCount++;
					logger.info("저장 성공: {} -> {} {}", place.getAreaName(), place.getGu(), place.getDong());
				} catch (Exception e) {
					errorCount++;
					logger.error("저장 실패: {}", place.getAreaName(), e);
				}
			}

			String message = String.format("총 %d개 중 %d개 저장 성공, %d개 실패", places.size(), savedCount, errorCount);

			return ResponseEntity.ok("{\"success\": true, \"message\": \"" + message + "\"}");

		} catch (Exception e) {
			logger.error("엑셀 업로드 중 오류 발생", e);
			return ResponseEntity.internalServerError()
					.body("{\"success\": false, \"message\": \"업로드 중 오류가 발생했습니다: " + e.getMessage() + "\"}");
		}
	}

	/**
	 * 엑셀 파일 파싱
	 */
	private List<MajorPlace> parseExcelFile(MultipartFile file) throws Exception {
		List<MajorPlace> places = new ArrayList<>();

		try (InputStream inputStream = file.getInputStream()) {
			Workbook workbook = WorkbookFactory.create(inputStream);
			Sheet sheet = workbook.getSheetAt(0);

			for (Row row : sheet) {
				// 헤더행 스킵
				if (row.getRowNum() == 0)
					continue;

				Cell areaNameCell = row.getCell(3); // D열: AREA_NM
				Cell addressCell = row.getCell(4); // E열: 주소

				if (areaNameCell != null && addressCell != null) {
					String areaName = getCellValueAsString(areaNameCell).trim();
					String address = getCellValueAsString(addressCell).trim();

					logger.info("파싱 중: 장소명={}, 주소={}", areaName, address);

					if (!areaName.isEmpty() && !address.isEmpty()) {
						// 주소에서 구와 동 추출
						String[] addressParts = parseAddress(address);

						if (addressParts != null) {
							MajorPlace place = new MajorPlace();
							place.setAreaName(areaName);
							place.setGu(addressParts[0]);
							place.setDong(addressParts[1]);

							places.add(place);
						}
					}
				}
			}
		}

		return places;
	}

	/**
	 * 셀 값을 문자열로 변환
	 */
	private String getCellValueAsString(Cell cell) {
		if (cell == null)
			return "";

		switch (cell.getCellType()) {
		case STRING:
			return cell.getStringCellValue();
		case NUMERIC:
			return String.valueOf((long) cell.getNumericCellValue());
		default:
			return "";
		}
	}

	/**
	 * 주소에서 구와 동 추출 예: "서울시 강남구 역삼동" -> ["강남구", "역삼동"]
	 */
	private String[] parseAddress(String address) {
		try {
			// 서울시, 서울특별시 제거
			address = address.replace("서울시", "").replace("서울특별시", "").trim();

			String[] parts = address.split("\\s+");

			if (parts.length >= 2) {
				String gu = parts[0].trim();
				String dong = parts[1].trim();

				// 구 이름에 "구"가 없으면 추가
				if (!gu.endsWith("구")) {
					gu += "구";
				}

				logger.info("주소 파싱 성공: {} -> 구={}, 동={}", address, gu, dong);
				return new String[] { gu, dong };
			}

		} catch (Exception e) {
			logger.error("주소 파싱 실패: {}", address, e);
		}

		return null;
	}

	// 기존 메서드들...
	@RequestMapping(value = "/dashboard", method = RequestMethod.GET)
	public String dashboard(Model model) {
		logger.info("관리자 대시보드 접근");
		model.addAttribute("pageTitle", "대시보드 전체");
		return "admin/dashboard_overall/dashboard-overall";
	}

	@RequestMapping(value = "/test", method = RequestMethod.GET)
	public String adminTest(Model model) {
		logger.info("관리자 테스트 페이지 접근");
		model.addAttribute("message", "관리자 페이지 연결 테스트 성공!");
		return "admin/test";
	}

	// 기존 API 메서드들도 그대로 유지...
	@RequestMapping(value = "/api/dashboard/kpi", method = RequestMethod.GET)
	@ResponseBody
	public String getKPIData() {
		logger.info("KPI 데이터 API 호출");

		String jsonResponse = "{" + "\"totalReports\": 1247," + "\"processingReports\": 89,"
				+ "\"completedReports\": 1158," + "\"dangerZones\": 23," + "\"trends\": {"
				+ "\"totalReports\": \"+127(12%)\"," + "\"processingReports\": \"-5(-5%)\","
				+ "\"completedReports\": \"+132(13%)\"," + "\"dangerZones\": \"+3(15%)\"" + "}" + "}";

		return jsonResponse;
	}

	@RequestMapping(value = "/api/dashboard/priority", method = RequestMethod.GET)
	@ResponseBody
	public String getPriorityRegionsData() {
		logger.info("우선처리 지역 TOP 5 데이터 API 호출");

		String jsonResponse = "["
				+ "{\"rank\": 1, \"region\": \"강남구 역삼동\", \"pending\": 15, \"maxDays\": 7, \"repeat\": 3, \"majorLocation\": true, \"score\": 94.2},"
				+ "{\"rank\": 2, \"region\": \"서초구 방배동\", \"pending\": 12, \"maxDays\": 14, \"repeat\": 8, \"majorLocation\": true, \"score\": 87.5},"
				+ "{\"rank\": 3, \"region\": \"마포구 상암동\", \"pending\": 8, \"maxDays\": 6, \"repeat\": 7, \"majorLocation\": false, \"score\": 85.1},"
				+ "{\"rank\": 4, \"region\": \"광진구 화양동\", \"pending\": 6, \"maxDays\": 5, \"repeat\": 10, \"majorLocation\": true, \"score\": 79.7},"
				+ "{\"rank\": 5, \"region\": \"종로구 혜화동\", \"pending\": 5, \"maxDays\": 9, \"repeat\": 2, \"majorLocation\": false, \"score\": 70.8}"
				+ "]";

		return jsonResponse;
	}

	@RequestMapping(value = "/api/dashboard/ranking", method = RequestMethod.GET)
	@ResponseBody
	public String getRegionRankingData() {
		logger.info("지역별 우선도 랭킹 데이터 API 호출");

		String jsonResponse = "{"
				+ "\"labels\": [\"강남구\", \"서초구\", \"마포구\", \"송파구\", \"영등포구\", \"용산구\", \"종로구\", \"중구\", \"성동구\", \"광진구\"],"
				+ "\"data\": [87.5, 78.3, 75.1, 68.9, 68.2, 65.4, 58.7, 52.3, 48.1, 42.5]" + "}";

		return jsonResponse;
	}

	@RequestMapping(value = "/api/dashboard/regional", method = RequestMethod.GET)
	@ResponseBody
	public String getRegionalStatusData() {
		logger.info("지역별 포트홀 신고현황 데이터 API 호출");

		String jsonResponse = "{" + "\"statusChart\": {" + "\"labels\": [\"완료\", \"처리중\", \"미처리\"],"
				+ "\"data\": [1158, 89, 223]" + "}," + "\"regionalDetails\": ["
				+ "{\"no\": 1, \"district\": \"종로구\", \"reports\": 127, \"rate\": 92, \"avgTime\": 7.2},"
				+ "{\"no\": 2, \"district\": \"은평구\", \"reports\": 111, \"rate\": 89, \"avgTime\": 7.1},"
				+ "{\"no\": 3, \"district\": \"강북구\", \"reports\": 108, \"rate\": 76, \"avgTime\": 6.7},"
				+ "{\"no\": 4, \"district\": \"강서구\", \"reports\": 96, \"rate\": 75, \"avgTime\": 5.9},"
				+ "{\"no\": 5, \"district\": \"광진구\", \"reports\": 89, \"rate\": 73, \"avgTime\": 5.5}" + "]" + "}";

		return jsonResponse;
	}
}
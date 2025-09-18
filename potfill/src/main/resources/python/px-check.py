# 작성자 : 이지민
# 설명   : YOLOv8과 OpenCV로 이미지 속 포트홀을 감지해 면적과 최대 폭을 계산하고 표준 출력으로 반환하는 Python 분석 모듈
import cv2
import torch
import sys
import os

def estimate_area(image_path, model_path, lane_width_m=3.5):
    # 1. 모델 불러오기
    model = torch.hub.load('ultralytics/yolov8', 'custom', path=model_path, force_reload=True)

    # 2. 이미지 로드
    img = cv2.imread(image_path)
    h, w, _ = img.shape

    # 3. YOLO 추론
    results = model(image_path)
    detections = results.xyxy[0]  # x1, y1, x2, y2, conf, cls

    if detections.shape[0] == 0:
        # 검출 없음: 면적 0, 폭 0
        print("0.0000,0.0000")
        return 0.0

    # 4. 픽셀을 미터로 스케일
    # 차선 폭 = 이미지 가로 폭 가정
    lane_width_px = w
    scale = lane_width_m / lane_width_px  # m/px

    total_area_m2 = 0.0
    max_width_m = 0.0

    for *box, conf, cls in detections.tolist():
        x1, y1, x2, y2 = box
        box_w_m = (x2 - x1) * scale
        box_h_m = (y2 - y1) * scale
        pothole_area = box_w_m * box_h_m
        total_area_m2 += pothole_area
        if box_w_m > max_width_m:
            max_width_m = box_w_m

    # CSV 출력
    print(f"{total_area_m2:.4f},{max_width_m:.4f}") # 면적,최대폭
    return total_area_m2


if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python px-check.py <image_path> <model_path>")
        sys.exit(1)
    image_path = sys.argv[1]
    model_path = sys.argv[2]
    estimate_area(image_path, model_path)

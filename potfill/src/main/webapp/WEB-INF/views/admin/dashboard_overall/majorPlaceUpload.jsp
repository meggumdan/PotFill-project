<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>주요장소 업로드 - PotFill</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Pretendard', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: linear-gradient(135deg, #3E4653 0%, #2c313b 100%);
            min-height: 100vh;
            padding: 30px 20px;
        }
        
        .main-container {
            max-width: 600px;
            margin: 0 auto;
        }
        
        /* 헤더 영역 */
        .header-section {
            text-align: center;
            margin-bottom: 25px;
            color: white;
        }
        
        .header-section h1 {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 8px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
        }
        
        .header-section p {
            font-size: 0.95rem;
            opacity: 0.9;
        }
        
        /* 메인 카드 */
        .upload-card {
            background: white;
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            padding: 25px;
            margin-bottom: 25px;
        }
        
        /* 안내 섹션 */
        .info-section {
            background: linear-gradient(135deg, #3E4653 0%, #4a5262 100%);
            border-radius: 12px;
            padding: 18px;
            margin-bottom: 20px;
            color: white;
        }
        
        .info-section h5 {
            font-weight: 600;
            margin-bottom: 12px;
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 0.95rem;
        }
        
        .info-section ul {
            margin: 0;
            padding-left: 22px;
            font-size: 0.85rem;
        }
        
        .info-section li {
            margin-bottom: 5px;
            line-height: 1.5;
        }
        
        /* 업로드 영역 */
        .upload-area {
            border: 2px dashed #d0d0d0;
            border-radius: 12px;
            padding: 25px;
            text-align: center;
            background: #fafafa;
            transition: all 0.3s ease;
            cursor: pointer;
            position: relative;
        }
        
        .upload-area:hover {
            border-color: #3E4653;
            background: #f5f6f7;
        }
        
        .upload-area.active {
            border-color: #3E4653;
            background: #f5f6f7;
        }
        
        .upload-icon {
            font-size: 2.5rem;
            color: #3E4653;
            margin-bottom: 15px;
        }
        
        .upload-title {
            font-size: 1.05rem;
            font-weight: 600;
            color: #333;
            margin-bottom: 8px;
        }
        
        .upload-subtitle {
            color: #666;
            font-size: 0.85rem;
        }
        
        #excelFile {
            position: absolute;
            width: 100%;
            height: 100%;
            top: 0;
            left: 0;
            opacity: 0;
            cursor: pointer;
        }
        
        /* 파일 선택 후 표시 */
        .file-info {
            background: #f5f6f7;
            border-radius: 10px;
            padding: 12px 16px;
            margin-top: 15px;
            display: none;
            align-items: center;
            justify-content: space-between;
        }
        
        .file-info.show {
            display: flex;
        }
        
        .file-details {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .file-icon {
            font-size: 1.5rem;
            color: #3E4653;
        }
        
        .file-name {
            font-weight: 600;
            color: #333;
            margin-bottom: 2px;
            font-size: 0.9rem;
        }
        
        .file-size {
            font-size: 0.75rem;
            color: #666;
        }
        
        .remove-file {
            background: none;
            border: none;
            color: #999;
            font-size: 1rem;
            cursor: pointer;
            transition: color 0.3s;
            padding: 0;
            width: 24px;
            height: 24px;
        }
        
        .remove-file:hover {
            color: #ff4444;
        }
        
        /* 버튼 스타일 */
        .btn-upload {
            background: linear-gradient(135deg, #3E4653 0%, #2c313b 100%);
            color: white;
            border: none;
            border-radius: 10px;
            padding: 12px 30px;
            font-size: 1rem;
            font-weight: 600;
            width: 100%;
            margin-top: 20px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(62, 70, 83, 0.3);
        }
        
        .btn-upload:hover:not(:disabled) {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(62, 70, 83, 0.4);
            background: linear-gradient(135deg, #4a5262 0%, #3E4653 100%);
        }
        
        .btn-upload:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }
        
        .btn-dashboard {
            background: white;
            color: #3E4653;
            border: 2px solid #3E4653;
            border-radius: 10px;
            padding: 10px 24px;
            font-weight: 600;
            font-size: 0.95rem;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        
        .btn-dashboard:hover {
            background: #3E4653;
            color: white;
            transform: translateY(-2px);
        }
        
        /* 결과 메시지 */
        .result-message {
            border-radius: 10px;
            padding: 12px 16px;
            margin-top: 15px;
            display: none;
            align-items: center;
            gap: 12px;
        }
        
        .result-message.show {
            display: flex;
        }
        
        .result-success {
            background: #d4f4dd;
            color: #14ae5c;
        }
        
        .result-error {
            background: #ffd6d6;
            color: #d72638;
        }
        
        .result-icon {
            font-size: 1.2rem;
        }
        
        .result-text {
            flex: 1;
        }
        
        .result-title {
            font-weight: 600;
            margin-bottom: 2px;
            font-size: 0.9rem;
        }
        
        .result-desc {
            font-size: 0.8rem;
            opacity: 0.9;
        }
        
        /* 로딩 스피너 */
        .spinner {
            display: inline-block;
            width: 16px;
            height: 16px;
            border: 2px solid rgba(255,255,255,0.3);
            border-radius: 50%;
            border-top-color: white;
            animation: spin 1s ease-in-out infinite;
        }
        
        @keyframes spin {
            to { transform: rotate(360deg); }
        }
        
        /* 반응형 */
        @media (max-width: 768px) {
            .upload-card {
                padding: 20px;
            }
            
            .header-section h1 {
                font-size: 1.75rem;
            }
            
            .upload-area {
                padding: 20px;
            }
            
            .upload-icon {
                font-size: 2rem;
            }
        }
    </style>
</head>
<body>
    <div class="main-container">
        <!-- 헤더 -->
        <div class="header-section">
            <h1>서울시 주요장소 업로드</h1>
            <p>엑셀 파일을 통해 주요장소 데이터를 일괄 업로드합니다</p>
        </div>
        
        <!-- 메인 카드 -->
        <div class="upload-card">
            <!-- 안내 섹션 -->
            <div class="info-section">
                <h5>
                    <i class="fas fa-info-circle"></i>
                    업로드 안내
                </h5>
                <ul>
                    <li>엑셀 파일(.xlsx, .xls)만 업로드 가능합니다</li>
                    <li>D열: 장소명 (AREA_NM)</li>
                    <li>E열: 주소 (예: 서울시 강남구 역삼동)</li>
                    <li>첫 번째 행은 헤더로 자동 제외됩니다</li>
                </ul>
            </div>
            
            <!-- 업로드 폼 -->
            <form id="uploadForm" enctype="multipart/form-data">
                <!-- 업로드 영역 -->
                <div class="upload-area" id="uploadArea">
                    <input type="file" id="excelFile" name="file" accept=".xlsx,.xls" required>
                    <i class="fas fa-cloud-upload-alt upload-icon"></i>
                    <div class="upload-title">파일을 선택하거나 여기에 드래그하세요</div>
                    <div class="upload-subtitle">최대 파일 크기: 10MB</div>
                </div>
                
                <!-- 파일 정보 표시 -->
                <div class="file-info" id="fileInfo">
                    <div class="file-details">
                        <i class="fas fa-file-excel file-icon"></i>
                        <div>
                            <div class="file-name" id="fileName"></div>
                            <div class="file-size" id="fileSize"></div>
                        </div>
                    </div>
                    <button type="button" class="remove-file" id="removeFile">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
                
                <!-- 업로드 버튼 -->
                <button type="submit" id="submitBtn" class="btn-upload" disabled>
                    <span id="btnText">업로드 시작</span>
                    <span id="btnSpinner" style="display: none;">
                        <span class="spinner"></span> 업로드 중...
                    </span>
                </button>
            </form>
            
            <!-- 결과 메시지 -->
            <div id="resultMessage" class="result-message">
                <i id="resultIcon" class="result-icon"></i>
                <div class="result-text">
                    <div class="result-title" id="resultTitle"></div>
                    <div class="result-desc" id="resultDesc"></div>
                </div>
            </div>
        </div>
        
        <!-- 대시보드 버튼 -->
        <div class="text-center">
            <a href="/potfill/admin/dashboard" class="btn-dashboard">
                <i class="fas fa-arrow-left"></i>
                대시보드로 돌아가기
            </a>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        const fileInput = document.getElementById('excelFile');
        const uploadArea = document.getElementById('uploadArea');
        const fileInfo = document.getElementById('fileInfo');
        const fileName = document.getElementById('fileName');
        const fileSize = document.getElementById('fileSize');
        const removeFileBtn = document.getElementById('removeFile');
        const submitBtn = document.getElementById('submitBtn');
        const uploadForm = document.getElementById('uploadForm');
        const resultMessage = document.getElementById('resultMessage');
        const resultIcon = document.getElementById('resultIcon');
        const resultTitle = document.getElementById('resultTitle');
        const resultDesc = document.getElementById('resultDesc');
        const btnText = document.getElementById('btnText');
        const btnSpinner = document.getElementById('btnSpinner');
        
        // 드래그 앤 드롭 이벤트
        uploadArea.addEventListener('dragover', (e) => {
            e.preventDefault();
            uploadArea.classList.add('active');
        });
        
        uploadArea.addEventListener('dragleave', () => {
            uploadArea.classList.remove('active');
        });
        
        uploadArea.addEventListener('drop', (e) => {
            e.preventDefault();
            uploadArea.classList.remove('active');
            
            const files = e.dataTransfer.files;
            if (files.length > 0) {
                fileInput.files = files;
                handleFileSelect(files[0]);
            }
        });
        
        // 파일 선택 이벤트
        fileInput.addEventListener('change', function() {
            if (this.files[0]) {
                handleFileSelect(this.files[0]);
            }
        });
        
        // 파일 제거 버튼
        removeFileBtn.addEventListener('click', function() {
            fileInput.value = '';
            fileInfo.classList.remove('show');
            submitBtn.disabled = true;
            hideResult();
        });
        
        // 파일 선택 처리
        function handleFileSelect(file) {
            const fileSizeMB = (file.size / 1024 / 1024).toFixed(2);
            
            // 파일 타입 확인
            if (!file.name.match(/\.(xlsx|xls)$/i)) {
                showResult('error', '잘못된 파일 형식', '엑셀 파일(.xlsx, .xls)만 업로드 가능합니다.');
                submitBtn.disabled = true;
                return;
            }
            
            // 파일 크기 확인 (10MB 제한)
            if (fileSizeMB > 10) {
                showResult('error', '파일 크기 초과', '파일 크기는 10MB를 초과할 수 없습니다.');
                submitBtn.disabled = true;
                return;
            }
            
            fileName.textContent = file.name;
            fileSize.textContent = fileSizeMB + ' MB';
            fileInfo.classList.add('show');
            submitBtn.disabled = false;
            hideResult();
        }
        
        // 폼 제출 이벤트
        uploadForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            const file = fileInput.files[0];
            if (!file) {
                showResult('error', '파일 없음', '파일을 선택해주세요.');
                return;
            }
            
            // 버튼 상태 변경
            submitBtn.disabled = true;
            btnText.style.display = 'none';
            btnSpinner.style.display = 'inline-block';
            
            const formData = new FormData();
            formData.append('file', file);
            
            fetch('/potfill/admin/uploadMajorPlaces', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showResult('success', '업로드 완료', '데이터가 성공적으로 업로드되었습니다.');
                    // 성공 시 폼 리셋
                    setTimeout(() => {
                        uploadForm.reset();
                        fileInfo.classList.remove('show');
                        submitBtn.disabled = true;
                        hideResult();
                    }, 3000);
                } else {
                    showResult('error', '업로드 실패', data.message || '업로드 중 오류가 발생했습니다.');
                }
            })
            .catch(error => {
                console.error('업로드 오류:', error);
                showResult('error', '서버 오류', '서버와의 통신 중 오류가 발생했습니다.');
            })
            .finally(() => {
                submitBtn.disabled = false;
                btnText.style.display = 'inline';
                btnSpinner.style.display = 'none';
            });
        });
        
        // 결과 메시지 표시
        function showResult(type, title, desc) {
            resultMessage.className = 'result-message show result-' + type;
            
            if (type === 'success') {
                resultIcon.className = 'fas fa-check-circle result-icon';
            } else {
                resultIcon.className = 'fas fa-exclamation-circle result-icon';
            }
            
            resultTitle.textContent = title;
            resultDesc.textContent = desc;
        }
        
        // 결과 메시지 숨기기
        function hideResult() {
            resultMessage.classList.remove('show');
        }
    </script>
</body>
</html>
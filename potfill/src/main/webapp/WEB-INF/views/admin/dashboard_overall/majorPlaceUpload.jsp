<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>주요장소 업로드 - PotFill</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<style>
.upload-container {
	max-width: 600px;
	margin: 50px auto;
	padding: 30px;
	border-radius: 10px;
	box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.result-area {
	margin-top: 20px;
	padding: 15px;
	border-radius: 5px;
	display: none;
}

.result-success {
	background-color: #d1ecf1;
	border: 1px solid #bee5eb;
	color: #0c5460;
}

.result-error {
	background-color: #f8d7da;
	border: 1px solid #f5c6cb;
	color: #721c24;
}
</style>
</head>
<body>
	<div class="container">
		<div class="upload-container">
			<h2 class="text-center mb-4">서울시 주요장소  업로드</h2>

			<div class="alert alert-info" role="alert">
				<strong>업로드 안내:</strong>
				<ul class="mb-0 mt-2">
					<li>엑셀 파일(.xlsx, .xls)만 업로드 가능합니다</li>
					<li>D열: 장소명 (AREA_NM)</li>
					<li>E열: 주소 (예: 서울시 강남구 역삼동)</li>
					<li>첫 번째 행은 헤더로 자동 제외됩니다</li>
				</ul>
			</div>

			<form id="uploadForm" enctype="multipart/form-data">
				<div class="mb-3">
					<label for="excelFile" class="form-label">엑셀 파일 선택</label> <input
						type="file" class="form-control" id="excelFile" name="file"
						accept=".xlsx,.xls" required>
				</div>

				<div class="mt-3">
					<p id="selectedFileName" class="text-muted"></p>
					<button type="submit" id="submitBtn" class="btn btn-success w-100"
						disabled>업로드 시작</button>
				</div>
			</form>

			<div id="resultArea" class="result-area"></div>

			<div class="mt-4">
				<a href="/potfill/admin/dashboard" class="btn btn-secondary">
					대시보드로 돌아가기 </a>
			</div>
		</div>
	</div>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
	<script>
        var fileInput = document.getElementById('excelFile');
        var selectedFileName = document.getElementById('selectedFileName');
        var submitBtn = document.getElementById('submitBtn');
        var resultArea = document.getElementById('resultArea');
        var uploadForm = document.getElementById('uploadForm');

        // 파일 선택 이벤트
        fileInput.addEventListener('change', function() {
            var file = fileInput.files[0];
            if (file) {
                var fileSize = (file.size / 1024 / 1024).toFixed(2);
                selectedFileName.textContent = '선택된 파일: ' + file.name + ' (' + fileSize + ' MB)';
                submitBtn.disabled = false;
                
                // 파일 타입 확인
                if (!file.name.match(/\.(xlsx|xls)$/i)) {
                    showResult('error', '엑셀 파일(.xlsx, .xls)만 업로드 가능합니다.');
                    submitBtn.disabled = true;
                    return;
                }
                
                hideResult();
            }
        });
        
        // 폼 제출 이벤트
        uploadForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            var file = fileInput.files[0];
            if (!file) {
                showResult('error', '파일을 선택해주세요.');
                return;
            }
            
            submitBtn.disabled = true;
            submitBtn.innerHTML = '업로드 중...';
            
            var formData = new FormData();
            formData.append('file', file);
            
            fetch('/potfill/admin/uploadMajorPlaces', {
                method: 'POST',
                body: formData
            })
            .then(function(response) {
                return response.json();
            })
            .then(function(data) {
                if (data.success) {
                    showResult('success', data.message);
                    // 성공 시 폼 리셋
                    uploadForm.reset();
                    selectedFileName.textContent = '';
                    submitBtn.disabled = true;
                } else {
                    showResult('error', data.message);
                }
            })
            .catch(function(error) {
                console.error('업로드 오류:', error);
                showResult('error', '서버 오류가 발생했습니다.');
            })
            .finally(function() {
                submitBtn.disabled = false;
                submitBtn.innerHTML = '업로드 시작';
            });
        });
        
        function showResult(type, message) {
            var resultClass = 'result-area result-' + type;
            var resultText = '<strong>';
            
            if (type == 'success') {
                resultText += '성공!';
            } else {
                resultText += '오류!';
            }
            
            resultText += '</strong> ' + message;
            
            resultArea.className = resultClass;
            resultArea.innerHTML = resultText;
            resultArea.style.display = 'block';
        }
        
        function hideResult() {
            resultArea.style.display = 'none';
        }
    </script>
</body>
</html>
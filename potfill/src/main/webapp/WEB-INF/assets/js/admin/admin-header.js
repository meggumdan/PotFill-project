console.log('스크립트 파일 로드 완료!');

// DOM이 모두 로드된 후에 스크립트가 실행
document.addEventListener('DOMContentLoaded', function() {
    // ID로 정확하게 로그아웃 버튼을 선택
    const logoutButton = document.getElementById('btnLogout');

    // 로그아웃 버튼이 페이지에 존재할 경우에만 이벤트를 연결
    if (logoutButton) {
        logoutButton.addEventListener('click', function() {
          
            console.log('로그아웃 버튼 클릭!'); 

         
            location.href = '/potfill/admin/logout'; 
        });
    }
});
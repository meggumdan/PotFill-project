/*
* 작성자 : 최영준
*/

document.addEventListener('DOMContentLoaded', function() {
    console.log('스크립트 로드됨');
    console.log('현재 URL:', window.location.pathname);
    
    // 현재 URL 경로 가져오기
    const path = window.location.pathname;
    
    // 요소들이 제대로 있는지 확인
    const navItems = document.querySelectorAll('.nav-item');
    const subItems = document.querySelectorAll('.sub-item');
    
    console.log('nav-item 개수:', navItems.length);
    console.log('sub-item 개수:', subItems.length);
    
    // 모든 active 클래스 제거
    navItems.forEach(el => el.classList.remove('active'));
    subItems.forEach(el => el.classList.remove('active'));
    
    // URL에 따라 메뉴 활성화
    if (path.includes('/admin/dashboard') && !path.includes('/district')) {
        console.log('대시보드 - 전체보기 활성화');
        if (navItems[0]) navItems[0].classList.add('active');
        if (subItems[0]) subItems[0].classList.add('active');
        
    } else if (path.includes('/district')) {
        console.log('대시보드 - 관할보기 활성화');
        if (navItems[0]) navItems[0].classList.add('active');
        if (subItems[1]) subItems[1].classList.add('active');
        
    } else if (path.includes('/complaints')) {
        console.log('민원관리 활성화');
        if (navItems[1]) navItems[1].classList.add('active');
        
    } else if (path.includes('/map')) {
        console.log('포트홀지도 활성화');
        if (navItems[2]) navItems[2].classList.add('active');
        
    } else {
        console.log('일치하는 URL 없음:', path);
    }
    
    // 최종 상태 확인
    setTimeout(() => {
        console.log('활성화된 nav-item:', document.querySelectorAll('.nav-item.active').length);
        console.log('활성화된 sub-item:', document.querySelectorAll('.sub-item.active').length);
    }, 100);
});
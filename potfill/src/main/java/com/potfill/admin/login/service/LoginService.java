/*
 * 작성자 : 김슬기
 * 설명 : 로그인 비즈니스 로직 인터페이스
 */
package com.potfill.admin.login.service;

import com.potfill.admin.login.model.Login;
import com.potfill.admin.login.model.LoginAdminInfo;

public interface LoginService {
	// 아이디, 패스워드 확인
	LoginAdminInfo checkCredentials(Login login);
}

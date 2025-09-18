/*
 * 작성자 : 김슬기
 * 설명 : 로그인 비즈니스 로직 구현체
 */
package com.potfill.admin.login.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.potfill.admin.login.dao.LoginRepository;
import com.potfill.admin.login.model.Login;
import com.potfill.admin.login.model.LoginAdminInfo;

@Service
public class LoginServiceImpl implements LoginService {

	@Autowired
	LoginRepository loginRepository;
	
	@Override
	public LoginAdminInfo checkCredentials(Login login) {
		return loginRepository.checkCredentials(login);
	}
}

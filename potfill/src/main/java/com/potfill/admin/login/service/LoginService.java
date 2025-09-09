package com.potfill.admin.login.service;

import com.potfill.admin.login.model.Login;
import com.potfill.admin.login.model.LoginAdminInfo;

public interface LoginService {
	// 아이디, 패스워드 확인
	LoginAdminInfo checkCredentials(Login login);
}

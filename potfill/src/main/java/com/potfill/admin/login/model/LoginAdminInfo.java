/*
 * 작성자 : 김슬기
 * 설명 : 로그인한 관리자 정보 데이터 객체
 */
package com.potfill.admin.login.model;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class LoginAdminInfo {
    private String loginId;         
    private String adminName;       
    private String email;           
    private String phone;           
    private String districtCode;    
    private Integer adminRole;           
}
 
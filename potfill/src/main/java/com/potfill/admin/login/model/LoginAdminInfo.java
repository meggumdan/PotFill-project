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
 
package com.potfill.admin.complaints.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString(exclude = "adminPw") // toString() 메서드에서 비밀번호 필드는 제외합니다.
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Admin {

    private Long adminId;
    private String loginId;
    private String adminPw;
    private String adminName;
    private String email;
    private String phone;
    private String department;
    private String districtCode;
    private Integer adminRole;

}
package com.potfill.admin.complaints.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MajorPlace {

    private Long majorId;
    private String areaName;
    private String gu;
    private String dong;

}

package com.potfill.admin.complaints.model;

import java.sql.Timestamp;
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
public class ReportPhoto {

    private Long photoId;
    private Long complaintId;
    private String fileUrl;
    private String photoName;
    private Timestamp createdAt;

}

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
public class ComplaintHistory {

    private Long historyId;
    private Long complaintId;
    private Long adminId;
    private String status;
    private String statusComment;
    private Timestamp createdAt;

}

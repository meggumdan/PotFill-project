package com.potfill.user.complaint.model;

import java.time.LocalDateTime;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ComplaintHistory {
    private Long historyId;
    private Long complaintId;
    private Long adminId;
    private String status;
    private String statusComment;
    private LocalDateTime createdAt;
}
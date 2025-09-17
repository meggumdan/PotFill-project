/*
 * 작성자 : 정소영
 * 설명   : 포트홀 신고의 처리 과정을 기록하는 이력 모델
 */
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
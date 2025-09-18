/*
 * 작성자 : 이지민
 * 설명   : 대시보드에 표시할 최근 일자별 민원 건수를 담는 모델
 * 			날짜(LocalDate)와 신규 건수, 완료·반려 건수를 저장/전달
 */
package com.potfill.admin.district.model;

import java.time.LocalDate;

public class DailyCount {
    private LocalDate date;
    private int newCount; // 신규 건수
    private int completedCount; // 완료+반려 건수

    public DailyCount(LocalDate date, int newCount, int completedCount) {
        this.date = date;
        this.newCount = newCount;
        this.completedCount = completedCount;
    }

    // getter & setter
    public LocalDate getDate() { return date; }
    public void setDate(LocalDate date) { this.date = date; }

    public int getNewCount() { return newCount; }
    public void setNewCount(int newCount) { this.newCount = newCount; }

    public int getCompletedCount() { return completedCount; }
    public void setCompletedCount(int completedCount) { this.completedCount = completedCount; }
}
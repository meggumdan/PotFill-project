package com.potfill.admin.managerdistrict.model;

import java.time.LocalDate;

public class DailyCount {
    private LocalDate date;    // 날짜
    private int newCount;      // 신규 건수
    private int completedCount; // 완료/반려 건수

    // 생성자
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
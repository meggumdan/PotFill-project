package com.potfill.admin.dashboard_overall.model;

public class MajorPlace {
    private int majorId;
    private String areaName;
    private String gu;
    private String dong;
    
    // 기본 생성자
    public MajorPlace() {}
    
    // 매개변수 생성자
    public MajorPlace(String areaName, String gu, String dong) {
        this.areaName = areaName;
        this.gu = gu;
        this.dong = dong;
    }
    
    // Getter & Setter
    public int getMajorId() { 
        return majorId; 
    }
    
    public void setMajorId(int majorId) { 
        this.majorId = majorId; 
    }
    
    public String getAreaName() { 
        return areaName; 
    }
    
    public void setAreaName(String areaName) { 
        this.areaName = areaName; 
    }
    
    public String getGu() { 
        return gu; 
    }
    
    public void setGu(String gu) { 
        this.gu = gu; 
    }
    
    public String getDong() { 
        return dong; 
    }
    
    public void setDong(String dong) { 
        this.dong = dong; 
    }
    
    @Override
    public String toString() {
        return "MajorPlace{" +
                "majorId=" + majorId +
                ", areaName='" + areaName + '\'' +
                ", gu='" + gu + '\'' +
                ", dong='" + dong + '\'' +
                '}';
    }
}
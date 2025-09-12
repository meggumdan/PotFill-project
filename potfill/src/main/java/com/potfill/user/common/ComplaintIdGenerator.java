package com.potfill.user.common;

import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.concurrent.ThreadLocalRandom;

public final class ComplaintIdGenerator {
    private static final DateTimeFormatter FMT = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
    private static final ZoneId KST = ZoneId.of("Asia/Seoul");

    private ComplaintIdGenerator() {}

    public static long newId() {
    	// 지금은 초 단위 + 2자리 난수니까 한 초 안에서 100건 이상 동시에 생성되면 충돌 주의
        String ts = ZonedDateTime.now(KST).format(FMT);   // 예: 20250910153412
        int suffix = ThreadLocalRandom.current().nextInt(0, 100); // 00~99
        String idStr = ts + String.format("%02d", suffix); // "2025091015341202"
        return Long.parseLong(idStr);
    }
}
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
        String ts = ZonedDateTime.now(KST).format(FMT);   // 예: 20250910153412
        int suffix = ThreadLocalRandom.current().nextInt(0, 1000); // 000~999
        String idStr = ts + String.format("%03d", suffix); // "20250910153412042"
        return Long.parseLong(idStr);
    }
}
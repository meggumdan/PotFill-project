package com.potfill.user.common;

import com.uber.h3core.H3Core;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.io.IOException;

@Configuration
public class H3Config {

    @Bean
    public H3Core h3Core() throws IOException {
        return H3Core.newInstance(); // H3 라이브러리 초기화
    }
}


package com.potfill.webConfig;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // 2. 웹 브라우저에서 /upload/ 로 시작하는 모든 요청을 처리할 핸들러를 추가합니다.
        registry.addResourceHandler("/upload/**")
                // 3. 위 요청이 오면, 아래 지정된 실제 폴더 경로에서 파일을 찾아 보여줍니다.
                .addResourceLocations("file:///C:/lect_labs/labs_java/sts-4.31.0.RELEASE/src/main/webapp/upload/");
    }
}
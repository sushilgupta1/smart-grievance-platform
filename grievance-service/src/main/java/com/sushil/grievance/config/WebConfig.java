package com.sushil.grievance.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer{
	
	@Value("${file.upload-dir}")
	private String uploadDir;
	
	@Override
	public void addResourceHandlers(ResourceHandlerRegistry registry) 
	{
		String uploadUri = java.nio.file.Paths.get(uploadDir).toAbsolutePath().normalize().toUri().toString();
		if(!uploadUri.endsWith("/")) {
		    uploadUri += "/";
		}
		registry.addResourceHandler("/grievance/uploads/**").addResourceLocations(uploadUri);
	}
	
}

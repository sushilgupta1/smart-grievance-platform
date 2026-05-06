package com.sushil.grievance.service;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import jakarta.annotation.PostConstruct;

@Service
public class FileStorageService {
	
	@Value("${file.upload-dir}")
	private String uploadDir;
	
	private Path fileStorageLocation;
	
	@PostConstruct
	public void init()
	{
		this.fileStorageLocation=Paths.get(uploadDir).toAbsolutePath().normalize();
		try {
			Files.createDirectories(this.fileStorageLocation);
		} catch (Exception e) {
			throw new RuntimeException("Could not create the directory where the uploaded files will be stored.",e);
		}
	}

	public String storeFile(MultipartFile file)
	{
		if(file ==null || file.isEmpty())
		{
			return null;
		}
		String origionalFileName=StringUtils.cleanPath(file.getOriginalFilename());
		
		try {
			if(origionalFileName.contains(".."))
			{
				throw new RuntimeException("Sorry! Filename contains invalid path sequence "+origionalFileName);
			}
			
			String fileExtension =origionalFileName.substring(origionalFileName.lastIndexOf("."));
			String newFileName=UUID.randomUUID().toString()+fileExtension;
			
			Path targetLocation=this.fileStorageLocation.resolve(newFileName);
			Files.copy(file.getInputStream(), targetLocation,StandardCopyOption.REPLACE_EXISTING);
			
			return newFileName;
		} catch (IOException e) {
			throw new RuntimeException("Could not store file "+origionalFileName+". Please try again!",e);
		
		}
	}
}

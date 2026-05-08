package com.sushil.auth.exception;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import com.sushil.auth.dto.ErrorResponse;

@RestControllerAdvice
public class GlobalExceptionHandler {

	@ExceptionHandler(RuntimeException.class)
	public ResponseEntity<ErrorResponse> handleRuntimeException(RuntimeException ex)
	{
		
		HttpStatus status=HttpStatus.BAD_REQUEST;
		String errorCode="ERR-GEN-000";
		String errorMessage=ex.getMessage();
		
		if(errorMessage.contains("Invalid credentials"))
		{
			status=HttpStatus.UNAUTHORIZED;
			errorCode="AUTH-401";
		} else if(errorMessage.contains("Account not verified"))
		{
			status=HttpStatus.FORBIDDEN;
			errorCode="AUTH-403";
		} else if(errorMessage.contains("already registered"))
		{
			status=HttpStatus.CONFLICT;
			errorCode="AUTH-409";
		} else if(errorMessage.contains("Unauthorized"))
		{
			status=HttpStatus.UNAUTHORIZED;
			errorCode="SEC-401";
		}
		
		ErrorResponse response=new ErrorResponse(status.value(), status.getReasonPhrase(), errorMessage, errorCode);
		
		return new ResponseEntity<>(response,status);
		
	}
	
	@ExceptionHandler(Exception.class)
	public ResponseEntity<ErrorResponse> handleGenericException(Exception ex)
	{
		
		ErrorResponse response=new ErrorResponse(HttpStatus.INTERNAL_SERVER_ERROR.value(), HttpStatus.INTERNAL_SERVER_ERROR.getReasonPhrase(), "An unexpected internal error occured.", "SYS-500");
		
		return new ResponseEntity<>(response,HttpStatus.INTERNAL_SERVER_ERROR);
	}
}

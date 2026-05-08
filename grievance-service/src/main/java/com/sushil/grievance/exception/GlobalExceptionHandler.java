package com.sushil.grievance.exception;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import com.sushil.grievance.dto.ErrorResponse;

@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(ResourceNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleNotFound(ResourceNotFoundException ex) {
        ErrorResponse response = new ErrorResponse(
                HttpStatus.NOT_FOUND.value(),
                HttpStatus.NOT_FOUND.getReasonPhrase(),
                ex.getMessage(),
                "GRV-404"
        );
        return new ResponseEntity<>(response, HttpStatus.NOT_FOUND);
    }

    @ExceptionHandler(RuntimeException.class)
    public ResponseEntity<ErrorResponse> handleRuntimeException(RuntimeException ex) {
        
        HttpStatus status = HttpStatus.BAD_REQUEST;
        String errorCode = "ERR-GEN-000";
        String errorMessage = ex.getMessage();

        // Custom Application Error Code mapping for Grievance rules
        if (errorMessage.contains("Maximum dispute limit exhausted")) {
            status = HttpStatus.FORBIDDEN;
            errorCode = "GRV-LIMIT-403";
        } else if (errorMessage.contains("Unauthorized: only the true owner")) {
            status = HttpStatus.UNAUTHORIZED;
            errorCode = "GRV-SEC-401";
        } else if (errorMessage.contains("Unauthorized: Email does not match")) {
            status = HttpStatus.UNAUTHORIZED;
            errorCode = "GRV-SEC-401";
        } else if (errorMessage.contains("Could not store file") || errorMessage.contains("invalid path sequence")) {
            status = HttpStatus.INTERNAL_SERVER_ERROR;
            errorCode = "GRV-FILE-500";
        }

        ErrorResponse response = new ErrorResponse(
                status.value(),
                status.getReasonPhrase(),
                errorMessage,
                errorCode
        );

        return new ResponseEntity<>(response, status);
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponse> handleGeneral(Exception ex) {
        ErrorResponse response = new ErrorResponse(
                HttpStatus.INTERNAL_SERVER_ERROR.value(),
                HttpStatus.INTERNAL_SERVER_ERROR.getReasonPhrase(),
                "An unexpected internal error occurred.",
                "SYS-500"
        );
        return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
    }
}

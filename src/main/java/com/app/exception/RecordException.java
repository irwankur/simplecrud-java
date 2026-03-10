package com.app.exception;

public class RecordException extends Exception {

    public RecordException(String message) {
        super(message);
    }

    public RecordException(String message, Throwable cause) {
        super(message, cause);
    }
}
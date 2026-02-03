/// Custom exceptions for the application
library exceptions;

/// Base exception for all app-related errors
class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  AppException(this.message, {this.code, this.details});

  @override
  String toString() => 'AppException: $message (code: $code)';
}

/// Exception for network-related errors
class NetworkException extends AppException {
  NetworkException(super.message, {super.code, super.details});

  @override
  String toString() => 'NetworkException: $message';
}

/// Exception for API errors
class ApiException extends AppException {
  final int? statusCode;

  ApiException(
    super.message, {
    this.statusCode,
    super.code,
    super.details,
  });

  @override
  String toString() => 'ApiException: $message (status: $statusCode)';
}

/// Exception for data parsing errors
class DataParseException extends AppException {
  DataParseException(super.message, {super.code, super.details});

  @override
  String toString() => 'DataParseException: $message';
}

/// Exception for storage errors
class StorageException extends AppException {
  StorageException(super.message, {super.code, super.details});

  @override
  String toString() => 'StorageException: $message';
}

/// Exception for when no profiles are available
class NoProfilesAvailableException extends AppException {
  NoProfilesAvailableException([String? message])
      : super(message ?? 'No profiles available');
}

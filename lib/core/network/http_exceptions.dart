// ignore_for_file: overridden_fields

import "../exceptions/exceptions.dart";

class BadRequestException extends ServerException {
  @override
  final String message;
  final int statusCode;
  BadRequestException({required this.statusCode, required this.message})
      : super(message: message);

  @override
  String toString() =>
      "Bad Request Exception occurred with status code $statusCode : $message";
}

class AuthenticationException extends ServerException {
  @override
  final String message;
  final int statusCode;
  AuthenticationException({required this.statusCode, required this.message})
      : super(message: message);

  @override
  String toString() =>
      "Auth Exception occurred with status code $statusCode : $message";
}

class ValidationException extends ServerException {
  @override
  final String message;
  final int statusCode;
  ValidationException({required this.statusCode, required this.message})
      : super(message: message);

  @override
  String toString() =>
      "Validation exception occurred code $statusCode : $message";
}

class SessionExpiredException extends ServerException {
  @override
  final String message;
  final int statusCode;
  SessionExpiredException({required this.statusCode, required this.message})
      : super(message: message);

  @override
  String toString() => "Session Expired $statusCode : $message";
}

class UnknownException extends ServerException {
  @override
  final String message;
  final int statusCode;
  UnknownException({required this.statusCode, required this.message})
      : super(message: message);

  @override
  String toString() => "Unknown Exception Ocurred $statusCode : $message";
}

class CustomException implements ServerException {
  @override
  final String message;
  final int code;
  CustomException({required this.message, required this.code}) : super();
}

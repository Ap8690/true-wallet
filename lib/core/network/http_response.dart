class NetworkResponse<T> {
  int statusCode;
  String message;
  T data;
  NetworkError? errors;

  NetworkResponse(
      {required this.statusCode,
      required this.data,
      required this.message,
      this.errors});

  factory NetworkResponse.fromJson(Map<String, dynamic> json) =>
      NetworkResponse(
        statusCode: json["status"],
        data: json["data"],
        message: json["message"],
        errors: json["errors"] != null
            ? NetworkError.fromJson(json["errors"])
            : null,
      );
}

class NetworkError {
  final int? code;
  NetworkError({required this.code});

  factory NetworkError.fromJson(Map<String, dynamic> json) =>
      NetworkError(code: json["code"]);
}

class SuccessResponse {
  final String message;
  SuccessResponse({required this.message});
}

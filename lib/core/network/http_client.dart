// ignore_for_file: avoid_function_literals_in_foreach_calls

import "dart:async";
import "dart:convert";
import "dart:io";
import "../exceptions/exceptions.dart";
import "http_response.dart";

import "package:http/http.dart" as http;
import "package:http_parser/http_parser.dart";
import "package:mime/mime.dart";

Future<String?> getContentType(File file) async {
  final mimeTypeResolver = MimeTypeResolver();
  String? mimeType = mimeTypeResolver.lookup(file.path);
  return mimeType;
}

abstract class MyHttpClient {
  Future<NetworkResponse> get(
      {required String url, required Map<String, String> headers});
  Future<NetworkResponse> post(
      {required String url,
      required Map<String, dynamic> body,
      required Map<String, String> headers});
  Future<NetworkResponse> patch(
      {required String url,
      required Map<String, dynamic> body,
      required Map<String, String> headers});
  Future<NetworkResponse> put(
      {required String url,
      required Map<String, dynamic> body,
      required Map<String, String> headers});
  Future<NetworkResponse> delete(
      {required String url,
      required Map<String, dynamic> body,
      required Map<String, String> headers});
  Future<NetworkResponse> patchMultipart(
      {required String url,
      required Map<String, String> body,
      required Map<String, File>? files,
      required Map<String, List<File>>? multiFiles,
      required Map<String, String> headers});
  Future<NetworkResponse> postMultipart(
      {required String url,
      required Map<String, String> body,
      required Map<String, File> files,
      required Map<String, String> headers});
}

class HttpClientImpl extends MyHttpClient {
  HttpClientImpl._internal();
  static final HttpClientImpl instance = HttpClientImpl._internal();

  factory HttpClientImpl() => instance;

  @override
  Future<NetworkResponse> get({
    required String url,
    Map<String, String>? headers,
  }) async {
    try {
      http.Response response = await http.get(Uri.parse(url), headers: headers);
      var data = jsonDecode(response.body);
      print(data);
      NetworkResponse networkResponse = NetworkResponse.fromJson(data);
      return networkResponse;
    } on SocketException {
      return NetworkResponse(
          data: null,
          statusCode: 410,
          message:
              "Connection Failed. Make sure you have active internet connection");
    } catch (e) {
      return NetworkResponse(data: null, statusCode: 0, message: e.toString());
    }
  }

  @override
  Future<NetworkResponse> delete(
      {required String url,
      required Map<String, dynamic> body,
      required Map<String, String> headers}) async {
    try {
      http.Response response =
          await http.delete(Uri.parse(url), headers: headers, body: body);
      var data = jsonDecode(response.body);
      print(data);

      NetworkResponse networkResponse = NetworkResponse.fromJson(data);
      return networkResponse;
    } on SocketException {
      return NetworkResponse(
          data: null,
          statusCode: 410,
          message:
              "Connection Failed. Make sure you have active internet connection");
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      return NetworkResponse(data: null, statusCode: 0, message: e.toString());
    }
  }

  @override
  Future<NetworkResponse> post(
      {required String url,
      required Map<String, String> headers,
      required Map<String, dynamic> body}) async {
    try {
      print(jsonEncode(url));
      http.Response response = await http.post(Uri.parse(url),
          headers: headers, body: jsonEncode(body));
      print(response.statusCode);
      print(response.body);
      print("::::::::::<<<<");
      var data = jsonDecode(response.body);
      NetworkResponse networkResponse = NetworkResponse.fromJson(data);
      return networkResponse;
    } on SocketException {
      return NetworkResponse(
          data: null,
          statusCode: 410,
          message:
              "Connection Failed. Make sure you have active internet connection");
    } catch (e) {
      print(":::::::<<<<$e");
      return NetworkResponse(data: null, statusCode: 0, message: e.toString());
    }
  }

  @override
  Future<NetworkResponse> put(
      {required String url,
      required Map<String, String> headers,
      required Map<String, dynamic> body}) async {
    try {
      http.Response response = await http.put(Uri.parse(url),
          headers: headers, body: json.encode(body));
      var data = jsonDecode(response.body);
      NetworkResponse networkResponse = NetworkResponse.fromJson(data);
      return networkResponse;
    } on SocketException {
      return NetworkResponse(
          data: null,
          statusCode: 410,
          message:
              "Connection Failed. Make sure you have active internet connection");
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      return NetworkResponse(data: null, statusCode: 0, message: e.toString());
    }
  }

  @override
  Future<NetworkResponse> patchMultipart(
      {required String url,
      required Map<String, String> body,
      required Map<String, File>? files,
      required Map<String, List<File>>? multiFiles,
      required Map<String, String> headers}) async {
    http.MultipartRequest request =
        http.MultipartRequest("PATCH", Uri.parse(url));
    if (files != null) {
      files.forEach((key, value) {
        http.MultipartFile httpImage = http.MultipartFile.fromBytes(
          key,
          value.readAsBytesSync(),
          filename: value.path.split("/").last,
        );
        request.files.add(httpImage);
      });
    }

    if (multiFiles != null) {
      multiFiles.forEach((key, value) {
        value.forEach((element) async {
          String? contentType = await getContentType(element);
          http.MultipartFile httpImage = http.MultipartFile.fromBytes(
              key, element.readAsBytesSync(),
              filename: element.path.split("/").last,
              contentType:
                  contentType != null ? MediaType.parse(contentType) : null);
          request.files.add(httpImage);
        });
      });
    }

    request.fields.addAll(body);
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();
      var data = jsonDecode(await response.stream.bytesToString());
      NetworkResponse networkResponse = NetworkResponse.fromJson(data);
      return networkResponse;
    } on SocketException {
      return NetworkResponse(
          data: null,
          statusCode: 410,
          message:
              "Connection Failed. Make sure you have active internet connection");
    } catch (e) {
      return NetworkResponse(data: null, statusCode: 0, message: e.toString());
    }
  }

  @override
  Future<NetworkResponse> postMultipart(
      {required String url,
      required Map<String, String> body,
      required Map<String, File> files,
      required Map<String, String> headers}) async {
    http.MultipartRequest request =
        http.MultipartRequest("POST", Uri.parse(url));

    files.forEach((key, value) {
      http.MultipartFile httpImage = http.MultipartFile.fromBytes(
          key, value.readAsBytesSync(),
          filename: value.path.split("/").last);
      request.files.add(httpImage);
    });
    request.fields.addAll(body);
    request.headers.addAll(headers);
    try {
      http.StreamedResponse response = await request.send();
      var data = jsonDecode(await response.stream.bytesToString());
      NetworkResponse networkResponse = NetworkResponse(
        data: data["data"],
        statusCode: response.statusCode,
        message: data["message"],
        errors: data["errors"],
      );
      return networkResponse;
    } on SocketException {
      return NetworkResponse(
          data: null,
          statusCode: 410,
          message:
              "Connection Failed. Make sure you have active internet connection");
    } catch (e) {
      return NetworkResponse(data: null, statusCode: 0, message: e.toString());
    }
  }

  @override
  Future<NetworkResponse> patch(
      {required String url,
      required Map<String, dynamic> body,
      required Map<String, String> headers}) async {
    try {
      print(jsonEncode(body));
      http.Response response = await http.patch(Uri.parse(url),
          headers: headers, body: jsonEncode(body));
      print(response.statusCode);
      print(response.body);

      var data = jsonDecode(response.body);
      NetworkResponse networkResponse = NetworkResponse.fromJson(data);
      return networkResponse;
    } on SocketException {
      return NetworkResponse(
          data: null,
          statusCode: 410,
          message:
              "Connection Failed. Make sure you have active internet connection");
    } catch (e) {
      return NetworkResponse(data: null, statusCode: 0, message: e.toString());
    }
  }
}

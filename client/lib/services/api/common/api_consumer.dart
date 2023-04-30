import 'dart:io';

import './api_response.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class ApiConsumer {
  static final baseUrl = '${dotenv.env['BASE_URL']}';

  static Future<ApiResponse<T>> get<T>(
      String path, T Function(Map<String, dynamic> json)? fromJson,
      {Map<String, String>? queryParameters}) async {
    final uri = Uri.parse(baseUrl + path)
        .replace(queryParameters: queryParameters ?? {});
    final response = await http.get(uri);
    return ApiResponse.fromJson(
        jsonDecode(response.body), response.statusCode, fromJson);
  }

  static Future<ApiResponseList<T>> getList<T>(
      String path, T Function(Map<String, dynamic> json)? fromJson,
      {Map<String, String>? queryParameters}) async {
    final uri = Uri.parse(baseUrl + path)
        .replace(queryParameters: queryParameters ?? {});
    final response = await http.get(uri);
    return ApiResponseList.fromJson(
        jsonDecode(response.body), response.statusCode, fromJson);
  }

  static Future<ApiResponse<Tout>> post<Tin, Tout>(String path, Tin data,
      Tout Function(Map<String, dynamic> json)? fromJson) async {
    final response = await http.post(Uri.parse(baseUrl + path),
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});
    return ApiResponse.fromJson(
        jsonDecode(response.body), response.statusCode, fromJson);
  }

  static Future<ApiResponse<T>> delete<T>(String path) async {
    final response = await http.delete(Uri.parse(baseUrl + path));
    return ApiResponse.fromJson(
        jsonDecode(response.body), response.statusCode, null);
  }

  static Future<ApiResponse<Tout>> update<Tin, Tout>(String path, Tin data,
      Tout Function(Map<String, dynamic> json)? fromJson) async {
    final response = await http.patch(Uri.parse(baseUrl + path),
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});
    return ApiResponse.fromJson(
        jsonDecode(response.body), response.statusCode, fromJson);
  }

  static Future<ApiResponseList<T>> uploadSingleFile<T>(
      String path,
      String fieldName,
      File file,
      T Function(Map<String, dynamic> json)? fromJson) async {
    var stream = http.ByteStream(Stream.castFrom(file.openRead()));
    var length = await file.length();

    var uri = Uri.parse(baseUrl + path);
    var request = http.MultipartRequest('POST', uri);
    var multipartFile = http.MultipartFile(fieldName, stream, length,
        filename: file.path.split('/').last);
    request.files.add(multipartFile);

    final response = await request.send();
    String responseBodyString =
        await response.stream.transform(utf8.decoder).join();
    return ApiResponseList.fromJson(
        jsonDecode(responseBodyString), response.statusCode, fromJson);
  }
}

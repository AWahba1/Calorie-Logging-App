import 'dart:io';
import 'package:client/services/api/common/api_helper.dart';
import './api_response.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class ApiConsumer {
  static final baseUrl = '${dotenv.env['BASE_URL']}';

  static Future<ApiResponse<T>> get<T>(
      String path, T Function(Map<String, dynamic> json)? fromJson,
      {Map<String, String>? queryParameters, bool requiresAuth = true}) async {
    final headers = <String, String>{};
    if (requiresAuth) {
      await ApiHelper.addAuthHeader(headers);
    }

    final uri = Uri.parse(baseUrl + path)
        .replace(queryParameters: queryParameters ?? {});
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 401 && requiresAuth) {
      // Refresh access token and retry request
      await ApiHelper.refreshAccessToken();
      await ApiHelper.addAuthHeader(headers);
      response = await http.get(uri, headers: headers);
    }
    return ApiResponse.fromJson(
        jsonDecode(response.body), response.statusCode, fromJson);
  }

  static Future<ApiResponseList<T>> getList<T>(
      String path, T Function(Map<String, dynamic> json)? fromJson,
      {Map<String, String>? queryParameters, bool requiresAuth = true}) async {
    final headers = <String, String>{};
    if (requiresAuth) {
      await ApiHelper.addAuthHeader(headers);
    }

    final uri = Uri.parse(baseUrl + path)
        .replace(queryParameters: queryParameters ?? {});
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 401 && requiresAuth) {
      // Refresh access token and retry request
      await ApiHelper.refreshAccessToken();
      await ApiHelper.addAuthHeader(headers);
      response = await http.get(uri, headers: headers);
    }
    return ApiResponseList.fromJson(
        jsonDecode(response.body), response.statusCode, fromJson);
  }

  static Future<ApiResponse<Tout>> post<Tin, Tout>(
      String path, Tin data, Tout Function(Map<String, dynamic> json)? fromJson,
      {bool requiresAuth = true}) async {
    final headers = {'Content-Type': 'application/json'};
    if (requiresAuth) {
      await ApiHelper.addAuthHeader(headers);
    }

    final uri = Uri.parse(baseUrl + path);
    final requestBody = jsonEncode(data);
    var response = await http.post(uri, body: requestBody, headers: headers);

    if (response.statusCode == 401 && requiresAuth) {
      // Refresh access token and retry request
      await ApiHelper.refreshAccessToken();
      await ApiHelper.addAuthHeader(headers);
      response = await http.post(uri, body: requestBody, headers: headers);
    }
    return ApiResponse.fromJson(
        jsonDecode(response.body), response.statusCode, fromJson);
  }

  static Future<ApiResponse<T>> delete<T>(String path,
      {bool requiresAuth = true}) async {
    final headers = <String, String>{};
    if (requiresAuth) {
      await ApiHelper.addAuthHeader(headers);
    }
    final uri = Uri.parse(baseUrl + path);
    var response = await http.delete(uri, headers: headers);
    if (response.statusCode == 401 && requiresAuth) {
      // Refresh access token and retry request
      await ApiHelper.refreshAccessToken();
      await ApiHelper.addAuthHeader(headers);
      response = await http.delete(uri, headers: headers);
    }
    return ApiResponse.fromJson(
        jsonDecode(response.body), response.statusCode, null);
  }

  static Future<ApiResponse<Tout>> update<Tin, Tout>(
      String path, Tin data, Tout Function(Map<String, dynamic> json)? fromJson,
      {bool requiresAuth = true}) async {
    final headers = {'Content-Type': 'application/json'};
    if (requiresAuth) {
      await ApiHelper.addAuthHeader(headers);
    }
    final uri = Uri.parse(baseUrl + path);
    final requestBody = jsonEncode(data);
    var response = await http.patch(uri, body: requestBody, headers: headers);

    if (response.statusCode == 401 && requiresAuth) {
      // Refresh access token and retry request
      await ApiHelper.refreshAccessToken();
      await ApiHelper.addAuthHeader(headers);
      response = await http.patch(uri, body: requestBody, headers: headers);
    }
    return ApiResponse.fromJson(
        jsonDecode(response.body), response.statusCode, fromJson);
  }

  static Future<ApiResponseList<T>> uploadSingleFile<T>(
      String path,
      String fieldName,
      File file,
      T Function(Map<String, dynamic> json)? fromJson,
      {bool requiresAuth = true}) async {
    final headers = <String, String>{};
    if (requiresAuth) {
      await ApiHelper.addAuthHeader(headers);
    }

    var stream = http.ByteStream(Stream.castFrom(file.openRead()));
    var length = await file.length();

    final uri = Uri.parse(baseUrl + path);
    var request = http.MultipartRequest('POST', uri);
    var multipartFile = http.MultipartFile(fieldName, stream, length,
        filename: file.path.split('/').last);
    request.files.add(multipartFile);
    request.headers.addAll(headers);

    var response = await request.send();

    if (response.statusCode == 401 && requiresAuth) {
      // Refresh access token and retry request
      await ApiHelper.refreshAccessToken();
      await ApiHelper.addAuthHeader(headers);

      final newRequest = http.MultipartRequest('POST', uri);
      var newMultipartFile = http.MultipartFile(fieldName, stream, length,
          filename: file.path.split('/').last);
      newRequest.files.add(newMultipartFile);
      newRequest.headers.addAll(headers);

      response = await newRequest.send();
    }
    String responseBodyString =
        await response.stream.transform(utf8.decoder).join();
    return ApiResponseList.fromJson(
        jsonDecode(responseBodyString), response.statusCode, fromJson);
  }
}

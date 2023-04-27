import './api_response.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';


class ApiConsumer {
  static final baseUrl = '${dotenv.env['BASE_URL']}';

  static Future<ApiResponse<T>> get<T>(String path) async {
    final response = await http.get(Uri.parse(baseUrl + path));
    return ApiResponse.fromJson(jsonDecode(response.body), response.statusCode);
  }

  static Future<ApiResponse<Tout>> post<Tin,Tout>(
      String path, Tin data) async {
    final response = await http.post(Uri.parse(baseUrl + path), body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'});
    return ApiResponse.fromJson(jsonDecode(response.body), response.statusCode);
  }

  static Future<ApiResponse<T>> delete<T>(String path) async {
    final response = await http.delete(Uri.parse(baseUrl+path));
    return ApiResponse.fromJson(jsonDecode(response.body), response.statusCode);
  }
}
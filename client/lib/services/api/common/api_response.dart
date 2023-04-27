import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiResponse<T> {
  final String message; // comma separated if multiple errors exist
  final T? data;
  final int status;
  final bool isSuccess;

  ApiResponse(
      {required this.message,
      required this.data,
      required this.status,
      required this.isSuccess});

  factory ApiResponse.fromJson(Map<String, dynamic> json, int statusCode) {
    return ApiResponse(
        message: formatMessage(json['message']),
        data: json['data'] != null ? json['data'] as T : null,
        status: statusCode,
        isSuccess: statusCode >= 200 && statusCode <= 299);
  }

  static String formatMessage(dynamic message) {
    String formattedMessage = "";
    if (message is String) {
      formattedMessage = message;
    } else {
      message.forEach((key, value) {
        formattedMessage += value.join(", ");
      });
    }
    return formattedMessage;
  }
}

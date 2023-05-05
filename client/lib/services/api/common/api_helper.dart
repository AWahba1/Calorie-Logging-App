import 'dart:convert';

import 'package:client/services/api/common/api_consumer.dart';
import 'package:client/services/api/common/secure_storage.dart';
import 'package:http/http.dart' as http;

import 'api_response.dart';

class ApiHelper {
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

  static Future<void> addAuthHeader(Map<String, String> headers) async {
    String accessToken = await SecureStorage.getAccessToken();
    headers['Authorization'] = 'Bearer $accessToken';
  }

  static Future<void> refreshAccessToken() async {
    final url = '${ApiConsumer.baseUrl}/auth/refresh';
    final headers = {'Content-Type': 'application/json'};
    final refreshToken = await SecureStorage.getRefreshToken();
    final body = jsonEncode({'refresh_token': refreshToken});

    final response =
        await http.post(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode == 200) {
      final decodedResponse = ApiResponse.fromJson(
          jsonDecode(response.body), response.statusCode, null);
      final accessToken = decodedResponse.data['access_token'];
      await SecureStorage.setAccessToken(accessToken);
    } else {
      throw Exception('Failed to refresh access token');
    }
  }
}

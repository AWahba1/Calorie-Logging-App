import 'package:client/services/api/common/secure_storage.dart';

import 'common/api_response.dart';
import 'common/api_consumer.dart';

class AuthService {
  static const authUrl = "/auth";
  static const registerUrl = "/users/";

  static Future<ApiResponse> registerUser(
      String name, String email, String password) async {
    final response = await ApiConsumer.post(
        registerUrl, {'name': name, 'email': email, 'password': password}, null,
        requiresAuth: false);
    return response;
  }

  static Future<ApiResponse> loginUser(String email, String password) async {
    final response = await ApiConsumer.post(
        '$authUrl/login', {'email': email, 'password': password}, null,
        requiresAuth: false);

    if (response.isSuccess) {
      String accessToken = response.data['access_token'];
      String refreshToken = response.data['refresh_token'];
      SecureStorage.setAccessToken(accessToken);
      SecureStorage.setRefreshToken(refreshToken);
    }
    return response;
  }
}

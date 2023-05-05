import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const storage = FlutterSecureStorage();

  static const accessTokenKey = 'access_token';
  static const refreshTokenKey = 'refresh_token';

  static Future<void> setAccessToken(String accessToken) async {
    print('Access token set $accessToken');
    await storage.write(key: accessTokenKey, value: accessToken);
  }

  static Future<void> setRefreshToken(String refreshToken) async {
    await storage.write(key: refreshTokenKey, value: refreshToken);
  }

  static Future<String> getRefreshToken() async {
    return await storage.read(key: refreshTokenKey) ?? "";
  }

  static Future<String> getAccessToken() async {
    return await storage.read(key: accessTokenKey) ?? "";
  }
}

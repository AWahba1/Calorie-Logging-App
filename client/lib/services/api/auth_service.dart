import 'common/api_response.dart';
import 'common/api_consumer.dart';

class AuthService {
  static const url = "/users";

  static Future<ApiResponse> registerUser(
      String name, String email, String password) async {
    final response = await ApiConsumer.post(
        '$url/signup', {'name': name, 'email': email, 'password': password},null);
    return response;
  }

  static Future<ApiResponse> loginUser(String email, String password) async {
    final response = await ApiConsumer.post(
        '$url/login', {'email': email, 'password': password},null);
    return response;
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';


class AuthService {
  static final url = "${dotenv.env['BASE_URL']}/users";

  static Future<bool> registerUser(String name, String email, String password) async {
    final response = await http.post(Uri.parse("$url/signup"),
      body: jsonEncode({'name':name, 'email': email, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode>=200 && response.statusCode<=299) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse("$url/login"),
      body: jsonEncode({'email': email, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );


    print(response.statusCode);
    print(response.body);

    if (response.statusCode>=200 && response.statusCode<=299) {
      //final responseBody = jsonDecode(response.body);
      //final token = responseBody['token'];
      //return token;
      return true;
    } else {
      return false;
    }
  }
}

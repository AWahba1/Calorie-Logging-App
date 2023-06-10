import 'dart:convert';
import 'package:client/models/search_item.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NutritionXApiClient {
  static final String _baseUrl = '${dotenv.env['NutritionX_base']}';
  static final String _appId = '${dotenv.env['NutritionX_app_id']}';
  static final String _appKey = '${dotenv.env['NutritionX_app_key']}';
  static final String _remoteUserId =
      '${dotenv.env['NutritionX_remote_user_id']}';

  static Future<List<SearchItem>> searchFood(String query) async {
    final headers = {
      'Content-Type': 'application/json',
      'x-app-id': _appId,
      'x-app-key': _appKey,
      'x-remote-user-id': _remoteUserId
    };

    var queryParameters = {
      'detailed': 'true',
      'branded': 'false',
      'self': 'false',
      'query': query
    };
    final uri = Uri.parse('$_baseUrl/search/instant')
        .replace(queryParameters: queryParameters);

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> foodList = responseData["common"];
      List<SearchItem> searchItems = foodList.map((item) {
        return SearchItem.fromJson(item);
      }).toList();

      return searchItems;
    } else {
      throw Exception(
          'Failed to search food. Status code: ${response.statusCode} - ${response.body}');
    }
  }
}

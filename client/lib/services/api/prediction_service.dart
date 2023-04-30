import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../models/prediction_result.dart';
import 'common/api_response.dart';
import 'common/api_consumer.dart';

class PredictionService {
  static const url = '/predict/upload';

  static Future<ApiResponseList<PredictedItem>> predictFromImage(
      File imageFile) async {
    final response = await ApiConsumer.uploadSingleFile<PredictedItem>(
        url, 'image', imageFile, PredictedItem.fromJson);
    return response;
  }
}

import 'dart:io';
import '../../models/prediction_result.dart';
import 'common/api_response.dart';
import 'common/api_consumer.dart';

class PredictionService {
  static const url = '/predict/upload';

  static Future<ApiResponse2DList<PredictedItem>> predictFromImage(
      File imageFile) async {
    final response = await ApiConsumer.uploadSingleFile<PredictedItem>(
        url, 'image', imageFile, PredictedItem.fromJson);
    return response;
  }
}

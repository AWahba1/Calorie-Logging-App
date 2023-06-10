import 'dart:io';
import 'package:client/models/search_item.dart';

import '../../models/history_item.dart';
import 'common/api_response.dart';
import 'common/api_consumer.dart';
import '../Firebase Storage/firebase_storage.dart';

class HistoryService {
  static const url = "/food-items/history";

  static Future<ApiResponseList<HistoryItem>> fetchAllHistoryItems(
      DateTime currentDate) async {
    String stringDate =
        "${currentDate.year}-${currentDate.month}-${currentDate.day}";
    final response = await ApiConsumer.getList<HistoryItem>(
        url, HistoryItem.fromJson,
        queryParameters: {'date': stringDate});
    return response;
  }

  static Future<ApiResponse<HistoryItem>> getHistoryItemById(
      int historyItemId) async {
    final response = await ApiConsumer.get<HistoryItem>(
        '$url/$historyItemId', HistoryItem.fromJson);
    return response;
  }

  static Future<ApiResponse> deleteHistoryItem(int historyItemId) async {
    final response = await ApiConsumer.delete('$url/$historyItemId');
    return response;
  }

  static Future<ApiResponse> updateHistoryItem(
      HistoryItem newHistoryItem) async {
    final response = await ApiConsumer.update(
        '$url/${newHistoryItem.id}',
        {
          'weight': newHistoryItem.weight,
          'weight_unit':
              WeightUnitExtension.convertToString(newHistoryItem.weightUnit),
          'quantity': newHistoryItem.quantity
        },
        null);
    return response;
  }

  static Future<ApiResponse> addHistoryItem(
      HistoryItem newHistoryItem, DateTime currentDate) async {
    String formattedDate =
        "${currentDate.year}-${currentDate.month}-${currentDate.day}";

    bool isManualEntry = newHistoryItem.imagePath!.startsWith('http') ||
        newHistoryItem.imagePath!.startsWith('https');
    final imageURL = isManualEntry
        ? newHistoryItem.imagePath!
        : await FirebaseStorageService.uploadImageToFirebase(
            File(newHistoryItem.imagePath!));
    final response = await ApiConsumer.post<Object, HistoryItem>(
        url,
        {
          'date': formattedDate,
          'food_item': isManualEntry ? null : newHistoryItem.foodItemDetails.id,
          'food_name': newHistoryItem.foodItemDetails.name.toLowerCase(),
          'weight': newHistoryItem.weight,
          'quantity': newHistoryItem.quantity,
          'imageURL': imageURL,
          'weight_unit':
              WeightUnitExtension.convertToString(newHistoryItem.weightUnit),
        },
        HistoryItem.fromJson);
    return response;
  }
}

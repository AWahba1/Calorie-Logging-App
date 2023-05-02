import 'dart:convert';
import 'dart:io';

import '../../models/history_item.dart';
import 'common/api_response.dart';
import 'common/api_consumer.dart';
import '../firebase_storage.dart';

class HistoryService {
  static const url = "/food-items/history";
  static int userId = 1; // TODO: remove when authentication is done

  static Future<ApiResponseList<HistoryItem>> fetchAllHistoryItems(
      DateTime currentDate) async {
    String stringDate =
        "${currentDate.year}-${currentDate.month}-${currentDate.day}";
    final response = await ApiConsumer.getList<HistoryItem>(
        '$url/user/$userId', HistoryItem.fromJson,
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
    final imageURL = await FirebaseStorageService.uploadImageToFirebase(
        File(newHistoryItem.imagePath!));
    final response = await ApiConsumer.post<Object, HistoryItem>(
        '$url/user/$userId',
        {
          'date': formattedDate,
          'food_item': newHistoryItem.foodItemDetails.id,
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

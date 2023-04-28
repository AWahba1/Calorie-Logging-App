import 'package:client/models/history_model.dart';
import 'common/api_response.dart';
import 'common/api_consumer.dart';

class HistoryService {
  static const url = "/food-items/history";
  static int userId = 1; // TODO: remove when authentication is done

  static Future<ApiResponseList<HistoryItem>> fetchAllHistoryItems(
      DateTime dateTime) async {
    String stringDate = "${dateTime.year}-${dateTime.month}-${dateTime.day}";
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
}

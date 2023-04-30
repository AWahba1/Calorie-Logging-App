import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:client/services/api/history_service.dart';

import 'history_item.dart';

class UserHistoryModel with ChangeNotifier {
  DateTime _currentDate;

  List<HistoryItem>? _historyItems = [];

  UserHistoryModel({DateTime? currentDate})
      : _currentDate = currentDate ?? DateTime.now();

  DateTime get currentDate => _currentDate;

  List<HistoryItem>? get historyItems => _historyItems;

  int get totalCalories =>
      _historyItems?.fold(
          0,
          (total, element) =>
              total! +
              (element.quantity *
                      element.weight *
                      (element.weightUnit == WeightUnit.kg ? 1000 : 1) *
                      element.foodItemDetails.caloriesPerGram)
                  .round()) ??
      0;

  double get totalCarbs =>
      _historyItems?.fold(
          0,
          (total, element) =>
              total! +
              (element.quantity *
                  element.weight *
                  (element.weightUnit == WeightUnit.kg ? 1000 : 1) *
                  element.foodItemDetails.carbsPerGram)) ??
      0;

  double get totalProteins =>
      _historyItems?.fold(
          0,
          (total, element) =>
              total! +
              (element.quantity *
                  element.weight *
                  (element.weightUnit == WeightUnit.kg ? 1000 : 1) *
                  element.foodItemDetails.proteinPerGram)) ??
      0;

  double get totalFats =>
      _historyItems?.fold(
          0,
          (total, element) =>
              total! +
              (element.quantity *
                  element.weight *
                  (element.weightUnit == WeightUnit.kg ? 1000 : 1) *
                  element.foodItemDetails.fatsPerGram)) ??
      0;

  Future<void> setDate(DateTime newDate) async {
    _currentDate = newDate;
    final response = await HistoryService.fetchAllHistoryItems(_currentDate);
    _historyItems = response.data;
    notifyListeners();
  }

  Future<List<HistoryItem>?> fetchAndSetHistoryList() async {
    final response = await HistoryService.fetchAllHistoryItems(_currentDate);
    _historyItems = response.data;
    notifyListeners();
    return _historyItems;
  }

  HistoryItem getHistoryItemById(int itemId) {
    return _historyItems!.firstWhere((historyItem) => historyItem.id == itemId);
  }

  HistoryItem getHistoryItemByPosition(int index) {
    return _historyItems![index];
  }

  Future<bool> removeHistoryItem(int itemId) async {
    if (historyItems == null) return false;

    try {
      final response = await HistoryService.deleteHistoryItem(itemId);
      if (response.isSuccess) {
        _historyItems!.removeWhere((historyItem) => historyItem.id == itemId);
        notifyListeners();
      }
      return response.isSuccess;
    } catch (exception) {
      return false;
    }
  }

  Future<bool> addHistoryItem(HistoryItem newItem) async {
    try {
      if (historyItems == null) return false;
      print(_currentDate);
      final response =
          await HistoryService.addHistoryItem(newItem, _currentDate);
      print(response.message);
      print(response.isSuccess);
      print(response.status);
      if (response.isSuccess) {
        _historyItems!.add(response.data);
        notifyListeners();
      }
      return response.isSuccess;
    } catch (exception) {
      print(exception.toString());
      return false;
    }
  }

  Future<bool> modifyHistoryItem(HistoryItem newHistoryItem) async {
    try {
      if (historyItems == null) return false;
      int itemIndex = historyItems!
          .indexWhere((historyItem) => historyItem.id == newHistoryItem.id);
      final oldHistoryItem = getHistoryItemByPosition(itemIndex);

      // all fields are identical, no need to send a request to the backend
      if (oldHistoryItem.quantity == newHistoryItem.quantity &&
          oldHistoryItem.weightUnit == newHistoryItem.weightUnit &&
          oldHistoryItem.weight == newHistoryItem.weight) {
        return true;
      }

      final response = await HistoryService.updateHistoryItem(newHistoryItem);
      if (response.isSuccess) {
        // update in memory if successful
        historyItems![itemIndex] = HistoryItem.clone(newHistoryItem);
        notifyListeners();
      }
      return response.isSuccess;
    } catch (exception) {
      return false;
    }
  }

// Future<bool> modifyOrAddHistoryItem(HistoryItem item) async {
//   if (historyItems == null) return false;
//
//   try {
//     int index =
//         historyItems!.indexWhere((historyItem) => historyItem.id == item.id);
//     if (index != -1) {
//       return await modifyHistoryItem(item, index);
//     } else {
//       //addHistoryItem(item);
//       return true;
//     }
//   } catch (exception) {
//     return false;
//   }
// }
}

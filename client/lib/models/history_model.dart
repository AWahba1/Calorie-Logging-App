import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:client/services/api/history_service.dart';

enum WeightUnit { g, kg }

extension WeightUnitExtension on WeightUnit {
  static WeightUnit? fromString(String shortString) {
    switch (shortString) {
      case 'g':
        return WeightUnit.g;
      case 'kg':
        return WeightUnit.kg;
      default:
        return null;
    }
  }

  static String convertToString(WeightUnit weightUnit) {
    switch (weightUnit) {
      case WeightUnit.kg:
        return 'kg';
      default:
        return 'g';
    }
  }
}

class HistoryItem {
  final int id;
  String? imageURL;
  int quantity;
  double weight;
  WeightUnit weightUnit;
  final FoodItemDetails foodItemDetails;

  HistoryItem(
      {required this.id,
      required this.imageURL,
      required this.quantity,
      required this.weight,
      this.weightUnit = WeightUnit.g,
      required this.foodItemDetails});

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      id: json['id'],
      imageURL: json['imageURL'],
      quantity: json['quantity'],
      weight: json['weight'],
      weightUnit:
          WeightUnitExtension.fromString(json['weight_unit']) ?? WeightUnit.g,
      foodItemDetails: FoodItemDetails.fromJson(json['food_item']),
    );
  }

  // deep cloning a history item object
  factory HistoryItem.clone(HistoryItem copyFromItem) {
    return HistoryItem(
        id: copyFromItem.id,
        imageURL: copyFromItem.imageURL,
        quantity: copyFromItem.quantity,
        weight: copyFromItem.weight,
        weightUnit: copyFromItem.weightUnit,
        foodItemDetails: copyFromItem.foodItemDetails);
  }

  int get calories => (quantity *
          weight *
          (weightUnit == WeightUnit.kg ? 1000 : 1) *
          foodItemDetails.caloriesPerGram)
      .round();

  // macros returned in grams
  double get fats => (quantity *
      weight *
      (weightUnit == WeightUnit.kg ? 1000 : 1) *
      foodItemDetails.caloriesPerGram);

  double get protein =>
      quantity *
      weight *
      (weightUnit == WeightUnit.kg ? 1000 : 1) *
      foodItemDetails.proteinPerGram;

  double get carbs =>
      quantity *
      weight *
      (weightUnit == WeightUnit.kg ? 1000 : 1) *
      foodItemDetails.carbsPerGram;
}

class FoodItemDetails {
  final int id;
  final String name;
  final double caloriesPerGram;
  final double proteinPerGram;
  final double carbsPerGram;
  final double fatsPerGram;

  FoodItemDetails(
      {required this.id,
      required this.name,
      required this.caloriesPerGram,
      required this.carbsPerGram,
      required this.fatsPerGram,
      required this.proteinPerGram});

  factory FoodItemDetails.fromJson(Map<String, dynamic> json) {
    return FoodItemDetails(
      id: json['id'],
      name: json['name'],
      caloriesPerGram: json['calories_per_gram'],
      proteinPerGram: json['protein_per_gram'],
      carbsPerGram: json['carbs_per_gram'],
      fatsPerGram: json['fats_per_gram'],
    );
  }
}

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

  void addHistoryItem(HistoryItem newItem) async {
    if (historyItems == null) return;

    // TODO: add food item backend
    _historyItems!.add(newItem);
    notifyListeners();
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

  Future<bool> modifyHistoryItem(
      HistoryItem newHistoryItem, int itemIndex) async {
    if (historyItems == null || itemIndex >= historyItems!.length) return false;
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
  }

  Future<bool> modifyOrAddHistoryItem(HistoryItem item) async {
    if (historyItems == null) return false;

    try {
      int index =
          historyItems!.indexWhere((historyItem) => historyItem.id == item.id);
      if (index != -1) {
        return await modifyHistoryItem(item, index);
      } else {
        //addHistoryItem(item);
        return true;
      }
    } catch (exception) {
      return false;
    }
  }
}

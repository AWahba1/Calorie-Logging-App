import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:client/services/api/history_service.dart';

enum WeightUnit { grams, kilograms }

class HistoryItem {
  final int id;
  String? imageURL;
  int quantity;
  double weight;
  final FoodItemDetails foodItemDetails;

  HistoryItem(
      {required this.id,
      required this.imageURL,
      required this.quantity,
      required this.weight,
      required this.foodItemDetails});

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      id: json['id'],
      imageURL: json['imageURL'],
      quantity: json['quantity'],
      weight: json['weight'],
      foodItemDetails: FoodItemDetails.fromJson(json['food_item']),
    );
  }

  int get calories => (quantity * weight * foodItemDetails.calories_per_gram).round();

  double get fats => (quantity * weight * foodItemDetails.calories_per_gram);

  double get protein => quantity * weight * foodItemDetails.protein_per_gram;

  double get carbs => quantity * weight * foodItemDetails.carbs_per_gram;
}

class FoodItemDetails {
  final int id;
  final String name;
  //WeightUnit weightUnit;
  final double calories_per_gram;
  final double protein_per_gram; // grams
  final double carbs_per_gram; // grams
  final double fats_per_gram; // grams

  FoodItemDetails(
      {required this.id,
      //required this.image,
      required this.name,
      required this.calories_per_gram,
      required this.carbs_per_gram,
      required this.fats_per_gram,
      required this.protein_per_gram});

  factory FoodItemDetails.fromJson(Map<String, dynamic> json) {
    return FoodItemDetails(
      id: json['id'],
      name: json['name'],
      calories_per_gram: json['calories_per_gram'],
      protein_per_gram: json['protein_per_gram'],
      carbs_per_gram: json['carbs_per_gram'],
      fats_per_gram: json['fats_per_gram'],
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
                  element.foodItemDetails.calories_per_gram).round()) ??
      0;

  double get totalCarbs =>
      _historyItems?.fold(
          0,
          (total, element) =>
              total! +
              (element.quantity *
                  element.weight *
                  element.foodItemDetails.carbs_per_gram)) ??
      0;

  double get totalProteins =>
      _historyItems?.fold(
          0,
          (total, element) =>
              total! +
              (element.quantity *
                  element.weight *
                  element.foodItemDetails.protein_per_gram)) ??
      0;

  double get totalFats =>
      _historyItems?.fold(
          0,
          (total, element) =>
              total! +
              (element.quantity *
                  element.weight *
                  element.foodItemDetails.fats_per_gram)) ??
      0;

  Future<void> setDate(DateTime newDate) async{
    _currentDate = newDate;
    //TODO: fetch from backend
    final response = await HistoryService.fetchAllHistoryItems(_currentDate);
    _historyItems=response.data;
    notifyListeners();
  }

  Future<List<HistoryItem>?> fetchAndSetHistoryList() async {
    // TODO: fetch from backend based on current date
    final response = await HistoryService.fetchAllHistoryItems(_currentDate);
    print(response.data);
    print(response.status);
    print(response.message);
    _historyItems = response.data;
    notifyListeners();
    return _historyItems;
  }

  HistoryItem getHistoryItemById(int itemId) {
    return _historyItems!.firstWhere((foodItem) => foodItem.id == itemId);
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

  void removeHistoryItem(int itemId) async {
    if (historyItems == null) return;

    // TODO: remove food item backend
    _historyItems!.removeWhere((historyItem) => historyItem.id == itemId);
    notifyListeners();
  }

  void modifyOrAddHistoryItem(HistoryItem item) async {
    if (historyItems == null) return;

    int index =
        historyItems!.indexWhere((historyItem) => historyItem.id == item.id);

    if (index != -1) {
      // TODO: update element in database
      historyItems![index] = item;
    } else {
      addHistoryItem(item);
    }
    notifyListeners();
  }
}

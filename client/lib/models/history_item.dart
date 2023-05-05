import 'food_item_details.dart';

class HistoryItem {
  final int id;
  String? imagePath; // can be local image path or a network URL
  int quantity;
  double weight;
  WeightUnit weightUnit;
  final FoodItemDetails foodItemDetails;

  HistoryItem(
      {required this.id,
      required this.imagePath,
      required this.quantity,
      required this.weight,
      this.weightUnit = WeightUnit.g,
      required this.foodItemDetails});

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      id: json['id'],
      imagePath: json['imageURL'],
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
        imagePath: copyFromItem.imagePath,
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
  double get fats => quantity *
      weight *
      (weightUnit == WeightUnit.kg ? 1000 : 1) *
      foodItemDetails.fatsPerGram;

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

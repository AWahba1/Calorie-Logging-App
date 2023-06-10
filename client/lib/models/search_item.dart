import 'package:client/models/history_item.dart';

import 'food_item_details.dart';

class SearchItem extends HistoryItem {
  final String servingUnit;
  final double servingQuantity;

  SearchItem(
      {required int id,
      String? imagePath,
      required int quantity,
      required double weight,
      WeightUnit weightUnit = WeightUnit.g,
      required FoodItemDetails foodItemDetails,
      required this.servingUnit,
      required this.servingQuantity})
      : super(
          id: id,
          imagePath: imagePath,
          quantity: quantity,
          weight: weight,
          weightUnit: weightUnit,
          foodItemDetails: foodItemDetails,
        );

  factory SearchItem.fromJson(Map<String, dynamic> json) {
    final List<dynamic> nutrients = json["full_nutrients"];

    double fats = 0.0;
    double protein = 0.0;
    double carbs = 0.0;
    double calories = 0.0;

    for (final nutrient in nutrients) {
      final int attrId = nutrient["attr_id"];
      final double value = nutrient["value"] * 1.0;

      switch (attrId) {
        case 203:
          protein = value;
          break;
        case 204:
          fats = value;
          break;
        case 205:
          carbs = value;
          break;
        case 208:
          calories = value;
          break;
      }
    }

    final double servingQuantity = json["serving_qty"] * 1.0;
    final double servingWeight = json['serving_weight_grams'] * 1.0;
    // final double actualWeight=servingWeight*servingQuantity;

    return SearchItem(
      id: 1,
      imagePath: json["photo"]["thumb"],
      quantity: 1,
      servingQuantity: servingQuantity,
      weight: servingWeight,
      weightUnit: WeightUnit.g,
      foodItemDetails: FoodItemDetails.fromJson({
        'id': 1,
        'name': json["food_name"],
        'fats_per_gram': fats / servingWeight,
        'carbs_per_gram': carbs / servingWeight,
        'protein_per_gram': protein / servingWeight,
        'calories_per_gram': calories / servingWeight,
      }),
      servingUnit: json['serving_unit'],
    );
  }
}

extension StringExtension on String {
  String convertToPascal() {
    final words = trim().split(RegExp(r'\s+'));

    final pascalCaseWords = words.map((word) {
      final firstLetter = word.substring(0, 1).toUpperCase();
      final rest = word.substring(1).toLowerCase();
      return '$firstLetter$rest';
    });

    return pascalCaseWords.join(' ');
  }
}

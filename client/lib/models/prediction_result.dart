import 'package:client/models/food_item_details.dart';
import 'package:client/models/history_item.dart';

class PredictedItem {
  final double weight;
  final FoodItemDetails foodItemDetails;

  const PredictedItem({required this.weight, required this.foodItemDetails});

  factory PredictedItem.fromJson(Map<String, dynamic> json) {
    return PredictedItem(
      weight: json['weight'],
      foodItemDetails: FoodItemDetails.fromJson(json['food_item_details']),
    );
  }
}


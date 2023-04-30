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

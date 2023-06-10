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
    final name=json['name'] as String;
    return FoodItemDetails(
      id: json['id'],
      name: name.convertToPascal(),
      caloriesPerGram: json['calories_per_gram'],
      proteinPerGram: json['protein_per_gram'],
      carbsPerGram: json['carbs_per_gram'],
      fatsPerGram: json['fats_per_gram'],
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


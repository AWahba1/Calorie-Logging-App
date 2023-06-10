import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';

class JournalChart extends StatelessWidget {
  //const JournalChart({Key? key}) : super(key: key);

  final int totalCalories;
  final double totalFats; // in grams
  final double totalProteins; // in grams
  final double totalCarbs; // in grams

  const JournalChart(
      {required this.totalCalories,
      required this.totalFats,
      required this.totalProteins,
      required this.totalCarbs});

  String formatCalories(int calories) {
    final formatter = NumberFormat('#,##0');
    String formattedString = formatter.format(calories);
    return formattedString;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      height: 280,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Consumed Calories: ${formatCalories(totalCalories)}",
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            PieChart(
              dataMap: {
                'Fats': totalFats,
                'Protein': totalProteins,
                'Carbohydrates': totalCarbs
              },
              chartRadius: 160,
              chartValuesOptions: const ChartValuesOptions(
                  showChartValueBackground: false,
                  showChartValuesInPercentage: true),
            ),
          ],
        ),
      ),
    );
  }
}

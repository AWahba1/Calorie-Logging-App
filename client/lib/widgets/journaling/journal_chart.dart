import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class JournalChart extends StatelessWidget {
  //const JournalChart({Key? key}) : super(key: key);

  final int totalCalories;
  final int totalFats; // in grams
  final int totalProteins; // in grams
  final int totalCarbs; // in grams

  const JournalChart(
      {required this.totalCalories,
      required this.totalFats,
      required this.totalProteins,
      required this.totalCarbs});

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
              "Consumed Calories: $totalCalories",
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            PieChart(
              dataMap: {
                'Fats': totalFats * 1.0,
                'Protein': totalProteins * 1.0,
                'Carbohydrates': totalCarbs * 1.0
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
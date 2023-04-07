
import 'package:client/widgets/journal_food_item.dart';
import 'package:flutter/material.dart';
import '../models/food_item.dart';

class JournalList extends StatelessWidget {
  //const JournalList({Key? key}) : super(key: key);

  List<FoodItem> foodItems;
  JournalList(this.foodItems);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: foodItems.length,
      itemBuilder: (context, index) {
        return JournalFoodItem(foodItems[index]);
      },

    );
  }
}

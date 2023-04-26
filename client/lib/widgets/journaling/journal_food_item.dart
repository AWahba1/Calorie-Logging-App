import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/history_model.dart';
import '../food_item_details/food_item_page.dart';

class JournalFoodItem extends StatelessWidget {
  //const JournalFoodItem({Key? key}) : super(key: key);

  final int foodItemIndex;

  JournalFoodItem(this.foodItemIndex);

  @override
  Widget build(BuildContext context) {
    final foodItem =
        Provider.of<HistoryModel>(context).getFoodItemByPosition(foodItemIndex);

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Card(
          margin: const EdgeInsets.only(left: 5, right: 5),
          elevation: 2,
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(foodItem.image!),
              radius: 30,
            ),
            title: Text(
              foodItem.name!,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
                '${foodItem.weight} ${foodItem.weightUnit == WeightUnit.grams ? 'g' : 'kg'}'),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text('${foodItem.calories}'), const Text('kcal')],
            ),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => FoodItemPage(isCameraPageCaller: false,foodItem: foodItem,)));
            },
          )),
    );
  }
}

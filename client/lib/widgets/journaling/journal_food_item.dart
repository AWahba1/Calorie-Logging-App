import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/history_model.dart';
import '../food_item_details/food_item_page.dart';

class JournalFoodItem extends StatelessWidget {
  //const JournalFoodItem({Key? key}) : super(key: key);

  final int historyItemIndex;

  JournalFoodItem(this.historyItemIndex);

  @override
  Widget build(BuildContext context) {
    final historyItem = Provider.of<UserHistoryModel>(context)
        .getHistoryItemByPosition(historyItemIndex);

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Card(
          margin: const EdgeInsets.only(left: 5, right: 5),
          elevation: 2,
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(historyItem.imageURL!),
              radius: 30,
            ),
            title: Text(
              historyItem.foodItemDetails.name,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
                '${historyItem.weight} ${historyItem.weightUnit == WeightUnit.g ? 'g' : 'kg'}'),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text('${historyItem.calories}'), const Text('kcal')],
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => FoodItemPage(
                        isCameraPageCaller: false,
                        historyItem: historyItem,
                      )));
            },
          )),
    );
  }
}

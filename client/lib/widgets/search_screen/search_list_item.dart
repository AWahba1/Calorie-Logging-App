import 'package:flutter/material.dart';
import '../food_item_details/food_item_page.dart';

import '../../models/search_item.dart';

class SearchListItem extends StatelessWidget {
  final SearchItem searchItem;

  const SearchListItem(this.searchItem);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => FoodItemPage(
                isCameraPageCaller: true,
                historyItem: searchItem,
              ),
            ),
          );
        },
        title: Text(searchItem.foodItemDetails.name),
        subtitle: Text(
            "${searchItem.servingQuantity} ${searchItem.servingUnit} — ${searchItem.calories} kcal"));
  }
}

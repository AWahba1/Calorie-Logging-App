import 'dart:io';
import 'dart:math';
import 'package:client/widgets/food_item_details/food_item_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/history_item.dart';
import '../../models/prediction_result.dart';
import '../../models/user_history_model.dart';
import '../util_views/snackbar_builder.dart';

class PredictedItemView extends StatefulWidget {
  final String? imagePath;
  final List<PredictedItem> predictedItems;
  int currentItemIndex = 0;

  PredictedItemView(this.imagePath, this.predictedItems);

  @override
  State<PredictedItemView> createState() => _PredictedItemViewState();
}

class _PredictedItemViewState extends State<PredictedItemView> {
  late UserHistoryModel history;
  bool _isLoading = false;

  Widget showTop1Prediction(HistoryItem topOneHistoryItem,
      VoidCallback onEditPress, VoidCallback onAddButtonPress) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onLongPress: () {},
        onTap: () {},
        child: ListTile(
          onTap: onEditPress,
          title: Text(
            topOneHistoryItem.foodItemDetails.name!,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text("${topOneHistoryItem.calories} kcal"),
          trailing: _isLoading
              ? const SizedBox(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : IconButton(
                  icon: const SizedBox(
                    height: 100,
                    child: Icon(Icons.add_circle_sharp, size: 30),
                  ),
                  onPressed: onAddButtonPress,
                  tooltip: "Add item",
                ),
        ),
      ),
    );
  }

  Widget showOtherPredictionItem(int index) {
    return Container(
      margin: const EdgeInsets.all(3),
      child: OutlinedButton(
        onPressed: () => onOtherPredictionPress(index),
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: Text(widget.predictedItems[index].foodItemDetails.name),
      ),
    );
  }

  void onOtherPredictionPress(int index) {
    setState(() {
      widget.currentItemIndex = index;
    });
  }

  void onAddButtonPress(HistoryItem topOneItem) async {
    try {
      setState(() {
        _isLoading = true;
      });
      final isSuccessful = await history.addHistoryItem(topOneItem);
      setState(() {
        _isLoading = false;
      });
      if (!isSuccessful) throw Exception();

      final successSnackBar = buildSnackBar(
          'Added Successfully', Colors.green, const Duration(seconds: 1));
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(successSnackBar);
    } catch (exception) {
      final failureSnackBar = buildSnackBar(
          'Error while adding food item! Please try again',
          Colors.red,
          const Duration(seconds: 1));
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(failureSnackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    history = Provider.of<UserHistoryModel>(context, listen: false);

    final topOnePredictedItem = widget.predictedItems[widget.currentItemIndex];
    final topOneHistoryItem = HistoryItem(
        id: Random().nextInt(100),
        imagePath: widget.imagePath,
        quantity: 1,
        weight: topOnePredictedItem.weight,
        foodItemDetails: topOnePredictedItem.foodItemDetails);
    return Column(
      children: [
        showTop1Prediction(topOneHistoryItem, () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => FoodItemPage(
                isCameraPageCaller: true,
                historyItem: topOneHistoryItem,
              ),
            ),
          );
        }, () => onAddButtonPress(topOneHistoryItem)),
        Container(
          height: 30,
          child: Row(
            children: [
              const Icon(
                Icons.swap_horiz,
                color: Colors.grey,
              ),
              // Exchange icon
              const SizedBox(width: 5),
              // Adjust the spacing as needed
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.predictedItems.length,
                  itemBuilder: (context, index) {
                    return topOnePredictedItem == widget.predictedItems[index]
                        ? const Text("")
                        : showOtherPredictionItem(index);
                  },
                ),
              ),
            ],
          ),
        ),
        const Divider(thickness: 0.5),
      ],
    );
  }
}

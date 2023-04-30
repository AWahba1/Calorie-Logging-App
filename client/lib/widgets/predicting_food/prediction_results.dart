import 'dart:io';
import 'dart:math';
import 'package:client/widgets/food_item_details/food_item_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/history_item.dart';
import '../../models/prediction_result.dart';
import '../../models/user_history_model.dart';
import '../util_views/snackbar_builder.dart';

class PredictionResults extends StatefulWidget {
  final String? imagePath;
  final List<PredictedItem> predictedItems;

  PredictionResults(this.imagePath, this.predictedItems);

  @override
  State<PredictionResults> createState() => _PredictionResultsState();
}

class _PredictionResultsState extends State<PredictionResults> {
  int currentItemIndex = 0; // initially points at the top 1 item
  late UserHistoryModel history;
  bool _isLoading = false;

  Widget showTop1Prediction(HistoryItem topOneHistoryItem,
      VoidCallback onEditPress, VoidCallback onAddButtonPress) {
    return Card(
      //color: Colors.blue,
      elevation: 4.0,
      margin: const EdgeInsets.only(top: 13, bottom: 20),
      child: ListTile(
        onTap: onEditPress,
        leading: CircleAvatar(
          backgroundImage: FileImage(File(widget.imagePath!)),
          radius: 30,
        ),
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
                  //value:10,
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
    );
  }

  Widget showOtherPredictionItem(int index) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: OutlinedButton(
        onPressed: () => onOtherPredictionPress(index),
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
        child: Text(widget.predictedItems[index].foodItemDetails.name),
      ),
    );
  }

  void onOtherPredictionPress(int index) {
    setState(() {
      currentItemIndex = index;
    });
  }

  void onTopOneAddButtonPress(HistoryItem topOneItem) async {
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

  List<Widget> buildEmptyPredictionResultView() {
    return [
      Container(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Icon(Icons.image_search, size: 50),
            SizedBox(height: 5),
            Text("No food items found!"),
            SizedBox(height: 20),
            Text(
              "Start adding by hovering your camera on the desired food item and tapping the add button.",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      )
    ];
  }

  List<Widget> buildFullPredictionResultView() {
    final topOnePredictedItem = widget.predictedItems[currentItemIndex];
    final topOneHistoryItem = HistoryItem(
        id: Random().nextInt(100),
        imagePath: widget.imagePath,
        quantity: 1,
        weight: topOnePredictedItem.weight,
        foodItemDetails: topOnePredictedItem.foodItemDetails);
    return [
      showTop1Prediction(topOneHistoryItem, () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FoodItemPage(
              isCameraPageCaller: true,
              historyItem: topOneHistoryItem,
            ),
          ),
        );
      }, () => onTopOneAddButtonPress(topOneHistoryItem)),
      const Text(
        "Consider also:",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      Container(
        height: 50,
        margin: const EdgeInsets.all(5),
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
    ];
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    history = Provider.of<UserHistoryModel>(context, listen: false);

    return Container(
      width: mediaQuery.size.width,
      height: 325,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Suggestions",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              //color: Colors.white,
            ),
          ),
          const Divider(thickness: 0.5),
          if (widget.imagePath == null)
            ...buildEmptyPredictionResultView()
          else
            ...buildFullPredictionResultView()
        ],
      ),
    );
  }
}

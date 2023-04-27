import 'package:client/widgets/predicting_food/camera_page.dart';
import 'package:client/widgets/food_item_details/food_item_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/history_model.dart';

class PredictionResults extends StatefulWidget {

  final String? foodImage;
  PredictionResults(this.foodImage);

  @override
  State<PredictionResults> createState() => _PredictionResultsState();
}

class _PredictionResultsState extends State<PredictionResults> {
  // List<FoodItem> predictedItems = [
  //   FoodItem(
  //     name: "Banana",
  //   ),
  //   FoodItem(
  //     name: "Apple Pie",
  //   ),
  //   FoodItem(
  //     name: "Steak",
  //   ),
  //   FoodItem(
  //     name: "French Fries",
  //   ),
  //   FoodItem(
  //     name: "Cheesecake",
  //   )
  // ];
  List<HistoryItem>predictedItems=[];
  // String foodImage =
  //     'https://tmbidigitalassetsazure.blob.core.windows.net/rms3-prod/attachments/37/1200x1200/Apple-Pie_EXPS_MRRA22_6086_E11_03_1b_v3.jpg';

  // List<FoodItem>predictedItems=[];
  int currentItemIndex = 0; // initially points at the top 1 item
  late UserHistoryModel history;

  Widget showTop1Prediction(HistoryItem historyItem, VoidCallback onEditPress,
      VoidCallback onAddButtonPress) {
    return Card(
      //color: Colors.blue,
      elevation: 4.0,
      margin: const EdgeInsets.only(top: 13, bottom: 20),
      child: ListTile(
        onTap: onEditPress,
        leading: CircleAvatar(
          backgroundImage: NetworkImage(widget.foodImage!),
          radius: 30,
        ),
        title: Text(historyItem.foodItemDetails.name!,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            )),
        subtitle: Text("${historyItem.calories} kcal"),
        trailing: IconButton(
          icon: const Icon(Icons.add_circle_sharp),
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
        child: Text(predictedItems[index].foodItemDetails.name!),
      ),
    );
  }

  void onOtherPredictionPress(int index) {
    setState(() {
      currentItemIndex = index;
    });
  }

  void onTopOneAddButtonPress(HistoryItem topOneItem) {
    // TODO: send to backend & based on response show corresponding snackbar
    history.addHistoryItem(topOneItem);
    const isRequestSuccessful = true;
    final snackBar = isRequestSuccessful
        ? buildSnackBar(
            'Added Successfully', Colors.green, const Duration(seconds: 1))
        : buildSnackBar('Error while adding food item! Please try again',
            Colors.red, const Duration(seconds: 1));
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  SnackBar buildSnackBar(String text, Color color, Duration duration) {
    return SnackBar(
      content: Text(text, style: const TextStyle(fontSize: 15)),
      backgroundColor: color,
      duration: duration,
    );
  }

  List<Widget> buildEmptyBottomSheet() {
    return [
      Container(
        // width: double.infinity,
        padding: const EdgeInsets.all(30),
        // alignment: Alignment.center,
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

  List<Widget> buildFullBottomSheet() {
    final topOneItem = predictedItems[currentItemIndex];
    topOneItem.imageURL = widget.foodImage!;
    topOneItem.weight = 100.0;
    // TODO: fetch macros & calories based on qty=1 & weight=100
    return [
      showTop1Prediction(topOneItem, () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FoodItemPage(
              isCameraPageCaller: true,
              historyItem: topOneItem,
            ),
          ),
        );
      }, () => onTopOneAddButtonPress(topOneItem)),
      const Text(
        "Consider also:",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          //color: Colors.white,
        ),
      ),
      Container(
        height: 50,
        margin: const EdgeInsets.all(5),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: predictedItems.length,
          itemBuilder: (context, index) {
            return topOneItem == predictedItems[index]
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
      height: 300,
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
          if (widget.foodImage==null)
            ...buildEmptyBottomSheet()
          else
            ...buildFullBottomSheet()
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class PredictionResults extends StatefulWidget {
  @override
  State<PredictionResults> createState() => _PredictionResultsState();
}

class _PredictionResultsState extends State<PredictionResults> {
  List<String> predictedItems = [
    "Banana",
    "Steak",
    "Cheesecake",
    "Apple Pie",
    "French Fries"
  ];

  //List<String>predictedItems=[];
  int currentItemIndex = 0; // initially points at the top 1 item

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //topOneItem=predictedItems[0];
  }

  Widget showTop1Prediction(
      String foodItemName, VoidCallback onAddButtonPress) {
    return Card(
      //color: Colors.blue,
      elevation: 4.0,
      margin: const EdgeInsets.only(top: 13, bottom: 20),
      child: ListTile(
        onTap: () {},
        leading: const CircleAvatar(
          backgroundImage: NetworkImage(
              'https://images.healthshots.com/healthshots/en/uploads/2022/01/21143156/BANANAS-1600x900.jpg'),
          radius: 30,
        ),
        title: Text(foodItemName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            )),
        subtitle: const Text("2,500 kcal"),
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
        child: Text(predictedItems[index]),
      ),
    );
  }

  void onOtherPredictionPress(int index) {
    setState(() {
      currentItemIndex = index;
    });
  }

  void onTopOnePress(int index) {
    // open food item page
  }

  void onTopOneAddButtonPress(int index) {
    // send to backend & based on response show snackbar
    const isRequestSuccessful = true;
    final snackBar = isRequestSuccessful
        ? buildSnackBar(
            'Added Successfully', Colors.green, const Duration(seconds: 1))
        : buildSnackBar('Error while adding food item! Please try again',
            Colors.red, const Duration(seconds: 1));
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
                "Start adding by hovering your camera on the desired food item.",
                textAlign: TextAlign.center,
              )
            ],
          ))
    ];
  }

  List<Widget> buildFullBottomSheet() {
    final topOneItem = predictedItems[currentItemIndex];
    return [
      showTop1Prediction(
          topOneItem, () => onTopOneAddButtonPress(currentItemIndex)),
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
          if (predictedItems.isEmpty)
            ...buildEmptyBottomSheet()
          else
            ...buildFullBottomSheet()
        ],
      ),
    );
  }
}

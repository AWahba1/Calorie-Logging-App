import 'package:client/widgets/predicting_food/prediction_item_view.dart';
import 'package:flutter/material.dart';

import '../../models/prediction_result.dart';
import '../search_screen/search_page.dart';

class PredictionResults extends StatelessWidget {
  final List<List<PredictedItem>> predictedItems;
  final String? imagePath;

  final VoidCallback onIdentifyButtonPress;
  bool isLoading;

  PredictionResults(this.imagePath, this.predictedItems,
      this.onIdentifyButtonPress, this.isLoading);

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
              "Start adding by hovering your camera on the desired food and tapping the button below.",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      )
    ];
  }

  Widget showManualEntryOption(BuildContext context) {
    return Row(
      children: [
        const Text(
          "Not what you're looking for?",
          style: TextStyle(
            fontStyle: FontStyle.italic,
          ),
        ),
        TextButton(onPressed:(){
          Navigator.pushNamed(context, SearchPage.route);
        }, child: const Text("Add manually"))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final deviceWidth = mediaQuery.size.width;
    return Container(
      width: mediaQuery.size.width,
      height: 325,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
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
          Row(
            children: [
              const Text(
                "Suggestions",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (imagePath != null)
                Text(
                  " (${predictedItems.length})",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                )
            ],
          ),
          const Divider(thickness: 0.5),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (imagePath == null)
                    ...buildEmptyPredictionResultView()
                  else
                    Container(
                      child: Column(
                        children: [
                          ListView.builder(
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: predictedItems.length,
                            itemBuilder: (context, index) {
                              return PredictedItemView(
                                  imagePath, predictedItems[index]);
                            },
                          ),
                          showManualEntryOption(context),
                          const SizedBox(height: 10)
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          Container(
            height: 45,
            width: deviceWidth - 20,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: isLoading ? null : onIdentifyButtonPress,
              child: isLoading
                  ? const SizedBox(
                      height: 24.0,
                      width: 24.0,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 3.0,
                      ),
                    )
                  : const Text("Identify Food Items"),
            ),
          ),
        ],
      ),
    );
  }
}

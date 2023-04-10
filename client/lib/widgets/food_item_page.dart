import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/history_model.dart';

class FoodItemPage extends StatefulWidget {
  //const FoodItemPage({Key? key}) : super(key: key);

  static const route = '/food-item';

  final bool isCameraPageCaller;
  final FoodItem foodItem;
  const FoodItemPage({required this.isCameraPageCaller, required this.foodItem});


  @override
  State<FoodItemPage> createState() => _FoodItemPageState();
}

class _FoodItemPageState extends State<FoodItemPage> {
  late FoodItem foodItem;
  late HistoryModel history;
  late TextEditingController _quantityController;
  late TextEditingController _weightController;
  bool initialized = false;
  late String chosenWeightUnit; // 'g' or 'kg'

  late int quantity;
  late int weight;
  late int calories;
  late int fats;
  late int carbs;
  late int proteins;

  late bool isCameraPageCaller;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (initialized) return;

    foodItem = widget.foodItem;

    history = Provider.of<HistoryModel>(context, listen: false);

    quantity = foodItem.quantity;
    weight = foodItem.weight;
    calories = foodItem.calories;
    fats = foodItem.fats;
    proteins = foodItem.proteins;
    carbs = foodItem.carbs;

    _quantityController = TextEditingController(text: '$quantity');
    _weightController = TextEditingController(text: '$weight');
    chosenWeightUnit = foodItem.weightUnit == WeightUnit.grams ? 'g' : 'kg';

    initialized = true;
  }

  Widget buildRing(String innerText, String label, Color color) {
    return Expanded(
      child: Column(
        children: [
          Container(
              margin: const EdgeInsets.only(bottom: 5),
              child: CircleAvatar(
                radius: 35,
                backgroundColor: color,
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Text(
                    innerText,
                    textAlign: TextAlign.center,
                  ),
                ),
              )),
          Text(label)
        ],
      ),
    );
  }

  Widget addQuantityRow(FoodItem foodItem) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 70,
      child: Row(
        children: [
          const Expanded(child: Text("Quantity")),
          Container(
            width: 100,
            child: TextField(
              textAlign: TextAlign.center,
              controller: _quantityController,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: false),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onChanged: (val) {
                setState(() {
                  if (val.isEmpty) val = "0";
                  // TODO: macros and calories recalculation here
                  fats += 2000;
                  quantity = int.parse(val);
                });
              },
            ),
          )
        ],
      ),
    );
  }

  Widget addWeightRow(FoodItem foodItem) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 80,
      child: Row(
        children: [
          const Expanded(child: Text("Weight")),
          Container(
            width: 100,
            margin: const EdgeInsets.only(right: 5),
            child: TextField(
              textAlign: TextAlign.center,
              controller: _weightController,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: false),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onChanged: (val) {
                setState(() {
                  if (val.isEmpty) val = "0";
                  // TODO: macros and calories recalculation here
                  // TODO: handle choice g / kg
                  weight = int.parse(val);
                  proteins += 1000; // TODO: remove this
                });

                // calories change
              },
            ),
          ),
          Container(
              width: 70,
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                alignment: Alignment.center,
                value: chosenWeightUnit,
                onChanged: (newValue) {
                  setState(() {
                    chosenWeightUnit = newValue!;
                  });
                },
                items: ['g', 'kg']
                    .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        ))
                    .toList(),
              ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${foodItem.name}'),
        actions: [
          if (!widget.isCameraPageCaller)
            IconButton(
                icon: const Icon(Icons.delete),
                tooltip: 'Delete item',
                onPressed: () {
                  history.removeFoodItem(foodItem.id!);
                  Navigator.of(context).pop();
                })
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 250,
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 15),
              child: Image.network(
                foodItem.image!,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              width: double.infinity,
              child: Row(
                children: [
                  buildRing("$calories\n kcal", "Calories", Colors.purple),
                  buildRing("${carbs}g", "Carbs", Colors.red),
                  buildRing("${proteins}g", "Protein", Colors.orange),
                  buildRing("${fats}g", "Fats", Colors.green),
                ],
              ),
            ),
            const Divider(
              thickness: 1,
              height: 25,
            ),
            addQuantityRow(foodItem),
            const Divider(
              thickness: 1,
              height: 25,
            ),
            addWeightRow(foodItem),
            Container(
              // alignment: Alignment.center,
              height: 70,
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              //margin: const EdgeInsets.only(top: 50),
              child: ElevatedButton(
                onPressed: () {
                  history.modifyOrAddFoodItem(FoodItem(
                      id: foodItem.id,
                      name: foodItem.name,
                      image: foodItem.image,
                      proteins: proteins,
                      carbs: carbs,
                      fats: fats,
                      weight: weight,
                      calories: calories,
                      quantity: quantity,
                      weightUnit: chosenWeightUnit == 'g'
                          ? WeightUnit.grams
                          : WeightUnit.kilograms));
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(widget.isCameraPageCaller?"Add Item":"Save Changes"),
              ),
            )
          ],
        ),
      ),
    );
  }
}

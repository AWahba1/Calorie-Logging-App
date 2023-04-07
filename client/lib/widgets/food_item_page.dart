import 'package:flutter/material.dart';
import '../models/food_item.dart';
import 'package:pie_chart/pie_chart.dart';

class FoodItemPage extends StatefulWidget {
  //const FoodItemPage({Key? key}) : super(key: key);

  static const route = '/food-item';

  @override
  State<FoodItemPage> createState() => _FoodItemPageState();
}

class _FoodItemPageState extends State<FoodItemPage> {
  FoodItem foodItem = FoodItem(
      name: "Banana",
      image:
          'https://www.allrecipes.com/thmb/hFs2oTo2hWflhFy7ORU3Sv3EHNo=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/Bananas-by-Mike-DieterMeredith-03866d9ab12a40d38eb452b344e6a9ea.jpg',
      weight: 210,
      fats: 50,
      carbs: 70,
      proteins: 90,
      calories: 500);
  TextEditingController _quantityController = TextEditingController(text: '1');
  TextEditingController _weightController = TextEditingController(text: '591');

  String chosenWeightUnit = 'g'; // g or kg

  @override
  void initState() {
    // TODO: implement initState
    //ModalRoute.of(context)?.settings.arguments as Map<String, String>;
  }

  Widget buildRing(String innerText, String label, Color color) {
    return Expanded(
      child: Column(
        children: [
          Container(
              margin: EdgeInsets.only(bottom: 5),
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

  Widget addQuantityRow() {
    return Container(
      padding: EdgeInsets.all(10),
      height: 70,
      child: Row(
        children: [
          Expanded(child: Text("Quantity")),
          Container(
            width: 100,
            child: TextField(
              textAlign: TextAlign.center,
              controller: _quantityController,
              keyboardType: TextInputType.numberWithOptions(decimal: false),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onChanged: (val) {
                // macros and calories recalculation here
              },
            ),
          )
        ],
      ),
    );
  }

  Widget addWeightRow() {
    return Container(
      padding: EdgeInsets.all(10),
      height: 80,
      child: Row(
        children: [
          Expanded(child: Text("Weight")),
          Container(
            width: 100,
            child: TextField(
              textAlign: TextAlign.center,
              controller: _weightController,
              keyboardType: TextInputType.numberWithOptions(decimal: false),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onChanged: (val) {
                // macros and calories recalculation here
              },
            ),
          ),
          Container(
              width: 70,
              //height:100,
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                alignment: Alignment.topLeft,
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
          IconButton(
              icon: const Icon(Icons.delete),
              tooltip: 'Delete item',
              onPressed: () {})
        ],
      ),
      body: Column(
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
                buildRing(
                    "${foodItem.calories}\n kcal", "Calories", Colors.purple),
                buildRing("${foodItem.carbs}g", "Carbohydrates", Colors.red),
                buildRing("${foodItem.proteins}g", "Protein", Colors.orange),
                buildRing("${foodItem.fats}g", "Fats", Colors.green),
              ],
            ),
          ),
          const Divider(
            thickness: 1,
          ),
          addQuantityRow(),
          const Divider(
            thickness: 1,
          ),
          addWeightRow(),
          Container(
            // alignment: Alignment.center,
            width:double.infinity,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(top:50),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text("Save Changes"),
            ),
          )
        ],
      ),
    );
  }
}

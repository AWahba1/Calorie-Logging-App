import 'package:flutter/material.dart';
import '../models/food_item.dart';
import 'dart:math';
import './journal_chart.dart';
import './journal_list.dart';
import './journal_date_picker.dart';

class JournalPage extends StatefulWidget {
  //const JournalPage({Key? key}) : super(key: key);
  static const route = '/journal';

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  Random rand = new Random();
  List<FoodItem> foodItems = [
    FoodItem(
      name: "Banana",
      image:
          'https://www.allrecipes.com/thmb/hFs2oTo2hWflhFy7ORU3Sv3EHNo=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/Bananas-by-Mike-DieterMeredith-03866d9ab12a40d38eb452b344e6a9ea.jpg',
    ),
    FoodItem(
      name: "Apple Pie",
      image:
          'https://tmbidigitalassetsazure.blob.core.windows.net/rms3-prod/attachments/37/1200x1200/Apple-Pie_EXPS_MRRA22_6086_E11_03_1b_v3.jpg',
    ),
    FoodItem(
      name: "Steak",
      image:
          'https://www.seriouseats.com/thmb/WzQz05gt5witRGeOYKTcTqfe1gs=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/butter-basted-pan-seared-steaks-recipe-hero-06-03b1131c58524be2bd6c9851a2fbdbc3.jpg',
    ),
    FoodItem(
      name: "French Fries",
      image:
          'https://images.immediate.co.uk/production/volatile/sites/30/2021/03/French-fries-b9e3e0c.jpg?resize=768,574',
    ),
    FoodItem(
      name: "Cheesecake",
      image:
          'https://www.jocooks.com/wp-content/uploads/2018/11/cheesecake-1-22.jpg',
    ),
    FoodItem(
      name: "Apple",
      image:
          'https://healthjade.com/wp-content/uploads/2017/10/apple-fruit.jpg',
    ),
    FoodItem(
      name: "Chocolate Cake",
      image:
          'https://recipes.timesofindia.com/thumb/53096885.cms?width=1200&height=900',
    ),
    FoodItem(
      name: "Club Sandwich",
      image: 'https://static.toiimg.com/photo/83740315.cms',
    ),
    FoodItem(
      name: "Hot Dog",
      image:
          'https://static.onecms.io/wp-content/uploads/sites/43/2022/09/09/268494_Basic-Air-Fryer-Hot-Dogs_Buckwheat-Queen_SERP_5844319_original-4x3-1.jpg',
    ),
    FoodItem(
        name: "Pizza",
        image:
            'https://cdn.apartmenttherapy.info/image/upload/f_jpg,q_auto:eco,c_fill,g_auto,w_1500,ar_4:3/k%2FPhoto%2FRecipe%20Ramp%20Up%2F2021-07-Chicken-Alfredo-Pizza%2FChicken-Alfredo-Pizza-KitchnKitchn2970-1_01'),
  ];

  DateTime _currentDate = DateTime.now();
   int totalCalories=0;
   double totalFats=0;
   double totalProteins=0;
   double totalCarbs=0;

  void modifyCurrentDate(DateTime newDate) {
    setState(() {
      _currentDate = newDate;
    });
    // fetch data equivalent to the selected date
  }

  void onCalendarPress() async {
    DateTime? chosenDate = await showDatePicker(
      context: context,
      initialDate: _currentDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(_currentDate.year + 3),
    );

    if (chosenDate == null) return;
    modifyCurrentDate(chosenDate);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (var food in foodItems) {
      food.weight = rand.nextInt(200);
      food.calories = rand.nextInt(2000);
      food.carbs = rand.nextInt(100);
      food.fats = rand.nextInt(100);
      food.proteins = rand.nextInt(100);
    }
    // assign total fats, proteins & carbs
    for (var food in foodItems) {
      totalCarbs += food.carbs!;
      totalFats += food.fats!;
      totalProteins += food.proteins!;
      totalCalories += food.calories!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    //print(currentDate);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Journal"),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            child: Container(
              width: mediaQuery.size.width,
              //color:Colors.green,
              child: JournalDatePicker(
                currentDate: _currentDate,
                onNextDay: () => modifyCurrentDate(
                    _currentDate.add(const Duration(days: 1))),
                onPreviousDay: () => modifyCurrentDate(
                    _currentDate.add(const Duration(days: -1))),
                onCalendarPress: onCalendarPress,
              ),
            ),
          ),
          Positioned(
            top: 60,
            left: 0,
            right: 0,
            bottom: 0,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                JournalChart(
                  totalCalories: totalCalories,
                  totalFats: totalFats,
                  totalCarbs: totalCarbs,
                  totalProteins: totalProteins,
                ),
                JournalList(foodItems)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:math';

import 'package:flutter/cupertino.dart';

class FoodItem {
  int? id;
  String? image;
  String? name;
  int? weight = 0; // in grams
  int? calories = 0;
  int? carbs = 0; // grams
  int? fats = 0; // grams
  int? proteins = 0; // grams
  int? quantity = 1;

  FoodItem({
    this.id,
    this.image,
    this.name,
    this.weight,
    this.calories,
    this.carbs,
    this.fats,
    this.proteins,
    this.quantity
  });
}

class HistoryModel with ChangeNotifier {
  DateTime _currentDate;

  //late List<FoodItem> foodItems;
  final List<FoodItem> _foodItems = [
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

  HistoryModel({DateTime? currentDate})
      : _currentDate = currentDate ?? DateTime.now() {
    _assignRandomValues(_foodItems);
    //TODO: remove random values & fetch from backend

    //_foodItems = _fetchFoodItems();
  }

  DateTime get currentDate => _currentDate;

  List<FoodItem> get foodItems => _foodItems;

  int get totalCalories =>
      _foodItems.fold(0, (total, element) => total + element.calories!);

  int get totalCarbs =>
      _foodItems.fold(0, (total, element) => total + element.carbs!);

  int get totalProteins =>
      _foodItems.fold(0, (total, element) => total + element.proteins!);

  int get totalFats =>
      _foodItems.fold(0, (total, element) => total + element.fats!);

  void setDate(DateTime newDate) {
    _currentDate = newDate;
    //TODO: remove random values & fetch from backend
    //_foodItems = _fetchFoodItem();
    _assignRandomValues(_foodItems);
    notifyListeners();
  }

  List<FoodItem> _fetchFoodItems() {
    // TODO: fetch from backend based on current date
    return [];
  }

  FoodItem getFoodItemById(int itemId) {
    return _foodItems.firstWhere((foodItem) => foodItem.id == itemId);
  }

  FoodItem getFoodItemByPosition(int index) {
    return _foodItems[index];
  }

  void addFoodItem() {
    // TODO: add food item backend
    notifyListeners();
  }

  void removeFoodItem(int itemId) {
    // TODO: remove food item backend
    _foodItems.removeWhere((foodItem) => foodItem.id == itemId);
    notifyListeners();

  }

  void modifyFoodItem(FoodItem modifiedItem) {
    int index =
        foodItems.indexWhere((foodItem) => foodItem.id == modifiedItem.id);

    if (index != -1) {
      // TODO: update element in database
      foodItems[index] = modifiedItem;
    }
    notifyListeners();
  }

  void _assignRandomValues(List<FoodItem> foodItems) {
    // TODO: remove random values method

    Random rand = Random();
    int index = 0;
    for (var food in foodItems) {
      food.weight = rand.nextInt(200);
      food.calories = rand.nextInt(2000);
      food.carbs = rand.nextInt(100);
      food.fats = rand.nextInt(100);
      food.proteins = rand.nextInt(100);
      food.id = index++;
      food.quantity=1;
    }
  }
}

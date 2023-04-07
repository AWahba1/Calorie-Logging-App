class FoodItem {
   int? id;
   String? image;
   String? name;
   int? weight=0; // in grams
   int? calories=0;
   int? carbs=0; // grams
   int? fats=0; // grams
   int? proteins=0; // grams

   FoodItem({this.id,this.image, this.name, this.weight, this.calories, this.carbs, this.fats, this.proteins});
}

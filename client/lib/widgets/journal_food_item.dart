
import 'package:flutter/material.dart';
import '../models/food_item.dart';
class JournalFoodItem extends StatelessWidget {
  //const JournalFoodItem({Key? key}) : super(key: key);

  FoodItem foodItem;
  JournalFoodItem(this.foodItem);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Card(
          margin:const EdgeInsets.only( left:5, right:5),
          elevation:2,
          child:ListTile(
            leading:CircleAvatar(
              backgroundImage: NetworkImage(
                  foodItem.image!),
              radius: 30,
            ),
            title: Text(foodItem.name!,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),),
            subtitle: Text('${foodItem.weight!}g'),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${foodItem.calories!}'),
                const Text('kcal')
              ],
            ),
            onTap: (){
              // Navigator.of(context).pushNamed(
              //     CategoryMealsScreen.routeName,
              //     arguments: {
              //     'id': id,
              //     'title': title,
              //     },
              //)
            },
          )
      ),
    );
  }


}

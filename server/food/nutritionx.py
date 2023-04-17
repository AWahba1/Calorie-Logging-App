import requests
from .models import FoodItem

import os
from dotenv import load_dotenv, find_dotenv

load_dotenv(find_dotenv())


class NutritionxAPI:
    def __init__(self):
        self.base_url = 'https://trackapi.nutritionix.com/v2/search/instant'
        self.headers = {
            'Content-Type': 'application/json',
            'x-app-id': os.environ.get('NUTRITIONX_APP_ID'),
            'x-app-key': os.environ.get('NUTRITIONX_API_KEY'),
            'x-remote-user-id': '0',
        }

    def search_food(self, food_name):
        params = {
            "query": food_name,
            "detailed": "true",
            "common": "true",
            "self": "false",
        }
        response = requests.get(
            self.base_url, params=params, headers=self.headers)
        if response.status_code == 200:
            data = response.json()
            self.create_food_item(food_name, data)
            return True
        else:
            print(response.status_code)
            return False

    def create_food_item(self, food_name, data):
        item = data["common"][0]
        item_weight = item["serving_weight_grams"]
        food_nutrients = self.get_nutrients(
            item_weight, item["full_nutrients"])

        food_item = FoodItem(
            name=food_name,
            calories_per_gram=food_nutrients["calories"],
            protein_per_gram=food_nutrients["protein"],
            carbs_per_gram=food_nutrients["carbs"],
            fats_per_gram=food_nutrients["fat"],
        )
        food_item.save()

    def get_nutrients(self, food_item_weight, food_item_nutrients):
        nutrients = {}
        for nutrient in food_item_nutrients:
            if nutrient["attr_id"] == 203:
                nutrients["protein"] = nutrient["value"] / food_item_weight
            elif nutrient["attr_id"] == 204:
                nutrients["fat"] = nutrient["value"] / food_item_weight
            elif nutrient["attr_id"] == 205:
                nutrients["carbs"] = nutrient["value"] / food_item_weight
            elif nutrient["attr_id"] == 208:
                nutrients["calories"] = nutrient["value"] / food_item_weight
        return nutrients

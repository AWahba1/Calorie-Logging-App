import os

from django.core.management.base import BaseCommand
from food.nutritionx import NutritionxAPI

from server.settings import BASE_DIR
import cnn_model


class Command(BaseCommand):
    help = 'Populates the food items table based on the Nutritionix API and labels.txt'
    name = 'populate_food_items'

    def handle(self, *args, **options):
        # Read labels.txt
        labels_file_path = os.path.join(
            BASE_DIR, 'cnn_model', 'classifier', 'food_classes.txt')

        with open(labels_file_path, 'r') as labels_file:
            labels = [label.strip() for label in labels_file.readlines()]

        # Use the Nutritionix API to create a food item for each label our model can predict
        nutritionix_api = NutritionxAPI()
        for food_name in labels:
            try:
                food_item_id = nutritionix_api.add_food_item(food_name)
                if food_item_id is not None:
                    self.stdout.write(self.style.SUCCESS(
                        f'Successfully added "{food_name}" to the food items table'))
                else:
                    self.stdout.write(self.style.ERROR(
                        f'Failed to add "{food_name}" to the food items table'))
            except Exception as e:
                self.stdout.write(self.style.ERROR(
                    f'Failed to add "{food_name}" - Exception {e}'))

        # self.stdout.write(self.style.SUCCESS('Done populating food items table'))

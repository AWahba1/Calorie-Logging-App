from django.apps import AppConfig
from .classifier.food_classifer import FoodPredictor


class CnnModelConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'cnn_model'
    food_predictor = None

    def ready(self):
        print(" \033[96m Loading model... \033[0m")

        CnnModelConfig.food_predictor = FoodPredictor()
        CnnModelConfig.food_predictor.load_model()

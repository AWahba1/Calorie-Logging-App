from django.apps import AppConfig

from cnn_model.segmentation.image_segmenter import ImageSegmenter
from .classifier.food_classifer import FoodPredictor


class CnnModelConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'cnn_model'
    food_predictor = None

    def ready(self):
        print(" \033[96m Loading classifier model... \033[0m")

        CnnModelConfig.food_predictor = FoodPredictor()
        CnnModelConfig.food_predictor.load_model()

        print(" \033[96m Loading segmentation model... \033[0m")

        CnnModelConfig.image_segmenter=ImageSegmenter()
        CnnModelConfig.image_segmenter.load_model()

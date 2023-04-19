
import os
from tensorflow import keras
from keras.models import load_model
from keras.utils import img_to_array
import numpy as np

import requests
from PIL import Image
from io import BytesIO


class FoodPredictor:
    def __init__(self):
        self.model_path = os.path.join(
            os.path.dirname(os.path.abspath(__file__)), 'model.h5')
        self.weights_path = os.path.join(
            os.path.dirname(os.path.abspath(__file__)), 'weights.h5')
        self.model = None
        self.class_list = self.get_classes_list()

    def load_model(self):
        self.model = load_model(self.model_path)
        self.model.load_weights(self.weights_path)

    def get_classes_list(self):
        labels_file_path = os.path.join(
            os.path.dirname(os.path.abspath(__file__)), 'food_classes.txt')
        with open(labels_file_path, 'r') as labels_file:
            labels = [label.strip() for label in labels_file.readlines()]
        return labels

    # Function to load image from URL or local path
    def load_image(self, image, is_url):
        try:
            img = None
            if is_url:
                response = requests.get(image)
                img = Image.open(BytesIO(response.content))
            else:
                img = Image.open(image)
            return img
        except Exception as e:
            raise Exception(f"Problem loading image - {e}")

    def preprocess_image(self, food_image):
        try:
            IMG_SIZE = (224, 224)

            # Resizing the image to be used as input for the model
            food_image = food_image.resize(IMG_SIZE)
            img_array = img_to_array(food_image)

            # Normalizing the image
            img_array = np.expand_dims(img_array, axis=0)
            img_array /= 255.
            return img_array
        except Exception as e:
            raise Exception(f"Problem preprocessing image - {e}")

    def predict(self, image, n_top_items=5, is_url=False):
        img = self.load_image(image, is_url)
        img_array = self.preprocess_image(img)

        predictions = self.model.predict(img_array)

        # top n food items with highest probability are predicted
        # n=5 by default unless otherwise specified in the function call
        top_n_indices = np.argsort(predictions)[
            0, -n_top_items:][::-1]
        top_n_labels = [self.class_list[i] for i in top_n_indices]
        return top_n_labels

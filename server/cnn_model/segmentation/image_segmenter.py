import os
from tensorflow import keras
from keras.models import load_model
from keras.utils import img_to_array
import numpy as np

import requests
from PIL import Image
from io import BytesIO

import cv2


class ImageSegmenter:
    def __init__(self):
        self.model_path = os.path.join(
            os.path.dirname(os.path.abspath(__file__)), 'model.h5')
        self.weights_path = os.path.join(
            os.path.dirname(os.path.abspath(__file__)), 'weights.h5')
        self.model = None

    def load_model(self):
        self.model = load_model(self.model_path)
        self.model.load_weights(self.weights_path)

    def preprocess_image(self, food_image):
        try:
            # IMG_SIZE = (224, 224)

            # Resizing the image to be used as input for the model
            # food_image = food_image.resize(IMG_SIZE)
            img_array = img_to_array(food_image)
            img_array /= 255.

            # Normalizing the image
            img_array = np.expand_dims(img_array, axis=0)

            return img_array
        except Exception as e:
            raise Exception(f"Problem preprocessing image - {e}")

    def predict_mask(self, image):
        # img = self.load_image(image, is_url)
        img_array = self.preprocess_image(image)

        predicted_mask = self.model.predict(img_array)[0]

        threshold = 0.3
        predicted_mask = (predicted_mask >= threshold).astype(np.uint8)
        return predicted_mask

    def generate_bounding_boxes(self, image):

        predicted_mask = self.predict_mask(image)
        # Find contours in the mask
        contours, _ = cv2.findContours(
            predicted_mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

        bounding_boxes = []

        # Iterate over the contours
        for contour in contours:
            x, y, w, h = cv2.boundingRect(contour)
            if w <= 20 and h <= 20:
                continue

            img_width = 224
            img_height = 224
            padding = 10

            x = max(0, x - padding)
            y = max(0, y - padding)
            w = min(img_width, w + 2 * padding)
            h = min(img_height, h + 2 * padding)
            bounding_boxes.append((x, y, w, h))

        return bounding_boxes

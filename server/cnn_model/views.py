

from rest_framework import views, permissions
from cnn_model.prediction_result import PredictionResult
from food.models import FoodItem
from food.serializers import FoodItemSerializer
from .serializers import FoodObjectResultSerializer, ImageSerializer, PredictionResultSerializer

from .apps import CnnModelConfig
from utils.unified_http_response.response import UnifiedHttpResponse
from rest_framework_simplejwt.authentication import JWTAuthentication

from PIL import Image


class FoodPredictionView(views.APIView):
    # prediction_serializer = PredictionResultSerializer
    image_serializer = ImageSerializer

    authentication_classes = [JWTAuthentication]
    permission_classes = [permissions.IsAuthenticated]

    def post(self, request):
        if 'image_url' in request.data:
            return self.predict_food_from_url(request)
        elif 'image' in request.data:
            return self.predict_food_from_image(request)
        else:
            return UnifiedHttpResponse(message="'image_url' or 'image is required'", status=400)

    def get_list_of_predictions(self, food_image, top_classes, bounding_boxes):

        predictions = []
        for food_class in top_classes:
            food_item_details = FoodItem.objects.get(name=food_class)
            # default weight of 100 grams is used for now
            predictions.append(PredictionResult(
                weight=100, food_item_details=food_item_details))
            # print(predictions)

        # Serializing predictions
        prediction_serializer = self.prediction_serializer(
            predictions, many=True)
        return prediction_serializer.data

    def predict_food_from_url(self, request):

        image_serializer = self.image_serializer(data=request.data)
        if not image_serializer.is_valid():
            return UnifiedHttpResponse(message=image_serializer.errors, status=400)

        # Instantiate classifier and predict
        image_url = image_serializer.validated_data['image_url']
        top_classes = CnnModelConfig.food_predictor.predict(
            image_url, is_url=True)

        # For each predicted food name, a food item object is retrieved from the database and a prediction object is created
        predictions_list = self.get_list_of_predictions(top_classes)
        return UnifiedHttpResponse(predictions_list)

    def predict_food_from_image(self, request):
        image_file = request.data['image']
        image = Image.open(image_file)
        img_width = 224
        img_height = 224
        IMG_SIZE = (img_width, img_height)
        image = image.resize(IMG_SIZE)

        bounding_boxes = CnnModelConfig.image_segmenter.generate_bounding_boxes(
            image)

        # if no bounding boxes are found, the entire image is sent to the classifier
        if len(bounding_boxes) == 0:
            bounding_boxes.append((0, 0, img_width, img_height))

        predictions_list = []
        for box in bounding_boxes:
            x, y, w, h = box
            cropped_image = image.crop((x, y, x + w, y + h))
            cropped_image = cropped_image.resize(IMG_SIZE)
            # cropped_image.save("cropped_image_{}.png".format(x))
            top_classes = CnnModelConfig.food_predictor.predict(cropped_image)
            object_predictions = []
            for food_class in top_classes:
                food_item_details = FoodItem.objects.get(name=food_class)

                object_prediction = {
                    'weight': 100,
                    'food_item_details': FoodItemSerializer(food_item_details).data
                }

                object_predictions.append(object_prediction)
            predictions_list.append(object_predictions)
        return UnifiedHttpResponse(predictions_list)

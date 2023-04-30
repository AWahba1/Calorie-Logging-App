

from rest_framework import views
from cnn_model.prediction_result import PredictionResult
# from rest_framework.response import Response
from food.models import FoodItem
from .serializers import ImageSerializer, PredictionResultSerialier
from .classifier.food_classifer import FoodPredictor

from .apps import CnnModelConfig
from utils.unified_http_response.response import UnifiedHttpResponse


class FoodPredictionView(views.APIView):
    prediction_serializer = PredictionResultSerialier
    image_serializer = ImageSerializer

    def post(self, request):
        if 'image_url' in request.data:
            return self.predict_food_from_url(request)
        elif 'image' in request.data:
            return self.predict_food_from_image(request)
        else:
            return UnifiedHttpResponse(message="'image_url' or 'image is required'", status=400)

    def get_list_of_predictions(self, top_classes):
        predictions = []
        for food_class in top_classes:
            food_item_details = FoodItem.objects.get(name=food_class)
            # default weight of 50 grams is used for now
            predictions.append(PredictionResult(
                weight=50, food_item_details=food_item_details))

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
        top_classes = CnnModelConfig.food_predictor.predict(image_file)

        # For each predicted food name, a food item object is retrieved from the database and a prediction object is created
        predictions_list = self.get_list_of_predictions(top_classes)
        return UnifiedHttpResponse(predictions_list)

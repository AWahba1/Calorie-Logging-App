

from rest_framework import views
from rest_framework.response import Response
from food.models import FoodItem
from .serializers import ImageSerializer
from .classifier.food_classifer import FoodPredictor
from food.serializers import FoodItemSerializer
from .apps import CnnModelConfig


class FoodPredictionView(views.APIView):
    prediction_serializer = FoodItemSerializer
    image_serializer = ImageSerializer

    def post(self, request):
        try:
            image_serializer = self.image_serializer(data=request.data)
            if not image_serializer.is_valid():
                return Response(image_serializer.errors, status=400)

            # Instantiate classifier and predict
            image_url = image_serializer.validated_data['image_url']
            top_classes = CnnModelConfig.food_predictor.predict(image_url)

            # # For each predicted food name, a food item object is retrieved from the database and a prediction object is created
            predictions = []
            for food_class in top_classes:
                food_item = FoodItem.objects.get(name=food_class)
                predictions.append(food_item)

            # # Serializing predictions
            prediction_serializer = self.prediction_serializer(
                predictions, many=True)
            return Response(prediction_serializer.data)
        except Exception as e:
            return Response({'error': str(e)}, status=500)

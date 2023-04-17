

from rest_framework import views, response

from food.models import FoodItem
from .serializers import ImageSerializer
from .classifier.food_classifer import FoodPredictor
from food.serializers import FoodItemSerializer


class FoodPredictionView(views.APIView):
    prediction_serializer = FoodItemSerializer
    image_serializer = ImageSerializer

    def post(self, request):
        image_serializer = self.image_serializer(data=request.data)
        if not image_serializer.is_valid():
            return response.Response(image_serializer.errors, status=400)

        # Instantiate classifier and predict
        predictor = FoodPredictor('model.h5', 'weights.h5')
        predictor.load_model()
        image_url = image_serializer.validated_data['image_url']
        top_classes = predictor.predict(image_url)

        # For each predicted food name, a food item object is retrieved from the database and a prediction object is created
        predictions = []
        for food_class in top_classes:
            food_item = FoodItem.objects.get(name=food_class)
            predictions.append(food_item)

        # Serializing predictions
        prediction_serializer = self.prediction_serializer(
            predictions, many=True)
        return response.Response(prediction_serializer.data)

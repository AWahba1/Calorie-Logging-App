from rest_framework import serializers
from food.serializers import FoodItemSerializer

class ImageSerializer(serializers.Serializer):
    image_url = serializers.URLField()



class PredictionResultSerialier(serializers.Serializer):
    weight=serializers.FloatField()
    food_item_details=FoodItemSerializer()

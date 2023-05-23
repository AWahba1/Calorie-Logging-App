from rest_framework import serializers
from food.serializers import FoodItemSerializer


class ImageSerializer(serializers.Serializer):
    image_url = serializers.URLField()


class FoodObjectResultSerializer(serializers.Serializer):
    weight = serializers.FloatField()
    food_item_details = FoodItemSerializer()


class InnerListSerializer(serializers.ListSerializer):
    child = FoodObjectResultSerializer()


class PredictionResultSerializer(serializers.Serializer):
    # inner_objects = InnerListSerializer(child=FoodObjectResultSerializer(), many=True)

    def to_representation(self, instance):
        return [InnerListSerializer(inner).data for inner in instance]

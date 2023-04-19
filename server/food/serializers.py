from rest_framework import serializers
from .models import FoodItem, UserHistory


class FoodItemSerializer(serializers.ModelSerializer):
    class Meta:
        model = FoodItem
        fields = '__all__'


class UserHistorySerializer(serializers.ModelSerializer):
    class Meta:
        model = UserHistory
        fields = '__all__'

    date = serializers.DateField(required=True)
    quantity = serializers.IntegerField(default=1)

    def to_representation(self, instance):
        representation = super().to_representation(instance)
        representation['food_item'] = FoodItemSerializer(instance.food_item).data
        return representation


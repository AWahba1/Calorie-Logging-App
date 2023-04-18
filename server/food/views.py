from django.shortcuts import get_object_or_404

from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status


from .models import FoodItem
from .serializers import FoodItemSerializer


class FoodItemList(APIView):
    def get(self, request):
        food_items = FoodItem.objects.all()
        serializer = FoodItemSerializer(food_items, many=True)
        return Response(serializer.data)

    def post(self, request):
        serializer = FoodItemSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class FoodItemDetail(APIView):
    def get_object(self, id):
        return get_object_or_404(FoodItem, pk=id)

    def get(self, request, id):
        food_item = self.get_object(id)
        serializer = FoodItemSerializer(food_item)
        return Response(serializer.data)

    def put(self, request, id):
        food_item = self.get_object(id)
        serializer = FoodItemSerializer(food_item, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, id):
        food_item = self.get_object(id)
        food_item.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)

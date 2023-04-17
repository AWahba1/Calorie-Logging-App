from django.urls import path
from .views import FoodItemList, FoodItemDetail

urlpatterns = [
    path('', FoodItemList.as_view()),
    path('/<int:id>', FoodItemDetail.as_view()),
]

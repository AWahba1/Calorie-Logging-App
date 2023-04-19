from django.urls import path
from .views.food_items_view import FoodItemList, FoodItemDetail
from .views.history_view import UserHistoryListView


urlpatterns = [
    path('', FoodItemList.as_view()),
    path('<int:id>', FoodItemDetail.as_view()),
    path('history/<int:user_id>', UserHistoryListView.as_view()),
]

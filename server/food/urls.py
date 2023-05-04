from django.urls import path
from .views.food_items_view import FoodItemList, FoodItemDetail
from .views.history_view import UserHistoryListView, UserHistoryDetailView


urlpatterns = [
    path('', FoodItemList.as_view()),
    path('<int:id>', FoodItemDetail.as_view()),
    path('history', UserHistoryListView.as_view()),
    path('history/<int:history_id>', UserHistoryDetailView.as_view()),
]

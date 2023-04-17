
from django.urls import path
from .views import FoodPredictionView

urlpatterns = [
    path('', FoodPredictionView.as_view(), name='food-prediction'),
]

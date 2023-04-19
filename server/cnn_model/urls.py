
from django.urls import path
from .views import FoodPredictionView

urlpatterns = [
    path('url', FoodPredictionView.as_view(), name='food-prediction-url'),
    path('upload', FoodPredictionView.as_view(), name='food-prediction-upload'),
]


from django.db import models

class FoodItem(models.Model):
    name = models.CharField(max_length=255)
    calories_per_gram = models.FloatField()
    protein_per_gram = models.FloatField()
    carbs_per_gram = models.FloatField()
    fats_per_gram = models.FloatField()

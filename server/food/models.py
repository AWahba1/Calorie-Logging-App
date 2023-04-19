from django.db import models
from users.models import CustomUser
import datetime

class FoodItem(models.Model):
    name = models.CharField(max_length=255)
    calories_per_gram = models.FloatField()
    protein_per_gram = models.FloatField()
    carbs_per_gram = models.FloatField()
    fats_per_gram = models.FloatField()

    def __str__(self):
        return self.name


class UserHistory(models.Model):
    user = models.ForeignKey(CustomUser, on_delete=models.CASCADE)
    food_item = models.ForeignKey(FoodItem, on_delete=models.CASCADE)
    date = models.DateField(default=datetime.date.today)
    weight = models.DecimalField(max_digits=7, decimal_places=2)
    quantity = models.PositiveIntegerField()

    def __str__(self):
        return f"{self.user} - {self.food_item} - {self.date}"

from django.db import models
from django.contrib.auth.models import AbstractBaseUser
from .managers import CustomUserManager


class CustomUser(AbstractBaseUser):
    email = models.EmailField(unique=True)
    name= models.CharField(max_length=50)
    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)
    date_created = models.DateTimeField(auto_now_add=True)

    USERNAME_FIELD = 'email'  # email used for logging in

    objects = CustomUserManager()

    def __str__(self):
        return self.email
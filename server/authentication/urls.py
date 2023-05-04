from django.urls import path
from . import views
from rest_framework_simplejwt.views import TokenBlacklistView


urlpatterns = [
    path('login', views.login, name='login'),
    path('logout', TokenBlacklistView.as_view(), name='logout'),
    path('refresh', views.refresh_token, name='refresh_token'),

]
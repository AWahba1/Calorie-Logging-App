from django.urls import path
from .views import UserDetailView, UserListView

urlpatterns = [
    path('', UserListView.as_view(), name='users'),
    path('<int:id>', UserDetailView.as_view(), name='user'),

]

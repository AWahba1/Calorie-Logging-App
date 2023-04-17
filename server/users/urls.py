from django.urls import path
from . import views

urlpatterns = [
    path('login', views.login, name='login'),
    path('signup', views.sign_up, name='signup'),
    path('', views.get_all_users, name='users'),
    path('<int:id>', views.get_user_by_id, name='user'),
    path('<int:id>/delete', views.delete_user, name='delete-user'),
    path('<int:id>/update', views.update_user, name='update-user'),

]

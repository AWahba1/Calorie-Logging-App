
from django.shortcuts import get_object_or_404

from rest_framework.decorators import api_view, permission_classes
from utils.unified_http_response.response import UnifiedHttpResponse
from rest_framework import status

from .models import CustomUser
from .custom_user_serializer import CustomUserSerializer
from rest_framework.permissions import IsAuthenticated
from rest_framework import views


class UserListView(views.APIView):

    def get(self, request):
        users = CustomUser.objects.all()
        serializer = CustomUserSerializer(users, many=True)
        return UnifiedHttpResponse(serializer.data)

    # Sign up
    def post(self, request):
        serializer = CustomUserSerializer(data=request.data)
        if serializer.is_valid():
            try:
                serializer.save()
                return UnifiedHttpResponse(serializer.data, status=status.HTTP_201_CREATED)
            except Exception as e:
                return UnifiedHttpResponse(message=str(e), status=status.HTTP_400_BAD_REQUEST)
        return UnifiedHttpResponse(message=serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class UserDetailView(views.APIView):

    def get_object(self, id):
        return get_object_or_404(CustomUser, pk=id)

    def get(self, request, id):
        user = self.get_object(id)
        serializer = CustomUserSerializer(user)
        return UnifiedHttpResponse(serializer.data)

    def delete(self, request, id):
        user = self.get_object(id)
        user.delete()
        return UnifiedHttpResponse()

    def put(self, request, id):
        user = self.get_object(id)
        serializer = CustomUserSerializer(instance=user, data=request.data)
        if serializer.is_valid():
            try:
                serializer.save()
                return UnifiedHttpResponse(serializer.data)
            except Exception as e:
                return UnifiedHttpResponse(message=str(e), status=status.HTTP_400_BAD_REQUEST)
        return UnifiedHttpResponse(message=serializer.errors, status=status.HTTP_400_BAD_REQUEST)

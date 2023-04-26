
from django.shortcuts import get_object_or_404

from rest_framework.decorators import api_view
# from rest_framework.response import Response
from unified_response.response import UnifiedHttpResponse
from rest_framework import status


from .models import CustomUser
from .serializers import CustomUserSerializer

from django.contrib.auth import authenticate


@api_view(['GET'])
def get_all_users(request):

    users = CustomUser.objects.all()
    serializer = CustomUserSerializer(users, many=True)
    return UnifiedHttpResponse(serializer.data)


@api_view(['GET'])
def get_user_by_id(request, id):

    user = get_object_or_404(CustomUser, pk=id)
    serializer = CustomUserSerializer(user, many=False)
    return UnifiedHttpResponse(serializer.data)


@api_view(['DELETE'])
def delete_user(request, id):

    user = get_object_or_404(CustomUser, pk=id)
    user.delete()
    return UnifiedHttpResponse()


@api_view(['PUT'])
def update_user(request, id):

    user = get_object_or_404(CustomUser, pk=id)
    serializer = CustomUserSerializer(instance=user, data=request.data)
    if serializer.is_valid():
        try:
            serializer.save()
            return UnifiedHttpResponse(serializer.data)
        except Exception as e:
            return UnifiedHttpResponse(message=str(e), status=status.HTTP_400_BAD_REQUEST)
    return UnifiedHttpResponse(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['POST'])
def sign_up(request):

    serializer = CustomUserSerializer(data=request.data)
    if serializer.is_valid():
        try:
            serializer.save()
            return UnifiedHttpResponse(serializer.data, status=status.HTTP_201_CREATED)
        except Exception as e:
            return UnifiedHttpResponse(message=str(e), status=status.HTTP_400_BAD_REQUEST)
    return UnifiedHttpResponse(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['POST'])
def login(request):

    email = request.data['email']
    password = request.data['password']
    user = authenticate(request, email=email, password=password)
    if user is not None:
        serializer = CustomUserSerializer(instance=user)
        return UnifiedHttpResponse(serializer.data)
    else:
        return UnifiedHttpResponse(message="Please check your username and password and try again!", status=status.HTTP_401_UNAUTHORIZED)



from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status


from .models import CustomUser
from .serializers import CustomUserSerializer

from django.contrib.auth import authenticate

@api_view(['GET'])
def get_all_users(request):
    users = CustomUser.objects.all()
    serializer = CustomUserSerializer(users, many=True)
    return Response(serializer.data)

@api_view(['GET'])
def get_user_by_id(request, id):
    try:
        user = CustomUser.objects.get(pk=id)
    except CustomUser.DoesNotExist:
        return Response({'error': 'User not found'}, status=status.HTTP_404_NOT_FOUND)
    
    serializer = CustomUserSerializer(user, many=False)
    return Response(serializer.data)


@api_view(['DELETE'])
def delete_user(request, id):
    try:
        user = CustomUser.objects.get(pk=id)
    except CustomUser.DoesNotExist:
        return Response({'error': 'User not found'}, status=status.HTTP_404_NOT_FOUND)

    user.delete()
    return Response('User deleted')


@api_view(['PUT'])
def update_user(request, id):
    try:
        user = CustomUser.objects.get(pk=id)
    except CustomUser.DoesNotExist:
        return Response({'error': 'User not found'}, status=status.HTTP_404_NOT_FOUND)

    serializer = CustomUserSerializer(instance=user, data=request.data)
    if serializer.is_valid():
        try:
            serializer.save()
            return Response(serializer.data)
        except Exception as e:
            return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)


    return Response(serializer.errors,status=status.HTTP_400_BAD_REQUEST)


@api_view(['POST'])
def sign_up(request):
    serializer = CustomUserSerializer(data=request.data)
    if serializer.is_valid():
        try:
            serializer.save()
            return Response(serializer.data)
        except Exception as e:
            return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)

    return Response(serializer.errors,status=status.HTTP_400_BAD_REQUEST)


@api_view(['POST'])
def login(request):
    email = request.data['email']
    password = request.data['password']
    user = authenticate(request, email=email, password=password)
    if user is not None:
        serializer = CustomUserSerializer(instance=user)
        return Response(serializer.data)
    else:
        return Response('Invalid credentials')



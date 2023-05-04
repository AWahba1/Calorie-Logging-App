
from rest_framework.decorators import api_view
from utils.unified_http_response.response import UnifiedHttpResponse
from rest_framework import status
from django.contrib.auth import authenticate
from rest_framework_simplejwt.tokens import RefreshToken
from .login_response_serializer import LoginResponseSerializer


@api_view(['POST'])
def login(request):

    email = request.data['email']
    password = request.data['password']
    user = authenticate(request, email=email, password=password)
    if user is not None:
        refresh = RefreshToken.for_user(user)
        access_token = refresh.access_token
        serializer = LoginResponseSerializer({
            'user_id': user.id,
            'user_name': user.name,
            'access_token': str(access_token),
            'refresh_token': str(refresh)
        })
        return UnifiedHttpResponse(serializer.data)
    else:
        return UnifiedHttpResponse(message="Please check your email and password and try again!", status=status.HTTP_401_UNAUTHORIZED)


@api_view(['POST'])
def refresh_token(request):

    refresh_token = request.data["refresh_token"]
    if refresh_token:
        try:
            token = RefreshToken(refresh_token)
            access_token = str(token.access_token)
            return UnifiedHttpResponse(data={'access_token': access_token})
        except:
            pass
    return UnifiedHttpResponse(message="Invalid Refresh Token", status=400)

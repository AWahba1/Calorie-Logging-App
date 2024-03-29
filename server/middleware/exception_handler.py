from django.http import Http404
from rest_framework import status
from utils.unified_http_response.response import UnifiedHttpResponse
from rest_framework_simplejwt.exceptions import InvalidToken, TokenError
from rest_framework.exceptions import NotAuthenticated

from rest_framework.views import exception_handler


def custom_exception_handler(exc, context):

    if isinstance(exc, Http404):
        response = UnifiedHttpResponse(
            status=status.HTTP_404_NOT_FOUND, message='Not found')
    elif isinstance(exc, NotAuthenticated) or isinstance(exc, InvalidToken) or isinstance(exc, TokenError):
        response = UnifiedHttpResponse(
            status=status.HTTP_401_UNAUTHORIZED, message='Authentication failed')
    else:
        response = UnifiedHttpResponse(message="An error has occured" if str(exc) == "" else str(
            exc), status=status.HTTP_500_INTERNAL_SERVER_ERROR)
    return response

from django.http import Http404
from rest_framework import status
from unified_http_response.response import UnifiedHttpResponse


from rest_framework.views import exception_handler


def custom_exception_handler(exc, context):

    if isinstance(exc, Http404):
        response = UnifiedHttpResponse(
            status=status.HTTP_404_NOT_FOUND, message='Not found')
    else:
        response = UnifiedHttpResponse(message=str(
            exc), status=status.HTTP_500_INTERNAL_SERVER_ERROR)
    return response

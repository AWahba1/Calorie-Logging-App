from django.http import Http404
# from rest_framework.response import Response
from rest_framework import status
from unified_response.response import UnifiedHttpResponse


# class CustomExceptionHandlerMiddleware:
#     """
#     Custom exception handler middleware that uses UnifiedResponse for Http404 exceptions.
#     """

#     def __init__(self, get_response):
#         self.get_response = get_response

#     def process_exception(self, request, exception):
#         if isinstance(exception, Http404):
#             response = UnifiedResponse(
#                 status_code=status.HTTP_404_NOT_FOUND, message='Not found')
#         else:
#             response = UnifiedResponse(message=str(
#                 exception), status=status.HTTP_500_INTERNAL_SERVER_ERROR)
#         return response


from rest_framework.views import exception_handler


def custom_exception_handler(exc, context):
    # Call REST framework's default exception handler first,
    # to get the standard error response.
    #response = exception_handler(exc, context)

    # # Now add the HTTP status code to the response.
    # if response is not None:
    #     response.data['status_code'] = response.status_code

    if isinstance(exc, Http404):
        response = UnifiedHttpResponse(
        status=status.HTTP_404_NOT_FOUND, message='Not found')
    else:
        response = UnifiedHttpResponse(message=str(
            exc), status=status.HTTP_500_INTERNAL_SERVER_ERROR)
    return response



# if isinstance(exception, Http404):
#             response = UnifiedResponse(
#                 status_code=status.HTTP_404_NOT_FOUND, message='Not found')
#         else:
#             response = UnifiedResponse(message=str(
#                 exception), status=status.HTTP_500_INTERNAL_SERVER_ERROR)
#         return response

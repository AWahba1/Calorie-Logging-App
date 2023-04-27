from rest_framework.response import Response
from rest_framework import status
import json


class UnifiedHttpResponse(Response):
    """
    A unified HTTP response that provides a consistent response structure.
    """

    def __init__(self, data=None, status=status.HTTP_200_OK, message='Success', **kwargs):
        response_data = {'data': data, 'message': message}
        super().__init__(data=response_data, status=status, **kwargs)

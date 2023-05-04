from django.db.utils import IntegrityError
from django.shortcuts import get_object_or_404

from rest_framework.views import APIView
from rest_framework import status, permissions


from ..models import UserHistory
from ..serializers import UserHistorySerializer
from utils.unified_http_response.response import UnifiedHttpResponse
from rest_framework_simplejwt.authentication import JWTAuthentication


class UserHistoryListView(APIView):

    authentication_classes = [JWTAuthentication]
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request):
        date = request.query_params.get('date')
        if not date:
            return UnifiedHttpResponse(message='Date is required', status=400)

        user_id = request.user.id
        history = UserHistory.objects.filter(
            user=user_id, date=date)
        serializer = UserHistorySerializer(history, many=True)
        return UnifiedHttpResponse(serializer.data)

    def post(self, request):
        try:
            data = request.data
            user_id = request.user.id

            data['user'] = user_id
            serializer = UserHistorySerializer(data=data)

            if serializer.is_valid():
                serializer.save()
                return UnifiedHttpResponse(serializer.data, status=201)
            else:
                return UnifiedHttpResponse(serializer.errors, status=400)

        except IntegrityError as e:
            return UnifiedHttpResponse(message=f"Error while logging food item - {e}", status=400)


class UserHistoryDetailView(APIView):

    authentication_classes = [JWTAuthentication]
    permission_classes = [permissions.IsAuthenticated]

    def get_object(self, id):
        return get_object_or_404(UserHistory, pk=id)

    def get(self, request, history_id):
        history = self.get_object(history_id)
        serializer = UserHistorySerializer(history)
        return UnifiedHttpResponse(serializer.data)

    def patch(self, request, history_id):
        history = self.get_object(history_id)
        serializer = UserHistorySerializer(
            history, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return UnifiedHttpResponse(serializer.data)
        return UnifiedHttpResponse(message=serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, history_id):
        history = self.get_object(history_id)
        history.delete()
        return UnifiedHttpResponse()

from django.db.utils import IntegrityError
from django.shortcuts import get_object_or_404

from rest_framework.views import APIView
from rest_framework import status


from ..models import UserHistory
from ..serializers import UserHistorySerializer
from utils.unified_http_response.response import UnifiedHttpResponse


class UserHistoryListView(APIView):

    def get(self, request, user_id):
        date = request.query_params.get('date')
        if not date:  # Date is required
            return UnifiedHttpResponse(message='Date is required', status=400)

        history = UserHistory.objects.filter(
            user=user_id, date=date).order_by("-id")
        serializer = UserHistorySerializer(history, many=True)
        return UnifiedHttpResponse(serializer.data)

    def post(self, request, user_id):
        try:
            data = request.data

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
        return UnifiedHttpResponse(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, history_id):
        history = self.get_object(history_id)
        history.delete()
        return UnifiedHttpResponse()

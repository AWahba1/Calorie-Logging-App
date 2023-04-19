from django.db.utils import IntegrityError 
from django.shortcuts import get_object_or_404

from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status


from ..models import UserHistory
from ..serializers import UserHistorySerializer


class UserHistoryListView(APIView):

    def get(self, request, user_id):
        date = request.query_params.get('date')
        if not date:  # Date is required
            return Response({'error': 'Date is required'}, status=400)

        history = UserHistory.objects.filter(user=user_id, date=date)
        serializer = UserHistorySerializer(history, many=True)
        return Response(serializer.data)

    def post(self, request, user_id):
        try:
            data = request.data

            data['user'] = user_id
            serializer = UserHistorySerializer(data=data)

            if serializer.is_valid():
                serializer.save()
                return Response(serializer.data, status=201)
            else:
                return Response(serializer.errors, status=400)

        except IntegrityError as e:
            return Response({'error': f"Error while logging food item - {e}"}, status=400)


class UserHistoryDetailView(APIView):
    
        def get_object(self, id):
            return get_object_or_404(UserHistory, pk=id)
    
        def get(self, request, history_id):
            history = self.get_object(history_id)
            serializer = UserHistorySerializer(history)
            return Response(serializer.data)
    
        def patch(self, request, history_id):
            history = self.get_object(history_id)
            serializer = UserHistorySerializer(history, data=request.data, partial=True)
            if serializer.is_valid():
                serializer.save()
                return Response(serializer.data)
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
        def delete(self, request, history_id):
            history = self.get_object(history_id)
            history.delete()
            return Response(status=status.HTTP_204_NO_CONTENT)

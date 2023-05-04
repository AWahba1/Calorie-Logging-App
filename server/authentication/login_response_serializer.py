from rest_framework import serializers


class LoginResponseSerializer(serializers.Serializer):
    user_id = serializers.IntegerField()
    user_name = serializers.CharField()
    access_token = serializers.CharField()
    refresh_token = serializers.CharField()

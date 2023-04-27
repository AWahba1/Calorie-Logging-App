from rest_framework import serializers
from .models import CustomUser
from rest_framework.validators import UniqueValidator


class CustomUserSerializer(serializers.ModelSerializer):

    email = serializers.EmailField(validators=[UniqueValidator(
        queryset=CustomUser.objects.all(), message="This email address is already registered. \nPlease choose another one.")])

    class Meta:
        model = CustomUser
        fields = ('id', 'email', 'name', 'password')
        # fields = '__all__'
        # hiding password when returning data & only show when creating/updating
        extra_kwargs = {'password': {'write_only': True}}

    def create(self, validated_data):
        user = CustomUser.objects.create_user(**validated_data)
        return user

from rest_framework import serializers
from .models import CustomUser

class CustomUserSerializer(serializers.ModelSerializer):
    class Meta:
        model = CustomUser
        fields=('id','email','name','password')
        #fields = '__all__'
        extra_kwargs = {'password': {'write_only': True}} # hiding password when returning data & only show when creating/updating


    def create(self, validated_data):
        print(validated_data)
        user = CustomUser.objects.create_user(**validated_data)
        return user
from rest_framework import serializers


class ImageSerializer(serializers.Serializer):
    image_url = serializers.URLField()

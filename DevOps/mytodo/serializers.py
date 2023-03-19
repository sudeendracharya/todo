from rest_framework import fields, serializers

from mytodo.models import ToDo

class Todo_Serializer(serializers.ModelSerializer):

    def create(self, validated_data):
        """
        Create and return a new `ToDo` instance, given the validated data.
        """
        return ToDo.objects.create(**validated_data)


    class Meta:
        model = ToDo
        fields = '__all__'

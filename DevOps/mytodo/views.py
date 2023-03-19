from django.db.models.aggregates import Count, Sum
from django.http import JsonResponse
from rest_framework.response import Response
from django.shortcuts import get_object_or_404, render
from rest_framework import viewsets, status, permissions, generics, filters

from mytodo.models import ToDo
from mytodo.serializers import Todo_Serializer

# Create your views here.
class ToDoViewSet(viewsets.ViewSet):
    """
    A simple ViewSet for listing or retrieving ToDo.
    """

    def list(self, request):
        try:
            snippet = ToDo.objects.all()
            serializer = Todo_Serializer(snippet, many=True)
            return Response(serializer.data, status=status.HTTP_200_OK)
        except ToDo.DoesNotExist:
            return Response([], status=status.HTTP_400_BAD_REQUEST)

    def create(self, request):
        serializer = Todo_Serializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        

    def retrieve(self, request, pk=None):
        try:
            queryset = ToDo.objects.get(pk=pk)
            serializer_class = Todo_Serializer(queryset)
            return JsonResponse(serializer_class.data, safe=False)
        except ToDo.DoesNotExist:
            return Response({"Message": "Coundn't retrive data"}, status=status.HTTP_400_BAD_REQUEST)


    def partial_update(self, request, pk=None):
        try:
            queryset = ToDo.objects.get(pk=pk)
            serializer = Todo_Serializer(
                instance=queryset, data=request.data, partial=True)
            if serializer.is_valid(raise_exception=True):
                serializer.save()
                return Response(serializer.data, status=status.HTTP_202_ACCEPTED)
            return Response(serializer.errors, status=status.HTTP_304_NOT_MODIFIED)
        except:
            return Response({"Message": ["Coudn't update at this moment"]}, status=status.HTTP_400_BAD_REQUEST)

    def destroy(self, request, pk=None):
        try:
            queryset = ToDo.objects.get(pk=pk)
            queryset.delete()
            return Response(status=status.HTTP_204_NO_CONTENT)
        except ToDo.DoesNotExist:
            return Response({"Message": ["Can't Delete at this moment"]}, status=status.HTTP_400_BAD_REQUEST)
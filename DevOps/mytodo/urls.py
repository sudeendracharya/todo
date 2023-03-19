from rest_framework.routers import DefaultRouter
from django.urls import path, include
from . import views

router = DefaultRouter()
router.register(r'todo', views.ToDoViewSet, basename='todo')

urlpatterns = [
    path('mytodo-list/', views.ToDoViewSet.as_view({
        'get': 'list',
        'post': 'create'
    })),
    path('mytodo-details/<int:pk>/', views.ToDoViewSet.as_view({
        'get': 'retrieve',
        'patch' : 'partial_update',
        'delete': 'destroy'
    })),
]
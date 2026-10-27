from django.urls import path
from student import views

app_name = "student"
urlpatterns = [
    path("", views.list, name="list"),
    path("get/<int:id>/", views.get, name="get"),
    path("delete/<int:id>/", views.delete, name="delete"),
]
from django.shortcuts import render, redirect, get_object_or_404
from . models import Student
from django.contrib import messages
from django.http import HttpResponse

# Create your views here.
def list(request):
    students = Student.objects.all().order_by("grade", "name")
    return render(request, "student/list.html", {"students": students})

def get(request, id):
    return render(request, "student/get.html")

def delete(request, id):
    return redirect("student:list")
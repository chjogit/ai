from django.shortcuts import render, redirect, get_object_or_404
from . models import Student
from django.contrib import messages
from django.http import HttpResponse

# Create your views here.
def list(request):
    students = Student.objects.all().order_by("grade", "name")
    return render(request, "student/list.html", {"students": students})

def get(request, id:int):
    # student = Student.objects.get(id=id)
    # student = get_object_or_404(Student, id=id) # Debug = False 시 작동
    # return render(request, "student/get.html", {"student": student})
    try:
        student = Student.objects.get(id=id)
        return render(request, "student/get.html", {"student": student})
    except:
        messages.error(request, f"학생 정보를 찾을 수 없습니다")
        return redirect("/student")

def delete(request, id):
    student = Student.objects.filter(id=id)
    if student:
        student.delete()
        messages.success(request, f"{id} 삭제 완료")
        return redirect("student:list")
    else:
        messages.error(request, f"학생 정보를 찾을 수 없습니다.")
        return redirect("student:list")
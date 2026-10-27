from django.shortcuts import render
from django.http import HttpResponse

def index(request):
    context = {
        'msg':'wordCount welcome page',
        'greeting':"Hello, Django(장고)",
    }
    return render(
        request,
        'home/index.html',
        context=context
    )

def test(request):
    return HttpResponse(
        '<h1>Test Page</h1>'+
        '<button onclick="location.href=\'/\'">back</button>'
    )

def showIntid(request, id):
    msg = 'int ID = ' + str(id)
    type = 'int'
    return render(
        request,
        template_name='home/showid.html',
        context={'msg':msg, 'type':type}
    )

def showStrid(request, id):
    msg = 'str ID = ' + str(id)
    type = 'str'
    return render(
        request,
        template_name="home/showid.html",
        context={'msg':msg, 'type':type}
    )
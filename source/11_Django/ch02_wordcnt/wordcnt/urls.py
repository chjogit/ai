# wordcnt pkg 안의 urls 모듈 (*.py)

from django.urls import path
from . import views # . : 현재 파일이 위치한 폴더

app_name = "wordcnt"
urlpatterns = [
    path('', views.wordinput, name='wordinput'),
    path('about/', views.about, name='about'),
    path('result/', views.result, name='result'),
]
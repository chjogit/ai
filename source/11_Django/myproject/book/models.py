from django.db import models
from django import forms
from django.core.validators import MinLengthValidator, MinValueValidator, MaxValueValidator
from django.urls import reverse
# Create your models here.

def min_length_2_validator(value):
    if len(value)<2:
        raise forms.ValidationError('2글자 이상 입력하세요')

class Book(models.Model): # 테이블명 : book_book
    title = models.CharField(verbose_name="책제목", max_length=50)
    author = models.CharField(
        verbose_name="책쓴이", 
        max_length=50, 
        validators=[
            min_length_2_validator,
            # MinLengthValidator(2)
            ]
        )
    publisher = models.CharField(
        verbose_name="출판사", 
        max_length=50, 
        null=True, blank=True # input charfield black 시 null 입력
        )
    sales = models.IntegerField(
        verbose_name="판매가",
        default=1000,
        validators=[
            MinValueValidator(0),
            MaxValueValidator(100000)
            ]
        )
    ip = models.GenericIPAddressField(blank=True, null=True) # create를 실행한 client의 주소
    publication_date = models.DateTimeField(auto_now_add=True) # create 시 자동 저장

    def __str__(self):
        return "{}:{}著 {:,}원 from{}".format(self.title,
                                              self.author,
                                              self.sales,
                                              self.ip)
    
    def get_absolute_url(self):
        return reverse("book:list")

    class Meta: # 내부 클래스
        ordering = ['-publication_date'] # book list 출력 시 order by 설정
        unique_together = [('title','author')] # title과 author가 모두 같은 값일 경우 저장 불가
from django.db import models

# 클래스 : 테이블 / 객체(인스턴스) : 테이블의 row(record)
class Student(models.Model): # 테이블 이름 : 앱이름_클래스이름소문자(student_student)
  id = models.AutoField(primary_key=True) # 테이블 안의 컬럼
  name = models.CharField(max_length=100, unique=True)
  major = models.CharField(max_length=100, null=True, blank=True)
  age   = models.IntegerField(default=1)
  grade = models.IntegerField(default=1)
  def __str__(self):
    return f"ID:{self.id} - name : {self.name} (major : {self.major}, grade : {self.grade} age : {self.age})"
if __name__=='__main__':
  st = Student(name='hong', major='AI', age=20)
  print(st)

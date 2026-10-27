from django.db import models

# class ≃ table / instance ≃ row(record)
class Student(models.Model):
    id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=100, unique=True)
    major = models.CharField(max_length=100, null=True, blank=True)
    age = models.IntegerField(default=1)
    grade = models.IntegerField(default=1)
    def __str__(self):
        return f" id : {self.id}, name : {self.name}, major : {self.major}, age : {self.age}, grade : {self.grade}"

if __name__ == "__main__":
    st = Student(name="hong", major="AI", age=18, grade=2)
    print(st)
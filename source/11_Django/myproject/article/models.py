import os.path
from django.db import models
from django.urls import reverse
from myproject import settings
from django.shortcuts import get_object_or_404
STATUS_CHOICES = (
  ('d', 'Draft'),
  ('p', 'Published'),
  ('w', 'Withdrawn'),
)
class Article(models.Model): # 테이블명 : article_article
  # id = models.AutoField(primary_key=True)
  title = models.CharField(verbose_name="제목", max_length=100) # input
  body = models.TextField(verbose_name="본문") # textarea
  status = models.CharField(max_length=1, choices=STATUS_CHOICES) # select
  # photo(이미지 파일 첨부) : pip install pillow -> pip freeze > requirements.txt
  photo = models.ImageField(verbose_name="사진",
                          blank=True, # _media/파일 자동 저장
                          upload_to="article/%Y/%m/%d") # _media/article/2026/11/10/파일
  def __str__(self):
    return f"{self.id}. {self.title}"

  def get_absolute_url(self):
    # return reverse("article:list") # create, update후 url
    return reverse("article:detail", args=[self.id]) # create, update후 url 해당기사 상세보기
                                                # /article/1/detail
  def save(self, *args, **kwargs):
    # 수정시 save()에서 photo 수정시 기존 photo 파일은 delete
    if self.pk: # 수정 여부
      db_instance = get_object_or_404(Article, pk=self.pk)
      if db_instance.photo and db_instance.photo != self.photo:
        # db_instance.photo 저장 파일을 삭제
        file_path = os.path.join(settings.MEDIA_ROOT, str(db_instance.photo))
        if os.path.exists(file_path): # 파일 존재 여부
          os.remove(file_path) # 파일 삭제
    super().save(*args, **kwargs) # 데이터베이스에 save

  def delete(self, *args, **kwargs):
    if self.photo: # 지울 artible의 photo 첨부 여부
      file_path = os.path.join(settings.MEDIA_ROOT, str(self.photo))
      if os.path.exists(file_path):
        os.remove(file_path)
    super().delete(*args, **kwargs) # 데이터베이스에 delete
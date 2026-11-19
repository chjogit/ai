from django.urls import path
'''
/article/ => article_list
/article/new => article추가(article_new)
/article/1/detail => 1번 article 상세보기(article_detail)
/article/1/edit => 1번 article 수정(article_edit)
/article/1/delete => 1번 article 삭제(article_delete)
'''
from .views import (ArticleListView, 
                    ArticleCreateView,
                    ArticleDetailView,
                    ArticleUpdateView,
                    ArticleDeleteView)
app_name = "article"
urlpatterns = [
    path("", ArticleListView.as_view(), name="list"),
    path("new/", ArticleCreateView.as_view(), name="new"),
    path("<int:pk>/detail/", ArticleDetailView.as_view(), name='detail'),
    path("<int:pk>/edit/", ArticleUpdateView.as_view(), name='edit'),
    path("<int:pk>/delete/", ArticleDeleteView.as_view(), name='delete'),
]

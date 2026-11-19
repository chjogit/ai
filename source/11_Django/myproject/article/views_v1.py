from django.shortcuts import render
from django.views.generic import ListView, CreateView
from django.views.generic import DetailView, UpdateView,DeleteView
from article.models import Article
from django.urls import reverse_lazy
from django.core.paginator import Paginator
# /article/?q=구글 => page=1      /article/?page=2&q=구글
# def article_list(request):
# 	article_list = Article.objects.all().order_by('-id')
# 	# 검색 기능 추가
# 	q = request.GET.get('q')
# 	if q:
# 		article_list = article_list.filter(title__icontains=q)
# 	# 페이징 기능
# 	paginator = Paginator(article_list, per_page=3)
# 	page_number = request.GET.get("page", "1")
# 	page_object = paginator.get_page(page_number)
# 	return render(request,
# 								"article/article_list.html",
# 								{"article_list":page_object,
# 								"page_obj":page_object,
# 								"q":q})
# article_list = ListView.as_view(model=Article, ordering=['-id'], paginate_by=3)
from django.db.models import Q # 여러 조건
class ArticleListView(ListView):
  model = Article
  ordering=['-id']
  paginate_by = 3
  def get_queryset(self):
    article_list = super().get_queryset() # Article.objects.all().order_by('-id)
    q = self.request.GET.get('q')
    if q:
      article_list = article_list.filter(Q(title__icontains=q) | Q(body__icontains=q))
    return article_list
  def get_context_data(self, **kwargs):
    context = super().get_context_data(**kwargs)
    context['q'] = self.request.GET.get('q')
    return context
  
article_list = ArticleListView.as_view()
article_new = CreateView.as_view(model=Article, fields="__all__")
article_detail = DetailView.as_view(model=Article)
article_edit   = UpdateView.as_view(model=Article, fields="__all__")
article_delete = DeleteView.as_view(model=Article,
                                    success_url="/article")
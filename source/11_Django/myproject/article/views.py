from django.shortcuts import render
from django.views.generic import ListView, CreateView
from django.views.generic import DetailView, UpdateView,DeleteView
from article.models import Article
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
class ArticleCreateView(CreateView):
  model = Article
  fields = "__all__"
  #template_name=""
class ArticleDetailView(DetailView):
  model = Article
class ArticleUpdateView(UpdateView):
  model = Article
  fields = "__all__"
class ArticleDeleteView(DeleteView):
  model=Article
  success_url="/article"
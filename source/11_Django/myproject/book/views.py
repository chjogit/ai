from django.shortcuts import render, redirect, reverse,  get_object_or_404
from django.views.generic import CreateView, ListView, UpdateView, DeleteView
from django.urls import reverse_lazy
from .forms import BookForm, BookModelForm
from .models import Book

# 1. form 없이  2. form 객체 생성 후(6장) 3. DjangoGenericView 이용 4. GenericView 상속(7장)

# def book_list(request):
#     return render(request, "book/book_list.html", {"book_list":Book.objects.all(), "object_list":Book.objects.all()})

book_list = ListView.as_view(model=Book)

def book_new1(request):
    # post : 파라미터 변수 입력 받아 유효성 확인
        # 1) pass : db insert -> book:list
        # 2) fail : error msg + 입력 페이지로 이동
    # get : template page(book/book_form.html)로 이동
    if request.method == 'POST':
        form = BookModelForm(request.POST)
        if form.is_valid():
            book = form.save(commit=False)
            book.ip = request.META.get('REMOTE_ADDR', 'localhost')
            book.save()
            return redirect(book)
    elif request.method == 'GET':
        form = BookModelForm()
    return render(request, "book/book_form.html", {"form":form})

book_new2 = CreateView.as_view(
    model = Book,
    fields = ['title', 'author', 'publisher', 'sales']
    ) # ip 저장 불가

class BookCreateView(CreateView): # 제너릭 뷰 상속 활용
    model = Book
    fields = ['title', 'author', 'publisher', 'sales']
    def form_valid(self, form):
        book = form.save(commit=False)
        book.ip = self.request.META.get('REMOTE_ADDR', 'localhost')
        book.save()
        return redirect(book) # ip 저장 가능

book_new = BookCreateView.as_view() # 상속한 자손 클래스 호출

def book_edit1(request, pk):
    # post : 파라미터 변수 입력 받아 유효성 확인
        # 1) pass : db insert -> book:list
        # 2) fail : error msg + 입력 페이지로 이동
    # get : template page(book/book_form.html)로 이동
    book = get_object_or_404(Book, id=pk)
    if request.method == 'POST':
        form = BookModelForm(
            request.POST, 
            instance=book # 없을 시 update가 아닌 create 실행됨
            )
        if form.is_valid():
            book = form.save(commit=False)
            book.ip = request.META.get('REMOTE_ADDR', 'localhost')
            book.save()
            return redirect(book)
    elif request.method == 'GET':
        form = BookModelForm(instance=book)
    return render(request, "book/book_form.html", {'form':form})

book_edit = UpdateView.as_view(
    model = Book,
    fields = ['title', 'author', 'publisher', 'sales']
    ) # ip 수정 불가

def book_delete1(request, pk):
    book = get_object_or_404(Book, pk=pk)
    # 바로 삭제하기
    # book.delete()
    # return redirect(book) # book.get_absolute_url() 호출
    # 삭제 시 사용자 확인받기
    if request.method == 'POST':
        book.delete()
        return redirect(book)
    elif request.method == 'GET':
        return render(request, "book/book_confirm_delete.html", {"object":book})

book_delete = DeleteView.as_view(
    model = Book,
    success_url = "/book/" # delete 후 표시할 url
    )
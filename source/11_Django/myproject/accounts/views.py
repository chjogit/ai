from django.shortcuts import render, redirect
from django.contrib.auth.forms import UserCreationForm
from django.conf import global_settings as settings
from django.contrib.auth.views import LoginView, LogoutView
from .forms import SignupForm
from .models import Profile
from django.contrib.auth.decorators import login_required
from django.contrib.auth import authenticate
from django.contrib.auth.forms import AuthenticationForm
# Create your views here.
def signup(request):
  if request.method == 'POST':
    form = SignupForm(request.POST)
    # print('유효 여부 :',form.is_valid())
    if form.is_valid():
      profile = form.save() # DB저장
      # 회원가입 후 로그인 페이지로 이동 (가입한 username 표시)
      request.session["username"] = profile.user.username
      # return redirect("/accounts/login") : 하드코딩
      return redirect(settings.LOGIN_URL)
  elif request.method == 'GET':
    #form = UserCreationForm() # auth앱
    form = SignupForm()
  return render(request,
                "accounts/signup_form.html",
                {"form":form})
login = LoginView.as_view(template_name="accounts/login_form.html")

class ArticleLoginView(LoginView):
  template_name="accounts/login_form.html"
  def get_initial(self):
    initial = super().get_initial()
    username = self.request.session.pop("username", None)
    if username:
      initial["username"] = username
    return initial

custom_login = ArticleLoginView.as_view()

logout = LogoutView.as_view(next_page=settings.LOGIN_URL) # "/accounts/login/"

@login_required # 로그인 상태에서만 실행 ; 비로그인 시 로그인 페이지로 이동
def profile(request):
  profile, created = Profile.objects.get_or_create(
    user=request.user, # profile에 등록된 user일 경우, created = False, profile 미등록인 user일 경우 created = True
    )
  return render(
      request, 
      "accounts/profile.html",
      {
        "profile":profile,
        "is_new_profile":created
      },
    )
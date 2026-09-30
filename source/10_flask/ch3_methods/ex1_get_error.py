# 가상 환경 생성 방법 1 : python -m venv .venv
# 가상 환경 생성 방법 2 : ctrl + shift + p => select interpreter => 가상환경 만들기 => .venv 생성 
# 라이브러리 설치 : pip install flask pydantic
# requirements를 활용한 라이브러리 일괄 설치 : pip freeze > requirements.txt
'''
- URL을 통한 데이터 전달
    - 쿼리 스트링 : C(생성), R(읽기)
        /apt?year=2002
    - 경로 파라미터 : R(읽기), U(수정), D(지우기) ; REST API 방식
        /apt/2002
'''
from flask import Flask, render_template, request, abort
from models import Member
from filters import mask_comma, masked_id, masked_password

app = Flask(__name__)

app.template_filter('mask_pw')(masked_password)

app.template_filter('mask_id')(masked_id)

app.template_filter('comma')(mask_comma)

@app.route('/')
def index():
    return render_template('1_get/index.html')

@app.route('/user', methods=['GET']) # 쿼리 스트링
def user():
    name = request.args.get('name')
    if name:
        return f'<h1>전달 받은 파라미터 : {name}</h1>'
    else:
        abort(404) # 강제 예외 처리 ; 404

@app.errorhandler(404)
def errorhandler(error):
    return render_template('error_page.html')

@app.route('/join_form')
def join_form():
    return render_template('1_get/join.html')

@app.route('/join')
def join():
    name = request.args.get('name') # GET방식으로 받은 파라미터 추출
    id = request.args.get('id')
    pw = request.args.get('pw')
    pwchk = request.args.get('pwchk')
    addr = request.args.get('addr')
    try:
        member = Member(name=name, id=id, pw=pw, pwchk=pwchk, addr=addr)
    except Exception as e:
        return render_template('error_page.html', error="입력 오류"), 500
    return render_template('1_get/result.html', member=member)




if __name__=='__main__':
    app.run(debug=True, port=80)
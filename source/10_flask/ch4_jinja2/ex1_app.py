# Jinja2 templates 문법 정리
# 1. 변수 : {{ var }} 또는 {{ var | filter }} 사용
#    - 기본 제공 필터 : upper, lower, title, capitalize, trim, length, replace
#    - 형변환 제공 필터 : int, float, string
# 2. 제어문 : {% %}
#    2-1. 조건문
#         {% if 조건1 %} 참일 때 {% elif 조건2 %} 조건2 참일 때 {% else %}  거짓일 때 {% endif %}
#    2-2. 반복문
#         {% for var in 나열가능변수 %}         - loop.index  : 1부터 시작하는 순번 (0부터 시작은 loop.index0)
#             {{ loop.index }}. {{ var }}      - loop.first  : 첫 번째 항목인지 여부 (True/False)
#         {% endfor %}#                        - loop.last   : 마지막 항목인지 여부 (True/False)
# 3. 헤더/푸터 및 레이아웃 관리
#    - 모듈 포함 : {% include "header.html" %}
#    - 레이아웃 상속 : {% extends "base.html" %}
# 4. 서브 블럭 (상속시 오버라이드할 영역)
#    {% block 블럭명 %} 내용 {% endblock %}
# 5. 주석 (HTML 렌더링 시 노출되지 않음)
#    {# 주석 내용 #}

from flask import Flask, render_template, request
app = Flask(__name__, static_folder='static', template_folder='templates')
lst = []

@app.route('/', methods=['GET', 'POST'])
def index(name=""):
    if request.method == 'POST':
        name = request.form.get('name', '').strip()
        if name:
            lst.append(name)
    cnt = len(lst)
    return render_template(
        '1_index.html',
        name=name,
        cnt=cnt,
        names = lst
        )

@app.errorhandler(404)
def page_not_found(error):
    return render_template('page_not_found.html', error=error), 404

if __name__=="__main__":
    app.run(debug=True, port=80)
from flask import Flask, url_for
app = Flask(__name__)
# 정적 라우팅 : 경로를 수동으로 직접 지정해 주는 방식
@app.route('/') 

def hello():
  return '<h1>Hello</h1>'
@app.route('/profile/<username>') # 동적 라우팅 : 경로를 자동으로 찾아내고 안내하는 방식
def get_profile(username):
  return f'<h1>profile : {username}</h1>'

if __name__=='__main__':
  with app.test_request_context():
    print('#### ', url_for('hello')) # hello와 연결된 url출력
    print('####', url_for('get_profile', username='hong'))
    print('####', url_for('get_profile', username='홍')) # 한글 url은 인코딩 처리됨
  app.run(debug=True)
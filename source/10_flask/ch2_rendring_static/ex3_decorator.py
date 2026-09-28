# 데코레이터 : 기존 코드의 본문을 수정하지 않고, 새로운 기능을 추가하거나 확장할 수 있도록 덧씌워주는 파이썬의 디자인 패턴이자 구문

# 전/후처리 코드를 중복 작성하는 대신, @check라는 데코레이터로 공통화할 수 있음을 보여주는 구조

def check(func):
  def wrapper():
    print(func.__name__, '함수 전처리')
    func()
    print(func.__name__, '함수 후처리')
  return wrapper
@check
def hello():
  print('hello')
@check
def world():
  print('world')

if __name__=='__main__':
  hello()
  world()
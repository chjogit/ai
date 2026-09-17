# ch05.py
def my_hello(cnt:int): # python을 cnt번 출력하고 __name__ 출력하는 함수 정의하기
    for i in range(cnt):
        print('hi, python', end= "\t")
        print('hello, python')
    print(__name__)
if __name__=="__main__":
    my_hello(3)
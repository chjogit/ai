def add_print(n):
    "1부터 n까지의 누적합을 출력"
    tot = 0
    for i in range(1,n+1):
        tot += i
    print(f'1부터 {n}까지 누적합은 {tot}입니다.')

def add_return(n):
    "1부터 n까지의 누적합을 반환"
    tot = 0
    for i in range(1,n+1):
        tot += i
    return tot

Pi = 3.141592

'''
터미널에서 테스트 하기
인터프리터 선택 : ctrl + shift + p => select interpreter => (base) 선택
터미널 띄우기 : ctrl + j
'''


if __name__ == "__main__":
    import sys
    print(sys.argv)
    if len(sys.argv)>1:
        var = int(sys.argv[1])
    else:
        print('실행 시 숫자 입력이 없을 경우 100')
        var = 100
    print('1. add_print',end='')
    add_print(var)
    print('2. add_return :', add_return(var))
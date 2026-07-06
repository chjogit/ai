# sample_pac/ab/__init__.py
# sample_pac.ab 패키지를 import 할 때 로드되는 파일

# ab 패키지 세팅
# a.py - 많이 쓰는 함수 / b.py - 그 외 [가정]
# from sample_pac.ab import *에서 a.py만 로드하도록 설정

__all__ = ['a']

print("sample_pac 내 ab 패키지 로드됨")
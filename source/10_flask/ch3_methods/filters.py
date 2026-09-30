def mask_password(pw): # 문자 갯수만큼 *로 
  return '*' * len(pw)

def mask_comma(value): # 세자리마다 ,추가
  return f'{value:,}'

if __name__=='__main__':
  pw = 'abc'
  print('비번 :', pw)
  print('비번 :', mask_password(pw))
  value = 1000000
  print('value :', value)
  print('value :', mask_comma(value))
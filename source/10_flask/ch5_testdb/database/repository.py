# emp 목록 가져오기, emp 한 행의 상세정보 확인하기 
from database.connection import conn
from typing import List
def get_emp_list() -> List[dict]: # 정적 타입 검사용 반환 타입 힌트 (성 중 에디터에서의 경고 제공)
    'emp 테이블의 내용을 dict list로 반환'
    cursor = conn.cursor()
    sql = "SELECT * FROM EMP"
    cursor.execute(sql)
    emps = cursor.fetchall()
    keys = [desc[0].lower() for desc in cursor.description]
    emp_list = [dict(zip(keys, emp)) for emp in emps]
    cursor.close()
    return emp_list

def get_emp(empno:int) -> dict:
    '사번을 입력 받아, 해당 사번의 데이터를 dict list로 반환'
    cursor = conn.cursor()
    sql = "SELECT * FROM EMP WHERE EMPNO = :empno"
    cursor.execute(sql, {'empno':empno})
    emp = cursor.fetchone()
    keys = [desc[0].lower() for desc in cursor.description]
    emp_dict = dict(zip(keys, emp))
    cursor.close()
    return emp_dict

if __name__=='__main__':
    emp_list = get_emp_list()
    print(emp_list)
    emp = get_emp(7876)
    print(emp)
-- CH02. SELECT문 - 조회

-- 1. SELECT 문자 작성법 (실행 : CTRL + ENTER)

SELECT * FROM TAB; -- 현 계정이 가지고 있는 테이블 정보

SELECT * FROM EMP; -- EMP 테이블의 모든 정보 (모든 열, 모든 행)

SELECT * FROM DEPT; -- DEPT 테이블의 모든 정보

SELECT * FROM SALGRADE;

-- 2. 특정 열 출력

DESC EMP; 
    -- EMP 테이블의 구조
    
SELECT EMPNO, ENAME, SAL, HIREDATE FROM EMP; -- EMP 테이블의 다중 검색

SELECT EMPNO AS "사번", ENAME AS "이름", SAL AS "급여", HIREDATE AS "입사일" FROM EMP; -- 열 이름 변경

SELECT EMPNO "사번", ENAME "이름", SAL "급여", HIREDATE "입사일" FROM EMP; -- AS 생략 가능

SELECT EMPNO "사 번", ENAME 이름, SAL 급여, HIREDATE 입사일 FROM EMP; -- 변경할 열 이름에 공백이 없을 경우 "" 생략 가능

-- 3.  비교연산자
    -- WHERE절(조건절)에서 비교연산자 사용 - 일치 : =, 불일치 : !=, ^=, <>, 비교 : >, <, >=, <=
    -- 비교연산자는 숫자, 문자, 날짜 모두 사용 가능

SELECT EMPNO NO, ENAME NAME, SAL
    FROM EMP
    WHERE SAL=3000;
    
SELECT EMPNO NO, ENAME NAME, SAL
    FROM EMP
    WHERE SAL!=3000;    

-- EX1. 사원 이름이 'A', 'B', 'C'로 시작하는 사원의 모든 필드
        SELECT * FROM EMP WHERE ENAME < 'D';
        
-- EX2. 81년도 이전에 입사한 사원의 모든 필드
        SELECT * FROM EMP WHERE HIREDATE < '81.01.01';
        
-- 날짜 표기법 설정 (현재 : RR/MM/DD)
        ALTER SESSION SET NLS_DATE_FORMAT = 'MM-DD-YYYY';
        
-- 검색을 위한 데이터 임시 변경
    
    -- 1) TO_CHAR : 데이터 베이스 구조 변경
        SELECT * FROM EMP 
            WHERE TO_CHAR (HIREDATE, 'RR/MM/DD') < '81/01/01'; 
        
    -- 2) TO_DATE : 검색 데이터 구조 확인 및 검색 최적화(변경)
        SELECT * FROM EMP
            WHERE HIREDATE < TO_DATE('81/01/01' , 'RR/MM/DD');
            
-- 4. 논리연산자
    -- WHERE절(조건절)에서 논리연산자 사용 - OR, AND, NOT
    
-- EX 1. 급여가 2000~3000인 직원의 모든 필드
    SELECT * FROM EMP WHERE 2000<=SAL AND SAL<=3000;
    
-- EX 2. 82년도에 입사한 사원의 모든 필드
    SELECT * FROM EMP WHERE '01-01-1982' <= HIREDATE AND HIREDATE <= '12-31-1982';
    SELECT * FROM EMP 
        WHERE HIREDATE >= TO_DATE('82/01/01' , 'RR/MM/DD') AND TO_DATE('82/12/31' , 'RR/MM/DD') >= HIREDATE;
        
-- EX 3. 10번 부서이거나, JOB이 MANAGER인 직원의 모든 필드
    SELECT * FROM EMP
        WHERE DEPTNO = 10 OR JOB = 'MANAGER';
        
-- 5. 산술연산자
    -- SELECT, WHERE, ORDER BY절에서 산술 연산자 사용
    -- 산술연산 과정 중 null 포함 시 결과도 null
        -- NVL (null이 있을 수 있는 필드명, 대체값) : 필드의 타입과 대체값의 타입은 일치해야함
    
-- EX 1. 연봉이 24000 이상인 직원의 ENAME, SAL, 연봉(SAL*12)
    -- ORDER BY : 정렬 - ASC(오름차순), DESC(내림차순)
    SELECT ENAME 이름, SAL 급여, SAL*12 연봉 
        FROM EMP
        WHERE SAL*12 >= 24000
        ORDER BY 연봉 DESC;
        
-- EX 2. 상여금을 포함한 연봉이 15000 이상인 직원의 ENAME, SAL, COMM, 연봉(SAL*12+COMM)
    SELECT ENAME 이름, SAL 급여, COMM, SAL*12+NVL(COMM, 0) 연봉  
        FROM EMP
        WHERE SAL*12+NVL(COMM, 0) >= 15000;
        
-- EX 3. 모든 사원의 ENAME, MGR을 출력 (MGR이 null일 경우 'CEO'를 출력)
    SELECT ENAME, NVL(TO_CHAR(MGR), 'CEO') "NVLexample" FROM EMP;
    
-- 6. 연결연산자
    -- || : 필드나 문자를 연결
    
-- EX. 모든 사원에 대해서 "ENAME의 연봉은 SAL*12+NVL(COMM, 0)$ 입니다."를 출력 및 TITLE = MESSAGE 설정
    SELECT ENAME || '의 연봉은 ' || (SAL*12+NVL(COMM, 0)) || '$ 입니다.' AS "MESSAGE"
        FROM EMP;
        
-- 7. 중복 제거 연산자
    -- DISTINCT

-- EX. 직책 종류 확인
    SELECT DISTINCT JOB FROM EMP;
    
    -- 연습 문제    
        
    --1. emp 테이블의 구조 출력
    DESC EMP;
    
    --2. emp 테이블의 모든 내용을 출력 
    SELECT * FROM EMP;
    
    --3. 현 scott 계정에서 사용가능한 테이블 출력
    SELECT * FROM TAB;
    
    --4. emp 테이블에서 사번, 이름, 급여, 업무, 입사일 출력
    SELECT EMPNO 사번, ENAME 이름, SAL 급여, JOB 업무, HIREDATE 입사일 FROM EMP;
    
    --5. emp 테이블에서 급여가 2000 미만인 사람의 사번, 이름, 급여 출력
    SELECT EMPNO 사번, ENAME 이름, SAL 급여
        FROM EMP
        WHERE SAL < 2000;
    
    --6. 입사일이 81/02 이후에 입사한 사람의 사번, 이름, 업무, 입사일 출력
    SELECT EMPNO 사번, ENAME 이름, SAL 급여, JOB 업무, HIREDATE 입사일
        FROM EMP
        WHERE HIREDATE >= TO_DATE('81/03/01', 'RR/MM/DD');
    
    --7. 업무가 SALESMAN인 사람들 모든 자료 출력
    SELECT * FROM EMP WHERE JOB = 'SALESMAN'; 
    
    --8. 급여가 1500 이상이고 3000 이하인 사람의 사번, 이름, 급여 출력
    SELECT EMPNO 사번, ENAME 이름, SAL 급여
        FROM EMP
        WHERE SAL>=1500 AND SAL <=3000;
    
    --9. 부서코드가 10이거나 30인 사람의 사번, 이름, 업무, 부서코드 출력
    SELECT EMPNO 사번, ENAME 이름, JOB 업무, DEPTNO 부서코드
        FROM EMP
        WHERE DEPTNO = 10 OR DEPTNO = 30;
    
    --10. 업무가 SALESMAN이거나 급여가 3000 이상인 사람의 사번, 이름, 업무, 부서코드 출력
    SELECT EMPNO 사번, ENAME 이름, JOB 업무, DEPTNO 부서코드
        FROM EMP
        WHERE JOB = 'SALESMAN' OR SAL >=3000;

    --11.“ename은 XXX 업무이고 연봉은 XX이다” 스타일로 모두 출력(연봉은 SAL*12+COMM)
    SELECT ENAME || '은 ' || JOB || '업무이고 연봉은 ' || (SAL*12+NVL(COMM, 0)) || '이다' MASSAGE
        FROM EMP
        ORDER BY SAL;

 -- 8. SQL 연산자
    -- BETWEEN, IN, LIKE, IS NULL

/*
     1) 필드 BETWEEN A AND B :  A와 B 사이(A와 B 포함)인 필드의 값 
         필드 NOT BETWEEN A AND B : A와 B 사이 (A와 B 포함)가 아닌 필드의 값
*/    
        -- EX 1. 급여가 1500 이상이고 3000 이하인 사람의 모든 필드 출력
        SELECT * FROM EMP WHERE SAL BETWEEN 1500 AND 3000;    
        
        -- EX 2. 82년도에 입사한 사람의 모든 필드 출력
        SELECT * FROM EMP WHERE HIREDATE  BETWEEN TO_DATE('82/01/01', 'RR/MM/DD') AND  TO_DATE('82/12/31', 'RR/MM/DD');
        
        -- EX 3. 급여가 1500 미만이고 3000 초과인 사람의 모든 필드 출력
        SELECT * FROM EMP WHERE SAL NOT BETWEEN 1500 AND 3000;
/*     
     2) 필드 IN (값1, 값2, ..., 값N) : ()의 값 중 하나라도 일치하는 필드의 값
         필드 NOT IN (값1, 값2, ..., 값N) : ()의 값과 일치하지 않는 필드의 값
*/ 
        -- EX 1. 부서코드가 10이거나 30인 사람의 사번, 이름, 업무, 부서코드 출력
        SELECT EMPNO 사번, ENAME 이름, JOB 업무, DEPTNO 부서코드
            FROM EMP
            WHERE DEPTNO IN (10, 30);
            
        -- EX 2. 부서코드가 10, 20이 아닌 사람의 모든 필드 출력
        SELECT * FROM EMP WHERE DEPTNO NOT IN (10, 20);
        
        -- EX 3. 사번이 7902, 7788, 7566인 사원의 이름, 사번, 업무 출력
        SELECT EMPNO 사번, ENAME 이름, JOB 업무
            FROM EMP
            WHERE EMPNO IN (7902, 7788, 7566);
/*            
     3) 필드 LIKE 패턴 : 패턴(% 0 글자 이상, _1 글자)을 포함한 필드의 값
         필드 NOT LIKE 패턴 : 패턴(% 0 글자 이상, _1 글자)을 포함하지 않는 필드의 값
*/   
        -- EX 1. 이름이 M으로 시작하는 사람의 모든 필드
        SELECT * FROM EMP WHERE ENAME LIKE 'M%';
        
        -- EX 2. 이름에 N이 포함된 사람의 모든 필드
        SELECT * FROM EMP WHERE ENAME LIKE '%N%';
        
        -- EX 3. 이름이 S로 끝나는 사람의 모든 필드
        SELECT * FROM EMP WHERE ENAME LIKE '%S';
        
        -- EX 4. SAL이 5로 끝나는 사람의 모든 필드
        SELECT * FROM EMP WHERE SAL LIKE '%5';
        
        -- EX 5. 82년도에 입사한 사람의 이름, 입사일 필드
        SELECT ENAME, HIREDATE FROM EMP WHERE TO_CHAR(HIREDATE, 'RR/MM/DD') LIKE '82%';
        
        -- EX 6. 1월에 입사한 사람의 모든 필드
        SELECT * FROM EMP WHERE TO_CHAR(HIREDATE, 'RR/MM/DD') LIKE '__/01/__';
/*        
     4) 필드 IS NULL : NULL 값 검색
         필드 IS NOT NULL : NULL이 아닌 값 검색
 */   
        -- EX 1. 상여금이 NULL인 사람의 모든 필드
        SELECT * FROM EMP WHERE COMM IS NULL;
        
        -- EX 2. 상여금이 없는 사람의 모든 필드
        SELECT * FROM EMP WHERE COMM IS NULL OR COMM = 0;
        
        -- EX 3. 상여금이 있는 사람의 모든 필드
        SELECT * FROM EMP WHERE COMM IS NOT NULL AND COMM != 0;
 
 -- 9. 정렬 
     -- ORDER BY
     -- ASC : 오름차순 / DESC : 내림차순
   
    -- EX. 급여 오름차순, 급여가 같으면 입사일 내림차순 정렬
    SELECT ENAME, SAL, HIREDATE FROM EMP ORDER BY SAL, HIREDATE DESC;
    
/* 
    - 형변환 함수
        날짜형 -> 문자형 : TO_CHAR(날짜형 데이터, '패턴')
        문자형 -> 날짜형 : TO_DATE(문자형 데이터, '패턴')
                        - 패턴 
                            - YYYY (4자리 연도), YY(2자리 연도), RR(2자리 연도), MM(월), DD(일), DY(요일명;수), DAY(요일;수요일)
                            - HH24(24시 기준), HH12(12시 기준), AM/PM, MI(분), SS(초)
        숫자형 -> 문자형 : TO_CHAR(숫자형 데이터, '패턴')
                        - 패턴 ex) 9999 -> '9,999'
 */   
 
 
---- 총 연습문제
    
    --1.	EMP 테이블에서 sal이 3000 이상인 사원의 empno, ename, job, sal을 출력하시오.
     SELECT EMPNO, ENAME, JOB, SAL 
        FROM EMP 
        WHERE SAL >= 3000; 
     
    --2.	EMP 테이블에서 empno가 7788인 사원의 ename과 deptno를 출력하시오.
    SELECT ENAME, DEPTNO 
        FROM EMP 
        WHERE EMPNO = 7788;
    
    --3.	연봉(SAL*12+COMM)이 24000 이상인 사번, 이름, 급여 출력하시오. (급여순 정렬)
    SELECT EMPNO, ENAME, SAL 
        FROM EMP 
        WHERE SAL*12+NVL(COMM, 0) >= 24000
        ORDER BY SAL;
    
    --4.	입사일이 1981년 2월 20일과 1981년 5월 1일 사이에 입사한 사원의 사원명, 업무, 입사일을 출력하시오. (hiredate 순으로 출력)
    SELECT ENAME, JOB, HIREDATE
        FROM EMP
        WHERE TO_CHAR(HIREDATE, 'YYYY/MM/DD') BETWEEN '1981/02/20' AND '1981/05/01'
        ORDER BY HIREDATE;
    
    --5. deptno가 10, 20인 사원의 모든 정보를 출력 (단 ename순으로 정렬)
    SELECT * 
        FROM EMP 
        WHERE DEPTNO IN (10, 20) 
        ORDER BY ENAME;
    
    -- 6. sal이 1500이상이고 deptno가 10,30인 사원의 ename과 sal를 출력하시오.
    --    (출력되는 결과의 타이틀을 employee과 Monthly Salary로 출력)
    SELECT ENAME "employee", SAL "Monthly Salary"
        FROM EMP
        WHERE SAL >=1500 AND DEPTNO IN (10, 30);
    
    -- 7. hiredate가 1982년인 사원의 모든 정보를 출력하시오.
    SELECT * FROM EMP WHERE TO_CHAR(HIREDATE, 'RR/MM/DD') LIKE '82/%';
    
    -- 8. 입사일이 1981년이고 업무가 'SALESMAN'이 아닌 직원의 사번, 사원명, 입사일, 
    --    업무, 급여를 검색하시오.
    SELECT EMPNO, ENAME, HIREDATE, JOB, SAL
        FROM EMP
        WHERE TO_CHAR(HIREDATE, 'RR/MM/DD') LIKE '81/%' AND JOB != 'SALESMAN';
    
    -- 9. 사번, 사원명, 입사일, 업무, 급여를 급여가 높은 순으로 정렬하고, 
    --    급여가 같으면 입사일이 빠른 사원으로 정렬하시오.
    SELECT EMPNO, ENAME, HIREDATE, JOB, SAL
        FROM EMP 
        ORDER BY SAL DESC, HIREDATE;
    
    --10. 사원명의 세 번째 알파벳이 'N'인 사원의 사번, 사원명을 검색하시오
    SELECT EMPNO, ENAME
        FROM EMP
        WHERE ENAME LIKE '__N%';
    
    --11. 사원명에 'A'가 들어간 사원의 사번, 사원명을 출력하시오.
    SELECT EMPNO, ENAME
        FROM EMP
        WHERE ENAME LIKE '%A%';
    
    --12. 연봉(SAL*12)이 35000 이상인 사번, 사원명, 연봉을 검색하시오.
    SELECT EMPNO 사번, ENAME 사원명, SAL*12 연봉
        FROM EMP
        WHERE SAL*12 >= 35000
        ORDER BY 연봉;


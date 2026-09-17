-- CH03. JOIN문
    -- 2개 이상의 테이블을 연결하여 데이터 검색

-- 1. INNER JOIN

    -- ex) CROSS JOIN : 특별한 키워드 없이 다음과 같이 FROM절에 두 개 이상의 테이블을 기술한 경우
    SELECT * FROM EMP WHERE ENAME='SCOTT'; -- 1행
    SELECT * FROM DEPT; -- 4행
    SELECT * FROM EMP, DEPT WHERE ENAME='SCOTT'; -- EMP의 1행 * DEPT의 4행 → 잘못된 결과값 도출

-- 1.1 EQUI JOIN : 두 테이블에서 공통적으로 존재하는 필드의 값이 일치되는 행을 연결
    -- ex)
    SELECT * FROM EMP, DEPT WHERE EMP.DEPTNO=DEPT.DEPTNO;

    -- ex) 테이블 별칭 지정 : AS와 ""를 사용하지 않음
    SELECT * FROM EMP E, DEPT D WHERE E.DEPTNO=D.DEPTNO;
    
    -- ex) 두 테이블에 동일한 이름의 필드가 있을 경우,  동일한 이름을 가진 필드를 불러올 때 테이블 지정 필요
    SELECT ENAME, JOB, E.DEPTNO, LOC, DNAME
        FROM EMP E, DEPT D 
        WHERE E.DEPTNO=D.DEPTNO;
        
    -- ex) 급여가 2000 이상인 직원의 이름, 직급, 급여, 부서명
    SELECT ENAME, JOB, SAL, DNAME, LOC 
        FROM EMP E, DEPT D 
        WHERE E.DEPTNO=D.DEPTNO AND SAL>=2000;
        
    -- ex) 근무지(LOC)가 'CHICAGO'인 직원의 이름, 직급, 급여, 부서번호
    SELECT ENAME, JOB, SAL, E.DEPTNO
        FROM EMP E, DEPT D
        WHERE LOC='CHICAGO' AND E.DEPTNO=D.DEPTNO;
        
    -- ex) 상여금을 받은, 급여가 1200 이상인 직원의 이름, 급여, 부서번호, 부서명, 상여금
        SELECT ENAME, SAL, E.DEPTNO, DNAME, COMM
            FROM EMP E, DEPT D
            WHERE E.DEPTNO=D.DEPTNO AND COMM IS NOT NULL AND COMM!=0 AND SAL>=1200;
    
---- 연습 문제
    
    -- 뉴욕에서 근무하는 사원의 이름과 급여를 출력하시오
    SELECT ENAME, SAL
        FROM EMP E, DEPT D
        WHERE E.DEPTNO=D.DEPTNO AND LOC='NEW YORK';

    -- ACCOUNTING 부서 소속 사원의 이름과 입사일을 출력하시오 (입사일 내림차순)
    SELECT ENAME, HIREDATE
        FROM EMP E, DEPT D
        WHERE E.DEPTNO=D.DEPTNO AND DNAME='ACCOUNTING'
        ORDER BY TO_CHAR(HIREDATE, 'RR/MM/DD') DESC;

    -- 직급이 MANAGER인 사원의 이름, 부서명을 출력하시오
    SELECT ENAME, DNAME
        FROM EMP E, DEPT D
        WHERE E.DEPTNO=D.DEPTNO AND JOB = 'MANAGER';

    -- Comm이 null이 아닌 사원의 이름, 급여, 부서코드, 근무지를 출력하시오
    SELECT ENAME, SAL, E.DEPTNO, LOC
        FROM EMP E, DEPT D
        WHERE E.DEPTNO=D.DEPTNO AND COMM IS NOT NULL;
    
    -- 20번 부서 외 사원의 이름, 급여, 부서코드, 근무지를 출력하시오 (부서코드 오름차순)
    SELECT ENAME, SAL, E.DEPTNO, LOC
        FROM EMP E, DEPT D
        WHERE E.DEPTNO=D.DEPTNO AND E.DEPTNO != 20
        ORDER BY E.DEPTNO;
        
-- 1.2 NON-EQUI JOIN : 등가 연산자(=)가 아닌 연산자로 행을 연결

    -- CROSS JOIN 예시
    SELECT * FROM EMP WHERE ENAME='SCOTT'; -- 직원 정보 (1행)
    SELECT * FROM SALGRADE; -- 급여 정보 (5행)
    SELECT * FROM EMP, SALGRADE WHERE ENAME='SCOTT'; -- CROSS JOIN 상태
    
    -- ex) NON-EQUI JOIN 예시
    SELECT * 
        FROM EMP, SALGRADE 
        WHERE ENAME='SCOTT' AND SAL BETWEEN LOSAL AND HISAL;
        
    -- ex) 전체 직원의 급여 등급 확인
    SELECT ENAME, JOB, SAL, GRADE 
        FROM EMP, SALGRADE 
        WHERE SAL BETWEEN LOSAL AND HISAL;
        
    -- ex) 모든 사원의 사번, 이름, 직급, 상사 사번, 급여, 급여 등급 (N등급)
    SELECT EMPNO, ENAME, JOB, MGR, SAL, GRADE||'등급' GRADE
        FROM EMP, SALGRADE
        WHERE SAL BETWEEN LOSAL AND HISAL;
    
    
---- 연습 문제

    --	 Comm이 null이 아닌 사원의 이름, 급여, 등급, 부서번호, 부서이름, 근무지를 출력
    SELECT ENAME, SAL, GRADE, E.DEPTNO, DNAME, LOC
        FROM EMP E, DEPT D, SALGRADE
        WHERE E.DEPTNO = D.DEPTNO AND SAL BETWEEN LOSAL AND HISAL AND COMM IS NOT NULL;
    
    --	 이름, 급여, 입사일, 급여등급
    SELECT ENAME, HIREDATE, GRADE
        FROM EMP, SALGRADE
        WHERE SAL BETWEEN LOSAL AND HISAL;
    
    --	 이름, 급여, 급여등급, 연봉, 부서명을 부서명 순으로 정렬하여 출력 (부서가 같으면 연봉 내림차순, 연봉=(sal+comm)*12, comm이 null이면 0)
    SELECT ENAME, SAL, GRADE, (SAL+NVL(COMM, 0))*12 PAY, DNAME
        FROM EMP E, DEPT D, SALGRADE
        WHERE E.DEPTNO = D.DEPTNO AND SAL BETWEEN LOSAL AND HISAL
        ORDER BY DNAME, PAY DESC;
    
    --	 급여가 1000~3000 사이인 사원의 이름, 직급, 급여, 등급, 부서코드, 부서명 출력 (정렬조건 : 부서별, 부서 같으면 직급별, 직급 같으면 급여 오름차순)
    SELECT ENAME, JOB, SAL, GRADE, E.DEPTNO, DNAME
        FROM EMP E, DEPT D, SALGRADE
        WHERE E.DEPTNO=D.DEPTNO AND SAL BETWEEN LOSAL AND HISAL AND SAL BETWEEN 1000 AND 3000
        ORDER BY DNAME, JOB, SAL;
    
    -- 81년에 입사한 사원의 이름, 급여, 등급, 입사일, 근무지  (등급 내림차순)
    SELECT ENAME, SAL, GRADE, HIREDATE, LOC
        FROM EMP E, SALGRADE, DEPT D
        WHERE E.DEPTNO=D.DEPTNO AND SAL BETWEEN LOSAL AND HISAL AND TO_CHAR(HIREDATE, 'RR') = 81
        ORDER BY GRADE DESC;

-- 1.3 SELF-JOIN : 하나의 테이블 내부의 연관 데이터 연결

    -- ex) EMPNO와 MGR의 관계
    SELECT EMPNO, ENAME, MGR FROM EMP WHERE ENAME='SMITH'; -- 1행
    SELECT EMPNO, ENAME FROM EMP; -- 14행
	
    -- ex) 하나의 테이블에 2개 이상의 별칭을 부여
    SELECT E.EMPNO, E.ENAME, E.MGR, M.ENAME MNAME
        FROM EMP E, EMP M
        WHERE E.MGR=M.EMPNO AND E.ENAME='SMITH';
      
    -- ex) 모든 사원의 사번, 이름, 상사 사번, 상사 이름  
    SELECT E.EMPNO, E.ENAME, E.MGR, M.ENAME MNAME
        FROM EMP E, EMP M
        WHERE E.MGR=M.EMPNO -- KING의 MGR은 NULL, 출력에서 제외됨
        ORDER BY MNAME;
        
    -- ex) 모든 사원에 대해 ['SMITH'의 상사는 FORD다] 포맷으로 출력
    SELECT E.ENAME||'의 상사는 '||M.ENAME||'다' "직원-상사"
        FROM EMP E, EMP M
        WHERE E.MGR=M.EMPNO;
        
    -- ex) 매니저가 KING인 사원들의 이름과 직급을 출력
    SELECT E.ENAME, E.JOB
        FROM EMP E, EMP M
        WHERE E.MGR=M.EMPNO AND M.ENAME = 'KING';
        

-- 2. OUTER JOIN : 조건에 맞지 않아 누락되는 행(매칭 데이터가 없는 행)까지 결과 집합에 포함


-- 2.1 SELF-JOIN에서의 OUTER JOIN : 데이터가 부족하여 NULL로 채워져야 하는 쪽에 (+) 기호를 붙여 표현

    -- ex) 모든 사원의 사번, 이름, 상사 사번, 상사 이름  (KING 포함)
    SELECT W.ENAME, W.MGR, M.EMPNO,  M.ENAME
        FROM EMP W, EMP M
        WHERE W.MGR=M.EMPNO(+);
        
     -- ex) 모든 사원에 대해 ['SMITH'의 상사는 FORD다] 포맷으로 출력 (KING 포함)
    SELECT W.ENAME||'의 상사는 '||NVL(M.ENAME, '없')||'다' STRING
        FROM EMP W, EMP M
        WHERE W.MGR=M.EMPNO(+);
        
    -- ex) 테이블 별칭으로 한글을 사용할 경우
    SELECT 부하.ENAME, 부하.MGR, 상사.EMPNO, 상사.ENAME
        FROM EMP 부하, EMP 상사
        WHERE 부하.MGR(+)=상사.EMPNO;
        
    -- ex) 말단 사원의 사번, 이름
    SELECT M.EMPNO, M.ENAME
        FROM EMP W, EMP M
        WHERE W.MGR(+)=M.EMPNO AND W.MGR IS NULL;
        
        
-- 2.2 EQUI-JOIN에서의 OUTTER-JOIN

    -- ex)
    SELECT * FROM  DEPT; -- 4행 (DEPTNO : 10, 20, 30, 40)
    SELECT * FROM EMP; -- 14행 (DEPTNO : 10, 20, 30)
    SELECT * FROM EMP E, DEPT D
        WHERE E.DEPTNO=D.DEPTNO; -- DEPTNO : 40 출력 X
    SELECT * FROM EMP E, DEPT D
        WHERE E.DEPTNO(+)=D.DEPTNO; -- DEPTNO : 40 출력 O
        
        
---- 연습문제

-- Part1(EQUI JOIN, NON EQUI JOIN)

-- 1. 모든 사원에 대한 이름, 부서번호, 부서명을 출력하는 SELECT 문장을 작성
    SELECT ENAME, E.DEPTNO, DNAME
        FROM EMP E, DEPT D
        WHERE E.DEPTNO=D.DEPTNO;

-- 2. NEW YORK에서 근무하고 있는 사원에 대하여 이름, 직급, 급여, 부서명을 출력
    SELECT ENAME, JOB, SAL, DNAME
        FROM EMP E, DEPT D
        WHERE E.DEPTNO=D.DEPTNO AND LOC = 'NEW YORK';
        
-- 3. 보너스를 받는 사원에 대하여 이름, 부서명, 위치를 출력
    SELECT ENAME, DNAME, LOC
        FROM EMP E, DEPT D
        WHERE E.DEPTNO=D.DEPTNO AND COMM IS NOT NULL AND COMM!=0;   -- COMM > 0;

-- 4. 이름 중 L자가 있는 사원에 대하여 이름, 직급, 부서명, 위치를 출력
    SELECT ENAME, JOB, DNAME, LOC
        FROM EMP E, DEPT D
        WHERE E.DEPTNO=D.DEPTNO AND ENAME LIKE '%L%';  

-- 5. 사번, 사원명, 급여, 부서명을 출력(단, 급여가 2000 이상인 사원에 대하여 급여를 기준으로 내림차순 정렬)
    SELECT E.DEPTNO, ENAME, SAL, DNAME
        FROM EMP E, DEPT D
        WHERE E.DEPTNO=D.DEPTNO AND SAL >= 2000
        ORDER BY SAL DESC;

-- 6. 사번, 사원명, 직급, 급여, 급여등급, 부서명을 출력(단, 직급이 MANAGER이며 급여가 2500 이상인
-- 사원에 대하여 사번을 기준으로 오름차순정렬)
    SELECT E.DEPTNO, ENAME, JOB, SAL, GRADE, DNAME
        FROM EMP E, DEPT D, SALGRADE
        WHERE E.DEPTNO=D.DEPTNO 
            AND JOB = 'MANAGER' 
            AND SAL >= 2500 
            AND SAL BETWEEN LOSAL AND HISAL
        ORDER BY E.EMPNO;

--Part2(4가지 JOIN 모두)

--1. 이름, 급여, 업무, 직속상사명 출력
    SELECT W.ENAME, W.SAL, W.JOB, M.ENAME MANAGER
        FROM EMP W, EMP M
        WHERE W.MGR=M.EMPNO;

--2. 이름, 급여, 업무, 직속상사명 출력 (상사가 없는 직원까지 출력, 상사가 없을 시 '없음'으로 출력)
    SELECT W.ENAME, W.SAL, W.JOB, NVL(M.ENAME, '없음') MANAGER
        FROM EMP W, EMP M
        WHERE W.MGR=M.EMPNO(+);

--3. 이름, 급여, 부서명, 직속상사명 출력
    SELECT W.ENAME, W.SAL, DNAME, M.ENAME MANAGER
        FROM EMP W, EMP M, DEPT D
        WHERE W.MGR=M.EMPNO 
            AND D.DEPTNO = W.DEPTNO;
        
--4. 상사가 없는 직원과 상사가 있는 직원 모두에 대해 이름, 급여, 부서코드, 부서명, 근무지, 직속상사명을 출력(상사가 없을 시 '없음'으로 출력)
    SELECT W.ENAME, W.SAL, W.DEPTNO,  DNAME, LOC, NVL(M.ENAME, '없음') MANAGER
        FROM EMP W, EMP M, DEPT D
        WHERE W.MGR=M.EMPNO(+) 
            AND D.DEPTNO = W.DEPTNO;

--5. 이름, 급여, 등급, 부서명, 직속상사명. 급여가 2000 이상인 사람
    SELECT W.ENAME, GRADE, DNAME, NVL(M.ENAME, '없음') MANAGER
        FROM EMP W, EMP M, DEPT D, SALGRADE
        WHERE W.MGR=M.EMPNO(+) 
            AND D.DEPTNO = W.DEPTNO 
            AND W.SAL >=2000 
            AND W.SAL BETWEEN LOSAL AND HISAL;
        
--6. 이름, 급여, 급여등급, 부서명, 연봉, 직속상사명. 연봉=(SAL+COMM)*12으로 계산하여 출력
    SELECT W.ENAME, W.SAL, GRADE, DNAME, (W.SAL+NVL(W.COMM,0))*12 PAY, NVL(M.ENAME, '없음') MANAGER
        FROM EMP W, EMP M, DEPT D, SALGRADE
        WHERE W.MGR=M.EMPNO(+) 
            AND D.DEPTNO = W.DEPTNO 
            AND W.SAL BETWEEN LOSAL AND HISAL;
        
--7. 6번을 부서명 순으로 오름차순 정렬하여 출력(부서가 같으면 급여가 큰 순 정렬)
    SELECT W.ENAME, W.SAL, GRADE, DNAME, (W.SAL+NVL(W.COMM,0))*12 PAY, NVL(M.ENAME, '없음') MANAGER
        FROM EMP W, EMP M, DEPT D, SALGRADE
        WHERE W.MGR=M.EMPNO(+) 
            AND D.DEPTNO = W.DEPTNO
            AND W.SAL BETWEEN LOSAL AND HISAL
        ORDER BY DNAME, W.SAL DESC;

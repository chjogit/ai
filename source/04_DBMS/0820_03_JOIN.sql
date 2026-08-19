-- CH03. JOIN문
    -- 2개 이상의 테이블을 연결하여 데이터 검색

    -- ex)
    SELECT * FROM EMP WHERE ENAME='SCOTT'; -- 1행
    SELECT * FROM DEPT; -- 4행


-- CROSS JOIN : 특별한 키워드 없이 다음과 같이 FROM절에 두 개 이상의 테이블을 기술한 경우
    -- ex)
    SELECT * FROM EMP, DEPT WHERE ENAME='SCOTT'; -- EMP의 1행 * DEPT의 4행 → 잘못된 결과값 도출

-- 1. EQUI JOIN : 두 테이블에서 공통적으로 존재하는 필드의 값이 일치되는 행을 연결
    -- ex)
    SELECT * FROM EMP, DEPT WHERE EMP.DEPTNO=DEPT.DEPTNO;

    -- 테이블 별칭 지정 : AS와 ""를 사용하지 않음
    -- ex)
    SELECT * FROM EMP E, DEPT D WHERE E.DEPTNO=D.DEPTNO;
    
    -- ex) 두 테이블에 동일한 이름의 필드가 있을 경우,  동일한 이름을 가진 필드를 불러올 때 테이블 지정 필요
    SELECT ENAME, JOB, E.DEPTNO, LOC, DNAME
        FROM EMP E, DEPT D 
        WHERE E.DEPTNO=D.DEPTNO;
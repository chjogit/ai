-- CH04. DDL, DML, DCL
/*
    SQL 문법
    1) DCL : 사용자 계정 생성 (CREATE USER), 권한 부여 (GRANT), 권한 박탈 (REVOKE), 사용자 계정 제거 (DROP USER), 트랜젝션 명령어 (ROLLBACK, COMMIT)
    2) DDL : 테이블 생성 (CREATE TABLE), 테이블 구조 변경 (ALTER TABLE), 테이블 삭제 (DROP TABLE)
    3) DML : CRUD (Create, Read, Update, Delete)
                입력 (INSERT), 수정 (UPDATE), 삭제 (DELETE) - 취소 (ROLLBACK) 가능
                검색 (SELECT)
*/

---- 1. DDL ----

/*
        1.1 테이블 생성 (CREATE TABLE [테이블명]...) : 테이블 구조 정의
        
            - ORACLE 타입 
                - NUMBER (N) : N 자리 수의 숫자형 (N≤38)
                - DATE : 날짜형
                - VARCHAR2 (N) : N byte 크기의 문자형 (N≤4000)
                - CLOB : 대용량 텍스트 데이터형 (최대 4GB/2GB 이하의 대용량 문자 데이터)
*/

    -- ex) 테이블 생성 예시 (테이블 수준 기본키 지정)
    CREATE TABLE BOOK(
        BOOKID          NUMBER(4),          -- 4자리의 숫자형
        BOOKNAME   VARCHAR2(30),   -- 30 byte 크기의 문자형 (한글 1자 = 3byte)
        PUBLISHER    VARCHAR2(30),    -- 30 byte 크기의 문자형
        RDATE            DATE,                       -- 날짜+시간의 날짜형
        PRICE              NUMBER(8, 2),      -- 소수점 2자리를 포함한 8자리의 숫자형
        PRIMARY KEY (BOOKID)              -- 제약 조건 : BOOKID를 기본키(Primary Key)로 지정 
    );
    
    DESC BOOK;
    SELECT * FROM BOOK;
    
    -- ex) 서브 쿼리를 이용한 테이블 생성 (제약 조건이 제외된 데이터)
    CREATE TABLE EMP01 AS SELECT * FROM EMP WHERE DEPTNO>10;
    DESC EMP01
    
/*
        1.2 테이블 삭제 (DROP TABLE [테이블명]...)
         - DROP TABLE [테이블명] CASCADE CONSTRAINTS
*/    

    -- ex) 테이블 삭제 시 복구 불가 (재생성 필요)
    DROP TABLE BOOK;
    
    -- ex) 기본키 설정 위치 변경 가능 (컬럼 수준 기본키 지정)
    CREATE TABLE BOOK(
        BOOKID          NUMBER(4) PRIMARY KEY, 
        BOOKNAME   VARCHAR2(30),
        PUBLISHER    VARCHAR2(30),
        RDATE            DATE,
        PRICE              NUMBER(8, 2)
    );
    
    DROP TABLE BOOK;
    
    -- ex) FOREIGN KEY가 연결되어있을 경우  테이블 삭제 시 오류 발생
    DROP TABLE DEPT;
    
    -- ex) 참조한 테이블에 상관없이 테이블 삭제
    DROP TABLE DEPT01 CASCADE CONSTRAINTS;
    
---- 2. DML, DCL ----

/*
        2.1 INSERT 
            - INSERT INTO [테이블명] VALUES (값1, 값2, ...)
            - INSERT INTO 테이블명 (필드명1, 필드명2, ...) VALUES (값1, 값2, ...) ; 지정되지 않은 필드는 NULL 입력됨
            - COMMIT 전까지 트랜젝션 메모리 임시 저장 상태 : 다른 사용자의 접근이 불가
        
        * 서브 쿼리 : 하나의 SQL 문장 안에 포함된 또 다른 SELECT 문장
        
        * DCL
            - ROLLBACK : 트랜젝션 시작 시점 이후에 실행된 모든 DML 작업 취소
            - COMMIT : 임시 저장소에 있던 모든 변경 사항이 데이터베이스 파일에 실제 저장됨
*/

    -- EX) DEPT와 유사한 DEPT01 TABLE 및 EMP와 유사한 EMP01 TALBE 생성
    
    -- DEPT01 : DEPTNO (PK:NUMBER(2)), DNAME(VARCHAR2(14)), LOC(VARCHAR2(13))
    
    CREATE TABLE DEPT01(
        DEPTNO NUMBER(2) PRIMARY KEY,
        DNAME VARCHAR2(14),
        LOC VARCHAR2(13)
    );
    
    INSERT INTO DEPT01 VALUES (10, '재무팀', '신림'); 
    
    ROLLBACK; -- 트랜젝션 시작 시점 이후에 실행된 모든 DML 작업 취소
    
    -- EMP01 : EMPNO (NUMBER(4), PK), ENAME (VARCHAR2(10)), JOB (VARCHAR2(9)), MGR (NUMBER(4)), HIREDATE (DATE)
    --                 SAL (NUMBER(7, 2)), COMM (NUMBER (7, 2)), DEPTNO (NUMBER(2), FK)
      
    CREATE TABLE EMP01 (
        EMPNO NUMBER(4),
        ENAME VARCHAR2(10),
        JOB VARCHAR2(9),
        MGR NUMBER(4),
        HIREDATE DATE,
        SAL NUMBER(7,2),
        COMM NUMBER(7,2),
        DEPTNO NUMBER(2),
        PRIMARY KEY(EMPNO),
        FOREIGN KEY(DEPTNO) REFERENCES DEPT01 (DEPTNO)
    );
    
    INSERT INTO DEPT01 VALUES (10, '재무', '신림'); 
    INSERT INTO EMP01 VALUES (1000, '홍길동', NULL, NULL, NULL, NULL, NULL, 10);
    
    COMMIT; -- 임시 저장소에 있던 모든 변경 사항이 데이터베이스 파일에 실제 저장됨
    
    -- ex) DEPT01에 데이터 입력
    INSERT INTO DEPT01 VALUES (50, '법무', '서초');
    INSERT INTO DEPT01 (LOC, DNAME, DEPTNO) VALUES ('신림', '인사', 60);
    INSERT INTO DEPT01 VALUES (70, '영업', NULL);                                  -- 명시적 NULL 입력
    INSERT INTO DEPT01(DEPTNO, DNAME) VALUES (80, '고객지원');   -- 묵시적 NULL 입력
    SELECT * FROM DEPT01;
    
    -- ex) 서브쿼리를 이용한 INSERT : 서브 쿼리 선 실행 후, 메인 쿼리 실행 필요
    INSERT INTO DEPT01 
        SELECT * 
        FROM DEPT
        WHERE DEPTNO > 10;
    
    
    ---- DDL, DML 연습문제
    
    CREATE TABLE SAM01 (
        EMPNO NUMBER(4) PRIMARY KEY,
        ENAME VARCHAR2(10),
        JOB VARCHAR2(9),
        SAL NUMBER(7,2)
    );
    
    INSERT INTO SAM01 VALUES (1000, 'APPLE', 'POLICE', 10000);
    INSERT INTO SAM01 VALUES (1010, 'BANANA', 'NURSE', 15000);
    INSERT INTO SAM01 VALUES (1020, 'ORANGE', 'DOCTOR', 25000);
    INSERT INTO SAM01 VALUES (1030, 'DOG', NULL, 25000);
    INSERT INTO SAM01 (EMPNO, ENAME, SAL) VALUES (1040, 'CAT', 2000);
    
    INSERT INTO SAM01
        SELECT EMPNO, ENAME, JOB, SAL FROM EMP
        WHERE DEPTNO = 10;
    
    SELECT * FROM SAM01;
    
    COMMIT;
    
/*
        2.2 UPDATE
        - UPDATE [테이블명] SET 필드명1=값1, 필드명2=값2, ...
        - UPDATE [테이블명] SET 필드명1=값1 WHERE [조건문]
*/
    
    DROP TABLE EMP01;
    
    -- ex) 1. 서브 쿼리를 이용한 테이블 생성
    CREATE TABLE EMP01 AS SELECT * FROM EMP WHERE DEPTNO>10;
    
    -- ex) 2. 부서 번호 99로 수정 후 철회
    UPDATE EMP01 SET DEPTNO=99;
    ROLLBACK;
    
    -- ex) 3. 모든 사원의 급여 10% 인상
    UPDATE EMP01 SET SAL = SAL*1.1;
    
    -- ex) 4. 급여가 1200 미만인 직원의 급여 100$ 인상
    UPDATE EMP01 SET SAL = SAL + 100 WHERE SAL < 1200;
    
    -- ex) 5. 'SMITH'의 부서 이동 및 급여, 상여금 500$ 인상
    UPDATE EMP01 
        SET JOB = 'SALESMAN', 
                MGR = (SELECT EMPNO FROM EMP01 WHERE ENAME = 'BLAKE'), 
                HIREDATE = SYSDATE, 
                SAL = SAL + 500, 
                COMM = NVL(COMM, 0) + 500,
                DEPTNO = 30
        WHERE ENAME = 'SMITH';
    
    SELECT * FROM EMP01;
    
    COMMIT;
    
/*
        2.3 DELETE
        - DELETE FROM [테이블명] WHERE [조건문]
*/
    
    -- ex) 1. DELETE에서 WHERE 조건문이 없을 시 모든 필드가 삭제됨
    DELETE FROM EMP01;
    ROLLBACK;
    SELECT * FROM EMP01;
    
    -- ex) 2. EMP01에서 'FORD' 정보 삭제
    DELETE FROM EMP01 WHERE ENAME='FORD';
    SELECT * FROM EMP01;
    
    -- ex) 3. SAM01에서 JOB이 NULL인 사원 정보 삭제
    DELETE FROM SAM01 WHERE JOB IS NULL;
    SELECT * FROM SAM01;
    
    -- ex) 4. EMP01에서 30번 부서 직원 정보 삭제
    DELETE FROM EMP01 WHERE DEPTNO=30;
    SELECT * FROM EMP01;
    
    COMMIT;
    
---- 연습문제 PAGE 2

    -- 1.MY_DATA 테이블을 생성하시오 (단, ID 필드는 PRIMARY KEY)
    CREATE TABLE MY_DATA (
        ID NUMBER(4) PRIMARY KEY,
        NAME VARCHAR2(10),
        USERID VARCHAR2(30),
        SALARY NUMBER(10,2)
    );
    
    -- 2. 생성된 테이블에 위의 도표와 같은 값을 입력하는 SQL 문을 작성하시오
    INSERT INTO MY_DATA VALUES (1, 'Scott', 'sscott', 10000.00);
    INSERT INTO MY_DATA VALUES (2, 'Ford', 'fford', 13000.00);
    INSERT INTO MY_DATA VALUES (3, 'Patel', 'ppatel', 33000.00);
    INSERT INTO MY_DATA VALUES (4, 'Report', 'rreport', 23500.00);
    INSERT INTO MY_DATA VALUES (5, 'Good', 'ggood', 44450.00);
    
    -- 3. TO_CHAR 내장 함수를 이용하여 입력한 자료를 위의 도표와 같은 형식으로 출력하는 SQL 문을 작성하시오
     SELECT ID "ID - number(4)", NAME "NAME - varchar2(10)", USERID "USERID - varchar2(30)", TO_CHAR(SALARY, '99,999.99') "SALARY - number(10,2)" 
        FROM MY_DATA;
    
    -- 4. 자료를 영구적으로 데이터베이스에 등록하는 명령어를 작성하시오
    COMMIT;
    
    -- 5. ID 가 3 번인 사람의 급여를 65000.00 으로 갱신하고 영구적으로 데이터베이스에 반영하시오
    UPDATE MY_DATA 
        SET SALARY = 65000.00 
        WHERE ID=3;
    COMMIT;
    
    -- 6. NAME 이 Ford 인 사람을 삭제하고 영구적으로 데이터베이스에 반영하시오
    DELETE FROM MY_DATA 
        WHERE NAME='Ford';
    COMMIT;
    
    -- 7. SALARY 가 15,000.00 이하인 사람의 급여를 15,000.00 으로 변경하시오
    UPDATE MY_DATA 
        SET SALARY = 15000.00 
        WHERE SALARY <= 15000.00;
    
    -- 8. 위에서 생성한 테이블을 삭제하시오
    DROP TABLE MY_DATA;
    
    
---- 연습문제 PAGE 3

    -- 1. EMP 테이블과 같은 구조와 내용의 테이블 EMP01 생성, 테이블이 있을시 제거하고 , 모든 사원의 부서번호 30번으로 수정
    DROP TABLE EMP01;
    CREATE TABLE EMP01 
        AS SELECT * FROM EMP;
    UPDATE EMP01 
        SET DEPTNO = 30;
    
    -- 2. EMP01 테이블의 모든 사원의 급여 10% 인상
    UPDATE EMP01 
        SET SAL = SAL*1.1;
    
    -- 3. 급여가 3000 이상인 사원만 급여 10% 인상
    UPDATE EMP01 
        SET SAL = SAL*1.1 
        WHERE SAL >=3000;
    
    -- 4. EMP01 테이블에서 'DALLAS' 에서 근무하는 사원의 급여 1000 인상
    UPDATE EMP01 
        SET SAL = SAL + 1000 
        WHERE DEPTNO = (SELECT DEPTNO FROM DEPT WHERE LOC='DALLAS');
    
    -- 5. SCOTT 사원의 부서번호는 20번으로 , 직급은 MANAGER로 수정
    UPDATE EMP01 
        SET DEPTNO=20, 
                JOB='MANAGER' 
            WHERE ENAME='SCOTT';
    
    -- 6. 부서명이 'RESEARCH'인 사원 삭제
    DELETE FROM EMP01 
        WHERE DEPTNO = (SELECT DEPTNO FROM DEPT WHERE DNAME='RESEARCH');
    
    -- 7. 사원명이 'FORD'인 사원 삭제
    DELETE FROM EMP01 
        WHERE ENAME='FORD';
    
    -- 8. SAM01 테이블에서 JOB이 NULL인 사원을 삭제
    DELETE FROM SAM01 
        WHERE JOB IS NULL;
    
    -- 9. SAM01 테이블에서 ENAME이 ORANGE인 사원을 삭제
    DELETE FROM SAM01  
        WHERE ENAME = 'ORANGE';
    
    -- 10. SAM01 테이블에서 급여가 1500 이하인 사람의 급여를 1500 으로 수정
    UPDATE SAM01 
        SET SAL = 1500 
        WHERE SAL <=1500;
    
    -- 11. SAM01 테이블에서 JOB이 'MANAGER'인 사원의 급여를 10% 인하
    UPDATE SAM01 
        SET SAL = SAL*0.9 
        WHERE JOB='MANAGER';
        
        
---- 3. 제약 조건 ----
/*
    - PRIMARY KEY  : 기본키 ; NULL 불가, 각각의 요소가 각 테이블의 유일한 값
        * [필드 정의] PRIMARY KEY
        *  PRIMARY KEY(필드명)
    - FOREIGN KEY : 외래키 ; 외부 테이블과 연결
        * [필드 정의] REFERENCES [연결할_테이블명] (연결할_필드명)
        * FOREIGN KEY(필드명) REFERENCES [연결할_테이블명] (연결할_필드명)
    - NOT NULL : NULL(빈 값) 입력을 금지
    - UNIQUE : 중복 값 금지, 다수의 NULL 허용
    - CHECK : 설정한 조건식을 만족하는 데이터만 허용 (NULL은 조건 통과)
        * CHECK (조건문)
*/



    -- EX) DEPT1 & EMP1 설계 프로그램 eXERD을 활용한 테이블 생성
    
    CREATE TABLE DEPT1 (
        DEPTNO  NUMBER(2) PRIMARY KEY,
        DNAME   VARCHAR2(14) UNIQUE,
        LOC         VARCHAR2(14) NOT NULL -- NOT NULL의 경우, 컬럼 수준의 설정만 가능
    );

    INSERT INTO DEPT1 SELECT * FROM DEPT;
    INSERT INTO DEPT1 VALUES (40, 'LAWYS', 'D.C'); -- PK 제약 조건 위반 에러
    UPDATE DEPT1 SET DNAME='SALES' WHERE DEPTNO = 40; -- UNIQUE 제약 조건 위반 에러
    INSERT INTO DEPT1 (DEPTNO, DNAME) VALUES (50, 'CMPT'); -- NOT NULL 제약 조건 위반 에러

    CREATE TABLE EMP1 (
        ENPNO   NUMBER(4) PRIMARY KEY,
        ENAME   VARCHAR2(10) NOT NULL,
        JOB          VARCHAR2(9) NOT NULL,
        MGR        NUMBER(4),
        HIREDATE  DATE DEFAULT SYSDATE, -- DEFAULT [기본값] : 값이 입력되지 않을 때 자동으로 들어갈 기본값 지정
        SAL         NUMBER(7,2) CHECK(SAL>0),
        COMM    NUMBER(7,2),
        DEPTNO NUMBER(2) REFERENCES DEPT1 (DEPTNO)
    );
    
    INSERT INTO EMP1 SELECT * FROM EMP;
    INSERT INTO EMP1 (ENPNO, ENAME, JOB, DEPTNO) VALUES (7000, 'HONG', 'MANAGER', 10); -- 기본값(SYSDATE) 입력 확인
    INSERT INTO EMP1 (ENPNO, ENAME, JOB, SAL, DEPTNO) VALUES (7001, 'KIM', 'CLERK', 0,10); -- CHECK 제약 조건 위반 에러
    INSERT INTO EMP1 (ENPNO, ENAME, JOB, SAL, DEPTNO) VALUES (7001, 'KIM', 'CLERK', 1200, 50); -- PK 제약 조건 위반 에러
    INSERT INTO EMP1 (ENPNO, ENAME, JOB, SAL, DEPTNO) VALUES (7001, 'KIM', 'CLERK', 1200, 30); -- PK 제약 조건 위반 에러

    SELECT * FROM EMP1;
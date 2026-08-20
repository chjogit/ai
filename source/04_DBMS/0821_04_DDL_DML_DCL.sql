-- CH04. DDL, DML, DCL
/*
    SQL
    1) DCL : 사용자 계정 생성 (CREATE USER), 권한 부여 (GRANT), 권한 박탈 (REVOKE), 사용자 계정 제거 (DROP USER), 트랜젝션 명령어 (ROLLBACK, COMMIT)
    2) DDL : 테이블 생성 (CREATE TABLE), 테이블 구조 변경 (ALTER TABLE), 테이블 삭제 (DROP TABLE)
    3) DML : CRUD (Create, Read, Update, Delete)
                입력 (INSERT), 수정 (UPDATE), 삭제 (DELETE) - 취소 (ROLLBACK) 가능
                검색 (SELECT)
*/

-- 1. DDL

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
/*
        1.2 테이블 삭제 (DROP TABLE [테이블명]...)
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
    
    -- ex) FOREIGN KEY가 연결되어있을 경우  테이블 삭제 시 오류 발생
    DROP TABLE DEPT;
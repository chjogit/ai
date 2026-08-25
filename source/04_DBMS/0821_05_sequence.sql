-- CH05. SEQUENCE
/*
    1. 시퀀스 (SEQUENCE)  
    - 개념 : 순차적인 번호를 자동으로 생성하는 데이터베이스 객체
    - 용도 : 인공키(Artificial PRIMARY KEY) 생성 시 주로 사용  
    - 특징
        - 하나의 시퀀스를 여러 테이블에서 참조 가능
        - 테이블 구조나 데이터 저장 여부와 무관하게 데이터베이스 객체로 별도 존재
*/

/*
    1.1 시퀀스 생성
    - CREATE SEQUENCE 시퀀스명
        - START WITH N : N 부터 시작 (기본값 : 1)
        - INCREMENT BY M : M 씩 증가 (기본값 : 1) 
        - MAXVALUE : 최댓값
        - MINVALUE : 최솟값
        - NOCACHE : 메모리 임시 할당 미사용 (서버 종료 시 번호 건너뜀 방지)
        - NOCYCLE : 최댓값 도달 시 중지
*/
    -- ex) 시퀀스 생성 예시
    CREATE SEQUENCE FRIEND_SEQ
        START WITH 1
        INCREMENT BY 1
        MAXVALUE 9999
        NOCACHE
        NOCYCLE;
        
/*
    1.2 시퀀스 활용
    - 시퀀스명.NEXTVAL : 다음 순번 생성
    - 시퀀스명.CURRVAL : 시퀀스 값 확인
*/
    
    -- ex) 시퀀스 출력
    SELECT FRIEND_SEQ.NEXTVAL FROM DUAL;
    SELECT FRIEND_SEQ.CURRVAL FROM DUAL; -- 현재 시퀀스 값 확인

    -- ex) FRIEND TABLE 생성 (NO : NUMBER(3) PK, NAME : VARCHAR2(20), TEL : VARCHAR2(20), ADDRESS : VARCHAR2(200), LAST_MODIFY : DATE)
    
    DROP SEQUENCE FRIEND_NO_SEQ;
    CREATE SEQUENCE FRIEND_NO_SEQ
        MAXVALUE 999
        NOCACHE
        NOCYCLE;
        
    DROP TABLE FRIEND;
    CREATE TABLE FRIEND (
        NO                  NUMBER(3)         PRIMARY KEY,       
        NAME            VARCHAR2(20)   NOT NULL,
        TEL                VARCHAR2(20)   UNIQUE,
        ADDRESS     VARCHAR2(200),
        LAST_MODIFY  DATE DEFAULT SYSDATE
    );
    
    INSERT INTO FRIEND (NO, NAME, TEL, ADDRESS)
        VALUES (FRIEND_NO_SEQ.NEXTVAL, '홍길동', NULL, '관악구 신림동');
    INSERT INTO FRIEND (NO, NAME, TEL, ADDRESS)
        VALUES (FRIEND_NO_SEQ.NEXTVAL, '성춘향', '010-9999-9999', '남원');
    
    SELECT * FROM FRIEND;
    
    COMMIT;

    
-- ※※※ QUIZ ※※※
-- 테이블 및 시퀀스 삭제
DROP TABLE MEMBER;
DROP TABLE MEMBER_LEVEL CASCADE CONSTRAINTS;;
DROP SEQUENCE MEMBER_MNO_SQ;
-- 테이블 및 시퀀스 생성
CREATE TABLE MEMBER_LEVEL(
  LEVELNO NUMBER(1) PRIMARY KEY,
  LEVELNAME VARCHAR2(20) NOT NULL
);
CREATE TABLE MEMBER(
    mNO     NUMBER(4)    PRIMARY KEY,
    mNAME   VARCHAR2(20) NOT NULL,
    mPW     VARCHAR2(8)  NOT NULL,
    -- mPW     VARCHAR2(8)  CHECK(LENGTH(MPW) BETWEEN 1 AND 8),
    mEMAIL  VARCHAR2(30) UNIQUE,
    mPOINT  NUMBER(10)   DEFAULT 1000 CHECK(mPOINT>=0),
    mRDATE  DATE         DEFAULT SYSDATE,
    LEVELNO NUMBER(1)    REFERENCES MEMBER_LEVEL(LEVELNO) 
);
CREATE SEQUENCE MEMBER_MNO_SQ MAXVALUE 9999 NOCACHE NOCYCLE;
-- 데이터 입력
INSERT INTO MEMBER_LEVEL VALUES (-1, 'black');
INSERT INTO MEMBER_LEVEL VALUES (0, '일반');
INSERT INTO MEMBER_LEVEL VALUES (1, '실버');
INSERT INTO MEMBER_LEVEL VALUES (2, '골드');
SELECT * FROM MEMBER_LEVEL;
INSERT INTO MEMBER (mNO, mNAME, mPW, mEMAIL, mPOINT, LEVELNO)
    VALUES (MEMBER_MNO_SQ.NEXTVAL, '홍길동', 'aa', 'hong@hong.com', 0, 0);
INSERT INTO MEMBER (mNO, mNAME, mPW, mEMAIL, mRDATE, LEVELNO)
    VALUES (MEMBER_MNO_SQ.NEXTVAL, '신길동', 'bb', 'sin@sin.com', 
            TO_DATE('22/04/01','RR/MM/DD'), 1);
SELECT * FROM MEMBER;

-- 데이터 출력
SELECT MNO, MNAME, TO_CHAR(MRDATE, 'YYYY-MM-DD') mEMAIL, MPOINT POINT, LEVELNAME||'고객' LEVELNAME
  FROM MEMBER M, MEMBER_LEVEL L
  WHERE M.LEVELNO = L.LEVELNO;

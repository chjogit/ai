-- 회원가입 | 전체조회 | 이름찾기 | 메일삭제 | csv내보내기
DROP TABLE MEMBER;

CREATE TABLE MEMBER (
    NAME  VARCHAR2(20),
    PHONE VARCHAR2(30),
    EMAIL VARCHAR2(50),
    AGE   NUMBER(3),
    GRADE NUMBER(1)
);
-- 1. 회원가입
INSERT INTO MEMBER VALUES ('김길동', '010-8888-8888', 'H@h.com', 25, 1);

-- 2. 전체조회 / 5. csv 내보내기
SELECT NAME, PHONE, EMAIL, AGE, GRADE 
    FROM MEMBER
    ORDER BY AGE;
    
-- 3. 이름으로 검색하기
SELECT * FROM MEMBER WHERE NAME = '홍길동';

-- 4. 메일으로 삭제하기
SELECT * FROM MEMBER WHERE UPPER(EMAIL)=UPPER('H@h.com');
DELETE FROM MEMBER WHERE UPPER(EMAIL)=UPPER('h@h.com');

commit;









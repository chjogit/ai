-- DCL(계정생성, 권한부여, 권한박탈, 계정삭제)
-- DDL(타입, 시퀀스없음, FK 지정을 아래에)
-- DML(outer join, and(&&), or(||), 일부 함수)

-- DCL

create user userid identified by 'password'; -- 계정 생성
grant all privileges on *.* to userid; -- 권한 부여
revoke all on *.* from userid; -- 권한 박탈
drop user userid; -- 계정 삭제
-- 데이터 베이스로 들어가기
show databases; -- 데이터베이스들의 리스트
create database devdb; -- 새로운 데이터베이스(devdb) 생성
show databases;
use devdb; -- 데이터베이스로 들어감
use information_schema;
show tables; -- 현재 데이터베이스 내의 테이블들
use devdb;
show tables; -- 현재 데이터베이스 내의 테이블들

-- DDL

/* 
mySQL 타입 : numeric(n, d), varchar(n), date(날짜만), datetime, timestamp(날짜시간)
정수 : tinyint(1byte), smallint(2byte), dediumint(3byte), int/integer(4byte), bigint(8byte)
실수 : float(n, d ; 4byte), double(n, d;8byte)
문자 : char(n), text, longtext(4GB)
*/
drop table if exists friend;
create table friend(
	no   int         primary key auto_increment, -- auto_increment 필드타입은 int
	name varchar(30) not null,
    tel  varchar(30) unique,
    age  numeric(3) default 1 check (age>=0),
    last_modify datetime default now()
);
select * from friend;
insert into friend (name, tel) values ('홍길동', null);
insert into friend (name, tel, age) values ('성춘향', '010-9999-9999', -2);
insert into friend (name, tel, age) values ('성춘향', '010-9999-9999', 22);

-- 파이썬 수업시간에 쓸 테이블 생성
-- DDL과 DML 명령어는 데이터베이스 안에서만 실행됨

select database(); -- 현재 들어와 있는 데이터베이스
use devdb;

drop table if exists person; -- emp 테이블과 유사한 예시 테이블
drop table if exists division; -- dept 테이블과 유사한 예시 테이블

create table division(
	dno int primary key,
    dname varchar(20), 
    phone varchar(20),
    position varchar(20)
);
create table person(
	pno int primary key,
    pname varchar(15) not null,
    job   varchar(15) not null,
    manager int, -- 상사사번
    hiredate date, -- 입사일
    sal     numeric(10),
    comm    numeric(10),
    dno     int,
    foreign key(dno) references division(dno) -- FK 제약조건은 반드시 아래에 따로 명시
);

-- DML

insert into division values (10, 'finance', '02-2088-5679','신림');
insert into division values (20, 'research', '02-555-4321','강남');
insert into division values (30, 'sales', '02-717-4321','마포');
insert into division values (40, 'cs', '031-4444-4321','수원');

insert into person values (1111,'smith','manager', 1001, '1990-12-17', 1000, null, 10);
insert into person values (1112,'ally','salesman',1116,'1991-02-20',1600,500,30);
insert into person values (1113,'word','salesman',1116,'1992-02-24',1450,300,30);
insert into person values (1114,'james','manager',1001,'1990-04-12',3975,null,20);
insert into person values (1001,'bill','president',null,'1989-01-10',7000,null,10);
insert into person values (1116,'johnson','manager',1001,'1991-05-01',3550,null,30);
insert into person values (1118,'martin','analyst',1111,'1991-09-09',3450,null,10);
insert into person values (1121,'kim','clerk',1114,'1990-12-08',4000,null,20);
insert into person values (1123,'lee','salesman',1116,'1991-09-23',1200,0,30);
insert into person values (1226,'park','analyst',1111,'1990-01-03',2500,null,10);
select * from division;
select * from person;

-- 1. 사번, 이름, 급여를 출력
select pno, pname, sal 
	from person;

-- 2. 급여가 2000~5000 사이 모든 직원의 모든 필드
select * from person where sal between 2000 and 5000;
select * from person where sal>=2000 && sal<=5000;
select * from person where sal>=2000 and sal<=5000;

-- 3. 부서번호가 10또는 20인 사원의 사번, 이름, 부서번호
select pno, pname, dno from person where dno in (10,20);
select pno, pname, dno from person where dno=10 || dno=20;
select pno, pname, dno from person where dno=10 or dno=20;

-- 4. 보너스가 null인 사원의 사번, 이름, 급여, 보너스. 급여 큰 순정렬
select pno, pname, sal, comm 
	from person 
    where comm is null 
    order by sal desc;
    
-- 5. 사번, 이름, 부서번호, 급여. 부서코드 순 정렬 같으면 sal 큰순
select pno, pname, dno, sal 
	from person 
    order by dno, sal desc;    
    
-- 6. 사번, 이름, 부서명
select pno, pname, dname 
	from person p, division d 
    where p.dno=d.dno;
    
select pno, pname, dname
	from person p join division d
		on p.dno=d.dno;
    
-- 7. 사번, 이름, 상사이름
select w.pno, w.pname, m.pname
	from person w, person m
    where w.manager=m.pno;
    
select w.pno, w.pname, m.pname
	from person w join person m
		on w.manager=m.pno;

-- 8. 사번, 이름, 상사이름(상사가 없는 사람도 출력하되 상사가 없는 경우 ★CEO★로 출력) – oracle과 다른 문법
select w.pno, w.pname, ifnull(m.pname, '★CEO★') manager
	from person w left join person m
		on w.manager=m.pno;
    
-- 8-1 사번, 이름, 상사사번(상사가 없으면 ceo로 출력. ifnull함수의 매개변수의 타입이 상이해도 상관없음) – oracle과 다른 문법
select pno, pname, ifnull(manager, 'ceo') manager
	from person;
select pno, pname, if(manager is null, 'ceo', manager) manager
	from person;
    
-- 8-2 사번, 이름, 급여, 고액연봉자(4000 이상) or 일반연봉가
select pno, pname, sal, if(sal>=4000, '고액연봉자', '일반연봉자') from person;

-- 9. 이름이 s로 시작하는 사원 이름 (like 이용)
select pname 
	from person 
    where pname like 's%';
    
-- 10. 사번, 이름, 급여, 부서명, 상사이름
select w.pno, w.pname, w.sal,dname, m.pname
	from division d, person w, person m
    where d.dno=w.dno && w.manager=m.pno;
select w.pno, w.pname, w.sal, dname, m.pname
	from division d 
		join person w on d.dno=w.dno
		join person m on w.manager=m.pno;
select w.pno, w.pname, w.sal, dname, m.pname
	from division d 
		join person w on d.dno=w.dno
		left join person m on w.manager=m.pno; -- 상사가 없는 사람도 출력하기 위함
        
-- oracle과 다른 함수들
select sysdate(); -- 현재 날짜와 시간
select current_timestamp();
select now(); -- select절 만으로 실행 가능

-- date_format(날짜/시간필드, 포맷) => 문자형
	-- 포맷 : %Y(년도4자리), %y(년도2자리), %m(월2자리), %M(월이름), %d(일2자리)
           -- %H(24시간), %h(12시간), %p(오전, 오후) %i(분), %s(초)
select pname, date_format(hiredate, '%Y년%m월%d일 %p %h:%i:%s') from person;

-- format(숫자필드, 소수점자리수)
select pname, format(sal, 0) sal from person;

-- 오라클에서의 연결연산자 || 'smith는 manager다'
select pname || '는 ' || job || '다' from person; -- mySQL에서의 ||는 OR연산자
select concat(pname, '는 ', job, '다') from person;


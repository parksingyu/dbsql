--sub7
--1번고객이 먹는 애음 제품
--2번고객도 먹는 애음제품으로 제한
--고객명 추가
SELECT cycle.cid, customer.cnm, product.pid, product.pnm,day, cnt
FROM cycle, customer, product
WHERE cycle.cid = 1
AND cycle.cid = customer.cid
AND cycle.pid = product.pid
AND cycle.pid IN(SELECT pid FROM cycle WHERE cid=2);

--ppt249 (과제 20191112까지)
SELECT a.cid, customer.cnm, a.pid, product.pnm, a.day, a.cnt
FROM (SELECT * --100, 400
      FROM cycle
      WHERE cid = 1
      AND pid IN(SELECT distinct pid
            FROM cycle
            WHERE cid = 2)) a, customer, product
WHERE a.cid = customer.cid
AND a.pid = product.pid;

--ppt252 (과제 20191112까지)
SELECT *
FROM product
WHERE NOT EXISTS (SELECT 'X'
              FROM cycle a
              WHERE product.pid = a.pid
              and cid = 1);
              
SELECT *
FROM dept;



SELECT *
FROM customer;

DELETE DEPT WHERE DEPTNO=99;
COMMIT;

INSERT INTO DEPT
values (99, 'DDIT', 'daejeon');

INSERT INTO customer
VALUES (99, 'ddit');
COMMIT; 

desc emp;

INSERT INTO emp (empno, ename, job)
VALUES (9999, 'brown', null);

SELECT *
FROM emp
WHERE empno = 9999;

-- rollback; --INSERT한 데이터를 commit하지 않고 없애기.

desc emp;

-- 내 DB에 저장되어 있는 테이블
SELECT *
FROM user_tab_columns
WHERE table_name = 'EMP'
ORDER BY column_id;
-----------------

1.empno
2.ename
3.job
4.mgr
5.hiredate
6.sal
7. comm
8. deptno

INSERT INTO emp
VALUES (9999, 'brown', 'ranger', null, sysdate, 2500, null, 40);

--SELECT 결과(여러건)를 INSERT

INSERT INTO emp(empno, ename)
SELECT deptno, dname
FROM dept;

SELECT deptno, dname
FROM dept;

SELECT *
FROM emp;

--UPDATE
--UPDATE 테이블 SET 컬럼=값, 컬럼=값...
--WHERE condition

--

UPDATE dept SET dname='대덕IT', loc='ym'
WHERE deptno=99;

SELECT *
FROM dept;

--고객관리-현금영수증 (야쿠르트여사님-13000, 운영팀, 일반직원, 영업점-650)
--주민번호 뒷자리
update 사용자테이블 set 비밀번호=주민번호뒷자리2;

SELECT *
FROM emp;

--DELETE 테이블명
--WHERE condition
--사원번호가 9999인 직원을 emp 테이블에서 삭제

DELETE emp
WHERE empno=9999;

--부서테이블을 이용해서 emp테이블에 입력한 5건(4건)의 데이터를 삭제
-- 10, 20, 30, 40, 99 --> empno < 100

DELETE emp
WHERE empno BETWEEN 10 AND 99;

rollback;

DELETE emp
WHERE empno IN (SELECT deptno FROM dept);

commit;

--LV1 -> LV3
SET TRANSACTION isolation LEVEL SERIALIZABLE;

--DML문장을 통해 트랜잭션시작
INSERT INTO dept values(98, 'ddit2', 'daejeon');

commit;

SELECT *
FROM dept;

--DDL : AUTO COMMIT , rollback이 안 된다.
--CREATE
CREATE TABLE ranger_new(
    ranger_no NUMBER, --  숫자 타입
    ranger_name VARCHAR2(50), --문자 : [VARCHAR2], CHAR
    reg_dt DATE DEFAULT sysdate  --DEFAULT : SYSDATE
);

desc ranger_new;

--DDL은 rollback이 적용되지 않는다.

rollback;

INSERT INTO ranger_new (ranger_no, ranger_name)
VALUES(1000, 'brown');

SELECT *
FROM ranger_new;

commit;

--날짜타입에서 특정 필드가져오기
--ex : sysdate에서 년도만 가져오기
SELECT TO_CHAR(sysdate, 'YYYY')
FROM dual;

SELECT ranger_no, ranger_name, reg_dt, TO_CHAR(reg_dt, 'MM'), EXTRACT(MONTH FROM reg_dt) month, 
    EXTRACT(YEAR FROM reg_dt) year, EXTRACT(day FROM reg_dt) day
FROM ranger_new;

--제약조건
--DEPT 모방해서 DEPT_TEST 생성
desc dept_test;
CREATE TABLE dept_test(
    deptno number(2) PRIMARY KEY, --deptno 컬럼을 식별자로 지정
    dname varchar2(14),           --식별자로 지정이 되면 값이 중복이 될수 없으며, null일 수도 없다.
    loc varchar2(13)
);

--primary key제약 조건 확인
--1. deptno컬럼에 null이 들어갈 수 없다.
--2. deptno컬럼에 중복된 값이 들어갈 수 없다
INSERT INTO dept_test (deptno, dname, loc)
VALUES (null, 'ddit','daejeon');

INSERT INTO dept_test VALUES (1, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES (1, 'ddit2', 'daejeon');

ROLLBACK;

--사용자 지정 제약조건명을 부여한 PRIMARY KEY
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2) CONSTRAINT PK_DEPT_TEST PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13)
);

DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2),
    dname VARCHAR2(14),
    loc VARCHAR2(13),
    
    CONSTRAINT PK_DEPT_TEST PRIMARY KEY (deptno, dname)
);

INSERT INTO dept_test VALUES (1, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES (1, 'ddit2', 'daejeon');
SELECT *
FROM dept_test;
rollback;

--NOT NULL
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14) NOT NULL,
    loc VARCHAR2(13)
);
INSERT INTO dept_test VALUES(1, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES(2, null, 'daejeon'); --제약조건을 걸었으니까 실행이 안된다.

--UNIQUE
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14) UNIQUE,  -- 값이 유일해야 된다고 조건을 걸어놈
    loc VARCHAR2(13)
);
INSERT INTO dept_test VALUES(1, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES(2, 'ddit', 'daejeon'); --값이 위의 값과 같지 않음. 유니크 하지 않으니 실행불가



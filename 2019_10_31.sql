--테이블에서 데이터 조회
/*
    SELECT 컬럼 | express (문자열상수) [as] 별칭
    FROM 데이터를 조회할 테이블(VIEN)
    WHERE 조건 (condition)
*/

SELECT 'TEST'
FROM emp;


DESC user_tables;
SELECT table_name, 'SELECT * FROM ' || table_name || ';' AS select_query
FROM user_tables
WHERE TABLE_NAME != 'EMP';
--전체건수 - 1


-- 숫자비교 연산
-- 부서번호가 30번 보다 크거나 같은 부서에 속한 직원 조회
SELECT *
FROM emp
WHERE deptno >= 30;

-- 부서번호가 30번 보다 작은 부서에 속한 직원 조회
SELECT *
FROM emp
WHERE deptno < 30;

-- 입사일자가 1982년 1월 1일 이후인 직원 조회
SELECT *
FROM emp
--WHERE hiredate < '82/01/01';
WHERE hiredate < TO_DATE('01011982', 'MMDDYYYY');   -- 11명(미국 날짜 형식)
--WHERE hiredate < TO_DATE('19820101', 'YYYYMMDD');   -- 11명
--WHERE hiredate >= TO_DATE('19820101', 'YYYYMMDD');  --3명
--WHERE hiredate >= TO_DATE('1982/01/01', 'YYYY/MM/DD');

-- BETWEEN X AND Y 연산
-- 컬럼의 값이 x 보다 크거나 같고, y보다 작거나 같은 데이터
-- 급여(sal)가 1000보다 크거나 같고, y보다 작거나 같은 데이터를 조회
SELECT *
FROM emp
where sal between 1000 AND 2000;

--위의 BETWEEN AND 연산자는 아래의 <=, >= 조합과 같다.

SELECT *
FROM emp
where 1000 <= sal 
and sal <= 2000
AND deptno = 30;

--입사일자가 1981년 1월 1일 부터 1981년 12월 31일 사이에 있는
SELECT ename, hiredate
FROM emp
WHERE hiredate BETWEEN TO_DATE('1982/01/01', 'YYYY/MM/DD') AND TO_DATE('1983/01/01', 'YYYY/MM/DD');

SELECT ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE('1982/01/01', 'YYYY/MM/DD') 
AND hiredate <= TO_DATE('1983/01/01', 'YYYY/MM/DD');

--IN 연산자
-- COL IN (values...)
-- 부서번호가 10 혹은 20인 직원 조회
SELECT *
FROM emp
WHERE deptno in (10, 20);

--IN 연산자는 OR연산자로 표현 할수 있다.
SELECT *
FROM emp
WHERE deptno = 10
     OR deptno = 20;
     
SELECT userid, usernm
FROM users
WHERE userid = 'brown'
        or userid = 'cony'
        or userid = 'sally';

--users 테이블에서 userid가 brown, cony, sally인 데이터를 다음과 같이 조회하시오
--(IN 연산자 사용)
SELECT userid as 아이디, usernm as 별명
FROM users
WHERE userid in ('brown', 'cony', 'sally');

--COL like 'S%'
--COL의 값이 대문자 S로 시작하는 모든 값
--COL LIKE 'S____'
--COL의 값이 대문자 S로 시작하고 이어서 4개의 문자열이 존재하는 값

--emp 테이블에서 직원이름이 S로 시작하는 모든 직원 조회
SELECT *
FROM emp
WHERE ename LIKE 'S%';

SELECT *
FROM emp
WHERE ename LIKE 'S____';

--조건에 맞는 데이터 조회하기
--member테이블에서 회원의 성이 [신]씨인 사람의 mem_id, mem_name을 조회하는 쿼리를 작성하시오
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '신%';

SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '%이%';  --mem_name이 문자열안에 이가 포함되는 데이터 
--WHERE mem_name LIKE '이%';  --mem_name이 이로 시작하는 데이터 


SELECT *
FROM dept;
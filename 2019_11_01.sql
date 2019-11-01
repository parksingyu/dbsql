-- 복습
-- WHERE
-- 연산자
-- 비교 : =, !=, <>, >=, >, <=, <
-- BETWEEN start AND end
-- IN (set)
-- LIKE 'S%'  ( % : 다수의 문자열과 매칭, _ :  정확히 한글자 매칭) 
-- IS NULL (!=NULL 이런식으로 안함)
-- AND, OR, NOT 

--emp 테이블에서 입사일자가 1981년 6월 1일부터 1986년 12월 31일까지
--직원 정보 조회

--BETWEEN
SELECT *
FROM emp
WHERE hiredate BETWEEN TO_DATE('19810601', 'YYYYMMDD')
               AND TO_DATE('19861231', 'YYYYMMDD');
               
-- >=, <=
SELECT *
FROM emp
WHERE hiredate >= TO_DATE('19810601', 'YYYYMMDD')
AND hiredate <= TO_DATE('19861231', 'YYYYMMDD');

--emp 테이블에서 관리자(mgr)이 있는 직원만 조회

SELECT *
FROM emp
WHERE MGR IS NOT null;

SELECT *
FROM emp
WHERE job='SALESMAN' or empno LIKE '78%';

-- where13
-- empno는 정수 4자리까지 허용
-- empno : 78, 780, 789
SELECT *
FROM emp
WHERE job = 'SALESMAN'
or empno = 78
or empno between 780 and 789
or empno between 7800 and 7899;

SELECT *
FROM emp
WHERE job = 'SALESMAN'
OR (hiredate >= TO_DATE('19810601', 'YYYYMMDD') AND empno LIKE '78%');

-- order by 컬럼명 | 별칭 | 컬럼인덱스 | (ASC | DESC)
-- order by 구문은 WHERE절 다음에 기술
-- WHERE 절이 없을 경우 FROM절 다음에 기술
-- emp 테이블을 ename 기준으로 오름차순 정렬
SELECT *
FROM emp
ORDER BY ename; --ASC

--이름(ename)을 기준으로 내림차순
SELECT *
FROM emp
ORDER BY ename DESC;

--job을 기준으로 내림차순으로 정렬, 만약 답이 같을 경우 사번(emp)으로 오름차순 정렬
-- SALESMAN - PRESIDENT - MANAGER - CLERK - ANALYST

SELECT *
FROM emp
ORDER BY job DESC, empno ASC;

--별칭으로 정렬하기
--사원 번호(empno), 사원명(ename), 연봉(Sal * 12) as year_sal
--year_sal 별칭으로 오름차순 정렬
SELECT empno, ename, sal * 12 as year_sal
FROM emp
ORDER BY year_sal;

--SELECT절 컬럼 순서 인덱스로 정렬
SELECT empno, ename, sal, sal * 12 as year_sal
FROM emp
ORDER BY 4;

SELECT *
FROM dept
ORDER BY DNAME ASC;

SELECT *
FROM dept
ORDER BY LOC DESC;

SELECT *
FROM emp
where COMM IS NOT NULL
ORDER BY comm DESC, empno ASC;

SELECT *
FROM emp
where mgr IS NOT null
ORDER BY job ASC, empno DESC;

SELECT *
FROM emp
WHERE (deptno = 10 or DEPTNO = 30) AND sal > 1500
ORDER BY ename DESC;

desc emp;

SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM <= 10;

--EMP 테이블에서 사번(empno), 이름(ename)을 급여 기준으로 오름차순 정렬하고
--정렬된 결과순으로 ROWNUM

SELECT empno, ename, sal, ROWNUM
FROM emp
ORDER BY sal;

SELECT ROWNUM, a.*
FROM
(SELECT empno, ename, sal
FROM emp
ORDER BY sal) a;



SELECT ROWNUM, a.*
FROM
(SELECT empno, ename, sal
FROM emp
ORDER BY sal) a;



-- 데이터 정렬(가상컬럼 ROWNUM 실습 row_2)
-- ROWNUM 같이 11~20(11~14)인 값만 조회하는 쿼리를 작성해보세요.
SELECT b.*
FROM
    (SELECT ROWNUM rn, a.*
    FROM
        (SELECT empno, ename
        FROM emp
        ORDER BY sal) a ) b
WHERE rn BETWEEN 11 and 14;


--FUNCTION
--DUAL 테이블 조회
SELECT 'HELLO WORLD' as msg
FROM emp;

--문자열 대소문자 관련 함수
--LOWER, UPPER, INITCAP
SELECT LOWER('Hello, World'), UPPER('Hello, World'), INITCAP('hello, world')
FROM emp
WHERE job = 'SALESMAN';

--FUNCTION은 WHERE절에서도 사용 가능
SELECT *
FROM emp
WHERE ename = UPPER('smith');

--개발자 SQL 칠거지악
--1. 좌변을 가공하지 말아라.
--좌변(TABLE의 컬럼)을 가공하게 되면 INDEX를 정상적으로 사용하지 못함
--FUNCTION BASED

--CONCAT : 문자열 결합 - 두개의 문자열을 결합하는 함수
--SUBSTR : 문자열의 부분 문자열(java : String.substring)
--INSTR : 문자열에 특정 문자열이 등장하는 첫번째 인덱스
--LPAD  
SELECT CONCAT(CONCAT('HELLO',','), 'WORLD') CONCAT,
        SUBSTR('HELLO, WORLD', 0, 5) substr,
        SUBSTR('HELLO, WORLD', 1, 5) substr1,
        LENGTH('HELLO, WORLD') length,
        INSTR('HELLO, WORLD', 'O') instr,
        --INSTR(문자열, 찾을 문자열, 문자열의 특정 위치 이후 표시)
        INSTR('HELLO, WORLD', 'O', 6) instr1, --문자열의 인덱스
        --INSTR(문자열, 찾을 문자열, 문자열의 특정 위치 이후 표시)
        LPAD('HELLO, WORLD', 15, '*') lpad,
        LPAD('HELLO, WORLD', 15) lpad,
        LPAD('HELLO, WORLD', 15, ' ') lpad,
        RPAD('HELLO, WORLD', 15, '*') rpad
FROM dual;



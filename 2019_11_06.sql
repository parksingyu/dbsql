--그룹함수
--multi row function : 여러개의 행을 입력으로 하나의 열과 행을 생성
--SUM, MAX, MIN, AVG, COUNT
--GROUP BY col | express
--SELECT 절에는 GROUP BY 절에 기술된 COL, EXPRESS 표기 가능

-- 직원중 가장 높은 급여 조회 
-- 14개의 행이 입력으로 들어가 하나의 결과가 도출
SELECT MAX(sal) max_sal
FROM emp;

--부서별로 가장 높은 급여 조회
SELECT deptno, MAX(sal) max_sal
FROM emp
GROUP BY deptno;

SELECT *
FROM emp;



SELECT 
      case
            when deptno = 10 then 'ACCOUNTING'
            when deptno = 20 then 'RESEARCH'
            when deptno = 30 then 'SALES'
            else 'none'
       end as DNAME,
       MAX(sal) max_sal,
       MIN(sal) min_sal,
       round(AVG(sal),2) avg_sal,
       sum(sal) sum_sal,
       count(sal) count_sal,
       count(mgr) count_mgr,
       count(*) count_all
FROM emp
GROUP BY deptno
ORDER BY MAX_SAL DESC;

--grp4 (ppt 163)
SELECT 
    TO_CHAR(hiredate, 'yyyymm') as HIRE_YYYYMM,
    --count(TO_CHAR(hiredate, 'yyyymm')) cnt  (이것도 상관 없음)
    count(*) cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'yyyymm');

--grp5 (ppt 164)
SELECT TO_CHAR(hiredate, 'yyyy') as HIRE_YYYY, count(TO_CHAR(hiredate, 'yyyy')) as cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'yyyy');

--grp6
SELECT count(deptno) cnt
FROM dept;

--JOIN
--emp 테이블에는 dname 컬럼이 없다 -->부서번호(deptno)밖에 없음
desc emp;

--emp테이블에 부서이름을 저장할 수 있는 dname 컬럼 추가
alter TABLE emp ADD (dname VARCHAR2(14));

SELECT *
FROM emp;

-- emp테이블의 dname컬럼에 accounting을 추가한다. 조건: deptno가 10일 경우.
UPDATE emp SET dname = 'ACCOUNTING' WHERE DEPTNO = 10;

-- emp테이블의 dname컬럼에 RESEARCH을 추가한다. 조건: deptno가 20일 경우.
UPDATE emp SET dname = 'RESEARCH' WHERE DEPTNO = 20;

-- emp테이블의 dname컬럼에 SALES을 추가한다. 조건: deptno가 30일 경우.
UPDATE emp SET dname = 'SALES' WHERE DEPTNO = 30;
COMMIT;

SELECT dname, MAX(sal) max_sal
FROM emp
GROUP BY dname;

ALTER TABLE emp DROP COLUMN DNAME;

SELECT *
FROM emp;

--ansi natural join : 조인하는 테이블의 컬러명이 같은 컬럼을 기준으로 JOIN
SELECT deptno, ename, dname
FROM EMP NATURAL JOIN DEPT;

--ORACLE join
SELECT emp.empno, emp.ename, emp.deptno, dept.dname, dept.loc
FROM emp, dept
WHERE emp.deptno = dept.deptno;


SELECT e.empno, e.ename, e.deptno, d.dname, d.loc
FROM emp e, dept d
WHERE e.deptno = d.deptno;


--ANSI JOIN WITH USING
SELECT emp.empno, emp.ename, dept.dname
FROM emp JOIN dept USING (deptno);

--from 절에 조인 대상 테이블 나열
--where절에 조인조건 기술
--기존에 사용하던 조건 제약도 기술 가능
SELECT emp.empno, emp.ename, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
    AND emp.job = 'SALESMAN'; --job이 SALES인 사람만 대상으로 조회
    
-- JOIN with ON (개발자가 조인 컬럼을 on절에 직접 기술)
SELECT emp.empno, emp.ename, dept.dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno);

--SELF join : 같은 테이블끼리 조인
--emp테이블의 mgr 정보를 참고하기 위해서 emp 테이블과 조인을 해야한다.
--a : 직원 정보, b : 관리자
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a JOIN emp b ON(a.mgr = b.empno)
WHERE a.empno between 7369 AND 7698;


SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno
AND a.empno between 7369 AND 7698;

SELECT *
FROM emp;

--non-equijoing(등식 조인이 아닌경우)
SELECT *
FROM salgrade;

SELECT *
FROM emp;

SELECT emp.empno, emp.ename, emp.sal, salgrade.*
FROM emp JOIN salgrade ON(emp.sal BETWEEN salgrade.losal AND salgrade.hisal);

--직원의 급여 등급은???
SELECT emp.empno, emp.ename, emp.deptno, 
FROM emp, salgrade
WHERE emp.sal BETWEEN salgrade.losal AND salgrade.hisal;

SELECT emp.empno, emp.ename, dept.deptno, dept.dname
FROM emp, dept
where emp.deptno = dept.deptno
ORDER BY DNAME;

SELECT emp.empno, emp.ename, emp.deptno, dept.dname
FROM emp, dept
where emp.deptno = dept.deptno;
and emp.deptno IN(10, 30);

SELECT *
FROM emp ;

SELECT *
FROM dept;




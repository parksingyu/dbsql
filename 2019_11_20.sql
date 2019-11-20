-- GROUPING (cube, rollup 절의 사용된 컬럼)
-- 해당 컬럼이 소계 계산에 사용된 경우 1
-- 사용되지 않은 경우 0
SELECT job, deptno, GROUPING(job), GROUPING(deptno), sum(sal) sal
FROM emp
GROUP BY ROLLUP(job, deptno);

--job 컬럼
--case1. GROUPING(job)=1 AND GROUPING(deptno) = 1
--       job --> '총계'
--case esle
--       job --> job

SELECT CASE WHEN GROUPING(job) = 1 AND
                 GROUPING(deptno) = 1 THEN '총계'
            ELSE job
        END job, deptno,
        GROUPING(job), GROUPING(deptno), sum(sal) sal
FROM emp
GROUP BY ROLLUP(job, deptno);

SELECT CASE WHEN GROUPING(job) = 1 AND
                 GROUPING(deptno) = 1 THEN '총계'
            ELSE job
        END job,
        
        CASE WHEN GROUPING(job) = 0 AND
                 GROUPING(deptno) = 1 THEN job || ' 소계'
            ELSE TO_CHAR(deptno)
        END deptno,
        
        /*GROUPING(job), GROUPING(deptno),*/ sum(sal) sal
FROM emp
GROUP BY ROLLUP(job, deptno);

-- 과제1. ppt25~27 
-- 과제2. git kraken 설치 (https://www.gitkraken.com)
--SQL응용 ppt25(실습 GROUP_AD3)
SELECT deptno, job, sum(sal) sal
FROM emp
GROUP BY ROLLUP(deptno, job);

--SQL응용 ppt26 (실습 GROUP_AD4)
SELECT a.dname, job, sum(sal) sal
FROM (SELECT *
      FROM emp, dept
      WHERE emp.deptno = dept.deptno) a
GROUP BY ROLLUP(a.dname, a.job)
ORDER BY a.dname, a.job desc;

--SQL응용 ppt27 (실습 GROUP_AD5)
SELECT CASE WHEN GROUPING(dept.dname) = 1 AND
                 GROUPING(job) = 1 THEN '총합'
            ELSE dept.dname
        END DNAME, job, sum(sal) sum
FROM emp, dept
WHERE emp.deptno = dept.deptno
GROUP BY rollup(dept.dname, job)
ORDER BY dept.DNAME, sum desc;

--CUBE (col, col2...)
--CUBE 절에 나열된 컬럼의 가능한 모든 조합에 대해 서브 그룹으로 생성
--CUBE에 나열된 컬럼에 대해 방향성은 없다(rollup과의 차이)
--GROUP BY CUBE(job, deptno)
-- 00 : GROUP BY job, deptno
-- 0X : GROUP BY job
-- X0 : GROUP BY deptno
-- XX : GROUP BY -- 모든 데이터에 대해서...

SELECT job, deptno, SUM(sal)
FROM emp
GROUP BY CUBE(job, deptno);

SELECT *
FROM emp;

SELECT deptno, job, sum(sal)
FROM emp
GROUP BY deptno, job;

DROP TABLE emp_test;

--emp테이블의 데이터를 포함해서 모든 컬럼을 이용하여 emp_test테이블로 생성  (테이블 복사!) emp -> emp_test
CREATE TABLE emp_test AS
SELECT *
FROM emp;

--emp_test 테이블의 dept테이블에서 관리되고 있는 dname 컬럼을 추가
ALTER TABLE emp_test ADD (dname VARCHAR2(14));

SELECT *
FROM emp_test;

--emp_test테이블의 dname 컬럼을 dept테이블의 dname컬럼 값으로 업데이트하는 쿼리 작성
UPDATE emp_test SET dname = ( SELECT dname
                              FROM dept
                              WHERE dept.deptno = emp_test.deptno);
commit;

--dept테이블을 이용하여 dept_test 테이블 생성
CREATE TABLE dept_test AS
SELECT *
FROM dept;

--dept_test테이블에 empcnt(number) 컬럼 추가
ALTER TABLE dept_test ADD (empcnt number); 

-- 서브쿼리에 들어갈 쿼리 작성
SELECT count(deptno)
FROM emp
GROUP BY deptno;


-- subquery를 이용하여 dept_test 테이블의 empcnt컬럼에
-- 해당 부서원 수를 update쿼리를 작성하세요
ALTER TABLE emp_test ADD (empcnt number);
UPDATE dept_test SET empcnt = ( SELECT count(deptno)
                                FROM emp
                                WHERE emp.deptno = dept_test.deptno
                                GROUP BY deptno);

--결과 보기
SELECT *
FROM dept_test;

-- emp테이블의 직원들이 속하지 않은 부서 정보는 삭제하는 쿼리를
-- 서브쿼리를 이용하여 작성하세요.
DELETE dept_test WHERE NOT EXISTS (SELECT count(emp.deptno)
                                FROM emp
                                WHERE emp.deptno = dept_test.deptno
                                GROUP BY emp.deptno);

SELECT count(emp.deptno)
FROM emp, dept_test
WHERE emp.deptno = dept_test.deptno
GROUP BY emp.deptno;

--EMP 테이블을 이용하여 EMP_TEST 테이블 생성
CREATE TABLE emp_test AS
SELECT *
FROM EMP;
--
UPDATE emp_test 
SET sal = sal + 200
WHERE (SELECT round(sum(sal)/count(deptno),2) average
         FROM emp_test
         GROUP BY deptno) > (SELECT sal FROM emp_test) ;

SELECT /*count(deptno), deptno, sum(sal) ,*/ round(sum(sal)/count(deptno),2) average
FROM emp_test
GROUP BY deptno;

SELECT avg(sal)
FROM emp_test
GROUP BY deptno;

--SUBQUERY를 이용하여 emp_test 테이블에서 본인이 속한 부서의 (SAL) 평균 급여보다 급여가
-- 작은 직원의 급여를 현 급여에서 200을 추가해서 업데이트 하는 쿼리를 작성하세요
UPDATE emp_test a SET sal = sal+200
WHERE  sal <
    (SELECT AVG(sal)
    FROM emp_test b
    WHERE b.deptno = a.deptno);

--결과 확인
SELECT *
FROM emp_test;

commit;



--emp, emp_test empno 컬럼으로 같은 값끼리 조회
--1. emp.empno, emp.ename, emp.sal, emp_test.sal
--2. emp.empno, emp.ename, emp.sal, emp_test.sal,
-- 해당사원(emp테이블 기준)이 속한 부서의 급여평균
SELECT emp.empno, emp.ename, emp.SAL, emp_test.sal, emp.deptno ,a.b SAL_AVG
FROM emp, emp_test, (SELECT deptno, round(avg(sal),2) b
                    FROM emp
                    GROUP BY deptno) a
WHERE emp.empno = emp_test.empno
AND emp.deptno = a.deptno;


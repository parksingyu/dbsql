--123

SELECT empno, ename, sal, deptno,
       RANK() OVER (PARTITION BY deptno ORDER BY sal) rank,
       DENSE_RANK() OVER (PARTITION BY deptno ORDER BY sal) d_rank,
       ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal) rown
FROM emp;

--분석함수 
--사원의 전체 급여 순위를 rank, dense_rank, row_number를 이용하여 구하세요.
--단, 급여가 동일할 경우 사번이 빠른 사람이 높은순위가 되도록 작성하세요.
SELECT empno, ename, sal, deptno,
       rank() OVER (ORDER BY sal desc, empno asc) sal_rank,
       DENSE_rank() OVER (ORDER BY sal desc, empno asc) sal_dense_rank,
       ROW_NUMBER() OVER (ORDER BY sal desc, empno asc) sal_row_rank
FROM emp;

--SQL 응용 ppt p.106
--분석함수 / window 함수(실습 no_ana2)
--기존의 배운 내용을 활용하여, 모든 사원에 대해 사원번호, 사원이름, 해당 사원이 속한 부서의
--사원 수를 조회하는 쿼리를 작성하세요.
SELECT empno, ename, a.deptno, a.cnt
FROM(
SELECT deptno, count(deptno) cnt
FROM emp
GROUP BY deptno)a, emp
WHERE a.deptno=emp.deptno
ORDER BY deptno;

-- 분석함수를 통한 부서별 직원수(count)
SELECT ename, empno, deptno, 
       count(*) OVER(PARTITION BY deptno) cnt
FROM emp;

--부서별 사원의 급여 합계
--SUM 분석함수
SELECT ename, empno, deptno, sal,
       sum(sal) OVER(PARTITION BY deptno) sum_sal
FROM emp;

--SQL 응용 ppt p.109
--분석함수 / window 함수(실습 ana2)
---window function을 이용하여 모든 사원에 대해 사원번호, 사원이름, 본인급여,
---부서번호와 해당 사원이 속한 부서의 급여 평균을 조회 하는 쿼리를
---작성하세요(급여 평균은 소수점 둘째 자리까지 구한다)
SELECT empno, ename, sal, deptno, 
    round(avg(sal) OVER(PARTITION BY deptno),2) avg_sal
FROM emp;

--SQL 응용 ppt p.110
--분석함수 / window 함수(실습 ana3)
---window function을 이용하여 모든 사원에 대해 사원번호, 사원이름 본인급여,
---부서번호와 해당 사원이 속한 부서의 가장 높은 급여를 조회하는 쿼리를 작성하세요.
SELECT empno, ename, sal, deptno, 
    max(sal) OVER(PARTITION BY deptno) max_sal
FROM emp;

--SQL 응용 ppt p.111
--분석함수 / window 함수(실습 ana3)
---window function을 이용하여 모든 사원에 대해 사원번호, 사원이름 본인급여,
---부서번호와 해당 사원이 속한 부서의 가장 높은 급여를 조회하는 쿼리를 작성하세요.
SELECT empno, ename, sal, deptno, 
    min(sal) OVER(PARTITION BY deptno) min_sal
FROM emp;

--부서별 사원번호가 가장 빠른사람
--부서별 사원번호가 가장 느린사람
SELECT empno, ename, deptno, 
       FIRST_VALUE(empno) OVER (PARTITION BY deptno ORDER BY empno) f_emp,
       LAST_VALUE(empno) OVER (PARTITION BY deptno ORDER BY empno) l_emp
FROM emp;

--LAG(이전행)
--현재행
--LEAD(다음행)
--급여가 높은순으로 정렬 했을때 자기보다 한단계 급여가 낮은 사람의 급여,
--                        자기보다 한단계 급여가 높은 사람의 급여

SELECT empno, ename, sal, 
       LAG(sal) OVER(ORDER BY sal) lag_sal,
       LEAD(sal) OVER(ORDER BY sal) lead_sal 
FROM emp;

--SQL 응용 ppt p.115
--분석함수 / window 함수(실습 ana5)
---window function을 이용하여 모든 사원에 대해 사원번호, 사원이름, 입사일자, 급여,
---전체 사원중 급여 순위가 1단계 높은 사람의 급여를 조회하는 쿼리를 작성하세요
---(급여가 같을 경우 입사일이 빠른 사람이 높은 순위)
SELECT empno, ename, hiredate, sal,
       LEAD(sal) OVER(ORDER BY sal desc) lead_sal 
FROM emp;

--분석함수 / window 함수 (그룹 내 행순서 실습 ana6)
---window function 을 이용하여 모든 사원에 대해 사원번호, 사원이름,
---입사일자, 직군(job), 급여 정보와 담당업무(JOB) 별 급여순위가 1단계 높은
---사람의 급여를 조회하는 쿼리를 작성하세요(급여가 같을경우 입사일이 빠른사람이 우선순위
SELECT empno, ename, hiredate, job, sal,
       LAG(sal) OVER(PARTITION BY job ORDER BY job desc, sal desc) lead_sal 
FROM emp;

--SELECT a.*, rownum rn, b.sal
SELECT a.empno, a.ename, a.sal a_sal, a.rn, b.sal b_sal, a.sal+b.sal
FROM
    (SELECT a.*, rownum-1 rn
    FROM(
    SELECT empno, ename, sal
    FROM emp
    ORDER BY sal) a)a,
    
    (SELECT a.*, rownum rn
    FROM(
    SELECT empno, ename, sal
    FROM emp
    ORDER BY sal) a)b
WHERE a.rn = b.rn(+)
ORDER BY a.sal;

SELECT a.empno, a.ename, a.sal, sum(b.sal)
    FROM(
        SELECT a.*, rownum rn
        FROM(
        SELECT *
            FROM emp
            ORDER BY sal) a) a,
        (
        SELECT a.*, rownum rn
        FROM(
            SELECT *
            FROM emp
            ORDER BY sal) a) b
    WHERE a.rn >= b.rn
    GROUP BY a.empno, a.ename, a.sal, a.rn
    ORDER BY a.sal, empno;
    
--WINDOWING
--UNBOUNDED PRECEDING : 현재 행을 기준으로 선행하는 모든 행
--CURRENT ROW : 현재 행
--UNBOUNDED FOLLOWING : 현재 행을 기준으로 후행하는 모든행
--N(정수) PRECEDING : 현재 행을 기준으로 선행하는 N개의 행
--N(정수) FOLLOWING : 현재 행을 기준으로 후행하는 N개의 행

SELECT empno, ename, sal,
       sum(sal) OVER (ORDER BY sal, empno 
       ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) sum_sal, --현재 행까지 더한 값
       
       sum(sal) OVER (ORDER BY sal, empno 
       ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) sum_sal2, 
       sum(sal) OVER (ORDER BY sal, empno 
       ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) sum_sal3 -- 선행, 후행, 본인 을 다 더한 값
FROM emp;

SELECT empno, ename, deptno, sal, 
       sum(sal) OVER (PARTITION BY deptno ORDER BY deptno
       ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) sum_sal 
FROM emp
ORDER BY deptno, sal, empno;

--ana7
SELECT empno, ename, deptno, sal,
       SUM(sal) OVER (PARTITION BY deptno 
                      ORDER BY sal, empno
                      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) c_sum
FROM emp;

SELECT empno, ename, deptno, sal,
       sum(sal) OVER (ORDER BY sal 
                      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) row_sum,
       sum(sal) OVER (ORDER BY sal 
                      ROWS UNBOUNDED PRECEDING) row_sum2,
       sum(sal) OVER (ORDER BY sal 
                      RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) RANGE_sum,
       sum(sal) OVER (ORDER BY sal 
                      RANGE UNBOUNDED PRECEDING) RANGE_sum2
FROM emp;

--알아보기
--RATIO_TO_REPORT
--PERCENT_RANK
--CUME_DIST
--NTILE
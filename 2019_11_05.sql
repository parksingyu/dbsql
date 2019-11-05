-- 년월 파라미터가 주어졌을 때 해당년월의 일수를 구하는 문제
-- 201911 --> 30 / 201912  --> 31

--한달 더한 후 원래값을 빼면 = 일수
--마지막날짜 구한 후 --> DD 만 추출
SELECT TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')), 'DD') day_cnt  -- 바인딩 하는 방법
FROM DUAL;   --201602라고 입력하면 윤년이어서 29가 출력된다.

SELECT :yyyymm as PARAM, TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')), 'DD') dt  -- 바인딩 하는 방법
FROM DUAL;   --201602라고 입력하면 윤년이어서 29가 출력된다.


explain plan for
SELECT *
FROM emp
WHERE TO_CHAR(empno) = '7369';

SELECT empno, ename, sal, TO_CHAR(sal, 'L999,999.99') sal_fmt
FROM emp;

--function null
--nvl(coll, coll이 null일 경우 대체할 값)
SELECT empno, ename, sal, comm, nvl(comm, 0) nvl_comm, sal+comm, sal + nvl(comm, 0), nvl(sal+comm, 0)
FROM emp;

--NVL2(coll, coll이 null이 아닐 경우 표현되는 값, coll null일 경우 표현 되는 값)
SELECT empno, ename, sal, comm, NVL2(comm, comm, 0) + sal
FROM emp;

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

--NULLIF(expr1, expr2)
--expr1 == expr2 같으면 null
--else : expr1
SELECT empno, ename, sal, comm, NULLIF(sal, 1250)
FROM emp;

--COALESCE(expr1, expr2, expr3....)
--함수 인자중 null이 아닌 첫번째 인자
SELECT empno, ename, sal, comm, coalesce(comm, sal)
FROM emp;

--nvl, nvl2, coalesce
SELECT empno, ename, MGR, nvl(MGR, 9999) as MGR_N, coalesce(MGR, 9999) as MGR_N, nvl2(MGR, MGR, 9999) as MGR_N
FROM emp;

SELECT userid, usernm, reg_dt, nvl(reg_dt, sysdate) as N_REG_DT
FROM users;

--case when
SELECT empno, ename, job, sal,
    case
            when job = 'SALESMAN' then sal * 1.05
            when job = 'MANAGER' then sal * 1.10
            when job = 'PRESIDENT' then sal * 1.20
            else sal 
    end as case_sal
FROM emp;

--decode (col, search1, return1, search2, return2....default)
SELECT empno, ename, job, sal,
        DECODE(job, 'SALESMAN', sal*1.05,
        'MANAGER', sal * 1.10,
        'PRESIDENT', sal * 1.20,
                            sal) decode_sal
FROM emp;

SELECT empno, ename,
    DECODE(
        deptno, 10, 'ACCOUNTING',
        20, 'RESEARCH',
        30, 'SALES',
        40, 'OPERTAIONS',
                    'DDIT') dname
FROM emp;

SELECT empno, ename,
    case
        when deptno = '10' then 'ACCOUNTING'
        when deptno = '20' then 'RESEARCH'
        when deptno = '30' then 'SALES'
        when deptno = '40' then 'OPERTAIONS'
        else 'DDIT'
    end as DNAME, DEPTNO
FROM emp;

SELECT empno, ename, hiredate,
    DECODE(
        MOD(TO_CHAR(hiredate, 'yy'),2), 0, '건강검진 비대상자'
        , 1, '건강검진 대상자', 
                        'DDIT') CONTACT
FROM emp;

SELECT empno, ename, hiredate,
    case
        when MOD(TO_CHAR(hiredate, 'yy'),2) = 0 then '건강검진 비대상자'
        when MOD(TO_CHAR(hiredate, 'yy'),2) = 1 then '건강검진 대상자'
        else 'DDIT'
    end as CONTACT_TO_DOCTOR
FROM emp;


-- 1. 올해 년도 구하기
-- 2. 올해 년도가 짝수인지 계산
-- 어떤수를 2로 나누면 나머지는 항상 2보다 작다
-- 2로 나눌 경우 나머지는 0 또는 1
-- MOD(대상, 나눌값) 
SELECT TO_CHAR(hiredate, 'yy')
FROM emp;

SELECT MOD(TO_CHAR(sysdate, 'yy'), 2)
FROM dual;

--emp 테이블에서 입사일자가 홀수년인지 짝수년인지 확인
SELECT empno, ename, hiredate, MOD(TO_CHAR(hiredate, 'yy'), 2) as y1, MOD(TO_CHAR(sysdate, 'yy'), 2) y2,
    case 
        when y1 = y2 then '건강검진 대상'
        else '건강검진 비대상'
    end contact_to_doctor
FROM emp;

SELECT USERID, USERNM, REG_DT, MOD(TO_CHAR(sysdate, 'yy'), 2) thisyear, MOD(TO_CHAR(reg_dt, 'yy'), 2) as y1,
    case
        when MOD(TO_CHAR(sysdate, 'yy'), 2) = MOD(TO_CHAR(reg_dt, 'yy'), 2) then '건강검진 대상자'
        else '건강검진 비대상자'
    end as contacttodoctor
FROM users;

--그룹함수(AVG, MAX, MIN, SUM, COUNT)
--그룹함수는 NULL값을 계산대상에서 제외한다.
--SUM(comm), COUNT(*), COUNT(mgr)
--직원중 가장 높은 급여를 받는사람의 급여
--직원중 가장 낮은 급여를 받는사람의 급여
--직원의 급여 평균(소수점 둘째자리 까지만 나오게 --> 소수점 3째자리에서 반올림)
--직원의 급여 전체합
SELECT MAX(sal) max_sal, MIN(sal) min_sal,
       round(AVG(sal),2) avg_sal,
       SUM(sal) sum_sal,
       count(*) emp_cnt,
       COUNT(sal) sal_cnt,
       COUNT(mgr) mgr_cnt,
       SUM(comm) comm_sum
FROM emp;

--부서별 가장 높은 급여를 받는사람의 급여
--GROUP BY 절에 기술되지 않은 컬럼이 SELECT 절에 기술될 경우 에러
SELECT deptno, MAX(sal) max_sal, MIN(sal) min_sal,
       round(AVG(sal),2) avg_sal,
       SUM(sal) sum_sal,
       count(*) emp_cnt,
       COUNT(sal) sal_cnt,
       COUNT(mgr) mgr_cnt,
       SUM(comm) comm_sum
FROM emp
GROUP BY deptno;

--부서별 최대 급여

SELECT deptno, MAX(sal) max_sal
FROM emp
GROUP BY deptno
HAVING MAX(sal) > 3000;

SELECT MAX(sal) max_sal,
       MIN(sal) min_sal,
       round(AVG(sal),2) avg_sal,
       sum(sal) sum_sal,
       count(sal) count_sal,
       count(mgr) count_mgr,
       count(*) count_all
FROM emp;

SELECT deptno,
       MAX(sal) max_sal,
       MIN(sal) min_sal,
       round(AVG(sal),2) avg_sal,
       sum(sal) sum_sal,
       count(sal) count_sal,
       count(mgr) count_mgr,
       count(*) count_all
FROM emp
GROUP BY deptno;

SELECT *
from emp;




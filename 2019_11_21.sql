--서브쿼리 ADVANCED(WITH)
--부서별 평균 급여가 직원 전체의 급여 평균보다(2073.21) 
--높은 부서의 부서번호(10, 20)와 부서별 급여 평균 금액 조회(10:2916.67, 20:2175)

--1. 전체 직원의 급여 평균 -- 2073.21
SELECT round(AVG(sal),2)
FROM emp;

--2. 부서별 급여 평균  10: 2916.687 / 20: 2175 / 30: 1566.67
SELECT deptno, round(AVG(sal),2)
FROM emp
GROUP BY deptno;

--방법1
SELECT *
FROM (SELECT deptno, round(AVG(sal),2) d_avgsal
      FROM emp
      GROUP BY deptno)
WHERE d_avgsal > (SELECT round(AVG(sal),2)
                  FROM emp);

--방법2                  
SELECT *
FROM (SELECT deptno, round(AVG(sal),2) d_avgsal
      FROM emp
      GROUP BY deptno)
WHERE d_avgsal > (2073.21);

--쿼리 블럭을 WITH절에 선언하여
--쿼리를 간단하게 표현한다.
WITH dept_avg_sal AS(
      SELECT deptno, round(AVG(sal),2) d_avgsal
      FROM emp
      GROUP BY deptno
)
SELECT *
FROM dept_avg_sal
WHERE d_avgsal > (SELECT ROUND(AVG(sal), 2) FROM emp);

--달력 만들기
--SETP1. 해당 년월의 일자 만들기
--CONNECT BY LEVERL

--201911
--DATE + 정수 = 일자 더하기 연산
SELECT TO_DATE(:YYYYMM, 'YYYYMM') + (level-1), TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')), 'DD')
FROM dual a
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')), 'DD');

SELECT MAX(DECODE(d, 1, dt)) sun, MAX(DECODE(d, 2, dt)) mon, MAX(DECODE(d, 3, dt)) tues,
       MAX(DECODE(d, 4, dt)) wed, MAX(DECODE(d, 5, dt)) thu, MAX(DECODE(d, 6, dt)) fri, MAX(DECODE(d, 7, dt)) sat
FROM
    (SELECT TO_DATE(:YYYYMM, 'YYYYMM') + (level-1) dt,
           TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (level-1), 'iw' ) iw,
           TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (level-1), 'd') d
    FROM dual a
    CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')), 'DD')) a
GROUP BY decode(d, 1, a.iw+1, a.iw)
ORDER BY decode(d, 1, a.iw+1, a.iw);

SELECT NVL(MAX(DECODE(TO_CHAR(DT, 'MM'), '01', SUM(sales))),0) jan,
    NVL(MAX(DECODE(TO_CHAR(DT, 'MM'), '02', SUM(sales))),0) feb,
    NVL(MAX(DECODE(TO_CHAR(DT, 'MM'), '03', SUM(sales))),0) mar,
    NVL(MAX(DECODE(TO_CHAR(DT, 'MM'), '04', SUM(sales))),0) apr,
    NVL(MAX(DECODE(TO_CHAR(DT, 'MM'), '05', SUM(sales))),0) may,
    NVL(MAX(DECODE(TO_CHAR(DT, 'MM'), '06', SUM(sales))),0) june
FROM sales
GROUP BY TO_CHAR(DT, 'MM');
--
SELECT *
FROM sales;
-- 
create table sales as 
select to_date('2019-01-03', 'yyyy-MM-dd') dt, 500 sales from dual union all
select to_date('2019-01-15', 'yyyy-MM-dd') dt, 700 sales from dual union all
select to_date('2019-02-17', 'yyyy-MM-dd') dt, 300 sales from dual union all
select to_date('2019-02-28', 'yyyy-MM-dd') dt, 1000 sales from dual union all
select to_date('2019-04-05', 'yyyy-MM-dd') dt, 300 sales from dual union all
select to_date('2019-04-20', 'yyyy-MM-dd') dt, 900 sales from dual union all
select to_date('2019-05-11', 'yyyy-MM-dd') dt, 150 sales from dual union all
select to_date('2019-05-30', 'yyyy-MM-dd') dt, 100 sales from dual union all
select to_date('2019-06-22', 'yyyy-MM-dd') dt, 1400 sales from dual union all
select to_date('2019-06-27', 'yyyy-MM-dd') dt, 1300 sales from dual;
--





-- 달력 따온거
SELECT MIN (DECODE (TO_CHAR (YM + LEVEL - 1, 'D'), '1', LEVEL)) SUN 
, MIN (DECODE (TO_CHAR (YM + LEVEL - 1, 'D'), '2', LEVEL)) MON 
, MIN (DECODE (TO_CHAR (YM + LEVEL - 1, 'D'), '3', LEVEL)) TUE 
, MIN (DECODE (TO_CHAR (YM + LEVEL - 1, 'D'), '4', LEVEL)) WED 
, MIN (DECODE (TO_CHAR (YM + LEVEL - 1, 'D'), '5', LEVEL)) THU 
, MIN (DECODE (TO_CHAR (YM + LEVEL - 1, 'D'), '6', LEVEL)) FRI 
, MIN (DECODE (TO_CHAR (YM + LEVEL - 1, 'D'), '7', LEVEL)) SAT 
 FROM (select to_date('201911','yyyymm') ym FROM DUAL) 
CONNECT BY LEVEL <= LAST_DAY (YM) - YM + 1 
GROUP BY TRUNC (YM + LEVEL, 'iw') 
ORDER BY SAT ;
------------------------------------------------------------------


--계층쿼리

-----------------------------
create table dept_h (
    deptcd varchar2(20) primary key ,
    deptnm varchar2(40) not null,
    p_deptcd varchar2(20),
    
    CONSTRAINT fk_dept_h_to_dept_h FOREIGN KEY
    (p_deptcd) REFERENCES  dept_h (deptcd) 
);

insert into dept_h values ('dept0', 'XX회사', '');
insert into dept_h values ('dept0_00', '디자인부', 'dept0');
insert into dept_h values ('dept0_01', '정보기획부', 'dept0');
insert into dept_h values ('dept0_02', '정보시스템부', 'dept0');
insert into dept_h values ('dept0_00_0', '디자인팀', 'dept0_00');
insert into dept_h values ('dept0_01_0', '기획팀', 'dept0_01');
insert into dept_h values ('dept0_02_0', '개발1팀', 'dept0_02');
insert into dept_h values ('dept0_02_1', '개발2팀', 'dept0_02');
insert into dept_h values ('dept0_00_0_0', '기획파트', 'dept0_01_0');
commit;
-----------------------------
--계층쿼리
--START WITH : 계층의 시작 부분을 정의
--CONNECT BY : 계층간 연결 조건을 정의

--하향식 계층쿼리 (가장 최상위 조직에서부터 모든 조직을 탐색)
SELECT dept_h.*, LEVEL, RPAD(' ', (LEVEL-1)*4, ' ') || dept_h.deptnm DEPTNM
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR DEPTCD = p_deptcd; --PRIOR 현재 읽은 데이터(XX회사)


-- 정보시스템부 하위의 부서계층 구조를 조회하는 쿼리를 작성하세요.
SELECT dept_h.deptcd, RPAD(' ', (LEVEL-1)*4, ' ') || dept_h.deptnm DEPTNM, dept_h.p_deptcd
FROM dept_h
START WITH deptcd = 'dept0_02'
CONNECT BY PRIOR DEPTCD = p_deptcd; --PRIOR 현재 읽은 데이터(XX회사)

SELECT a.*, level
FROM dept_h a
CONNECT BY PRIOR DEPTCD = p_deptcd; --PRIOR 현재 읽은 데이터(XX회사)



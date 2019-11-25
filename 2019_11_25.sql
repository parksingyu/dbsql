-- member 테이블을 이용하여 member2 테이블을 생성
-- member2 테이블에서
-- 김은대 회원(mem_id='a001')의 직업(mem_job)을 '군인'으로 변경후
-- commit

CREATE TABLE MEMBER2
as SELECT * FROM member;

UPDATE member2 SET mem_job='군인'
WHERE MEM_ID='a001';
commit;

SELECT mem_id, mem_name, mem_job
FROM member2
WHERE mem_id='a001';
--------------------------------------------------
--제품별 제품 구매 수량(BUY_QTY) 합계, 제품 구입 금액(BUY_COST) 합계
--제품코드, 제품명, 수량합계, 금액합계
SELECT buy_prod, sum(BUY_QTY) sum_qty, sum(buy_cost) sum_cost
FROM buyprod
GROUP BY BUY_PROD;

--제품코드, 제품명, 수량합계, 금액합계
SELECT buy_prod, b.prod_name, sum_qty, sum_cost
FROM(
SELECT buy_prod, sum(BUY_QTY) sum_qty, sum(buy_cost) sum_cost
FROM buyprod, prod
GROUP BY BUY_PROD) a, prod b
WHERE a.buy_prod = b.prod_id;

--VW_PROD_BUY(view 생성)
CREATE OR REPLACE VIEW VW_PROD_BUY AS
SELECT buy_prod, b.prod_name, sum_qty, sum_cost
FROM(
SELECT buy_prod, sum(BUY_QTY) sum_qty, sum(buy_cost) sum_cost
FROM buyprod, prod
GROUP BY BUY_PROD) a, prod b
WHERE a.buy_prod = b.prod_id;
commit;

--결과 확인
SELECT *
FROM USER_VIEWS;

SELECT *
FROM USER_TABLES;

SELECT *
FROM buyprod;

SELECT * 
FROM prod;

--선생님이 말한 중간단계
SELECT *
FROM(
SELECT b.ename, b.sal, b.deptno, a.count
FROM (
SELECT deptno, count(deptno) count
FROM emp
GROUP BY deptno) a, emp b
WHERE a.deptno = b.deptno
ORDER BY a.deptno, b.sal desc) c;

----------------------------------
SELECT a.ename, a.sal, a.deptno, b.rn
FROM 
(SELECT a.*, rownum j_rn
FROM(
SELECT ename, sal, deptno
FROM emp
ORDER BY deptno, sal desc) a) a,

(SELECT b.*, rownum j_rn
FROM(
SELECT a.deptno, b.rn
FROM
(SELECT deptno, COUNT(*) cnt  --3, 5, 6
FROM emp
GROUP BY deptno) a,
(SELECT ROWNUM rn
FROM emp) b
WHERE a.cnt >= b.rn
ORDER BY a.deptno, b.rn) b) b
WHERE a.j_rn = b.j_rn;
-------------------------------
SELECT ename, sal, deptno, ROW_NUMBER() OVER(PARTITION BY deptno ORDER BY sal DESC) rank
FROM emp;

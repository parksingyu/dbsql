-- member ���̺��� �̿��Ͽ� member2 ���̺��� ����
-- member2 ���̺���
-- ������ ȸ��(mem_id='a001')�� ����(mem_job)�� '����'���� ������
-- commit

CREATE TABLE MEMBER2
as SELECT * FROM member;

UPDATE member2 SET mem_job='����'
WHERE MEM_ID='a001';
commit;

SELECT mem_id, mem_name, mem_job
FROM member2
WHERE mem_id='a001';
--------------------------------------------------
--��ǰ�� ��ǰ ���� ����(BUY_QTY) �հ�, ��ǰ ���� �ݾ�(BUY_COST) �հ�
--��ǰ�ڵ�, ��ǰ��, �����հ�, �ݾ��հ�
SELECT buy_prod, sum(BUY_QTY) sum_qty, sum(buy_cost) sum_cost
FROM buyprod
GROUP BY BUY_PROD;

--��ǰ�ڵ�, ��ǰ��, �����հ�, �ݾ��հ�
SELECT buy_prod, b.prod_name, sum_qty, sum_cost
FROM(
SELECT buy_prod, sum(BUY_QTY) sum_qty, sum(buy_cost) sum_cost
FROM buyprod, prod
GROUP BY BUY_PROD) a, prod b
WHERE a.buy_prod = b.prod_id;

--VW_PROD_BUY(view ����)
CREATE OR REPLACE VIEW VW_PROD_BUY AS
SELECT buy_prod, b.prod_name, sum_qty, sum_cost
FROM(
SELECT buy_prod, sum(BUY_QTY) sum_qty, sum(buy_cost) sum_cost
FROM buyprod, prod
GROUP BY BUY_PROD) a, prod b
WHERE a.buy_prod = b.prod_id;
commit;

--��� Ȯ��
SELECT *
FROM USER_VIEWS;

SELECT *
FROM USER_TABLES;

SELECT *
FROM buyprod;

SELECT * 
FROM prod;

--�������� ���� �߰��ܰ�
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

--123

SELECT empno, ename, sal, deptno,
       RANK() OVER (PARTITION BY deptno ORDER BY sal) rank,
       DENSE_RANK() OVER (PARTITION BY deptno ORDER BY sal) d_rank,
       ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal) rown
FROM emp;

--�м��Լ� 
--����� ��ü �޿� ������ rank, dense_rank, row_number�� �̿��Ͽ� ���ϼ���.
--��, �޿��� ������ ��� ����� ���� ����� ���������� �ǵ��� �ۼ��ϼ���.
SELECT empno, ename, sal, deptno,
       rank() OVER (ORDER BY sal desc, empno asc) sal_rank,
       DENSE_rank() OVER (ORDER BY sal desc, empno asc) sal_dense_rank,
       ROW_NUMBER() OVER (ORDER BY sal desc, empno asc) sal_row_rank
FROM emp;

--SQL ���� ppt p.106
--�м��Լ� / window �Լ�(�ǽ� no_ana2)
--������ ��� ������ Ȱ���Ͽ�, ��� ����� ���� �����ȣ, ����̸�, �ش� ����� ���� �μ���
--��� ���� ��ȸ�ϴ� ������ �ۼ��ϼ���.
SELECT empno, ename, a.deptno, a.cnt
FROM(
SELECT deptno, count(deptno) cnt
FROM emp
GROUP BY deptno)a, emp
WHERE a.deptno=emp.deptno
ORDER BY deptno;

-- �м��Լ��� ���� �μ��� ������(count)
SELECT ename, empno, deptno, 
       count(*) OVER(PARTITION BY deptno) cnt
FROM emp;

--�μ��� ����� �޿� �հ�
--SUM �м��Լ�
SELECT ename, empno, deptno, sal,
       sum(sal) OVER(PARTITION BY deptno) sum_sal
FROM emp;

--SQL ���� ppt p.109
--�м��Լ� / window �Լ�(�ǽ� ana2)
---window function�� �̿��Ͽ� ��� ����� ���� �����ȣ, ����̸�, ���α޿�,
---�μ���ȣ�� �ش� ����� ���� �μ��� �޿� ����� ��ȸ �ϴ� ������
---�ۼ��ϼ���(�޿� ����� �Ҽ��� ��° �ڸ����� ���Ѵ�)
SELECT empno, ename, sal, deptno, 
    round(avg(sal) OVER(PARTITION BY deptno),2) avg_sal
FROM emp;

--SQL ���� ppt p.110
--�м��Լ� / window �Լ�(�ǽ� ana3)
---window function�� �̿��Ͽ� ��� ����� ���� �����ȣ, ����̸� ���α޿�,
---�μ���ȣ�� �ش� ����� ���� �μ��� ���� ���� �޿��� ��ȸ�ϴ� ������ �ۼ��ϼ���.
SELECT empno, ename, sal, deptno, 
    max(sal) OVER(PARTITION BY deptno) max_sal
FROM emp;

--SQL ���� ppt p.111
--�м��Լ� / window �Լ�(�ǽ� ana3)
---window function�� �̿��Ͽ� ��� ����� ���� �����ȣ, ����̸� ���α޿�,
---�μ���ȣ�� �ش� ����� ���� �μ��� ���� ���� �޿��� ��ȸ�ϴ� ������ �ۼ��ϼ���.
SELECT empno, ename, sal, deptno, 
    min(sal) OVER(PARTITION BY deptno) min_sal
FROM emp;

--�μ��� �����ȣ�� ���� �������
--�μ��� �����ȣ�� ���� �������
SELECT empno, ename, deptno, 
       FIRST_VALUE(empno) OVER (PARTITION BY deptno ORDER BY empno) f_emp,
       LAST_VALUE(empno) OVER (PARTITION BY deptno ORDER BY empno) l_emp
FROM emp;

--LAG(������)
--������
--LEAD(������)
--�޿��� ���������� ���� ������ �ڱ⺸�� �Ѵܰ� �޿��� ���� ����� �޿�,
--                        �ڱ⺸�� �Ѵܰ� �޿��� ���� ����� �޿�

SELECT empno, ename, sal, 
       LAG(sal) OVER(ORDER BY sal) lag_sal,
       LEAD(sal) OVER(ORDER BY sal) lead_sal 
FROM emp;

--SQL ���� ppt p.115
--�м��Լ� / window �Լ�(�ǽ� ana5)
---window function�� �̿��Ͽ� ��� ����� ���� �����ȣ, ����̸�, �Ի�����, �޿�,
---��ü ����� �޿� ������ 1�ܰ� ���� ����� �޿��� ��ȸ�ϴ� ������ �ۼ��ϼ���
---(�޿��� ���� ��� �Ի����� ���� ����� ���� ����)
SELECT empno, ename, hiredate, sal,
       LEAD(sal) OVER(ORDER BY sal desc) lead_sal 
FROM emp;

--�м��Լ� / window �Լ� (�׷� �� ����� �ǽ� ana6)
---window function �� �̿��Ͽ� ��� ����� ���� �����ȣ, ����̸�,
---�Ի�����, ����(job), �޿� ������ ������(JOB) �� �޿������� 1�ܰ� ����
---����� �޿��� ��ȸ�ϴ� ������ �ۼ��ϼ���(�޿��� ������� �Ի����� ��������� �켱����
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
--UNBOUNDED PRECEDING : ���� ���� �������� �����ϴ� ��� ��
--CURRENT ROW : ���� ��
--UNBOUNDED FOLLOWING : ���� ���� �������� �����ϴ� �����
--N(����) PRECEDING : ���� ���� �������� �����ϴ� N���� ��
--N(����) FOLLOWING : ���� ���� �������� �����ϴ� N���� ��

SELECT empno, ename, sal,
       sum(sal) OVER (ORDER BY sal, empno 
       ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) sum_sal, --���� ����� ���� ��
       
       sum(sal) OVER (ORDER BY sal, empno 
       ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) sum_sal2, 
       sum(sal) OVER (ORDER BY sal, empno 
       ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) sum_sal3 -- ����, ����, ���� �� �� ���� ��
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

--�˾ƺ���
--RATIO_TO_REPORT
--PERCENT_RANK
--CUME_DIST
--NTILE
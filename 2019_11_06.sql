--�׷��Լ�
--multi row function : �������� ���� �Է����� �ϳ��� ���� ���� ����
--SUM, MAX, MIN, AVG, COUNT
--GROUP BY col | express
--SELECT ������ GROUP BY ���� ����� COL, EXPRESS ǥ�� ����

-- ������ ���� ���� �޿� ��ȸ 
-- 14���� ���� �Է����� �� �ϳ��� ����� ����
SELECT MAX(sal) max_sal
FROM emp;

--�μ����� ���� ���� �޿� ��ȸ
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
    --count(TO_CHAR(hiredate, 'yyyymm')) cnt  (�̰͵� ��� ����)
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
--emp ���̺��� dname �÷��� ���� -->�μ���ȣ(deptno)�ۿ� ����
desc emp;

--emp���̺� �μ��̸��� ������ �� �ִ� dname �÷� �߰�
alter TABLE emp ADD (dname VARCHAR2(14));

SELECT *
FROM emp;

-- emp���̺��� dname�÷��� accounting�� �߰��Ѵ�. ����: deptno�� 10�� ���.
UPDATE emp SET dname = 'ACCOUNTING' WHERE DEPTNO = 10;

-- emp���̺��� dname�÷��� RESEARCH�� �߰��Ѵ�. ����: deptno�� 20�� ���.
UPDATE emp SET dname = 'RESEARCH' WHERE DEPTNO = 20;

-- emp���̺��� dname�÷��� SALES�� �߰��Ѵ�. ����: deptno�� 30�� ���.
UPDATE emp SET dname = 'SALES' WHERE DEPTNO = 30;
COMMIT;

SELECT dname, MAX(sal) max_sal
FROM emp
GROUP BY dname;

ALTER TABLE emp DROP COLUMN DNAME;

SELECT *
FROM emp;

--ansi natural join : �����ϴ� ���̺��� �÷����� ���� �÷��� �������� JOIN
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

--from ���� ���� ��� ���̺� ����
--where���� �������� ���
--������ ����ϴ� ���� ���൵ ��� ����
SELECT emp.empno, emp.ename, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
    AND emp.job = 'SALESMAN'; --job�� SALES�� ����� ������� ��ȸ
    
-- JOIN with ON (�����ڰ� ���� �÷��� on���� ���� ���)
SELECT emp.empno, emp.ename, dept.dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno);

--SELF join : ���� ���̺��� ����
--emp���̺��� mgr ������ �����ϱ� ���ؼ� emp ���̺�� ������ �ؾ��Ѵ�.
--a : ���� ����, b : ������
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a JOIN emp b ON(a.mgr = b.empno)
WHERE a.empno between 7369 AND 7698;


SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno
AND a.empno between 7369 AND 7698;

SELECT *
FROM emp;

--non-equijoing(��� ������ �ƴѰ��)
SELECT *
FROM salgrade;

SELECT *
FROM emp;

SELECT emp.empno, emp.ename, emp.sal, salgrade.*
FROM emp JOIN salgrade ON(emp.sal BETWEEN salgrade.losal AND salgrade.hisal);

--������ �޿� �����???
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




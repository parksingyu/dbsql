-- GROUPING (cube, rollup ���� ���� �÷�)
-- �ش� �÷��� �Ұ� ��꿡 ���� ��� 1
-- ������ ���� ��� 0
SELECT job, deptno, GROUPING(job), GROUPING(deptno), sum(sal) sal
FROM emp
GROUP BY ROLLUP(job, deptno);

--job �÷�
--case1. GROUPING(job)=1 AND GROUPING(deptno) = 1
--       job --> '�Ѱ�'
--case esle
--       job --> job

SELECT CASE WHEN GROUPING(job) = 1 AND
                 GROUPING(deptno) = 1 THEN '�Ѱ�'
            ELSE job
        END job, deptno,
        GROUPING(job), GROUPING(deptno), sum(sal) sal
FROM emp
GROUP BY ROLLUP(job, deptno);

SELECT CASE WHEN GROUPING(job) = 1 AND
                 GROUPING(deptno) = 1 THEN '�Ѱ�'
            ELSE job
        END job,
        
        CASE WHEN GROUPING(job) = 0 AND
                 GROUPING(deptno) = 1 THEN job || ' �Ұ�'
            ELSE TO_CHAR(deptno)
        END deptno,
        
        /*GROUPING(job), GROUPING(deptno),*/ sum(sal) sal
FROM emp
GROUP BY ROLLUP(job, deptno);

-- ����1. ppt25~27 
-- ����2. git kraken ��ġ (https://www.gitkraken.com)
--SQL���� ppt25(�ǽ� GROUP_AD3)
SELECT deptno, job, sum(sal) sal
FROM emp
GROUP BY ROLLUP(deptno, job);

--SQL���� ppt26 (�ǽ� GROUP_AD4)
SELECT a.dname, job, sum(sal) sal
FROM (SELECT *
      FROM emp, dept
      WHERE emp.deptno = dept.deptno) a
GROUP BY ROLLUP(a.dname, a.job)
ORDER BY a.dname, a.job desc;

--SQL���� ppt27 (�ǽ� GROUP_AD5)
SELECT CASE WHEN GROUPING(dept.dname) = 1 AND
                 GROUPING(job) = 1 THEN '����'
            ELSE dept.dname
        END DNAME, job, sum(sal) sum
FROM emp, dept
WHERE emp.deptno = dept.deptno
GROUP BY rollup(dept.dname, job)
ORDER BY dept.DNAME, sum desc;

--CUBE (col, col2...)
--CUBE ���� ������ �÷��� ������ ��� ���տ� ���� ���� �׷����� ����
--CUBE�� ������ �÷��� ���� ���⼺�� ����(rollup���� ����)
--GROUP BY CUBE(job, deptno)
-- 00 : GROUP BY job, deptno
-- 0X : GROUP BY job
-- X0 : GROUP BY deptno
-- XX : GROUP BY -- ��� �����Ϳ� ���ؼ�...

SELECT job, deptno, SUM(sal)
FROM emp
GROUP BY CUBE(job, deptno);

SELECT *
FROM emp;

SELECT deptno, job, sum(sal)
FROM emp
GROUP BY deptno, job;

DROP TABLE emp_test;

--emp���̺��� �����͸� �����ؼ� ��� �÷��� �̿��Ͽ� emp_test���̺�� ����  (���̺� ����!) emp -> emp_test
CREATE TABLE emp_test AS
SELECT *
FROM emp;

--emp_test ���̺��� dept���̺��� �����ǰ� �ִ� dname �÷��� �߰�
ALTER TABLE emp_test ADD (dname VARCHAR2(14));

SELECT *
FROM emp_test;

--emp_test���̺��� dname �÷��� dept���̺��� dname�÷� ������ ������Ʈ�ϴ� ���� �ۼ�
UPDATE emp_test SET dname = ( SELECT dname
                              FROM dept
                              WHERE dept.deptno = emp_test.deptno);
commit;

--dept���̺��� �̿��Ͽ� dept_test ���̺� ����
CREATE TABLE dept_test AS
SELECT *
FROM dept;

--dept_test���̺� empcnt(number) �÷� �߰�
ALTER TABLE dept_test ADD (empcnt number); 

-- ���������� �� ���� �ۼ�
SELECT count(deptno)
FROM emp
GROUP BY deptno;


-- subquery�� �̿��Ͽ� dept_test ���̺��� empcnt�÷���
-- �ش� �μ��� ���� update������ �ۼ��ϼ���
ALTER TABLE emp_test ADD (empcnt number);
UPDATE dept_test SET empcnt = ( SELECT count(deptno)
                                FROM emp
                                WHERE emp.deptno = dept_test.deptno
                                GROUP BY deptno);

--��� ����
SELECT *
FROM dept_test;

-- emp���̺��� �������� ������ ���� �μ� ������ �����ϴ� ������
-- ���������� �̿��Ͽ� �ۼ��ϼ���.
DELETE dept_test WHERE NOT EXISTS (SELECT count(emp.deptno)
                                FROM emp
                                WHERE emp.deptno = dept_test.deptno
                                GROUP BY emp.deptno);

SELECT count(emp.deptno)
FROM emp, dept_test
WHERE emp.deptno = dept_test.deptno
GROUP BY emp.deptno;

--EMP ���̺��� �̿��Ͽ� EMP_TEST ���̺� ����
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

--SUBQUERY�� �̿��Ͽ� emp_test ���̺��� ������ ���� �μ��� (SAL) ��� �޿����� �޿���
-- ���� ������ �޿��� �� �޿����� 200�� �߰��ؼ� ������Ʈ �ϴ� ������ �ۼ��ϼ���
UPDATE emp_test a SET sal = sal+200
WHERE  sal <
    (SELECT AVG(sal)
    FROM emp_test b
    WHERE b.deptno = a.deptno);

--��� Ȯ��
SELECT *
FROM emp_test;

commit;



--emp, emp_test empno �÷����� ���� ������ ��ȸ
--1. emp.empno, emp.ename, emp.sal, emp_test.sal
--2. emp.empno, emp.ename, emp.sal, emp_test.sal,
-- �ش���(emp���̺� ����)�� ���� �μ��� �޿����
SELECT emp.empno, emp.ename, emp.SAL, emp_test.sal, emp.deptno ,a.b SAL_AVG
FROM emp, emp_test, (SELECT deptno, round(avg(sal),2) b
                    FROM emp
                    GROUP BY deptno) a
WHERE emp.empno = emp_test.empno
AND emp.deptno = a.deptno;


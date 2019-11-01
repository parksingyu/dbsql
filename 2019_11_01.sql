-- ����
-- WHERE
-- ������
-- �� : =, !=, <>, >=, >, <=, <
-- BETWEEN start AND end
-- IN (set)
-- LIKE 'S%'  ( % : �ټ��� ���ڿ��� ��Ī, _ :  ��Ȯ�� �ѱ��� ��Ī) 
-- IS NULL (!=NULL �̷������� ����)
-- AND, OR, NOT 

--emp ���̺��� �Ի����ڰ� 1981�� 6�� 1�Ϻ��� 1986�� 12�� 31�ϱ���
--���� ���� ��ȸ

--BETWEEN
SELECT *
FROM emp
WHERE hiredate BETWEEN TO_DATE('19810601', 'YYYYMMDD')
               AND TO_DATE('19861231', 'YYYYMMDD');
               
-- >=, <=
SELECT *
FROM emp
WHERE hiredate >= TO_DATE('19810601', 'YYYYMMDD')
AND hiredate <= TO_DATE('19861231', 'YYYYMMDD');

--emp ���̺��� ������(mgr)�� �ִ� ������ ��ȸ

SELECT *
FROM emp
WHERE MGR IS NOT null;

SELECT *
FROM emp
WHERE job='SALESMAN' or empno LIKE '78%';

-- where13
-- empno�� ���� 4�ڸ����� ���
-- empno : 78, 780, 789
SELECT *
FROM emp
WHERE job = 'SALESMAN'
or empno = 78
or empno between 780 and 789
or empno between 7800 and 7899;

SELECT *
FROM emp
WHERE job = 'SALESMAN'
OR (hiredate >= TO_DATE('19810601', 'YYYYMMDD') AND empno LIKE '78%');

-- order by �÷��� | ��Ī | �÷��ε��� | (ASC | DESC)
-- order by ������ WHERE�� ������ ���
-- WHERE ���� ���� ��� FROM�� ������ ���
-- emp ���̺��� ename �������� �������� ����
SELECT *
FROM emp
ORDER BY ename; --ASC

--�̸�(ename)�� �������� ��������
SELECT *
FROM emp
ORDER BY ename DESC;

--job�� �������� ������������ ����, ���� ���� ���� ��� ���(emp)���� �������� ����
-- SALESMAN - PRESIDENT - MANAGER - CLERK - ANALYST

SELECT *
FROM emp
ORDER BY job DESC, empno ASC;

--��Ī���� �����ϱ�
--��� ��ȣ(empno), �����(ename), ����(Sal * 12) as year_sal
--year_sal ��Ī���� �������� ����
SELECT empno, ename, sal * 12 as year_sal
FROM emp
ORDER BY year_sal;

--SELECT�� �÷� ���� �ε����� ����
SELECT empno, ename, sal, sal * 12 as year_sal
FROM emp
ORDER BY 4;

SELECT *
FROM dept
ORDER BY DNAME ASC;

SELECT *
FROM dept
ORDER BY LOC DESC;

SELECT *
FROM emp
where COMM IS NOT NULL
ORDER BY comm DESC, empno ASC;

SELECT *
FROM emp
where mgr IS NOT null
ORDER BY job ASC, empno DESC;

SELECT *
FROM emp
WHERE (deptno = 10 or DEPTNO = 30) AND sal > 1500
ORDER BY ename DESC;

desc emp;

SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM <= 10;

--EMP ���̺��� ���(empno), �̸�(ename)�� �޿� �������� �������� �����ϰ�
--���ĵ� ��������� ROWNUM

SELECT empno, ename, sal, ROWNUM
FROM emp
ORDER BY sal;

SELECT ROWNUM, a.*
FROM
(SELECT empno, ename, sal
FROM emp
ORDER BY sal) a;



SELECT ROWNUM, a.*
FROM
(SELECT empno, ename, sal
FROM emp
ORDER BY sal) a;



-- ������ ����(�����÷� ROWNUM �ǽ� row_2)
-- ROWNUM ���� 11~20(11~14)�� ���� ��ȸ�ϴ� ������ �ۼ��غ�����.
SELECT b.*
FROM
    (SELECT ROWNUM rn, a.*
    FROM
        (SELECT empno, ename
        FROM emp
        ORDER BY sal) a ) b
WHERE rn BETWEEN 11 and 14;


--FUNCTION
--DUAL ���̺� ��ȸ
SELECT 'HELLO WORLD' as msg
FROM emp;

--���ڿ� ��ҹ��� ���� �Լ�
--LOWER, UPPER, INITCAP
SELECT LOWER('Hello, World'), UPPER('Hello, World'), INITCAP('hello, world')
FROM emp
WHERE job = 'SALESMAN';

--FUNCTION�� WHERE�������� ��� ����
SELECT *
FROM emp
WHERE ename = UPPER('smith');

--������ SQL ĥ������
--1. �º��� �������� ���ƶ�.
--�º�(TABLE�� �÷�)�� �����ϰ� �Ǹ� INDEX�� ���������� ������� ����
--FUNCTION BASED

--CONCAT : ���ڿ� ���� - �ΰ��� ���ڿ��� �����ϴ� �Լ�
--SUBSTR : ���ڿ��� �κ� ���ڿ�(java : String.substring)
--INSTR : ���ڿ��� Ư�� ���ڿ��� �����ϴ� ù��° �ε���
--LPAD  
SELECT CONCAT(CONCAT('HELLO',','), 'WORLD') CONCAT,
        SUBSTR('HELLO, WORLD', 0, 5) substr,
        SUBSTR('HELLO, WORLD', 1, 5) substr1,
        LENGTH('HELLO, WORLD') length,
        INSTR('HELLO, WORLD', 'O') instr,
        --INSTR(���ڿ�, ã�� ���ڿ�, ���ڿ��� Ư�� ��ġ ���� ǥ��)
        INSTR('HELLO, WORLD', 'O', 6) instr1, --���ڿ��� �ε���
        --INSTR(���ڿ�, ã�� ���ڿ�, ���ڿ��� Ư�� ��ġ ���� ǥ��)
        LPAD('HELLO, WORLD', 15, '*') lpad,
        LPAD('HELLO, WORLD', 15) lpad,
        LPAD('HELLO, WORLD', 15, ' ') lpad,
        RPAD('HELLO, WORLD', 15, '*') rpad
FROM dual;



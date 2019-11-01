--���̺��� ������ ��ȸ
/*
    SELECT �÷� | express (���ڿ����) [as] ��Ī
    FROM �����͸� ��ȸ�� ���̺�(VIEN)
    WHERE ���� (condition)
*/

SELECT 'TEST'
FROM emp;

DESC user_tables;
SELECT table_name, 'SELECT * FROM ' || table_name || ';' AS select_query
FROM user_tables
WHERE TABLE_NAME != 'EMP';
--��ü�Ǽ� - 1


-- ���ں� ����
-- �μ���ȣ�� 30�� ���� ũ�ų� ���� �μ��� ���� ���� ��ȸ
SELECT *
FROM emp
WHERE deptno >= 30;

-- �μ���ȣ�� 30�� ���� ���� �μ��� ���� ���� ��ȸ
SELECT *
FROM emp
WHERE deptno < 30;

-- �Ի����ڰ� 1982�� 1�� 1�� ������ ���� ��ȸ
SELECT *
FROM emp
--WHERE hiredate < '82/01/01';
WHERE hiredate < TO_DATE('01011982', 'MMDDYYYY');   -- 11��(�̱� ��¥ ����)
--WHERE hiredate < TO_DATE('19820101', 'YYYYMMDD');   -- 11��
--WHERE hiredate >= TO_DATE('19820101', 'YYYYMMDD');  --3��
--WHERE hiredate >= TO_DATE('1982/01/01', 'YYYY/MM/DD');

-- BETWEEN X AND Y ����
-- �÷��� ���� x ���� ũ�ų� ����, y���� �۰ų� ���� ������
-- �޿�(sal)�� 1000���� ũ�ų� ����, y���� �۰ų� ���� �����͸� ��ȸ
SELECT *
FROM emp
where sal between 1000 AND 2000;

--���� BETWEEN AND �����ڴ� �Ʒ��� <=, >= ���հ� ����.

SELECT *
FROM emp
where 1000 <= sal 
and sal <= 2000
AND deptno = 30;

--�Ի����ڰ� 1981�� 1�� 1�� ���� 1981�� 12�� 31�� ���̿� �ִ�
SELECT ename, hiredate
FROM emp
WHERE hiredate BETWEEN TO_DATE('1982/01/01', 'YYYY/MM/DD') AND TO_DATE('1983/01/01', 'YYYY/MM/DD');

SELECT ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE('1982/01/01', 'YYYY/MM/DD') 
AND hiredate <= TO_DATE('1983/01/01', 'YYYY/MM/DD');

--IN ������
-- COL IN (values...)
-- �μ���ȣ�� 10 Ȥ�� 20�� ���� ��ȸ
SELECT *
FROM emp
WHERE deptno in (10, 20);

--IN �����ڴ� OR�����ڷ� ǥ�� �Ҽ� �ִ�.
SELECT *
FROM emp
WHERE deptno = 10
     OR deptno = 20;
     
SELECT *
FROM users;
     
SELECT userid, usernm
FROM users
WHERE userid = 'brown'
        or userid = 'cony'
        or userid = 'sally';

--users ���̺��� userid�� brown, cony, sally�� �����͸� ������ ���� ��ȸ�Ͻÿ�
--(IN ������ ���)
SELECT userid as ���̵�, usernm as ����
FROM users
WHERE userid in ('brown', 'cony', 'sally');

--COL like 'S%'
--COL�� ���� �빮�� S�� �����ϴ� ��� ��
--COL LIKE 'S____'
--COL�� ���� �빮�� S�� �����ϰ� �̾ 4���� ���ڿ��� �����ϴ� ��

--emp ���̺��� �����̸��� S�� �����ϴ� ��� ���� ��ȸ
SELECT *
FROM emp
WHERE ename LIKE 'S%';

SELECT *
FROM emp
WHERE ename LIKE 'S____';

--���ǿ� �´� ������ ��ȸ�ϱ�
--member���̺��� ȸ���� ���� [��]���� ����� mem_id, mem_name�� ��ȸ�ϴ� ������ �ۼ��Ͻÿ�
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '��%';

SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '%��%';  --mem_name�� ���ڿ��ȿ� �̰� ���ԵǴ� ������ 
--WHERE mem_name LIKE '��%';  --mem_name�� �̷� �����ϴ� ������ 

--NULL ��
--col IS NULL
--EMP ���̺��� MGR ������ ���� ���(NULL) ��ȸ

SELECT *
FROM emp
WHERE MGR IS NULL;

--�Ҽ� �μ��� 10���� �ƴ� ������
SELECT *
FROM emp
WHERE deptno != '10';
-- =, !=
-- is null is not null

--���ǿ� �´� ������ ��ȸ�ϱ� (IS NULL �ǽ� where6)
--emp ���̺��� ��(comm)�� �ִ� ȸ���� ������ ������ ���� ��ȸ�ǵ��� ������ �ۼ��Ͻÿ�
SELECT *
FROM emp
WHERE comm IS NOT NULL;

--AND / OR
--������(mgr) ����� 7698�̰� �޿��� 1000 �̻��� ���
SELECT *
FROM emp
WHERE mgr = 7698
AND sal >= 1000;
-- emp���̺��� ������(mgr) ����� 7698�̰ų�
--    �޿���(sal)�� 1000�̻��� ���� ��ȸ

SELECT *
FROM emp
WHERE mgr = 7698
OR sal >= 1000;

--emp ���̺��� ������(mgr) ����� 7698�� �ƴϰ�, 7939�� �ƴ� ������ ��ȸ
SELECT *
FROM emp
WHERE mgr NOT IN(7698, 7839);    -- IN --> OR

--���� ������ AND/OR �����ڷ� ��ȯ
SELECT *
FROM emp
WHERE mgr != 7698
AND mgr != 7839;

--IN, NOT IN �������� NULL ó��
--emp ���̺��� ������(mgr) ����� 7698, 7839 �Ǵ� null�� �ƴ� ������ ��ȸ
SELECT *
FROM emp
WHERE mgr NOT IN (7698, 7839)
AND mgr IS NOT NULL;

--������(AND, OR �ǽ� where7)
--emp ���̺��� job�� SALESMAN �̰� �Ի����ڰ� 1981�� 6�� 1�� ������ ������ ������ ������ ���� ��ȸ�ϼ���.
SELECT *
FROM emp
WHERE job = 'SALESMAN'
AND hiredate >= TO_DATE('19810601', 'YYYYMMDD');

-- ������(AND, OR �ǽ� where8)
-- emp ���̺��� �μ���ȣ�� 10���� �ƴϰ� �Ի����ڰ� 1981�� 6�� 1�� ������ 
-- ������ ������ ������ ���� ��ȸ�ϼ���.(IN, NOT IN ������ ������)
SELECT *
FROM emp
WHERE DEPTNO != 10
AND hiredate >= TO_DATE('19810601', 'YYYYMMDD');

-- ������(AND, OR �ǽ� where9)
-- emp ���̺��� �μ���ȣ�� 10���� �ƴϰ� �Ի����ڰ� 1981�� 6�� 1�� ������ 
-- ������ ������ ������ ���� ��ȸ�ϼ���.(IN, NOT IN ������ ���)
SELECT *
FROM emp
WHERE DEPTNO NOT IN (10)
AND hiredate >= TO_DATE('19810601', 'YYYYMMDD');

-- ������(AND, OR �ǽ� where10)
-- emp ���̺��� �μ���ȣ�� 10���� �ƴϰ� �Ի����ڰ� 1981�� 6�� 1�� ������ 
-- ������ ������ ������ ���� ��ȸ�ϼ���.(�μ��� 10, 20, 30 �� �ִٰ� �����ϰ� IN �����ڸ� ���)
SELECT *
FROM emp
WHERE DEPTNO IN (20, 30)
AND hiredate >= TO_DATE('19810601', 'YYYYMMDD');

-- ������(AND, OR �ǽ� where11)
-- emp���̺��� job�� SALESMAN�̰ų� �Ի����ڰ� 1981�� 6�� 1�� ������
-- ������ ������ ������ ���� ��ȸ�ϼ���.
SELECT *
FROM emp
WHERE job = 'SALESMAN' 
or hiredate >= TO_DATE('19810601', 'YYYYMMDD');

-- ������(AND, OR �ǽ� where12)
-- emp���̺��� job�� SALESMAN�̰ų� �����ȣ�� 78�� �����ϴ�
-- ������ ������ ������ ���� ��ȸ�ϼ���.
SELECT *
FROM emp
WHERE job = 'SALESMAN' 
or empno LIKE '78%';

-- ������(AND, OR �ǽ� where13)
-- emp���̺��� job�� SALESMAN�̰ų� �����ȣ�� 78�� �����ϴ�
-- ������ ������ ������ ���� ��ȸ�ϼ���.
-- (like �����ڸ� ������� ������)
SELECT *
FROM emp
WHERE job = 'SALESMAN' 
or empno < 7900
AND empno >= 7800;

-- ������(AND, OR �ǽ� where13_2)
-- emp���̺��� job�� SALESMAN�̰ų� �����ȣ�� 78�� �����ϴ�
-- ������ ������ ������ ���� ��ȸ�ϼ���.
-- (like �����ڸ� ������� ������)
SELECT *
FROM emp
WHERE job = 'SALESMAN' 
or empno between 7800 and 7899;
-- ������(AND, OR �ǽ� where14)
-- emp���̺��� job�� SALESMAN�̰ų� �����ȣ�� 78�� �����ϸ鼭
-- �Ի����ڰ� 1981�� 6�� 1�� ������ ������ ������ ������ ���� ��ȸ�ϼ���

SELECT *
FROM emp
WHERE job = 'SALESMAN' 
or empno LIKE '78%'
AND hiredate >= TO_DATE('19810601', 'YYYYMMDD');

SELECT *
FROM dept;
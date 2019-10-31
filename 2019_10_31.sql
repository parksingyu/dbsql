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


SELECT *
FROM dept;
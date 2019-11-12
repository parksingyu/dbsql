--SMITH, WARD �� ���ϴ� �μ��� ������ ��ȸ
SELECT *
FROM emp
WHERE deptno IN (20, 30);

SELECT *
FROM emp
WHERE deptno = 10
OR    deptno = 20;

SELECT *
FROM emp;
WHERE deptno in (SELECT deptno 
                FROM emp WHERE ename IN(:name1, :name2) );
                
-- ANY : set�߿� �����ϴ°� �ϳ��� ������ ������(ũ���)
-- SMITH, WARD�� �޿����� �λ���� �ƹ��� 
SELECT *
FROM emp
WHERE sal < any(SELECT sal --800, 1250 --> 1250���� ���� �޿��� �޴� ���
                FROM emp
                WHERE ename IN ('SMITH', 'WARD'));
                
--SMITH�� WARD���� �޿��� ���� ���� ��ȸ
--SMITH���ٵ� �޿��� ���� WARD���ٵ� �޿��� ���� ���(AND)
SELECT *
FROM emp
WHERE sal > all(SELECT sal
                FROM emp
                WHERE ename IN('SMITH', 'WARD'));
                
--NOT IN

--�������� ��������
--1. �������� ����� ��ȸ
-- .mgr �÷��� ���� ������ ����
-- �ߺ����� : DISTINCT
-- 
SELECT DISTINCT mgr
FROM emp;

--� ������ ������ ������ �ϴ� ���� ���� ��ȸ
SELECT *
FROM emp
WHERE empno IN(7839,7782,7698,7902,7566,7788);

SELECT *
FROM emp
WHERE empno IN(SELECT mgr
               FROM  emp);

--������ ������ ���� �ʴ� ���� ���� ��ȸ
--�� NOT IN ������ ���� set�� null�� ���Ե� ��� ���������� �������� �ʴ´�.
--NULLó�� �Լ��� WHERE���� ���� NULL���� ó���� ���� ���
SELECT *
FROM emp
WHERE empno NOT IN(SELECT nvl(mgr, -9999)
                   FROM  emp);

--pair wise
--��� 7499, 7782�� ������ ������, �μ���ȣ ��ȸ
-- 7698 30
-- 7839 10
--�����߿� �����ڿ� �μ���ȣ�� (7698, 30) �̰ų�, (7839, 10)�� ���
--mgr, deptno �÷��� [����]�� ������Ű�� ���� ���� ��ȸ
SELECT *
FROM emp
WHERE (mgr, deptno) IN(SELECT mgr, deptno
                       FROM emp
                       WHERE empno IN (7499, 7782));
                       
SELECT *
FROM emp
WHERE mgr IN(SELECT mgr
            FROM emp
            WHERE empno IN (7499, 7782))
AND deptno IN (SELECT deptno
                FROM emp
                WHERE empno IN(7499, 7782));
                
--SCALAR SUBQUERY : SELECT ���� �����ϴ� ���� ����(��, ���� �ϳ��� ��, �ϳ��� �÷�)
--������ �Ҽ� �μ����� JOIN�� ������� �ʰ� ��ȸ
SELECT empno, ename, deptno, (SELECT dname 
                              FROM dept
                              WHERE deptno = emp.deptno) dname
FROM emp;

SELECT dname 
FROM dept
WHERE deptno = 20;

--sub4 ������ ����
SELECT *
FROM dept;

SELECT *
FROM emp;

INSERT INTO dept VALUES (99, 'ddit', 'daejeon');
COMMIT;

--ppt246
SELECT *
FROM dept
WHERE deptno NOT IN (SELECT DISTINCT deptno
                    FROM emp);
                    
SELECT *
FROM dept
WHERE deptno NOT IN (10, 20, 30);

SELECT DISTINCT deptno
FROM emp;

SELECT pid
FROM cycle
WHERE CID = 1;

SELECT *
FROM product;

SELECT cycle.pid
FROM cycle, product
WHERE product.pid = cycle.pid
AND CID = 1;

--ppt 247
SELECT *
FROM product
WHERE pid NOT IN(SELECT DISTINCT pid
                FROM cycle
                WHERE CID = 1);                

SELECT *
FROM cycle
WHERE cid IN (1, 2);

SELECT *
FROM cycle
WHERE pid NOT IN
(SELECT DISTINCT pid
FROM cycle
WHERE cid IN (1, 2));

SELECT pid
FROM cycle
WHERE cid = 2;

SELECT *
FROM product;

--ppt 248
SELECT * --100, 400
FROM cycle
WHERE cid = 1
AND pid IN(SELECT distinct pid
    FROM cycle
    WHERE cid = 2); --2�� ���� �Դ� ��ǰ

--ppt249 (���� 20191112����)
SELECT a.cid, customer.cnm, a.pid, product.pnm, a.day, a.cnt
FROM (SELECT * --100, 400
      FROM cycle
      WHERE cid = 1
      AND pid IN(SELECT distinct pid
            FROM cycle
            WHERE cid = 2)) a, customer, product
WHERE a.cid = customer.cid
AND a.pid = product.pid;

--ppt252 (���� 20191112����)
SELECT *
FROM product
WHERE NOT EXISTS (SELECT 'X'
              FROM cycle a
              WHERE product.pid = a.pid
              and cid = 1);
              
SELECT *
FROM product;

SELECT *
FROM cycle;
              
--ppt252
SELECT *
FROM product
WHERE EXISTS (SELECT '*'
                FROM cycle a
                WHERE product.pid = a.pid
                and cid = 1);

              
SELECT *
FROM product
WHERE EXISTS (SELECT 'X'
            FROM product, cycle
            WHERE product.pid = cycle.pid);

    
SELECT *
FROM product;

SELECT *
FROM cycle;

SELECT *
FROM customer;
    
--EXISTS MAIN������ �÷��� ����ؼ� SUBQUERY�� �����ϴ� ������ �ִ��� üũ
--�����ϴ� ���� �ϳ��� �����ϸ� ���̻� �������� �ʰ� ���߱� ������
--���ɸ鿡�� ����

--MGR�� �����ϴ� ���� ��ȸ
SELECT *
FROM emp a
WHERE EXISTS (SELECT 'X'
              FROM emp
              WHERE empno = a.mgr);
              
--MGR�� �������� �ʴ� ���� ��ȸ
SELECT *
FROM emp a
WHERE NOT EXISTS (SELECT 'X'
                  FROM emp
                  WHERE empno = a.mgr);
                  
SELECT *
FROM emp a
WHERE EXISTS (SELECT 'X'
            FROM emp b
            WHERE b.empno = a.mgr);
            
SELECT *
FROM emp
WHERE MGR IS NULL;

--�μ��� �Ҽӵ� ������ �ִ� �μ� ���� ��ȸ(EXISTS)
SELECT *
FROM dept
WHERE deptno IN(10, 20, 30);

--EXISTS�� �ٽ�
SELECT *
FROM dept
WHERE NOT EXISTS (SELECT 'X'
              FROM emp
              WHERE deptno = dept.deptno);
              
SELECT *
FROM dept;

SELECT *
FROM emp;
              
--IN              
SELECT *
FROM dept
WHERE deptno in (SELECT deptno
                 FROM emp);
                 
--���տ���
--UNION : ������. �ߺ��� ����
--        DBMS������ �ߺ��� �����ϱ����� �����͸� ����
--        (�뷮�� �����Ϳ� ���� ���Ľ� ����)
--UNION ALL : UNION�� ���� ����
--            �ߺ��� �������� �ʰ�, �� �Ʒ� ������ ���� => �ߺ�����
--            ���Ʒ� ���տ� �ߺ��Ǵ� �����Ͱ� ���ٴ� ���� Ȯ���ϸ�
--            UNION �����ں��� ���ɸ鿡�� ����
--����� 7566 �Ǵ� 7698�� ��� ��ȸ(����̶�, �̸�)
SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7698

UNION
--����� 7369, 7499�� ��� ��ȸ(���, �̸�)
SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7698;
--WHERE empno = 7369 OR empno = 7499;

--UNION ALL(�ߺ� ���)
SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7698

UNION ALL
--����� 7369, 7499�� ��� ��ȸ(���, �̸�)
SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7698;
--WHERE empno = 7369 OR empno = 7499;

--INTERSECT(������ : �� �Ʒ� ���հ� ���� ������)
SELECT empno, ename
FROM emp
WHERE empno IN( 7566, 7698, 7369)

INTERSECT

SELECT empno, ename
FROM EMP
WHERE empno IN(7566, 7698, 7499);


--MINUS(������ : �� ���տ��� �Ʒ� ������ ����)
SELECT empno, ename
FROM emp
WHERE empno IN( 7566, 7698, 7369)

MINUS

SELECT empno, ename
FROM EMP
WHERE empno IN(7566, 7698, 7499);

SELECT empno, ename
FROM EMP
WHERE empno IN(7566, 7698, 7499)
MINUS
SELECT empno, ename
FROM emp
WHERE empno IN( 7566, 7698, 7369);

SELECT *
FROM USER_CONSTRAINTS
WHERE OWNER = 'PC10'
AND TABLE_NAME IN ('PROD', 'LPROD')
AND CONSTRAINT_TYPE IN ('P', 'R');
SELECT l.sido , l.sigungu, round(m.na/l.lo,2) as ���ù�������
FROM 
(SELECT sido, sigungu, count(*) lo
FROM fastfood
WHERE gb='�Ե�����'
GROUP BY sido, sigungu) l,
(SELECT sido, sigungu, count(*) na
FROM fastfood
WHERE gb IN ('�Ƶ�����', '����ŷ','KFC')
GROUP BY sido, sigungu) m
WHERE l.sigungu = m.sigungu
AND l.sido = m.sido
ORDER by round(m.na/l.lo,2) desc;

SELECT sido, sigungu, sal
FROM tax
ORDER BY sal desc;

-- �������� �õ�, �ñ��� | �������� �õ� �ñ���
--�õ�, �ñ���, ��������, �õ�, �ñ���,  �������� ���Ծ�
--����� �߱� 5.7 ��⵵ ������

SELECT *
FROM 
(
SELECT rownum ����, aa.*
FROM 
(
SELECT l.sido as �õ�, l.sigungu as ��, /*m.na as kmb, l.lo as l,*/ round(m.na/l.lo,2) as ���ù�������
FROM 
(SELECT sido, sigungu, count(*) lo
FROM fastfood
WHERE gb='�Ե�����'
GROUP BY sido, sigungu) l,
(SELECT sido, sigungu, count(*) na
FROM fastfood
WHERE gb IN ('�Ƶ�����', '����ŷ','KFC')
GROUP BY sido, sigungu) m
WHERE l.sigungu = m.sigungu
AND l.sido = m.sido
ORDER by ���ù������� desc
)aa
) a,
(
SELECT rownum as ����, bb.*
FROM
(
SELECT sido �õ�, sigungu �ñ���, sal �޿�
FROM tax
ORDER BY sal desc
) bb
) b
WHERE a.���� = b.����;

SELECT *
FROM emp_test;

--emp test ���̺� ����

DROP TABLE emp_test;

--multiple insert�� ���� �׽�Ʈ ���̺� ����
--empno, ename �ΰ��� �÷��� ���� emp_test, emp_test2 ���̺���
--emp ���̺�� ���� �����Ѵ�(CTAS)

CREATE TABLE emp_test AS;
CREATE TABLE emp_test2 AS
SELECT empno, ename
FROM emp
WHERE 1=2;

--INSERT ALL
--�ϳ��� INSERT SQL �������� ���� ���̺� �����͸� �Է�
INSERT ALL
    INTO emp_test
    INTO emp_test2
SELECT 1, 'brown' FROM dual UNION ALL
SELECT 2, 'sally' FROM dual;

--INSERT ������ Ȯ��
SELECT *
FROM emp_test;

SELECT *
FROM emp_test2;

--INSERT ALL �÷� ����
ROLLBACK;

INSERT ALL 
    INTO emp_test (empno) VALUES (empno)
    INTO emp_test2 VALUES (empno, ename)
SELECT 1 empno, 'brown' ename FROM dual UNION ALL
SELECT 2 empno, 'sally' ename FROM dual ;

SELECT *
FROM emp_test;

SELECT *
FROM emp_test2;



--multiple insert (conditional insert)
ROLLBACK;
INSERT ALL
    WHEN empno < 10 THEN
        INTO emp_test (empno) VALUES (empno)
    ELSE --�⺻ INSERT ����
        INTO emp_test2 VALUES (empno, ename)
SELECT 20 empno, 'brown' ename FROM dual UNION ALL
SELECT 2 empno, 'sally' ename FROM dual ;

SELECT *
FROM emp_test;

SELECT *
FROM emp_test2;

--INSERT FIRST
--���ǿ� �����ϴ� ù��° INSERT ������ ����
INSERT FIRST
    WHEN empno > 10 THEN
        INTO emp_test (empno) VALUES (empno)
    WHEN empno > 5 THEN
        INTO emp_test2 VALUES (empno, ename)
SELECT 20 empno, 'brown' ename FROM dual;

SELECT *
FROM emp_test;

SELECT *
FROM emp_test2;

--MERGE : ���ǿ� �����ϴ� �����Ͱ� ������ UPDATE
--        ���ǿ� �����ϴ� �����Ͱ� ������ INSERT

--empno�� 7369�� �����͸� emp ���̺�� ���� emp_test���̺� ����(insert)
INSERT INTO emp_test
SELECT empno, ename
FROM emp
WHERE EMPNO=7369;

SELECT *
FROM emp_test;

--emp���̺��� �������� emp_test ���̺��� empno�� ���� ���� ���� �����Ͱ� �������
-- emp_test.ename = ename || '_merge' ������ update
-- �����Ͱ� ���� ��쿡�� emp_test���̺� insert
ALTER TABLE emp_test MODIFY (ename VARCHAR2(20));
MERGE INTO emp_test
USING emp 
 ON (emp.empno = emp_test.empno)
WHEN MATCHED THEN
    UPDATE SET ename = emp.ename || '_merge'
WHEN NOT MATCHED THEN
    INSERT VALUES ( emp.empno, emp.ename );
    
SELECT *
FROM emp_test;

ROLLBACK;

--�ٸ� ���̺��� ������ �ʰ� ���̺� ��ü�� ������ ���� ������
--merge �ϴ� ���
-- empno = 1, ename = 'brown'
-- empno�� ���� ���� ������ ename�� 'brown'���� ������Ʈ
-- empno�� ���� ���� ������ �ű� insert

MERGE INTO emp_test
USING dual
 ON (emp_test.empno = 1 )
WHEN MATCHED THEN
    UPDATE SET ename = 'brown' || '_merge'
WHEN NOT MATCHED THEN
    INSERT VALUES ( 1, 'brown' );

SELECT 'X'
FROM emp_test
WHERE empno=1;

UPDATE emp_test set ename = 'brown' || '_merge'
WHERE empno=1;

INSERT INTO emp_test VALUES (1, 'brown');

MERGE INTO emp_test
USING dual
 ON (emp_test.empno = 1 )
WHEN MATCHED THEN
    UPDATE SET ename = 'brown' || '_merge'
WHEN NOT MATCHED THEN
    INSERT VALUES ( 1, 'brown' );

--GROUP_AD1
SELECT deptno, sum(sal) sal
FROM emp
GROUP BY deptno

UNION ALL

SELECT null, sum(sal) sal
FROM emp
ORDER BY deptno;

SELECT deptno, sum(sal) sal
FROM emp
GROUP BY ROLLUP(deptno);

SELECT deptno, job,sum(sal) sal
FROM emp
GROUP BY ROLLUP(deptno, job);

--rollup
--group by�� ���� �׷��� ����
--GROUP BY ROLLUP( {col, } )
--�÷��� �����ʿ������� �����ذ��鼭 ���� ����׷���
--GROUP BY �Ͽ� UNION �� �Ͱ� ����
--ex : GROUP BY ROLLUP(job, deptno)
--    GROUP BY ROLLUP(job, deptno)
--    UNION
--    GROUP BY job
--    UNION
--    GROUP BY --> �Ѱ�(��� �࿡ ���� �׷��Լ� ����)
SELECT job, deptno, sum(sal) sal
FROM emp
GROUP BY ROLLUP(job, deptno);

--GROUPING SETS (col1, col2...)
--GROUPING SETS�� ������ �׸��� �ϳ��� ����׷����� GROUP BY ���� �̿�ȴ�

--GROUP BY col1
--UNION ALL
--GROUP BY col2

--emp ���̺��� �̿��Ͽ� �μ��� �޿��հ�, ������(�ä���)quf rmqdugkqdmf rngktldh

--�μ���ȣ, job, �޿� �հ�

SELECT deptno, null job,SUM(sal)
FROM emp
GROUP BY deptno

UNION ALL

SELECT null, job, SUM(sal)
FROM emp
GROUP BY job;

SELECT deptno, job, SUM(sal)
FROM emp
GROUP BY GROUPING SETS(deptno, job);
SELECT *
FROM jdbc_board;

SELECT *
FROM jdbc_board
WHERE board_no = 21;

-- ppt403
CREATE UNIQUE INDEX idx_emp_000 ON emp(empno);
CREATE INDEX idx_emp_001 ON emp(deptno);
CREATE INDEX idx_emp_002 ON emp(ename);
CREATE INDEX idx_emp_003 ON emp(mgr, empno);

--pc10 ����
--dictionary
--���ξ� : USER
--        ALL : ����ڰ� ��밡�� �� ��ü
--        DBA : ������ ������ ��ü ��ü(�Ϲ� ����ڴ� ��� �Ұ�)
--        VS : �ý��۰� ���õ� view (�Ϲ� ����ڴ� ��� �Ұ�)

SELECT *
FROM USER_TABLES;

SELECT *
FROM ALL_TABLES;

SELECT *
FROM DBA_TABLES
WHERE OWNER IN('PC10', 'HR');

--����Ŭ���� ������ SQL�̶�?
--���ڰ� �ϳ��� Ʋ���� �ȵ�.
--���� sql���� ��������� ����� ���� ���� DBMS������
--���� �ٸ� SQL�� �νĵȴ�.
SELECT /* bind_test */* FROM emp;
Select /* bind_test */* FROM emp;
Select /* bind_test */*  FROM emp;

Select /* bind_test */* FROM emp WHERE empno=7369;
Select /* bind_test */* FROM emp WHERE empno=7499;
Select /* bind_test */* FROM emp WHERE empno=7521;

Select /* bind_test */* FROM emp WHERE empno=:empno;

SELECT *
FROM FASTFOOD
WHERE GB='�Ե�����'
AND ADDR LIKE '%����������%';

SELECT gb, count(gb)
FROM fastfood
WHERE addr LIKE '%���������� ����%'
GROUP BY gb;

SELECT gb, count(gb)
FROM fastfood
WHERE addr LIKE '%����������%'
GROUP BY gb;
GROUP BY sido, sigungu, gb
ORDER BY sido, sigungu, gb;

SELECT gb ,count(*)
FROM fastfood
GROUP BY gb;

SELECT sido, sigungu
FROM fastfood
WHERE sido LIKE '%����%';

SELECT *
FROM fastfood;

--hint
--�õ�, �ñ����� �����(����Ű�� �Ƶ�����, KFC ) :
--�õ�, �ñ����� �����(�Ե�����) :

--�Ե�����
SELECT sido, sigungu, count(*)
FROM fastfood
WHERE gb='�Ե�����'
GROUP BY sido, sigungu;


SELECT l.sido as �õ�, l.sigungu as ��, m.na as kmb, l.lo as l, round(m.na/l.lo,2) as ���ù�������
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
--AND l.sido = '����������';
ORDER by ���ù������� desc;


SELECT rownum r, aa.*
FROM 
(
SELECT l.sido as �õ�, l.sigungu as ��, m.na as kmb, l.lo as l, round(m.na/l.lo,2) as ���ù�������
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
)aa;

SELECT rownum as rr, bb.*
FROM
(
SELECT sido, sigungu, sal
FROM tax
ORDER BY sal desc
) bb;


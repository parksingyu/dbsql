--20191127

SELECT *
FROM no_emp;

SELECT LPAD(' ', 4 * (LEVEL -1)) || org_cd org_cd, no_emp
FROM no_emp
START WITH parent_org_cd IS NULL
CONNECT BY PRIOR org_cd = parent_org_cd;

-- 1.leaf node ã��
-----------------------------------------------------------------------------
SELECT org_cd, LEVEL, s_emp
FROM
(SELECT  org_cd, parent_org_cd,/* no_emp, lv, leaf, rn, gr,*/
        SUM(no_emp/org_cnt) OVER(PARTITION BY GR ORDER BY rn ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) s_emp
FROM 
    (SELECT a.*, rownum rn, a.lv + rownum gr, COUNT(org_cd) OVER(PARTITION BY org_cd ) org_cnt
    FROM
        (SELECT org_cd, parent_org_cd, no_emp, LEVEL LV, connect_by_isleaf leaf
        FROM no_emp
        START WITH PARENT_ORG_CD is NULL
        CONNECT BY PRIOR org_cd = parent_org_cd) a
    START WITH leaf = 1
    CONNECT BY PRIOR parent_org_cd = org_cd))
GROUP BY org_cd, parent_org_cd;
START WITH parent_org_cd IS NULL
CONNECT BY PRIOR org_cd = parent_org_cd;
-----------------------------------------------------------------------------

--PL/SQL
--�Ҵ翬�� :=
-- System.out.println("") --> dbms_out.put_line("");
-- Log4j
-- set serveroutput on; --��±���� Ȱ��ȭ

--PL/SQL
--declare   : ����, ��� ����
--begin     : ���� ����
--exception : ���� ó��

DESC dept;
set serveroutput on;
DECLARE
    --���� ����
    deptno NUMBER(2);
    dname VARCHAR(14);
BEGIN
    SELECT deptno, dname INTO deptno, dname
    FROM dept
    WHERE deptno = 10;
    --dbms_output.put_line('test');
    
    --SELECT ���� ����� ������ �� �Ҵ� �ߴ��� Ȯ��
    dbms_output.put_line('dname : ' || dname || '(' || deptno || ')');
END;
/

DECLARE
    --���� ���� ����(���̺� �÷�Ÿ���� ����ǵ� pl/sql ������ ������ �ʿ䰡 ����)
    deptno dept.deptno%TYPE;
    dname dept.dname%TYPE;
BEGIN
    SELECT deptno, dname INTO deptno, dname
    FROM dept
    WHERE deptno = 10;
    --dbms_output.put_line('test');
    
    --SELECT ���� ����� ������ �� �Ҵ� �ߴ��� Ȯ��
    dbms_output.put_line('dname : ' || dname || '(' || deptno || ')');
END;
/  -- �̰� DECLARE���� �����ݷ� �����̴ϴ�.

--10���μ��� �μ��̸���  LOC ������ ȭ������ϴ� ���ν���
--���ν����� : printdept
-- CREATE OR REPLACE VIEW
CREATE OR REPLACE PROCEDURE printdept 
IS
    --��������
    dname dept.dname%TYPE;
    loc dept.loc%TYPE;
BEGIN
    SELECT dname, loc
    INTO dname, loc
    FROM dept
    WHERE deptno = 10;
    
    dbms_output.put_line('dname, loc = ' || dname || ',' || loc);
END;
/

exec printdept;

CREATE OR REPLACE PROCEDURE printdept_p(p_deptno IN dept.deptno%TYPE)
IS
    --��������
    dname dept.dname%TYPE;
    loc dept.loc%TYPE;
BEGIN
    SELECT dname, loc
    INTO dname, loc
    FROM dept
    WHERE deptno = p_deptno;
    
    dbms_output.put_line('dname, loc = ' || dname || ',' || loc);
END;
/
exec printdept_p(30);

-- printtemp procedure ����
-- param : empno
-- logic : empno�� �ش��ϴ� ����� ������ ��ȸ�Ͽ� ����̸�, �μ��̸��� ȭ�鿡 ���

CREATE OR REPLACE PROCEDURE printtemp(p_empno IN emp.empno%TYPE)
IS
    --��������
    ename emp.ename%TYPE; --�� ename�� �ƴϾ �ȴ�. ���״�� ���������̴ϱ�.
    dname dept.dname%TYPE;
BEGIN
    SELECT ename, dname
    INTO ename, dname --����� ���� ������ ����
    FROM emp, dept
    WHERE empno = p_empno
    AND emp.deptno = dept.deptno;
    
    dbms_output.put_line('ename, dname = ' || ename || ',' || dname);
END;
/
--��� Ȯ��
exec printtemp(7499);

SELECT *
FROM dept_test;

-- registdept_test procedure ����
-- param : deptno, dname, loc
-- logic : �Է¹��� �μ� ������ dept_test ���̺� �ű� �Է�
-- exec registdept_test('99', 'ddit', 'daejeon');
-- dept_test���̺� ���������� �Է� �Ǿ����� Ȯ��
CREATE OR REPLACE PROCEDURE registdept_test(p_deptno IN dept.deptno%TYPE, p_dname IN dept.dname%TYPE, p_loc IN dept.loc%TYPE)
IS
    var_deptno dept.deptno%type;
    var_dname dept.dname%type;
    var_loc dept.loc%type;
BEGIN
    INSERT INTO dept_test(deptno, dname, loc)
    VALUES(p_deptno, p_dname, p_loc);
END;
/
exec registdept_test('99', 'ddit', 'daejeon');

INSERT INTO dept_test(deptno, dname, loc)
VALUES('90', 'abcd', 'busan');

    
    

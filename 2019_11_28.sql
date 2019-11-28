SELECT *
FROM dept_test;

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

--------------------------------------
CREATE OR REPLACE PROCEDURE updatedept_test(p_deptno IN dept.deptno%TYPE, p_dname IN dept.dname%TYPE, p_loc IN dept.loc%TYPE)
IS
--    p_deptno dept.deptno%type;
--    p_dname dept.dname%type;
--    p_loc dept.loc%type;
BEGIN
    UPDATE dept_test SET deptno=p_deptno, dname=p_dname, loc=p_loc
    WHERE deptno = p_deptno;
    --INSERT INTO dept_test(deptno, dname, loc)
    --VALUES(p_deptno, p_dname, p_loc);
END;
/

exec updatedept_test(99, 'ddit_m', 'daejeon');

SELECT *
FROM dept_test;
    
--ROWTYPE : ���̺��� �� ���� �����͸� ���� �� �ִ� ���� Ÿ��

set serveroutput on;
DECLARE
    dept_row dept%ROWTYPE;
BEGIN
    SELECT *
    INTO dept_row
    FROM dept
    WHERE deptno = 10;
    
    dbms_output.put_line(dept_row.deptno || ', ' || dept_row.dname || ', ' || dept_row.loc);
END;
/

--���պ��� : record
DECLARE
    --UserVo userVo;
    TYPE dept_row IS RECORD(
        deptno NUMBER(2),
        dname dept.dname%TYPE);
    
    v_dname dept.dname%Type;
    v_row dept_row;
BEGIN
    SELECT deptno, dname
    INTO v_row
    FROM dept
    WHERE deptno = 10;
    
    dbms_output.put_line(v_row.deptno || ', ' || v_row.dname);
END;
/

--tablettype
DECLARE
    TYPE dept_tab IS TABLE OF dept%ROWTYPE INDEX BY BINARY_INTEGER;
    
    -- java : Ÿ�� ������
    -- pl/sql : ������ Ÿ��;
    v_dept dept_tab;
    bi BINARY_INTEGER;
    
BEGIN
    bi := 100;
    SELECT *
    BULK COLLECT INTO v_dept
    FROM dept;
    
    dbms_output.put_line(bi);
    --���� ������
    FOR i IN 1..v_dept.count LOOP
        dbms_output.put_line(i || '��° : ' || v_dept(i).dname);    
    END LOOP;
    
--    dbms_output.put_line(v_dept(1).dname);
--    dbms_output.put_line(v_dept(2).dname);
--    dbms_output.put_line(v_dept(3).dname);
--    dbms_output.put_line(v_dept(4).dname);
--    dbms_output.put_line(v_dept(5).dname);
--    dbms_output.put_line(v_dept(6).dname);
END;
/

SELECT *
FROM dept;

--IF
--ELSE IF --> ELSIF
--END IF;

DECLARE
    ind BINARY_INTEGER;
BEGIN
    ind := 2;
    
    IF ind = 1 THEN
        dbms_output.put_line(ind);
    ELSIF ind = 2 THEN
        dbms_output.put_line('ELSIF ' || ind);
    ELSE
        dbms_output.put_line('ELSE');
    END IF;
END;
/

--PL/SQL (�������� - for loop)
-- FOR �ε��� ��� IN ���۰�..���ᰪ LOOP
--END LOOP;
DECLARE
BEGIN
    FOR i IN 0..5 LOOP -- i�� 0���� 0���� 
        dbms_output.put_line('i : ' || i);
    END LOOP;
END;
/

-- PL/SQL (��������-while)
-- LOOP : ��� ���� �Ǵ� ������ LOOP �ȿ��� ����
-- java : while(true)

DECLARE
    i NUMBER;
BEGIN
    i := 0;
    
    LOOP
        dbms_output.put_line(i);
        i := i + 1;
        --loop��� ���� ���� �Ǵ�
        EXIT WHEN i >=5 ;
    END LOOP;
END;

----
 CREATE TABLE DT
(	DT DATE);

insert into dt
select trunc(sysdate + 10) from dual union all
select trunc(sysdate + 5) from dual union all
select trunc(sysdate) from dual union all
select trunc(sysdate - 5) from dual union all
select trunc(sysdate - 10) from dual union all
select trunc(sysdate - 15) from dual union all
select trunc(sysdate - 20) from dual union all
select trunc(sysdate - 25) from dual;

commit;


SELECT *
FROM dt;

----���� ��� : 5��
DECLARE
    TYPE dt_tab IS TABLE OF dt%ROWTYPE INDEX BY BINARY_INTEGER;
  
    v_dt dt_tab;
    
    summ INTEGER;
    sumc INTEGER;
    avgg FLOAT;
    i NUMBER;
BEGIN
    i := 1;
    
    summ := 0;
    sumc := 0;
    avgg := 0;
    
    SELECT *
    BULK COLLECT INTO v_dt
    FROM dt;
    
    LOOP
        --summ := v_dt(i).dt - v_dt(i+1).dt;
        sumc := sumc + v_dt(i).dt - v_dt(i+1).dt;
        i := i+1;
        EXIT WHEN i>= v_dt.count;
    END LOOP;
    
    avgg := sumc / (v_dt.count-1);
    
    dbms_output.put_line('avg : ' || avgg);
END;
/

--lead, lag �������� ����, ���� �����͸� ������ �� �ִ�.
SELECT *
FROM dt
ORDER BY dt desc;

SELECT dt, LAG(dt) OVER(ORDER BY dt) lag_dt, dt - LAG(dt) OVER(ORDER BY dt)
FROM dt
ORDER BY dt desc;


SELECT dt - LAG(dt) OVER(ORDER BY dt)
FROM dt
ORDER BY dt desc;


SELECT ROWNUM RN, dt
FROM
    (SELECT dt
    FROM dt
    ORDER BY dt DESC);

SELECT sum(diff_sum) / count(diff_sum) as �����հ�
FROM(
    SELECT b.dt, a.dt, b.dt-a.dt diff_sum
    FROM
        (SELECT ROWNUM RN, dt
        FROM
            (SELECT dt
            FROM dt
            ORDER BY dt DESC)) a,
        (SELECT ROWNUM RN, dt
        FROM
            (SELECT dt
            FROM dt
            ORDER BY dt DESC)) b
WHERE a.RN = b.RN+1)
GROUP BY DIFF_SUM;

--HALL OF HONOR
SELECT (MAX(dt) - MIN(dt)) / (COUNT(*) -1)
FROM dt;

DECLARE
    CURSOR dept_cursor IS
        SELECT deptno, dname FROM dept;
        
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
BEGIN
    --Ŀ�� ����
    OPEN dept_cursor;
    LOOP
        FETCH dept_cursor INTO v_deptno, v_dname;
        dbms_output.put_line(v_deptno || ', ' || v_dname);
        EXIT WHEN dept_cursor%NOTFOUND; -- ���̻� ���� �����Ͱ� ���� �� ����
    END LOOP;
END;
/

--FOR LOOP CURSOR ����
DECLARE
    CURSOR dept_cursor IS
        SELECT deptno, dname
        FROM dept;
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
BEGIN
    FOR rec IN dept_cursor LOOP
    dbms_output.put_line(rec.deptno || ',' || rec.dname);
    END LOOP;
END;
/

--�Ķ���Ͱ� �ִ� ����� Ŀ��
DECLARE
    CURSOR emp_cursor(p_job emp.job%TYPE) IS
        SELECT empno, ename, job 
        FROM emp
        WHERE job = p_job;
BEGIN
    FOR emp IN emp_cursor('SALESMAN') LOOP
        dbms_output.put_line(emp.empno || ', ' || emp.ename || ', ' || emp.job);
    END LOOP;
END;
/
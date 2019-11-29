--CURSOR�� ��������� �������� �ʰ�
--LOOP���� inline ���·� cursor ���

set serveroutput on;
-- �͸� ���
DECLARE
    --cursor ���� --> LOOP���� inline ����
BEGIN
    -- for(String str : list)
    FOR rec IN (SELECT deptno, dname FROM dept) LOOP
        dbms_output.put_line(rec.deptno || ', ' || rec.dname);
    END LOOP;
END;
/


------------------------------------------------
DECLARE
    --cursor ���� --> LOOP���� inline ����
    mx INTEGER;
    mn INTEGER;
    sm INTEGER;
    ct INTEGER;
BEGIN
    mx := 0;
    ct := 0;
    -- for(String str : list)
    FOR rec IN (SELECT * FROM dt) LOOP
        dbms_output.put_line(rec.dt);
        ct := ct + 1;
        --mx := rec.dt;
        --sm := max(dt) - min(dt);
    END LOOP;
    ct := ct - 1;
    dbms_output.put_line(ct);
END;
/








DECLARE
    --cursor ���� --> LOOP���� inline ����
    sm INTEGER;
    ct INTEGER;
    fi INTEGER;
BEGIN
    sm := 0;
    ct := 0;
    fi := 0;
    -- for(String str : list)
    FOR rec IN (SELECT bdt, adt, bdt-adt sm
                FROM(
                    SELECT dt adt, rownum rn
                    FROM dt
                    ORDER BY dt desc) a,
                    (
                    SELECT dt bdt, rownum+1 rn
                    FROM dt
                    ORDER BY dt desc) b
                WHERE a.rn = b.rn) LOOP
        --dbms_output.put_line(rec.sm);
        sm := sm + rec.sm;
        ct := ct + 1;
    END LOOP;
    
    ct := ct;
    fi := sm / ct;
    dbms_output.put_line('������� : ' || fi);
END;
/

--�������
CREATE OR REPLACE PROCEDURE avgdt
IS
    --�����
    prev_dt DATE;
    ind NUMBER := 0;
    diff NUMBER := 0;
BEGIN
    --dt ���̺� ��� ������ ��ȸ
    FOR rec IN (SELECT * FROM dt ORDER BY dt DESC) LOOP
        -- red : dt�÷�
        -- �������� ������(dt) - ���� ������ : 
        IF ind = 0 THEN -- LOOP�� ù ����
            prev_dt := rec.dt;
        ELSE
            diff := diff + prev_dt - rec.dt;
            prev_dt := rec.dt;
        END IF;
        ind := ind + 1;
    END LOOP;
    dbms_output.put_line('diff : ' || diff / (ind-1));
END;
/

exec avgdt;

SELECT *
FROM daily;

SELECT *
FROM cycle;




--1	100	2	1
--1�� ���� 100�� ��ǰ�� �����ϳ� �Ѱ��� �Դ´�


SELECT TO_CHAR(TO_DATE('201911', 'YYYYMM'), 'd') 
FROM dual;



SELECT LAST_DAY(NOW() - interval 1 month)  FROM DUAL; --�̴��� ��������

SELECT  TO_CHAR(ADD_MONTHS(LAST_DAY(SYSDATE)+1,-1),'DD') MONTH_FIRST_DAY  --���� ù°��
FROM    DUAL;

SELECT  TO_CHAR(LAST_DAY(SYSDATE),'DD') MONTH_LAST_DAY FROM DUAL; --���� ��������

SELECT ml, mf, ml-mf
FROM(SELECT  TO_CHAR(ADD_MONTHS(LAST_DAY(SYSDATE)+1,-1),'DD') mf--MONTH_FIRST_DAY
FROM    DUAL) a,
(SELECT  TO_CHAR(LAST_DAY(SYSDATE),'DD') ml--MONTH_LAST_DAY 
FROM DUAL) b;





--> DAILY
1 100 20191104 1
1 100 20191104 1
1 100 20191104 1
1 100 20191104 1

CREATE OR REPLACE PROCEDURE insertdate_test(p_cid IN daily.cid%TYPE, p_pid IN daily.pid%TYPE, p_dt IN daily.dt%TYPE, p_cnt IN daily.cnt%TYPE)
IS
--    p_deptno dept.deptno%type;
--    p_dname dept.dname%type;
--    p_loc dept.loc%type;
BEGIN
    FOR i IN 1..30
    IF i = 
        INSERT INTO daily(cid, pid, dt, cnt)
        VALUES (p_cid, p_pid, p_dt, p_cnt);
    END LOOP;
END;
/

exec insertdate_test(1, 100, 20101012, 1);

DESC daily;

SELECT *
FROM daily;

INSERT INTO daily(cid, pid, dt, cnt)
VALUES(1, 100, 20101011, 1);

------������� ��
CREATE OR REPLACE PROCEDURE create_daily_sales(p_yyyymm VARCHAR2)
IS
    --�޷��� �������� ������ RECORD TYPE
    TYPE cal_row IS RECORD (
        dt VARCHAR2(9),
        d VARCHAR2(1));
    
    --�޷� ������ ������ table type
    TYPE calendar IS TABLE OF cal_row;
    cal calendar;
    
    --�����ֱ� cursor
    CURSOR cycle_cursor IS
        SELECT *
        FROM cycle;
BEGIN
    SELECT TO_CHAR(TO_DATE(p_yyyymm, 'YYYYMM') + (LEVEL-1), 'YYYYMMDD') dt,
           TO_CHAR(TO_DATE(p_yyyymm, 'YYYYMM') + (LEVEL-1), 'D') d
           BULK COLLECT INTO cal
    FROM dual
    CONNECT BY LEVEL <= TO_NUMBER(TO_CHAR(LAST_DAY(TO_DATE(p_yyyymm, 'YYYYMM')),'DD'));
    
    --�����Ϸ��� �ϴ� ����� ���� �����͸� �����Ѵ�
    DELETE daily
    WHERE dt LIKE p_yyyymm || '%';
    
    --�����ֱ� loop
    FOR rec IN cycle_cursor LOOP
        FOR i IN 1..cal.count LOOP    
            --�����ֱ��� �����̶� ������ �����̶� ������ ��
            if REC.day = cal(i).d THEN
                INSERT INTO daily VALUES(rec.cid, rec.pid, cal(i).dt, rec.cnt);
            END IF;
        END LOOP;    
    END LOOP;
    COMMIT;    
END;
/

exec create_daily_sales('201911');

SELECT *
FROM daily;
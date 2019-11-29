--CURSOR를 명시적으로 선언하지 않고
--LOOP에서 inline 형태로 cursor 사용

set serveroutput on;
-- 익명 블록
DECLARE
    --cursor 선언 --> LOOP에서 inline 선언
BEGIN
    -- for(String str : list)
    FOR rec IN (SELECT deptno, dname FROM dept) LOOP
        dbms_output.put_line(rec.deptno || ', ' || rec.dname);
    END LOOP;
END;
/


------------------------------------------------
DECLARE
    --cursor 선언 --> LOOP에서 inline 선언
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
    --cursor 선언 --> LOOP에서 inline 선언
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
    dbms_output.put_line('간격평균 : ' || fi);
END;
/

--이진우쌤
CREATE OR REPLACE PROCEDURE avgdt
IS
    --선언부
    prev_dt DATE;
    ind NUMBER := 0;
    diff NUMBER := 0;
BEGIN
    --dt 테이블 모든 데이터 조회
    FOR rec IN (SELECT * FROM dt ORDER BY dt DESC) LOOP
        -- red : dt컬럼
        -- 먼저읽은 데이터(dt) - 다음 데이터 : 
        IF ind = 0 THEN -- LOOP의 첫 시작
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
--1번 고객은 100번 제품을 월요일날 한개를 먹는다


SELECT TO_CHAR(TO_DATE('201911', 'YYYYMM'), 'd') 
FROM dual;



SELECT LAST_DAY(NOW() - interval 1 month)  FROM DUAL; --이달의 마지막날

SELECT  TO_CHAR(ADD_MONTHS(LAST_DAY(SYSDATE)+1,-1),'DD') MONTH_FIRST_DAY  --월의 첫째날
FROM    DUAL;

SELECT  TO_CHAR(LAST_DAY(SYSDATE),'DD') MONTH_LAST_DAY FROM DUAL; --월의 마지막날

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

------이진우쌤 답
CREATE OR REPLACE PROCEDURE create_daily_sales(p_yyyymm VARCHAR2)
IS
    --달력의 행정보를 저장할 RECORD TYPE
    TYPE cal_row IS RECORD (
        dt VARCHAR2(9),
        d VARCHAR2(1));
    
    --달력 정보를 저장할 table type
    TYPE calendar IS TABLE OF cal_row;
    cal calendar;
    
    --애음주기 cursor
    CURSOR cycle_cursor IS
        SELECT *
        FROM cycle;
BEGIN
    SELECT TO_CHAR(TO_DATE(p_yyyymm, 'YYYYMM') + (LEVEL-1), 'YYYYMMDD') dt,
           TO_CHAR(TO_DATE(p_yyyymm, 'YYYYMM') + (LEVEL-1), 'D') d
           BULK COLLECT INTO cal
    FROM dual
    CONNECT BY LEVEL <= TO_NUMBER(TO_CHAR(LAST_DAY(TO_DATE(p_yyyymm, 'YYYYMM')),'DD'));
    
    --생성하려고 하는 년월의 실적 데이터를 삭제한다
    DELETE daily
    WHERE dt LIKE p_yyyymm || '%';
    
    --애음주기 loop
    FOR rec IN cycle_cursor LOOP
        FOR i IN 1..cal.count LOOP    
            --애음주기의 요일이랑 일자의 요일이랑 같은지 비교
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
--20191127

SELECT *
FROM no_emp;

SELECT LPAD(' ', 4 * (LEVEL -1)) || org_cd org_cd, no_emp
FROM no_emp
START WITH parent_org_cd IS NULL
CONNECT BY PRIOR org_cd = parent_org_cd;

-- 1.leaf node 찾기
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
--할당연산 :=
-- System.out.println("") --> dbms_out.put_line("");
-- Log4j
-- set serveroutput on; --출력기능을 활성화

--PL/SQL
--declare   : 변수, 상수 선언
--begin     : 로직 실행
--exception : 예외 처리

DESC dept;
set serveroutput on;
DECLARE
    --변수 선언
    deptno NUMBER(2);
    dname VARCHAR(14);
BEGIN
    SELECT deptno, dname INTO deptno, dname
    FROM dept
    WHERE deptno = 10;
    --dbms_output.put_line('test');
    
    --SELECT 절의 결과를 변수에 잘 할당 했는지 확인
    dbms_output.put_line('dname : ' || dname || '(' || deptno || ')');
END;
/

DECLARE
    --참조 변수 선언(테이블 컬럼타입이 변경되도 pl/sql 구문을 수정할 필요가 없다)
    deptno dept.deptno%TYPE;
    dname dept.dname%TYPE;
BEGIN
    SELECT deptno, dname INTO deptno, dname
    FROM dept
    WHERE deptno = 10;
    --dbms_output.put_line('test');
    
    --SELECT 절의 결과를 변수에 잘 할당 했는지 확인
    dbms_output.put_line('dname : ' || dname || '(' || deptno || ')');
END;
/  -- 이게 DECLARE에서 세미콜론 같은겁니다.

--10번부서의 부서이름과  LOC 정보를 화면출력하는 프로시저
--프로시저명 : printdept
-- CREATE OR REPLACE VIEW
CREATE OR REPLACE PROCEDURE printdept 
IS
    --변수선언
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
    --변수선언
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

-- printtemp procedure 생성
-- param : empno
-- logic : empno에 해당하는 사원의 정보를 조회하여 사원이름, 부서이름을 화면에 출력

CREATE OR REPLACE PROCEDURE printtemp(p_empno IN emp.empno%TYPE)
IS
    --변수선언
    ename emp.ename%TYPE; --꼭 ename이 아니어도 된다. 말그대로 변수선언이니까.
    dname dept.dname%TYPE;
BEGIN
    SELECT ename, dname
    INTO ename, dname --결과를 담을 변수명 선언
    FROM emp, dept
    WHERE empno = p_empno
    AND emp.deptno = dept.deptno;
    
    dbms_output.put_line('ename, dname = ' || ename || ',' || dname);
END;
/
--결과 확인
exec printtemp(7499);

SELECT *
FROM dept_test;

-- registdept_test procedure 생성
-- param : deptno, dname, loc
-- logic : 입력받은 부서 정보를 dept_test 테이블에 신규 입력
-- exec registdept_test('99', 'ddit', 'daejeon');
-- dept_test테이블에 정상적으로 입력 되었는지 확인
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

    
    

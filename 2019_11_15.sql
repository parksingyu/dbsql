SELECT SUM(sal)
FROM emp;

--emp 테이블에 empno컬럼을 기준으로 PRIMARY KEY를 생성
--PRIMARY KEY = UNIQUE + NOT NULL
--UNIQUE ==> 해당 컬럼으로 UNIQUE INDEX를 자동으로 생성

ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY(empno);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno=7369;

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

Plan hash value: 2949544139
--------------------------------------------------------------------------------------
| Id  | Operation                   | Name   | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |        |     1 |    87 |     1   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP    |     1 |    87 |     1   (0)| 00:00:01 |
|*  2 |   INDEX UNIQUE SCAN         | PK_EMP |     1 |       |     0   (0)| 00:00:01 |
--------------------------------------------------------------------------------------
Predicate Information (identified by operation id):
---------------------------------------------------
   2 - access("EMPNO"=7369)
   
--empno 컬럼으로 인덱스가 존재하는 상황에서
--다른컬럼 값으로 데이터를 조회하는 경우

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER';

SELECT *
FROM TABLE(dbms_xplan.display);

/*TABLE 생성(제약조건이 없고 인덱스를 변도로 생성X)
--> TABLE ACCESS FULL

2. 첫번째 인덱스
--> TABLE ACCESS FULL
    첫번째 인덱스
    
3. 두번째 인덱스
--> TABLE ACCESS FULL
    첫번째 인덱스
    두번째 인덱스
    
4. 세번째 인덱스
--> TABLE ACCESS FULL
    첫번째 인덱스
    두번째 인덱스
    세번째 인덱스
    
테이블 2개 조인시 : 16개 전략 가능
테이블 3개 조인시 : 64개 전략 가능*/

EXPLAIN PLAN FOR
SELECT empno
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(dbms_xplan.display);

--컬럼에 중복이 가능한 non-unique 인덱스 생성후
--unique index와의 실행계획 비교
--PRIMARY KEY 제약조건 삭제(unique 인덱스 삭제)
ALTER TABLE emp DROP CONSTRAINT pk_emp;

CREATE INDEX /*UNIQUE*/ IDX_emp_01 ON emp (empno);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(dbms_xplan.display);



Plan hash value: 4208888661
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    87 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    87 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_01 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("EMPNO"=7782)
 
Note
-----
   - dynamic sampling used for this statement (level=2)
   
--emp 테이블에 job컬럼으로 두번째 인덱스 생성
--job 컬럼은 다른 로우의 컬럼과 중복이 가능한 컬럼이다.
CREATE INDEX idx_emp_02 ON emp (job);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER';

SELECT *
FROM TABLE(dbms_xplan.display);

SELECT * 
FROM emp
WHERE job = 'MANAGER';

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';

SELECT *
FROM TABLE(dbms_xplan.display);

Plan hash value: 4079571388
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    87 |     2   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    87 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_02 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("ENAME" LIKE 'C%')
   2 - access("JOB"='MANAGER')
 
Note
-----
   - dynamic sampling used for this statement (level=2)


--emp 테이블에 job ename 컬럼을 기준으로 non-unique 인덱스 생성
CREATE INDEX IDX_emp_03 ON emp(job, ename);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';

SELECT *
FROM TABLE(dbms_xplan.display);

Plan hash value: 2549950125
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    87 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    87 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_03 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("JOB"='MANAGER' AND "ENAME" LIKE 'C%')
       filter("ENAME" LIKE 'C%')
 
Note
-----
   - dynamic sampling used for this statement (level=2)

--emp 테이블에 ename, job 컬럼으로 non-unique 인덱스 생성
CREATE INDEX IDX_EMP_04 ON emp(ename, job);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE '%C';

SELECT *
FROM TABLE(dbms_xplan.display);

Plan hash value: 4079571388
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    87 |     2   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    87 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_02 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("ENAME" IS NOT NULL AND "ENAME" LIKE '%C')
   2 - access("JOB"='MANAGER')
 
Note
-----
   - dynamic sampling used for this statement (level=2)
   

--HINT를 사용한 실행 계획 제어
EXPLAIN PLAN FOR
SELECT /*+ INDEX ( emp idx_emp_03 ) */ *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE '%C';

SELECT *
FROM TABLE(dbms_xplan.display);

CREATE TABLE DEPT_TEST AS SELECT * FROM DEPT WHERE 1 = 1;

SELECT *
FROM DEPT_TEST;

-- deptno컬럼을 기준으로 unique 인덱스 생성
CREATE UNIQUE INDEX IDX_deptno ON dept_test(deptno);



-- dname 컬럼을 기준으로 non-unique 인덱스 생성
CREATE INDEX IDX_dname ON dept_test(dname);

-- deptno, dname 컬럼을 기준으로 non-unique 인덱스 생성
CREATE INDEX IDX_deptno_dname ON dept_test(deptno, dname);

SELECT *
FROM TABLE(dbms_xplan.display);

-- 실습 idx1 에서 생성한 인덱스를 삭제하는 DDL 문을 작성하세요.
DROP INDEX IDX_deptno;
DROP INDEX IDX_dname;
DROP INDEX IDX_deptno_dname;

SELECT *
FROM emp
WHERE empno = 7298;

SELECT *
FROM emp
WHERE ename = 'SCOTT';

SELECT *
FROM emp
WHERE sal BETWEEN 500 AND 7000
AND deptno = 20;

SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.deptno = 10
AND emp.empno LIKE '78%';

SELECT B.*
FROM EMP A, EMP B
WHERE A.mgr = B.empno
AND A.deptno = 30;


--SMITH, WARD 가 속하는 부서의 직원들 조회
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
                
-- ANY : set중에 만족하는게 하나라도 있으면 참으로(크기비교)
-- SMITH, WARD의 급여보다 두사람중 아무나 
SELECT *
FROM emp
WHERE sal < any(SELECT sal --800, 1250 --> 1250보다 작은 급여를 받는 사람
                FROM emp
                WHERE ename IN ('SMITH', 'WARD'));
                
--SMITH와 WARD보다 급여가 높은 직원 조회
--SMITH보다도 급여가 높고 WARD보다도 급여가 높은 사람(AND)
SELECT *
FROM emp
WHERE sal > all(SELECT sal
                FROM emp
                WHERE ename IN('SMITH', 'WARD'));
                
--NOT IN

--관리자의 직원정보
--1. 관리자인 사람만 조회
-- .mgr 컬럼에 값이 나오는 직원
-- 중복제거 : DISTINCT
-- 
SELECT DISTINCT mgr
FROM emp;

--어떤 직원의 관리자 역할을 하는 직원 정보 조회
SELECT *
FROM emp
WHERE empno IN(7839,7782,7698,7902,7566,7788);

SELECT *
FROM emp
WHERE empno IN(SELECT mgr
               FROM  emp);

--관리자 역할을 하지 않는 평사원 정보 조회
--단 NOT IN 연산자 사용시 set에 null이 포함될 경우 정상적으로 동작하지 않는다.
--NULL처리 함수나 WHERE절을 통해 NULL값을 처리한 이후 사용
SELECT *
FROM emp
WHERE empno NOT IN(SELECT nvl(mgr, -9999)
                   FROM  emp);

--pair wise
--사번 7499, 7782인 직원의 관리자, 부서번호 조회
-- 7698 30
-- 7839 10
--직원중에 관리자와 부서번호가 (7698, 30) 이거나, (7839, 10)인 사람
--mgr, deptno 컬럼을 [동시]에 만족시키는 직원 정보 조회
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
                
--SCALAR SUBQUERY : SELECT 절에 등장하는 서브 쿼리(단, 값이 하나의 행, 하나의 컬럼)
--직원의 소속 부서명을 JOIN을 사용하지 않고 조회
SELECT empno, ename, deptno, (SELECT dname 
                              FROM dept
                              WHERE deptno = emp.deptno) dname
FROM emp;

SELECT dname 
FROM dept
WHERE deptno = 20;

--sub4 데이터 생성
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
    WHERE cid = 2); --2번 고객이 먹는 제품

--ppt249 (과제 20191112까지)
SELECT a.cid, customer.cnm, a.pid, product.pnm, a.day, a.cnt
FROM (SELECT * --100, 400
      FROM cycle
      WHERE cid = 1
      AND pid IN(SELECT distinct pid
            FROM cycle
            WHERE cid = 2)) a, customer, product
WHERE a.cid = customer.cid
AND a.pid = product.pid;

--ppt252 (과제 20191112까지)
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
    
--EXISTS MAIN쿼리의 컬럼을 사용해서 SUBQUERY에 만족하는 조건이 있는지 체크
--만족하는 값이 하나라도 존재하면 더이상 진행하지 않고 멈추기 때문에
--성능면에서 유리

--MGR가 존재하는 직원 조회
SELECT *
FROM emp a
WHERE EXISTS (SELECT 'X'
              FROM emp
              WHERE empno = a.mgr);
              
--MGR가 존재하지 않는 직원 조회
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

--부서에 소속된 직원이 있는 부서 정보 조회(EXISTS)
SELECT *
FROM dept
WHERE deptno IN(10, 20, 30);

--EXISTS의 핵심
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
                 
--집합연산
--UNION : 합집합. 중복을 제거
--        DBMS에서는 중복을 제거하기위해 데이터를 정렬
--        (대량의 데이터에 대한 정렬시 부하)
--UNION ALL : UNION과 같은 개념
--            중복을 제거하지 않고, 위 아래 집합을 결합 => 중복가능
--            위아래 집합에 중복되는 데이터가 없다는 것을 확신하면
--            UNION 연산자보다 성능면에서 유리
--사번이 7566 또는 7698인 사원 조회(사번이랑, 이름)
SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7698

UNION
--사번이 7369, 7499인 사원 조회(사번, 이름)
SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7698;
--WHERE empno = 7369 OR empno = 7499;

--UNION ALL(중복 허용)
SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7698

UNION ALL
--사번이 7369, 7499인 사원 조회(사번, 이름)
SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7698;
--WHERE empno = 7369 OR empno = 7499;

--INTERSECT(교집합 : 위 아래 집합간 공통 데이터)
SELECT empno, ename
FROM emp
WHERE empno IN( 7566, 7698, 7369)

INTERSECT

SELECT empno, ename
FROM EMP
WHERE empno IN(7566, 7698, 7499);


--MINUS(차집합 : 위 집합에서 아래 집합을 제거)
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
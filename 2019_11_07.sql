--emp 테이블에는 부서번호(deptno)만 존재
--emp 테이블에서 부서명을 조회하기 위해서는
--dept 테이블과 조인을 통해 부서명 조회

--조인 문법
--ANSI : 테이블1 join 테이블2 ON(테이블1.COL = 테이블2.COL)
--       emp JOIN dept ON (emp.deptno = dept.deptno)
--ORACLE : FROM 테이블1, 테이블2, WHERE 테이블1.col = 테이블2.col
--         FROM emp, dept WHERE emp.deptno = dept.deptno

--사원번호, 사원명, 부서번호, 부서명(ORACLE)
SELECT emp.empno, emp.ename, emp.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

--사원번호, 사원명, 부서번호, 부서명(ANSI)
SELECT emp.empno, emp.ename, emp.deptno, dept.dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno);

-- ppt 182
-- emp, dept 테이블을 이용하여 다음과 같이 조회되도록 쿼리를 작성하세요(급여가 2500초과, ORACLE)
SELECT emp.empno, emp.ename, emp.sal, emp.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND SAL > 2500
ORDER BY dept.dname;

-- emp, dept 테이블을 이용하여 다음과 같이 조회되도록 쿼리를 작성하세요(급여가 2500초과, ANSI)
SELECT emp.empno, emp.ename, emp.sal, emp.deptno, dept.dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno)
AND SAL > 2500
ORDER BY dept.dname;

-- emp, dept 테이블을 이용하여 다음과 같이 조회되도록 쿼리를 작성하세요(급여가 2500초과, 사번이 7600보다 큰 직원)
SELECT emp.empno, emp.ename, emp.sal, emp.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND SAL > 2500
AND emp.empno > 7600
ORDER BY dept.dname;

SELECT emp.empno, emp.ename, emp.sal, emp.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND SAL > 2500
AND emp.empno > 7600
AND dept.dname = 'RESEARCH'
ORDER BY emp.empno desc;

SELECT *
FROM prod;

SELECT *
FROM lprod;

--ppt185
--erd 다이어그램을 참고하여 prod테이블과 lprod 테이블을 조인하여
--다음과 같은 결과가 나오는 쿼리를 작성해보세요. (ORACLE)
SELECT lprod.lprod_gu, lprod.lprod_nm, prod.prod_id, prod.prod_name
FROM prod, lprod
WHERE prod.prod_lgu = lprod.lprod_gu;

--ppt185
--erd 다이어그램을 참고하여 prod테이블과 lprod 테이블을 조인하여
--다음과 같은 결과가 나오는 쿼리를 작성해보세요. (ORACLE, alias)
SELECT l.lprod_gu, l.lprod_nm, p.prod_id, p.prod_name
FROM prod p, lprod l
WHERE p.prod_lgu = l.lprod_gu;

--ppt185
--erd 다이어그램을 참고하여 prod테이블과 lprod 테이블을 조인하여
--다음과 같은 결과가 나오는 쿼리를 작성해보세요. (ANSI)
SELECT lprod.lprod_gu, lprod.lprod_nm, prod.prod_id, prod.prod_name
FROM prod JOIN lprod on (prod.prod_lgu = lprod.lprod_gu);

SELECT buyer.buyer_id, buyer.buyer_name, prod.prod_id, prod.prod_name
FROM prod, buyer
WHERE buyer.buyer_id = prod.prod_buyer;

--ppt 187
SELECT member.mem_id, member.mem_name, prod.prod_id, prod.prod_name, cart.cart_qty
FROM member, cart, prod
WHERE prod.prod_id = cart.cart_prod
AND cart.cart_member = member.mem_id;

SELECT *
FROM cart, member
WHERE member.mem_id = cart.cart_member;

--ppt189
--erd 다이어그램을 참고하여 customer, cycle 테이블을 조인하여 고객별
--애음 제품, 애음 요일, 개수를 다음과 같은 결과가 나오도록 쿼리를
--작성해보세요(고객명이 brown, sally인 고객만 조회)
SELECT cycle.cid, customer.cnm, cycle.pid, cycle.day, cycle.cnt
FROM product, cycle, customer
WHERE cycle.cid = customer.cid
AND product.pid = cycle.pid
AND (customer.cnm = 'brown'
or customer.cnm = 'sally');

--ppt190
SELECT cycle.cid, customer.cnm, cycle.pid,product.pnm ,cycle.day, cycle.cnt
FROM product, cycle, customer
WHERE cycle.cid = customer.cid
AND product.pid = cycle.pid
AND (customer.cnm = 'brown'
or customer.cnm = 'sally');

--ppt191
--SELECT cycle.cid, customer.cnm, cycle.pid,product.pnm ,cycle.day, cycle.cnt
SELECT a.cid, customer.cnm, a.pid, product.pnm, b as cnt
FROM(
SELECT cid, pid, sum(cnt) b
FROM cycle
GROUP BY cid, pid) a, product, customer
WHERE product.pid = a.pid
AND a.cid = customer.cid;

--ppt192
--erd다이어그램을 참고하여 cycle, product 테이블을 이용하여 제품별, 개수의 합과, 
--제품명을 다음과 같은 결과가 나오도록 쿼리를 작성해보세요
SELECT cycle.pid, product.pnm, sum(cycle.cnt) cnt
FROM cycle, product, customer
WHERE cycle.cid = customer.cid
AND product.pid = cycle.pid
GROUP BY cycle.pid, product.pnm;

SELECT *
FROM cycle;

SELECT *
from customer;

SELECT *
FROM product;

SELECT product.pid, product.pnm, sum(cnt) cnt
FROM product, cycle, customer
WHERE product.pid = cycle.pid
AND cycle.cid = customer.cid
GROUP BY product.pid, product.PNM;





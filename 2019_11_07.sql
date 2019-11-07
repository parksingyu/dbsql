--emp ���̺��� �μ���ȣ(deptno)�� ����
--emp ���̺��� �μ����� ��ȸ�ϱ� ���ؼ���
--dept ���̺�� ������ ���� �μ��� ��ȸ

--���� ����
--ANSI : ���̺�1 join ���̺�2 ON(���̺�1.COL = ���̺�2.COL)
--       emp JOIN dept ON (emp.deptno = dept.deptno)
--ORACLE : FROM ���̺�1, ���̺�2, WHERE ���̺�1.col = ���̺�2.col
--         FROM emp, dept WHERE emp.deptno = dept.deptno

--�����ȣ, �����, �μ���ȣ, �μ���(ORACLE)
SELECT emp.empno, emp.ename, emp.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

--�����ȣ, �����, �μ���ȣ, �μ���(ANSI)
SELECT emp.empno, emp.ename, emp.deptno, dept.dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno);

-- ppt 182
-- emp, dept ���̺��� �̿��Ͽ� ������ ���� ��ȸ�ǵ��� ������ �ۼ��ϼ���(�޿��� 2500�ʰ�, ORACLE)
SELECT emp.empno, emp.ename, emp.sal, emp.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND SAL > 2500
ORDER BY dept.dname;

-- emp, dept ���̺��� �̿��Ͽ� ������ ���� ��ȸ�ǵ��� ������ �ۼ��ϼ���(�޿��� 2500�ʰ�, ANSI)
SELECT emp.empno, emp.ename, emp.sal, emp.deptno, dept.dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno)
AND SAL > 2500
ORDER BY dept.dname;

-- emp, dept ���̺��� �̿��Ͽ� ������ ���� ��ȸ�ǵ��� ������ �ۼ��ϼ���(�޿��� 2500�ʰ�, ����� 7600���� ū ����)
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
--erd ���̾�׷��� �����Ͽ� prod���̺�� lprod ���̺��� �����Ͽ�
--������ ���� ����� ������ ������ �ۼ��غ�����. (ORACLE)
SELECT lprod.lprod_gu, lprod.lprod_nm, prod.prod_id, prod.prod_name
FROM prod, lprod
WHERE prod.prod_lgu = lprod.lprod_gu;

--ppt185
--erd ���̾�׷��� �����Ͽ� prod���̺�� lprod ���̺��� �����Ͽ�
--������ ���� ����� ������ ������ �ۼ��غ�����. (ORACLE, alias)
SELECT l.lprod_gu, l.lprod_nm, p.prod_id, p.prod_name
FROM prod p, lprod l
WHERE p.prod_lgu = l.lprod_gu;

--ppt185
--erd ���̾�׷��� �����Ͽ� prod���̺�� lprod ���̺��� �����Ͽ�
--������ ���� ����� ������ ������ �ۼ��غ�����. (ANSI)
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
--erd ���̾�׷��� �����Ͽ� customer, cycle ���̺��� �����Ͽ� ����
--���� ��ǰ, ���� ����, ������ ������ ���� ����� �������� ������
--�ۼ��غ�����(������ brown, sally�� ���� ��ȸ)
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
--erd���̾�׷��� �����Ͽ� cycle, product ���̺��� �̿��Ͽ� ��ǰ��, ������ �հ�, 
--��ǰ���� ������ ���� ����� �������� ������ �ۼ��غ�����
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





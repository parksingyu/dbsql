-- ��� �Ķ���Ͱ� �־����� �� �ش����� �ϼ��� ���ϴ� ����
-- 201911 --> 30 / 201912  --> 31

--�Ѵ� ���� �� �������� ���� = �ϼ�
--��������¥ ���� �� --> DD �� ����
SELECT TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')), 'DD') day_cnt  -- ���ε� �ϴ� ���
FROM DUAL;   --201602��� �Է��ϸ� �����̾ 29�� ��µȴ�.

SELECT :yyyymm as PARAM, TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')), 'DD') dt  -- ���ε� �ϴ� ���
FROM DUAL;   --201602��� �Է��ϸ� �����̾ 29�� ��µȴ�.


explain plan for
SELECT *
FROM emp
WHERE TO_CHAR(empno) = '7369';

SELECT empno, ename, sal, TO_CHAR(sal, 'L999,999.99') sal_fmt
FROM emp;

--function null
--nvl(coll, coll�� null�� ��� ��ü�� ��)
SELECT empno, ename, sal, comm, nvl(comm, 0) nvl_comm, sal+comm, sal + nvl(comm, 0), nvl(sal+comm, 0)
FROM emp;

--NVL2(coll, coll�� null�� �ƴ� ��� ǥ���Ǵ� ��, coll null�� ��� ǥ�� �Ǵ� ��)
SELECT empno, ename, sal, comm, NVL2(comm, comm, 0) + sal
FROM emp;

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

--NULLIF(expr1, expr2)
--expr1 == expr2 ������ null
--else : expr1
SELECT empno, ename, sal, comm, NULLIF(sal, 1250)
FROM emp;

--COALESCE(expr1, expr2, expr3....)
--�Լ� ������ null�� �ƴ� ù��° ����
SELECT empno, ename, sal, comm, coalesce(comm, sal)
FROM emp;

--nvl, nvl2, coalesce
SELECT empno, ename, MGR, nvl(MGR, 9999) as MGR_N, coalesce(MGR, 9999) as MGR_N, nvl2(MGR, MGR, 9999) as MGR_N
FROM emp;

SELECT userid, usernm, reg_dt, nvl(reg_dt, sysdate) as N_REG_DT
FROM users;

--case when
SELECT empno, ename, job, sal,
    case
            when job = 'SALESMAN' then sal * 1.05
            when job = 'MANAGER' then sal * 1.10
            when job = 'PRESIDENT' then sal * 1.20
            else sal 
    end as case_sal
FROM emp;

--decode (col, search1, return1, search2, return2....default)
SELECT empno, ename, job, sal,
        DECODE(job, 'SALESMAN', sal*1.05,
        'MANAGER', sal * 1.10,
        'PRESIDENT', sal * 1.20,
                            sal) decode_sal
FROM emp;

SELECT empno, ename,
    DECODE(
        deptno, 10, 'ACCOUNTING',
        20, 'RESEARCH',
        30, 'SALES',
        40, 'OPERTAIONS',
                    'DDIT') dname
FROM emp;

SELECT empno, ename,
    case
        when deptno = '10' then 'ACCOUNTING'
        when deptno = '20' then 'RESEARCH'
        when deptno = '30' then 'SALES'
        when deptno = '40' then 'OPERTAIONS'
        else 'DDIT'
    end as DNAME, DEPTNO
FROM emp;

SELECT empno, ename, hiredate,
    DECODE(
        MOD(TO_CHAR(hiredate, 'yy'),2), 0, '�ǰ����� ������'
        , 1, '�ǰ����� �����', 
                        'DDIT') CONTACT
FROM emp;

SELECT empno, ename, hiredate,
    case
        when MOD(TO_CHAR(hiredate, 'yy'),2) = 0 then '�ǰ����� ������'
        when MOD(TO_CHAR(hiredate, 'yy'),2) = 1 then '�ǰ����� �����'
        else 'DDIT'
    end as CONTACT_TO_DOCTOR
FROM emp;


-- 1. ���� �⵵ ���ϱ�
-- 2. ���� �⵵�� ¦������ ���
-- ����� 2�� ������ �������� �׻� 2���� �۴�
-- 2�� ���� ��� �������� 0 �Ǵ� 1
-- MOD(���, ������) 
SELECT TO_CHAR(hiredate, 'yy')
FROM emp;

SELECT MOD(TO_CHAR(sysdate, 'yy'), 2)
FROM dual;

--emp ���̺��� �Ի����ڰ� Ȧ�������� ¦�������� Ȯ��
SELECT empno, ename, hiredate, MOD(TO_CHAR(hiredate, 'yy'), 2) as y1, MOD(TO_CHAR(sysdate, 'yy'), 2) y2,
    case 
        when y1 = y2 then '�ǰ����� ���'
        else '�ǰ����� ����'
    end contact_to_doctor
FROM emp;

SELECT USERID, USERNM, REG_DT, MOD(TO_CHAR(sysdate, 'yy'), 2) thisyear, MOD(TO_CHAR(reg_dt, 'yy'), 2) as y1,
    case
        when MOD(TO_CHAR(sysdate, 'yy'), 2) = MOD(TO_CHAR(reg_dt, 'yy'), 2) then '�ǰ����� �����'
        else '�ǰ����� ������'
    end as contacttodoctor
FROM users;

--�׷��Լ�(AVG, MAX, MIN, SUM, COUNT)
--�׷��Լ��� NULL���� ����󿡼� �����Ѵ�.
--SUM(comm), COUNT(*), COUNT(mgr)
--������ ���� ���� �޿��� �޴»���� �޿�
--������ ���� ���� �޿��� �޴»���� �޿�
--������ �޿� ���(�Ҽ��� ��°�ڸ� ������ ������ --> �Ҽ��� 3°�ڸ����� �ݿø�)
--������ �޿� ��ü��
SELECT MAX(sal) max_sal, MIN(sal) min_sal,
       round(AVG(sal),2) avg_sal,
       SUM(sal) sum_sal,
       count(*) emp_cnt,
       COUNT(sal) sal_cnt,
       COUNT(mgr) mgr_cnt,
       SUM(comm) comm_sum
FROM emp;

--�μ��� ���� ���� �޿��� �޴»���� �޿�
--GROUP BY ���� ������� ���� �÷��� SELECT ���� ����� ��� ����
SELECT deptno, MAX(sal) max_sal, MIN(sal) min_sal,
       round(AVG(sal),2) avg_sal,
       SUM(sal) sum_sal,
       count(*) emp_cnt,
       COUNT(sal) sal_cnt,
       COUNT(mgr) mgr_cnt,
       SUM(comm) comm_sum
FROM emp
GROUP BY deptno;

--�μ��� �ִ� �޿�

SELECT deptno, MAX(sal) max_sal
FROM emp
GROUP BY deptno
HAVING MAX(sal) > 3000;

SELECT MAX(sal) max_sal,
       MIN(sal) min_sal,
       round(AVG(sal),2) avg_sal,
       sum(sal) sum_sal,
       count(sal) count_sal,
       count(mgr) count_mgr,
       count(*) count_all
FROM emp;

SELECT deptno,
       MAX(sal) max_sal,
       MIN(sal) min_sal,
       round(AVG(sal),2) avg_sal,
       sum(sal) sum_sal,
       count(sal) count_sal,
       count(mgr) count_mgr,
       count(*) count_all
FROM emp
GROUP BY deptno;

SELECT *
from emp;




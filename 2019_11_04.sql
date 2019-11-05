SELECT *
FROM emp
WHERE job = 'SALESMAN' 
OR hiredate >= TO_DATE('19810601', 'YYYYMMDD');

SELECT *
FROM emp
ORDER BY ename DESC, mgr;   --ename���� ������������ �����ض�. ���࿡ �������� �ִٸ� mgr�� �������� �����ض�.

--ROWNUM
SELECT ROWNUM, e.*
FROM emp e;

SELECT ROWNUM, emp.*
FROM emp;

--ROWNUM�� ���Ĺ���
--ORDER BY���� SELECT �� ���Ŀ� ����
--ROWNUM �����÷��� �����ǰ��� ���ĵǱ� ������
--�츮�� ���ϴ´�� ù��° �����ͺ��� �������� ��ȣ �ο��� ���� �ʴ´�.
SELECT ROWNUM, e.*
FROM emp e
ORDER BY ename;

--ORDER BY ���� ������ �ζ��� �並 ����
SELECT ROWNUM, a.*
FROM
    (SELECT e.*
    FROM emp e
    ORDER BY ename) a;
    
--ROWNUM : 1������ �о�� �ȴ�.
--WHERE���� ROWNUM���� �߰��� �д°� �Ұ���
--�Ұ����� ���̽�
--WHERE ROWNUM = 2
--WHERE ROWNUM >= 2

--������ ���̽�
--WHERE ROWNUM = 1
--WHERE ROWNUM <= 10
SELECT ROWNUM, a.*
FROM
    (SELECT e.*
    FROM emp e
    ORDER BY ename) a;
    
--����¡ ó���� ���� �ļ� ROWNUM�� ��Ī�� �ο�, �ش� SQL�� INLINE VIEW��
--���ΰ� ��Ī�� ���� ����¡ ó��
SELECT *
FROM 
    (SELECT ROWNUM rn, a.*
        FROM
            (SELECT e.*
            FROM emp e
            ORDER BY ename) a)
WHERE rn between 10 AND 14;


--11/04 ������
--CONCAT : ���ڿ� ���� - �ΰ��� ���ڿ��� �����ϴ� �Լ�
--SUBSTR : ���ڿ��� �κ� ���ڿ�(java : String.substring)
--INSTR : ���ڿ��� Ư�� ���ڿ��� �����ϴ� ù��° �ε���
--LPAD  
SELECT CONCAT(CONCAT('HELLO',','), 'WORLD') CONCAT,
        SUBSTR('HELLO, WORLD', 0, 5) substr,
        SUBSTR('HELLO, WORLD', 1, 5) substr1,
        LENGTH('HELLO, WORLD') length,
        INSTR('HELLO, WORLD', 'O') instr,
        --INSTR(���ڿ�, ã�� ���ڿ�, ���ڿ��� Ư�� ��ġ ���� ǥ��)
        INSTR('HELLO, WORLD', 'O', 6) instr1, --���ڿ��� �ε���
        --INSTR(���ڿ�, ã�� ���ڿ�, ���ڿ��� Ư�� ��ġ ���� ǥ��)
        LPAD('HELLO, WORLD', 15, '*') lpad,
        LPAD('HELLO, WORLD', 15) lpad,
        LPAD('HELLO, WORLD', 15, ' ') lpad,
        RPAD('HELLO, WORLD', 15, '*') rpad,
        --REPLACE(�������ڿ�, �������ڿ����� �����ϰ��� �ϴ� ��� ���ڿ�, ���湮�ڿ�)
        REPLACE (REPLACE('HELLO, WORLD', 'HELLO', 'hello'), 'WORLD', 'world') replace,
        --TRIM ���ڿ� �Ǿհ� �ǵ��� ������ ��������. ��� ������ �ƴ�.
        TRIM('   HELLO, WORLD') trim,
        TRIM('H' FROM 'HELLO, WORLD') trim2 
FROM dual;

--ROUND(������, �ݿø� ��� �ڸ���)
SELECT ROUND(105.54, 2) r1,   --�Ҽ��� ��° �ڸ����� �ݿø�
       ROUND(105.55, 1) r2,   --�Ҽ��� ��° �ڸ����� �ݿø�
       ROUND(105.55, 0) r3,   --�Ҽ��� ù° �ڸ����� �ݿø�
       ROUND(105.55, -1) r4    --���� ù° �ڸ����� �ݿø�
FROM DUAL;

--TRUNC
SELECT
TRUNC(105.54, 2) T1,   --�Ҽ��� ��° �ڸ����� ����
TRUNC(105.55, 1) T2,   --�Ҽ��� ��° �ڸ����� ����
TRUNC(105.55, 0) T3,   --�Ҽ��� ù° �ڸ����� ����
TRUNC(105.55, -1) T4    --���� ù° �ڸ����� ����
FROM DUAL;

-- SYSDATE : ����Ŭ�� ��ġ�� ������ ���� ��¥ + �ð������� ����
-- ������ ���ڰ� ���� �Լ�

-- TO_CHAR : DATE Ÿ���� ���ڿ��� ��ȯ
-- ��¥�� ���ڿ��� ��ȯ�ÿ� ������ ����
SELECT TO_CHAR(SYSDATE, 'YYYY/MM/DD hh24:MI:SS'),
       TO_CHAR(SYSDATE + (1/24/60) * 30, 'YYYY/MM/DD HH24:MI:SS')
FROM dual;

SELECT TO_DATE('20191231', 'yyyymmdd') as LASTDAY,
       TO_DATE('20191231' -5, 'yyyymmdd') as LASTDAY_BEFORE5,
       TO_CHAR(SYSDATE) as now,
       TO_CHAR(SYSDATE-3) as now_BEFORE3
FROM dual;

--fn1
SELECT LASTDAY, LASTDAY-5 AS LASTDAY_BEFORE5,
        NOW, NOW-3 NOW_BEFORE3
FROM
    (SELECT TO_DATE('2019/12/31', 'YYYY/MM/DD') LASTDAY,
            SYSDATE NOW
    FROM DUAL);
    
-- date format
-- �⵵ : YYYY, YY, RR : ���ڸ��϶��� 4�ڸ��϶��� �ٸ�
-- RR : 50���� Ŭ��� ���ڸ��� 19, 50���� ������� ���ڸ��� 20
-- YYYY, RRRR�� ���� �������̸� ��������� ǥ�� �� ��
-- �������̸� ��������� ǥ��
-- D : ������ ���ڷ� ǥ��( �Ͽ���-1, ������-2, ȭ����-3...�����-7)
SELECT  TO_CHAR(TO_DATE('35/03/01', 'RR/MM/DD'), 'YYYY/MM/DD') r1,
        TO_CHAR(TO_DATE('55/03/01', 'RR/MM/DD'), 'YYYY/MM/DD') r2,
        TO_CHAR(TO_DATE('35/03/01', 'YY/MM/DD'), 'YYYY/MM/DD') y1,
        TO_CHAR(SYSDATE, 'D') d, --������ ������ -2
        TO_CHAR(SYSDATE, 'IW') iw, -- ���� ǥ��
        TO_CHAR(TO_DATE('20191229', 'YYYYMMDD'), 'IW') this
FROM dual;

SELECT  TO_CHAR(SYSDATE, 'YYYY/MM/DD') as DT_DASH,
        TO_CHAR(SYSDATE, 'YYYY/MM/DD HH24:MI:SS') as DT_DASH_WIDTH_TIME,
        TO_CHAR(SYSDATE, 'DD/MM/YYYY') as DT_DD_MM_YYYY
FROM dual;

--��¥�� �ݿø�(ROUND), ����(TRUNC)
--ROUND(DATE, '����') YYYY, MM, DD

SELECT ename,
TO_CHAR(hiredate, 'YYYY/MM/DD HH24:MI:SS') as hiredate,
TO_CHAR(ROUND(hiredate, 'YYYY'), 'YYYY/MM/DD HH24:MI:SS') as round_YYYY,
TO_CHAR(ROUND(hiredate, 'MM'), 'YYYY/MM/DD HH24:MI:SS') as round_MM,
TO_CHAR(ROUND(hiredate-1, 'MM'), 'YYYY/MM/DD HH24:MI:SS') as round_mm,
TO_CHAR(ROUND(hiredate-2, 'MM'), 'YYYY/MM/DD HH24:MI:SS') as round_mm
FROM emp
WHERE ename = 'SMITH';

SELECT ename,
TO_CHAR(hiredate, 'YYYY/MM/DD HH24:MI:SS') as hiredate,
TO_CHAR(TRUNC(hiredate, 'YYYY'), 'YYYY/MM/DD HH24:MI:SS') as trunc_YYYY,
TO_CHAR(TRUNC(hiredate, 'MM'), 'YYYY/MM/DD HH24:MI:SS') as trunc_MM,
TO_CHAR(TRUNC(hiredate, 'DD'), 'YYYY/MM/DD HH24:MI:SS') as trunc_DD,
TO_CHAR(TRUNC(hiredate-1, 'MM'), 'YYYY/MM/DD HH24:MI:SS') as trunc_MM,
TO_CHAR(TRUNC(hiredate-2, 'MM'), 'YYYY/MM/DD HH24:MI:SS') as trunc_MM
FROM emp
WHERE ename = 'SMITH';

desc emp;
SELECT empno, ename, sal, sal/1000, /*ROUND(sal/1000) quotient,*/ MOD(sal, 1000) reminder
FROM emp;

--��¥ ���� �Լ�
--MONTHS_BETWEEN(DATE, DATE) : �� ��¥ ������ ���� ��
--19801217 ~ 20191104  --> 20191117
SELECT ename, TO_CHAR(hiredate, 'YYYY-MM-DD HH24:MI:SS') hiredate,
       MONTHS_BETWEEN(SYSDATE, hiredate) months_between,
       MONTHS_BETWEEN(TO_DATE('20191117', 'YYYYMMDD'), hiredate) months_between
FROM emp
WHERE ename='SMITH';

--ADD_MONTHS(DATE, ������) : DATE�� �������� ���� ��¥
--�������� ����� ��� �̷�, ������ ��� ����
SELECT ename, TO_CHAR(hiredate, 'YYYY-MM-DD HH24:MI:SS') hiredate,
       ADD_MONTHS(hiredate, 467) add_months,
       ADD_MONTHS(hiredate, 0) add_months0,
       ADD_MONTHS(hiredate, -467) add_months
FROM emp
WHERE ename='SMITH';

SELECT e.*
FROM emp e
ORDER BY ename;

SELECT TO_DATE('1981/03/01', 'YYYY/MM/DD'),
       TO_CHAR(TO_DATE('35/03/01', 'YY/MM/DD')+1, 'YYYY/MM/DD') r1
FROM dual;

--NEXT_DAY(DATE, ����) : DATE ���� ù��° ������ ��¥
SELECT SYSDATE, 
       NEXT_DAY(SYSDATE, 2) first_sat, -- ���ó�¥���� ù ����� ����
       NEXT_DAY(SYSDATE, '�ݿ���') first_sat -- ���ó�¥���� ù ����� ����
FROM dual;

--LAST_DAY(DATE) �ش� ��¥�� ���� ���� ������ ����
SELECT SYSDATE, LAST_DAY(SYSDATE) LAST_DAY,
       LAST_DAY(ADD_MONTHS(SYSDATE, 1)) LAST_DAY_12
FROM dual;

--DATE + ���� = DATE (DATE���� ������ŭ ������ DATE)
--D1 + ���� = D2
--�纯���� D2 ����
--D1 + ���� - D2 = D2-D2
--D1 + ���� - D2 = 0
--D1 + ���� = D2
--�纯�� D1 ����
--D1 + ���� - D1 = D2 -D1
--���� = D2 - D1
--��¥���� ��¥�� ���� ���ڰ� ���´�.
SELECT TO_DATE('20191104', 'YYYYMMDD') - TO_DATE('20191101', 'YYYYMMDD') as aa,
       TO_DATE('20191201', 'YYYYMMDD') - TO_DATE('20191101', 'YYYYMMDD') as bb,
       --201908 : 2019��� 8���� �ϼ� : 31
       ADD_MONTHS(TO_DATE('201908', 'YYYYMM'), 1) - TO_DATE('201908', 'YYYYMM') D3,
       ADD_MONTHS(TO_DATE('201907', 'YYYYMM'), 1) - TO_DATE('201907', 'YYYYMM') D3,
       ADD_MONTHS(TO_DATE('201906', 'YYYYMM'), 1) - TO_DATE('201906', 'YYYYMM') D3,
       ADD_MONTHS(TO_DATE('201905', 'YYYYMM'), 1) - TO_DATE('201905', 'YYYYMM') D3
FROM dual;

SELECT MOD(467, 12)
FROM dual;
create table h_sum as
select '0' s_id, null ps_id, null value from dual union all
select '01' s_id, '0' ps_id, null value from dual union all
select '012' s_id, '01' ps_id, null value from dual union all
select '0123' s_id, '012' ps_id, 10 value from dual union all
select '0124' s_id, '012' ps_id, 10 value from dual union all
select '015' s_id, '01' ps_id, null value from dual union all
select '0156' s_id, '015' ps_id, 20 value from dual union all

select '017' s_id, '01' ps_id, 50 value from dual union all
select '018' s_id, '01' ps_id, null value from dual union all
select '0189' s_id, '018' ps_id, 10 value from dual union all
select '11' s_id, '0' ps_id, 27 value from dual;

SELECT *
FROM h_sum;

SELECT RPAD(' ', (LEVEL-1)*4, ' ') || S_ID s_id, value
FROM h_sum
START WITH s_id='0'
CONNECT BY PRIOR s_id = ps_id;

create table no_emp(
    org_cd varchar2(100),
    parent_org_cd varchar2(100),
    no_emp number
);
insert into no_emp values('XXȸ��', null, 1);
insert into no_emp values('�����ý��ۺ�', 'XXȸ��', 2);
insert into no_emp values('����1��', '�����ý��ۺ�', 5);
insert into no_emp values('����2��', '�����ý��ۺ�', 10);
insert into no_emp values('������ȹ��', 'XXȸ��', 3);
insert into no_emp values('��ȹ��', '������ȹ��', 7);
insert into no_emp values('��ȹ��Ʈ', '��ȹ��', 4);
insert into no_emp values('�����κ�', 'XXȸ��', 1);
insert into no_emp values('��������', '�����κ�', 7);

commit;

SELECT *
FROM no_emp;

SELECT RPAD(' ', (LEVEL-1)*4, ' ')  || org_cd org_cd, no_emp
FROM no_emp a
START WITH org_cd ='XXȸ��'
CONNECT BY PRIOR ORG_CD = PARENT_ORG_CD;

--prunning branch (����ġ��)
--������������ WHERE���� START WITH, CONNECT BY ���� ���� ����� ���Ŀ� ����ȴ�.

--dept_h���̺��� �ֻ��� ��� ���� ��������� ��ȸ
SELECT deptcd, RPAD(' ', (LEVEL-1)*4, ' ')  || deptnm, level
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

SELECT deptcd, RPAD(' ', (LEVEL-1)*4, ' ')  || deptnm, level
FROM dept_h
WHERE deptnm != '������ȹ��'
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

SELECT deptcd, RPAD(' ', (LEVEL-1)*4, ' ')  || deptnm, level
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd 
            AND deptnm != '������ȹ��';
---- WHERE���� �ƴ� CONNECT BY PRIOR AND ���� deptnm != '������ȹ��'�� �־�߸� ���� ������ ������ �ȴ�. 

-- CONNECT_BY_ROOT(org_cd): �ֻ��� ���� ���� ã�� �ڵ� 
-- sys_connect_by_path(col, '-') : � �����͸� Ÿ�� �Ӵ��� �˷��ִ� �ڵ�
--      . LTRIM�� ���� �ֻ��� ��� ������ �����ڸ� ���� �ִ� ���°� �Ϲ���
-- CONNECT_BY_ISLEAF : ���̻� ������ ���� ���ٸ� ��ȯ�� : 1 �׷��� ������ : 0 
SELECT LPAD(' ', 4*(level-1), ' ') || org_cd org_cd,
        CONNECT_BY_ROOT(org_cd) root_org_cd,
        LTRIM(sys_connect_by_path(org_cd, '-'), '-') path_org_cd,
        CONNECT_BY_ISLEAF
FROM no_emp
START WITH ORG_CD = 'XXȸ��'
CONNECT BY PRIOR org_cd = parent_org_cd;


create table board_test (
 seq number,
 parent_seq number,
 title varchar2(100) );
 
insert into board_test values (1, null, 'ù��° ���Դϴ�');
insert into board_test values (2, null, '�ι�° ���Դϴ�');
insert into board_test values (3, 2, '����° ���� �ι�° ���� ����Դϴ�');
insert into board_test values (4, null, '�׹�° ���Դϴ�');
insert into board_test values (5, 4, '�ټ���° ���� �׹�° ���� ����Դϴ�');
insert into board_test values (6, 5, '������° ���� �ټ���° ���� ����Դϴ�');
insert into board_test values (7, 6, '�ϰ���° ���� ������° ���� ����Դϴ�');
insert into board_test values (8, 5, '������° ���� �ټ���° ���� ����Դϴ�');
insert into board_test values (9, 1, '��ȩ��° ���� ù��° ���� ����Դϴ�');
insert into board_test values (10, 4, '����° ���� �׹�° ���� ����Դϴ�');
insert into board_test values (11, 10, '���ѹ�° ���� ����° ���� ����Դϴ�');
commit;

--h6
SELECT * FROM board_test;

SELECT seq, title
FROM board_test
START WITH parent_seq > 1
CONNECT BY PRIOR seq = parent_seq;

-- ��������(�Խñ� ���������� ���� �ڷ�.sql, �ǽ� h8)
-- �Խñ��� ���� �ֽű��� �ֻ����� �´�. ���� �ֽű��� ������ �����Ͻÿ�
SELECT seq, LPAD(' ', 4*(level-1), ' ') || title title
FROM (SELECT seq,  nvl(parent_seq, 0) parent_seq, title
      FROM board_test) a
START WITH parent_seq < 1
CONNECT BY PRIOR seq = parent_seq
ORDER siblings BY SEQ desc;
-- ������ ������ order by : order siblings by

SELECT *
FROM
(
SELECT seq, LPAD(' ', 4*(level-1), ' ') || title title, level lev
FROM (SELECT seq,  nvl(parent_seq, 0) parent_seq, title
      FROM board_test) a
START WITH parent_seq < 1
CONNECT BY PRIOR seq = parent_seq
ORDER siblings BY SEQ desc) a;

SELECT *
FROM board_test;
--�� �׷��ȣ �÷� �߰�
ALTER TABLE board_test ADD (gn NUMBER);

SELECT *
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY gn DESC, seq;


SELECT a.ename, a.sal, b.sal
FROM(SELECT a.ename, a.sal, rownum rm
    FROM(
    SELECT ename, sal
    FROM emp
    ORDER BY sal desc)a) a,
    (SELECT b.ename, b.sal, rownum-1 rm 
    FROM(
    SELECT ename, sal
    FROM emp
    ORDER BY sal desc)b) b
    WHERE a.rm = b.rm(+)
    ORDER BY a.sal desc;



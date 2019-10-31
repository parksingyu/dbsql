-- SELECT : ��ȸ�� �÷� ���
--        - ��ü �÷� ��ȸ : *
--        - �Ϻ� �÷� : �ش� �÷��� ����(, ����)
-- FROM : ��ȸ�� ���̺� ���
-- ������ �����ٿ� ����� �ۼ��ص� ��� ����.
-- �� keyword�� �ٿ��� �ۼ�

--��� �÷��� ��ȸ
SELECT * FROM prod;

--Ư�� �÷��� ��ȸ
SELECT prod_id, prod_name
FROM prod;


--1) lprod ���̺��� ��� �÷� ��ȸ
SELECT * FROM lprod;

SELECT * FROM buyer;

SELECT buyer_id, buyer_name
FROM buyer;

SELECT * FROM cart;

SELECT mem_id, mem_pass, mem_name
FROM member;

-- ������ / ��¥��ȯ
-- date type + ���� : ���ڸ� ���Ѵ�.
-- null�� ������ ������ ����� �׻� null�̴�.
SELECT userid, usernm, reg_dt,
        reg_dt + 5 reg_dt_after5,
        reg_dt - 5 as reg_dt_before5
FROM users;

SELECT prod_id as id,
        prod_name as name
FROM prod;

SELECT lprod_gu as gu, lprod_nm as nm
FROM lprod;

SELECT buyer_id as ���̾���̵�, buyer_name as �̸�
FROM buyer;

--���ڿ� ����
-- java + -->sql ||
-- CONCAT(str, str) �Լ�
-- user���̺��� userid, usernm

SELECT userid,usernm,userid || usernm as ����, 
        CONCAT(userid, usernm)
FROM users;

--���ڿ� ��� (�÷��� ��� �����Ͱ� �ƴ϶� �����ڰ� ���� �Է��� ���ڿ�)
SELECT '����� ���̵� : ' || userid,
        concat('����� �ƾƵ� : ', userid)
FROM users;

--�ǽ� sel_con1]
SELECT *
FROM user_tables;

SELECT 'SELECT * FROM ' || table_name || ';' QUERY   
FROM user_tables;

--desc table
--���̺� ���ǵ� �÷��� �˰� ���� ��
--1. desc
--2. select * .....
desc emp;


SELECT *
from emp;

select *
from users
where userid = 'brown';

--usernm�� ������ �����͸� ��ȸ�ϴ� ������ �ۼ�

select *
from users
where usernm = '����';



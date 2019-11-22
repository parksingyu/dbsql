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
insert into no_emp values('XX회사', null, 1);
insert into no_emp values('정보시스템부', 'XX회사', 2);
insert into no_emp values('개발1팀', '정보시스템부', 5);
insert into no_emp values('개발2팀', '정보시스템부', 10);
insert into no_emp values('정보기획부', 'XX회사', 3);
insert into no_emp values('기획팀', '정보기획부', 7);
insert into no_emp values('기획파트', '기획팀', 4);
insert into no_emp values('디자인부', 'XX회사', 1);
insert into no_emp values('디자인팀', '디자인부', 7);

commit;

SELECT *
FROM no_emp;

SELECT RPAD(' ', (LEVEL-1)*4, ' ')  || org_cd org_cd, no_emp
FROM no_emp a
START WITH org_cd ='XX회사'
CONNECT BY PRIOR ORG_CD = PARENT_ORG_CD;

--prunning branch (가지치기)
--계층쿼리에서 WHERE절은 START WITH, CONNECT BY 절이 전부 적용된 이후에 실행된다.

--dept_h테이블을 최상위 노드 부터 하향식으로 조회
SELECT deptcd, RPAD(' ', (LEVEL-1)*4, ' ')  || deptnm, level
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

SELECT deptcd, RPAD(' ', (LEVEL-1)*4, ' ')  || deptnm, level
FROM dept_h
WHERE deptnm != '정보기획부'
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

SELECT deptcd, RPAD(' ', (LEVEL-1)*4, ' ')  || deptnm, level
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd 
            AND deptnm != '정보기획부';
---- WHERE절이 아닌 CONNECT BY PRIOR AND 절에 deptnm != '정보기획부'를 넣어야만 예하 팀까지 삭제가 된다. 

-- CONNECT_BY_ROOT(org_cd): 최상위 값이 뭔지 찾는 코드 
-- sys_connect_by_path(col, '-') : 어떤 데이터를 타고서 왓는지 알려주는 코드
--      . LTRIM을 통해 최상위 노드 왼쪽의 구분자를 없애 주는 형태가 일반적
-- CONNECT_BY_ISLEAF : 더이상 내려갈 곳이 없다면 반환값 : 1 그렇지 않으면 : 0 
SELECT LPAD(' ', 4*(level-1), ' ') || org_cd org_cd,
        CONNECT_BY_ROOT(org_cd) root_org_cd,
        LTRIM(sys_connect_by_path(org_cd, '-'), '-') path_org_cd,
        CONNECT_BY_ISLEAF
FROM no_emp
START WITH ORG_CD = 'XX회사'
CONNECT BY PRIOR org_cd = parent_org_cd;


create table board_test (
 seq number,
 parent_seq number,
 title varchar2(100) );
 
insert into board_test values (1, null, '첫번째 글입니다');
insert into board_test values (2, null, '두번째 글입니다');
insert into board_test values (3, 2, '세번째 글은 두번째 글의 답글입니다');
insert into board_test values (4, null, '네번째 글입니다');
insert into board_test values (5, 4, '다섯번째 글은 네번째 글의 답글입니다');
insert into board_test values (6, 5, '여섯번째 글은 다섯번째 글의 답글입니다');
insert into board_test values (7, 6, '일곱번째 글은 여섯번째 글의 답글입니다');
insert into board_test values (8, 5, '여덜번째 글은 다섯번째 글의 답글입니다');
insert into board_test values (9, 1, '아홉번째 글은 첫번째 글의 답글입니다');
insert into board_test values (10, 4, '열번째 글은 네번째 글의 답글입니다');
insert into board_test values (11, 10, '열한번째 글은 열번째 글의 답글입니다');
commit;

--h6
SELECT * FROM board_test;

SELECT seq, title
FROM board_test
START WITH parent_seq > 1
CONNECT BY PRIOR seq = parent_seq;

-- 계층쿼리(게시글 계층형쿼리 샘플 자료.sql, 실습 h8)
-- 게시글은 가장 최신글이 최상위로 온다. 가장 최신글이 오도록 설정하시오
SELECT seq, LPAD(' ', 4*(level-1), ' ') || title title
FROM (SELECT seq,  nvl(parent_seq, 0) parent_seq, title
      FROM board_test) a
START WITH parent_seq < 1
CONNECT BY PRIOR seq = parent_seq
ORDER siblings BY SEQ desc;
-- 계층을 유지한 order by : order siblings by

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
--글 그룹번호 컬럼 추가
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



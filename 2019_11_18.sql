SELECT *
FROM jdbc_board;

SELECT *
FROM jdbc_board
WHERE board_no = 21;

-- ppt403
CREATE UNIQUE INDEX idx_emp_000 ON emp(empno);
CREATE INDEX idx_emp_001 ON emp(deptno);
CREATE INDEX idx_emp_002 ON emp(ename);
CREATE INDEX idx_emp_003 ON emp(mgr, empno);

--pc10 계정
--dictionary
--접두어 : USER
--        ALL : 사용자가 사용가능 한 객체
--        DBA : 관리자 관점의 전체 객체(일반 사용자는 사용 불가)
--        VS : 시스템과 관련된 view (일반 사용자는 사용 불가)

SELECT *
FROM USER_TABLES;

SELECT *
FROM ALL_TABLES;

SELECT *
FROM DBA_TABLES
WHERE OWNER IN('PC10', 'HR');

--오라클에서 동일한 SQL이란?
--문자가 하나라도 틀리면 안됨.
--다음 sql들은 같은결과를 만들어 낼지 몰라도 DBMS에서는
--서로 다른 SQL로 인식된다.
SELECT /* bind_test */* FROM emp;
Select /* bind_test */* FROM emp;
Select /* bind_test */*  FROM emp;

Select /* bind_test */* FROM emp WHERE empno=7369;
Select /* bind_test */* FROM emp WHERE empno=7499;
Select /* bind_test */* FROM emp WHERE empno=7521;

Select /* bind_test */* FROM emp WHERE empno=:empno;

SELECT *
FROM FASTFOOD
WHERE GB='롯데리아'
AND ADDR LIKE '%대전광역시%';

SELECT gb, count(gb)
FROM fastfood
WHERE addr LIKE '%대전광역시 서구%'
GROUP BY gb;

SELECT gb, count(gb)
FROM fastfood
WHERE addr LIKE '%대전광역시%'
GROUP BY gb;
GROUP BY sido, sigungu, gb
ORDER BY sido, sigungu, gb;

SELECT gb ,count(*)
FROM fastfood
GROUP BY gb;

SELECT sido, sigungu
FROM fastfood
WHERE sido LIKE '%대전%';

SELECT *
FROM fastfood;

--hint
--시도, 시군구별 매장수(버거키으 맥도날드, KFC ) :
--시도, 시군구별 매장수(롯데리아) :

--롯데리아
SELECT sido, sigungu, count(*)
FROM fastfood
WHERE gb='롯데리아'
GROUP BY sido, sigungu;


SELECT l.sido as 시도, l.sigungu as 구, m.na as kmb, l.lo as l, round(m.na/l.lo,2) as 도시발전지수
FROM 
(SELECT sido, sigungu, count(*) lo
FROM fastfood
WHERE gb='롯데리아'
GROUP BY sido, sigungu) l,
(SELECT sido, sigungu, count(*) na
FROM fastfood
WHERE gb IN ('맥도날드', '버거킹','KFC')
GROUP BY sido, sigungu) m
WHERE l.sigungu = m.sigungu
AND l.sido = m.sido
--AND l.sido = '대전광역시';
ORDER by 도시발전지수 desc;


SELECT rownum r, aa.*
FROM 
(
SELECT l.sido as 시도, l.sigungu as 구, m.na as kmb, l.lo as l, round(m.na/l.lo,2) as 도시발전지수
FROM 
(SELECT sido, sigungu, count(*) lo
FROM fastfood
WHERE gb='롯데리아'
GROUP BY sido, sigungu) l,
(SELECT sido, sigungu, count(*) na
FROM fastfood
WHERE gb IN ('맥도날드', '버거킹','KFC')
GROUP BY sido, sigungu) m
WHERE l.sigungu = m.sigungu
AND l.sido = m.sido
ORDER by 도시발전지수 desc
)aa;

SELECT rownum as rr, bb.*
FROM
(
SELECT sido, sigungu, sal
FROM tax
ORDER BY sal desc
) bb;


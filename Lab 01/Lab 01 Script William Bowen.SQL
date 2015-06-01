Column Table_Name heading 'Table Name' format A15
Column Column_Name Heading 'Column Name' Format A15
Column Constraint_Name Heading 'Constraint Name' Format A15
Column Constraint_Type Heading 'Constraint Type' Format A15
Column Owner Heading 'Owner' Format A10


select table_name from user_tables
where table_name not like 'APEX%' and table_name not like 'DEMO%';

desc STATE_LOOKUP;

select * from STATE_LOOKUP;

select owner, constraint_name, constraint_type, table_name
from user_constraints where table_name = 'STATE_LOOKUP';

desc DEPT;

select * from DEPT;

select owner, constraint_name, constraint_type, table_name
from user_constraints where table_name = 'DEPT';

desc EMP;

select empno, ename, job, mgr from EMP;

select hiredate, sal, comm, deptno from EMP;

select owner, constraint_name, constraint_type, table_name
from user_constraints where table_name = 'EMP';

desc SALGRADE;

select * from SALGRADE;

select owner, constraint_name, constraint_type, table_name
from user_constraints where table_name = 'SALGRADE';

desc CUSTOMER;

select * from CUSTOMER;

select owner, constraint_name, constraint_type, table_name
from user_constraints where table_name = 'CUSTOMER';

desc WIDGETS;

select * from WIDGETS;

select owner, constraint_name, constraint_type, table_name
from user_constraints where table_name = 'WIDGETS';

desc PURCHASE_ORDER;

select * from PURCHASE_ORDER;

select owner, constraint_name, constraint_type, table_name
from user_constraints where table_name = 'PURCHASE_ORDER';

desc EMP_SERVICE;

select * from EMP_SERVICE;

select owner, constraint_name, constraint_type, table_name
from user_constraints where table_name = 'EMP_SERVICE';

desc EMP_SERVICE_LOG;

select * from EMP_SERVICE_LOG;

select owner, constraint_name, constraint_type, table_name
from user_constraints where table_name = 'EMP_SERVICE_LOG';

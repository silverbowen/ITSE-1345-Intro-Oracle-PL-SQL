/* William Bowen
   ITSE 1345
   Competency 4.1 */

set serveroutput on;
 
/* Assignment 8-1 */

desc user_objects;
/

select rpad(object_name, 23) "OBJECT_NAME", status, timestamp
 from user_objects
 where object_type = 'PROCEDURE';
/

desc user_dependencies;
/

column name format a15
select name, type
 from user_dependencies
 where referenced_name = 'BB_BASKET';
 /
/* Problem 01

Create an Anonymous block. Declare a Sequence Number named list#, a
constant named C_XYZ that is Number(10), an Binary Integer named V_Counter1,
a variable named V_Row_number based on the column Row in the Theater Table 
(you will have to create the table and the row), and a character string named 
String A that is up to 50 characters long. Print out and hand in the code
and show that it compiled without errors.

Hint:(You will have to include a Begin with a Null Process and 
an end to get this to compile). */


-- I had to use Row_number rather than Row (SQL keyword)
create table Theater (Row_number number(3));
  
create sequence temp_seq
  start with 1
  increment by 1;

declare
  list# number := temp_seq.nextval;
  C_XYZ constant number(10) := 10;
  V_Counter1 binary_integer;
  V_Row_number Theater.Row_number%type;
  String_A varchar2(50); -- had to name String_A (SQL keyword)

begin
  null;

end;

/

drop table Theater;
drop sequence temp_seq;

/

/* Problem 02

Create an Anonymous block that Creates and Inserts data into 
the Student, Course and Student/Course composite tables using 
the Create and Insert commands. You will find the table description
attached. Print out and hand in the code, the proof that it successfully
compiled and show the tables created and populated by the code using
the Select and Describe commands. */

begin
  create table Student(
  Stu_ID number(5),
  Lname varchar2(11),
  Fname varchar2(8),
  Mi varchar2(2),
  Sex varchar2(3),
  Major varchar2(9),
  Home_State varchar2(10));
  
  create table Course(
  Course_ID varchar(8),
  Section# number(8),
  C_Name varchar2(19),
  C_Description varchar2(23));
  
  create table Student_Course(
  Stu_ID number(5),
  Course_ID varchar(8),
  Section# number(3));
  
  insert into Student
    values(10001, 'Smith', 'Ron', 'M', 'M', 'Math', 'Tx';
  insert into Student
    values(10002, 'Jones', 'Peter', 'A', 'M', 'English', 'Tx';
  insert into Student
    values(10003, 'Peters', 'Anne', 'A', 'F', 'English', 'Me';
  insert into Student
    values(10004, 'Johnson', 'John', 'J', 'M', 'CompSci', 'Ca';
  insert into Student
    values(10005, 'Penders', 'Alton', 'P', 'F', 'Math', 'Ga';
  insert into Student
    values(10006, 'Allen', 'Diane', 'J', 'F', 'Geography', 'Minn';
  insert into Student
    values(10007, 'Gill', 'Jennifer', null, 'F', 'CompSci', 'Tx';
  insert into Student
    values(10008, 'Johns', 'Roberta', null, 'F', 'CompSci', 'Tx';
  insert into Student
    values(10009, 'Wier', 'Paul', null, 'M', 'Math', 'Ala';
  insert into Student
    values(10010, 'Evans', 'Richard', null, 'M', 'English', 'Tx';
    
  insert into Course
    values('COSC1300', 001, 'Intro to Comp.', 'First Computer Course';
  insert into Course
    values('ITSE2309', 001, 'Intro to DB', 'First Database Course';
  insert into Course
    values('GEOG1791', 002, 'World Geography', 'Second Geography Course';
  insert into Course
    values('COSC1315', 001, 'Intro to Prog.', 'Second Computer Course';
  insert into Course
    values('ITSE1345', 001, 'Intro to DB Prog.', 'Second Database Course';
  insert into Course
    values('ENGL2617', 002, 'English Literature', 'Second English Course';	
  insert into Course
    values('MATH1101',  001, 'Calculus 1', 'Second Math Course';
  insert into Course
    values('ENGL1001', 001, 'American Literature', 'First English Course';
  insert into Course
    values('MATH1011', 001, 'Trig. & Algebra', 'First Math Course';
  insert into Course
    values('GEOG1010', 001, 'Texas Geography', 'First Geography Course';

end;
/

--drop table Student;
--drop table Course;
--drop table Student_Course;
--/
  
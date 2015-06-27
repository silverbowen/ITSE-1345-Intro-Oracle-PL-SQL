/* William Bowen
   ITSE 1345
   Lab 02 */
   
set serveroutput on;
/

-- Opening cleanup - uncomment if needed

--drop table Theater;
--drop sequence temp_seq;
--drop table Student;
--drop table Course;
--drop table Student_Course;
--drop table Temp_Table;
--/

/* Problem 01

Create an Anonymous block. Declare a Sequence Number named list#, a
constant named C_XYZ that is Number(10), an Binary Integer named V_Counter1,
a variable named V_Row_number based on the column Row in the Theater Table 
(you will have to create the table and the row), and a character string named 
String A that is up to 50 characters long. Print out and hand in the code
and show that it compiled without errors.

Hint:(You will have to include a Begin with a Null Process and 
an end to get this to compile). */


/* I had to use Row_number rather than Row (can't use a SQL keyword
  as a variable name), and String_A rather than String A.*/
  
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

/* Problem 02

Create an Anonymous block that Creates and Inserts data into 
the Student, Course and Student/Course composite tables using 
the Create and Insert commands. You will find the table description
attached. Print out and hand in the code, the proof that it successfully
compiled and show the tables created and populated by the code using
the Select and Describe commands. */

/* Although we haven't covered the EXECUTE IMMEDIATE'' command,
  It seemed the easiest way to make this into a block (actually
  two, since the insert commands don't work in a block if the
  tables don't already exist. */
  

begin
  execute immediate
  'create table Student(
  Stu_ID number(5),
  Lname varchar2(10),
  Fname varchar2(8),
  Mi varchar2(2),
  Sex varchar2(3),
  Major varchar2(9),
  Home_State varchar2(10))';

  execute immediate
  'create table Course(
  Course_ID varchar(8),
  Section# number(8),
  C_Name varchar2(19),
  C_Description varchar2(23))';
  
  execute immediate
  'create table Student_Course(
  Stu_ID number(5),
  Course_ID varchar(8),
  Section# number(3))';
  
end;
/
  
begin
  insert into Student
    values(10001, 'Smith', 'Ron', 'M', 'M', 'Math', 'Tx');
  insert into Student
    values(10002, 'Jones', 'Peter', 'A', 'M', 'English', 'Tx');
  insert into Student
    values(10003, 'Peters', 'Anne', 'A', 'F', 'English', 'Me');
  insert into Student
    values(10004, 'Johnson', 'John', 'J', 'M', 'CompSci', 'Ca');
  insert into Student
    values(10005, 'Penders', 'Alton', 'P', 'F', 'Math', 'Ga');
  insert into Student
    values(10006, 'Allen', 'Diane', 'J', 'F', 'Geography', 'Minn');
  insert into Student
    values(10007, 'Gill', 'Jennifer', null, 'F', 'CompSci', 'Tx');
  insert into Student
    values(10008, 'Johns', 'Roberta', null, 'F', 'CompSci', 'Tx');
  insert into Student
    values(10009, 'Wier', 'Paul', null, 'M', 'Math', 'Ala');
  insert into Student
    values(10010, 'Evans', 'Richard', null, 'M', 'English', 'Tx');
    
  insert into Course
    values('COSC1300', 001, 'Intro to Comp.', 'First Computer Course');
  insert into Course
    values('ITSE2309', 001, 'Intro to DB', 'First Database Course');
  insert into Course
    values('GEOG1791', 002, 'World Geography', 'Second Geography Course');
  insert into Course
    values('COSC1315', 001, 'Intro to Prog.', 'Second Computer Course');
  insert into Course
    values('ITSE1345', 001, 'Intro to DB Prog.', 'Second Database Course');
  insert into Course
    values('ENGL2617', 002, 'English Literature', 'Second English Course');	
  insert into Course
    values('MATH1101',  001, 'Calculus 1', 'Second Math Course');
  insert into Course
    values('ENGL1001', 001, 'American Literature', 'First English Course');
  insert into Course
    values('MATH1011', 001, 'Trig. &' || 'Algebra', 'First Math Course');
  insert into Course
    values('GEOG1010', 001, 'Texas Geography', 'First Geography Course');

  insert into Student_Course
    values(10001, 'MATH1101', 001);
  insert into Student_Course
    values(10002, 'ENGL2617', 002);
  insert into Student_Course
    values(10003, 'ENGL1001', 001);
  insert into Student_Course
    values(10003, 'ENGL2617', 002);
  insert into Student_Course
    values(10003, 'GEOG1010', 001);
  insert into Student_Course
    values(10004, 'COSC1315', 001);
  insert into Student_Course
    values(10005, 'MATH1101', 001);
  insert into Student_Course
    values(10006, 'GEOG1010', 001);
  insert into Student_Course
    values(10006, 'GEOG1791', 002);
  insert into Student_Course
    values(10007, 'COSC1315', 001);
  insert into Student_Course
    values(10007, 'ITSE2309', 001);
  insert into Student_Course
    values(10008, 'COSC1315', 001);
  insert into Student_Course
    values(10009, 'ITSE2309', 001);
  insert into Student_Course
    values(10010, 'ENGL2617', 002);

end;
/

select * from Student;
select * from Course;
select * from Student_Course;

desc Student;
desc Course;
desc Student_Course;

/

/* Problem 03

Create an Anonymous block that counts the number of courses a student
is signed up for in the Course/Student composite table. Use the tables
you created in #2 above. Print out and hand in the code, the proof that
it successfully compiled and show the test results. No error processing
should be required. Hint:(Use the select Into command for each student
inside a loop to determine this information). */

declare
  L_Stu_ID number(5);
  Num_Courses number(2);
  
begin
  for i in 10001..10010 loop
    select distinct Stu_ID, count(Course_ID)
      into L_Stu_ID, Num_Courses
    from Student_Course
    where Stu_ID = i
    group by Stu_ID;
    dbms_output.put_line(
      'Student ID ' || L_Stu_ID
      || ' is signed up for '
      || Num_Courses || ' courses.');
  end loop;

end;
/

/* Problem 04

Create an Anonymous block that counts the number of students enrolled
in the Student table. Use DBMS Output Putline to send out a message
stating the number of students found. Print out and hand in the code,
the proof that it successfully compiled and show test results.
No error processing required. */

declare
  L_Total_Students number(2);

begin
  select count(Stu_ID)
    into L_Total_Students
    from Student;
  dbms_output.put_line(
  'There are ' || L_Total_Students
  || ' students enrolled.');

end;
/

/* Problem 05

Create an Anonymous block that determines the number of courses in the
StudentCourse table and (using the IF statement) if the number is greater
than 10 sends out a message (using DBMS Output Putline) stating that “more
than 10 courses have been established”. If the number is less than 10 send
out a message stating “less than 10 courses established”.  Print out and
hand in the code, the proof that it successfully compiled and show test
results. No error processing required. */

declare
  L_#Courses number(2);
  
begin
  select count(distinct Course_ID)
    into L_#Courses
    from Student_Course;
  if L_#Courses > 10 then
    dbms_output.put_line(
    'more than 10 courses have been established');
  elsif L_#Courses < 10 then
    dbms_output.put_line(
    'less than 10 courses established');
  else
    dbms_output.put_line(
    'wowsers, exactly 10 courses have been established');
  end if;
end;
/

/* Problem 06

Create a Named block that tests each student entry in the student table
to see if the student is an instate student. Print out, (using the DBMS
Output Putline) a line stating that each student is or is not an instate
student and a count of the students in and out of state at the end of the
program. Print out the code, the proof that it successfully compiled and
show test results. No error processing required. */

/* My understanding is that named blocks are functions, procedures and the
like. We haven't covered any of that yet and you specifically said not use
those. Did you mean labelled blocks? I went ahead and labelled them :) */


<<problem6block>>
declare
  InState_Count number(2) := 0;
  OutState_Count number(2) := 0;
  Curr_Student Student.Stu_ID%type;
  Curr_State Student.Home_State%type;

begin
  for i in 10001..10010 loop
    select Stu_ID, Home_State
     into Curr_Student, Curr_State
    from Student
    where Stu_ID = i;
    if Curr_State = 'Tx' then
      dbms_output.put_line(
      'Student ' || Curr_Student
      || ' is an in-state student.');
      InState_Count := InState_Count + 1;
    else
      dbms_output.put_line(
      'Student ' || Curr_Student
      || ' is an out-of-state student.');
      OutState_Count := OutState_Count + 1;
    end if;
  end loop;
  dbms_output.put_line(
    'There are ' || InState_Count
     || ' in-state students.');
  dbms_output.put_line(
    'There are ' || OutState_Count
     || ' out-of-state students.');

end problem6block;
/

/* Problem 07

Create a Named block that takes the information provided by Named Parameters,
&Variable_Name, to determine if a student is registered in the specified
course from the student/course table created above. Use the DBMS Output
Putline to send a message indicating if the student specified is in the
course specified. Print out the code, the proof that it successfully
compiled and show test results. No error processing required. */

<<problem7block>>
declare
  Which_Course Student_Course.Course_ID%type
    := '&Pick_A_Course';
  Which_Stu Student_Course.Stu_ID%type
    := &Pick_A_Student;
  type Type_Stu_Course is table of
    Student_Course%rowtype
    index by binary_integer;
  Tbl_Stu_Course Type_Stu_Course;
  flag number(1) := 0;

begin
    select * bulk collect
      into Tbl_Stu_Course
    from Student_Course;
  for i in 1..10 loop
    if Tbl_Stu_Course(i).Stu_ID = Which_Stu and
          Tbl_Stu_Course(i).Course_ID = Which_Course then 
      dbms_output.put_line(
      'Student ' || Which_Stu
      || ' is taking ' || Which_Course);
      flag := 1;
    end if;
  end loop;
  if flag = 0 then
    dbms_output.put_line(
    'Student ' || Which_Stu
    || ' is not taking ' || Which_Course);
  end if;
end problem7block;
/

/* Problem 08
Create a Named block that uses the If construct to test if each student
is male or female and the Case Construct to determine if the major is
a Math, English, Comp Sci, or Geography major. Print out the code, the
proof that it successfully compiled and show test results. No error
processing required. */

<<problem08block>>
declare
  Gender Student.Sex%type;
  L_Major Student.Major%type;
   
begin
  for i in 10001..10010 loop
    select Sex, Major
      into Gender, L_Major
    from Student
    where Stu_ID = i;
    if Gender = 'M' then
      dbms_output.put_line(
      'Student #' || i
      || ' is a male.');
    else
      dbms_output.put_line(
      'Student #' || i
      || ' is a female.');
    end if;
    case L_Major
      when 'Math' then
        dbms_output.put_line(
        'Student #' || i
        || ' is a Math major.');
      when 'English' then
        dbms_output.put_line(
        'Student #' || i
        || ' is an English major.');
      when 'CompSci' then
        dbms_output.put_line(
        'Student #' || i
        || ' is a Computer Science major.');
      when 'Geography' then
        dbms_output.put_line(
        'Student #' || i
        || ' is a Geography major.');
    end case;
  end loop;
end problem8block;
/

/* Problem 09
Create a Named block that performs the same activity as in #8 above
using the If construct in place of the Case Construct. Print out the
code, the proof that it successfully compiled and show test results.
No error processing required. */

<<problem09block>>
declare
  Gender Student.Sex%type;
  L_Major Student.Major%type;
   
begin
  for i in 10001..10010 loop
    select Sex, Major
      into Gender, L_Major
    from Student
    where Stu_ID = i;
    if Gender = 'M' then
      dbms_output.put_line(
      'Student #' || i
      || ' is a male.');
    else
      dbms_output.put_line(
      'Student #' || i
      || ' is a female.');
    end if;
    if L_Major = 'Math' then
        dbms_output.put_line(
        'Student #' || i
        || ' is a Math major.');
    elsif L_Major = 'English' then
        dbms_output.put_line(
        'Student #' || i
        || ' is an English major.');
    elsif  L_Major = 'CompSci' then
        dbms_output.put_line(
        'Student #' || i
        || ' is a Computer Science major.');
    else
        dbms_output.put_line(
        'Student #' || i
        || ' is a Geography major.');
    end if;
  end loop;
end problem9block;
/

/* Problem 10
Create a Named block that Inserts rows of data from the student table
into a  temporary table and uses a loop with a counter to know when
to exit. Set the counter equal to the Count of the rows in the student
table so it will know when to end processing. Print out the code, the
proof that it successfully compiled and show test results. No error
processing required. Hint:(You will need to create the Temporary Table
first. Use a loop to take each row from the student table and place
it in the Temporary Table). */

begin
  execute immediate
  'create table Temp_Table(
  Stu_ID number(5),
  Lname varchar2(10),
  Fname varchar2(8),
  Mi varchar2(2),
  Sex varchar2(3),
  Major varchar2(9),
  Home_State varchar2(10))';
  
end;
/
  
<<problem10block>>
declare
  Rec_Student Student%rowtype;
  Counter number(2) := 1;
  End_Count number(2);

begin
  select count(Stu_ID)
    into End_Count
  from Student;
  loop
    select *
      into Rec_Student
    from Student
    where Stu_ID = Counter + 10000;
    insert into Temp_Table
      values Rec_Student;
    exit when Counter = End_Count;
    Counter := Counter + 1;
  end loop;

end problem10block;
/

select * from Temp_Table;

/

-- Ending cleanup

drop table Theater;
drop sequence temp_seq;
drop table Student;
drop table Course;
drop table Student_Course;
drop table Temp_Table;
/
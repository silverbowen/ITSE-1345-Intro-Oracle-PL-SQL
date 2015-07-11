/* William Bowen
   ITSE 1345
   Lab 04 */
   
set serveroutput on;
/

/* Problem 01

(30 Points) Write a PL/SQL procedure which will determine whether a
given range of customer has a purchase order or not. Use the explicit
cursor to process the table data. The procedure specification is as follows: 

Purpose: To test whether a customer has at least one purchase order for
         a given range of customer numbers.
Input arguments: 1) The low Cust_ID value for the customer number range.
			           2) The high Cust_ID value for the customer number range.
Input/Output arguments:    NONE
Output arguments:     NONE
Preconditions: The first Cust_ID parameter value should be less than the
               second Cust_ID parameter value. If not, put out an appropriate
               error message.
Postconditions: Order the output by Cust_ID. Print out the Cust_ID and
                either the message ‘has a purchase order’ or the message 
                ‘does not have a purchase order’.

Write a simple driver to call the procedure. 
Test the following ranges of Cust_Ids.

90001 to 90008
90003 to 90007
90009 to 90010
90005 to 90004  */

-- create procedure
create or replace procedure find_purchase
  -- two parameters
  (lv_cust_id in purchase_order.cust_id%type,
   lv_cust_id2 in purchase_order.cust_id%type)
  is
  
  -- use explicit cursor
  cursor cur_purchase is
    select distinct cust_id
     from purchase_order
      order by cust_id;
      
  -- flag is needed for no order cust IDs
  flag number(1) := 0;

  begin
    -- check that parameters are valid
    if lv_cust_id >= lv_cust_id2 then
      dbms_output.put_line('Error! 1st customer Id must be '||
                                   'less than 2nd customer ID.');
    else
      -- cursor for loop, looks at each distinct cust ID in porchase_order
      for i in lv_cust_id..lv_cust_id2 loop
        
        -- regular for loop, iterates through each value in parameters range
        for rec_purchase in cur_purchase loop
          
          -- if selected id equals i
          if rec_purchase.cust_id = i then
            dbms_output.put_line(rec_purchase.cust_id ||
                                           ' has a purchase order.');
            -- set flag to 1, for 'id used in output'
            flag := 1;
            
          end if; -- end inner if
        end loop; -- end inner for loop
          
        -- if flag is still 0, we know this id hasn't ordered
        if flag = 0 then
          dbms_output.put_line(i || ' does not have a purchase order.');
        end if;
        
        -- reset flag
        flag := 0;
        
      end loop; -- end outer loop
    end if; -- end outer if
      
end; -- end procedure find_purchase
/

-- simple driver, first 3 calls ar valid, 4th is invalid
begin
  dbms_output.put_line('');
  dbms_output.put_line('90001 to 90008');
  dbms_output.put_line('');
  find_purchase(90001, 90008);
  dbms_output.put_line('');
  dbms_output.put_line('90003 to 90007');
  dbms_output.put_line('');
  find_purchase(90003, 90007);
  dbms_output.put_line('');
  dbms_output.put_line('90009 to 90010');
  dbms_output.put_line('');
  find_purchase(90009, 90010);
  dbms_output.put_line('');
  dbms_output.put_line('90005 to 90004');
  dbms_output.put_line('');
  find_purchase(90005, 90004);
  dbms_output.put_line('');
  
end; -- end find_purchase driver
/

/* It made no sense to do problem 02 before  04 when I had to create the tables
   anyway, so I did 04 first. */

/* Problem 04. 

(20 Points) Modify and add data to your Physician, Patient, and Treatment
tables so that the tables look like the following. Also be sure that the 
Primary Key and Foreign Key constraints are still in effect. Note that
the Pat_Room and Pat_Bed have changed values in some cases. Also, a new
table has been added.  

Patient Table

Pat_Nbr	  Pat_Name           Pat_Address        Pat_City    Pat_State     Pat_ZIP   Pat_Room     Pat_Bed
------    ---------------    ---------------    ---------   ---------     -------   ---------    -------
1379      Cribbs, John       2110 Main St.      Austin	    TX     	      78711     101          1
3249	    Baker, Mary        3547 W. 42nd St.   Berkeley	  CA	          94117     137		       2
4500	    Garcia, Juan	     1533 Telegraph     Berkeley	  CA	          94117     228	         2
5116      Harris, Carol      4710 Ave. E	      Austin	    TX 	          78705	    438		       1
5872	    Zimmer, Elka       7988 Cedar	        Cleveland   OH     	      44060	    137		       1
6213	    Rose, David        322 Bridge Ave.    Redwood	    CA    	      94065	    100		       1
7459	    Smith, Chris       788 Cummings       Cleveland   OH	          44066     438		       3
8031	    Fitch, Sylvia	     3380 Fox Ave.      Madison	    WI 	          53711	    420		       4
8659	    Hernandez, Juan    8300 Geneva Dr.    Austin	    TX     	      78723	    350		       2

Physician Table

Phys_ID		Phys_Name		  Phys_Phone		  Phys_Specialty
-------  ----------     -----------   	------------------
  101		 Wilcox, Chris	512-329-1848		Eyes, Ears, Throat
  102		 Nusca, Jane		512-516-3947		Cardiovascular
  103	 	 Gomez, Juan		512-382-4987		Orthopedics
  104	   Li, Jan			  512-516-3948		Cardiovascular
  105		 Simmons, Alex  512-442-5700		Hemotology

Treament  Table

Pat_Nbr		    Phys_ID		  Trt_Procedure		      Trt_Date
----------		-----------	------------------		------------
3249		      101		      13-08		            	12-FEB-1999
1379		      103		      27-45		            	25-MAR-1999
3249		      103		      88-20			            22-JAN-1999
5116		      104	      	52-14		            	03-APR-1999
4500		      101	      	13-08		            	04-FEB-1999
8031		      102	      	52-14		            	15-MAR-2000
5116		      104	      	52-14		            	05-FEB-2001
5872		      105	      	60-00		            	13-FEB-2000
3249		      103	      	88-20		            	24-JAN-2000
8659		      104		      60-00		            	08-APR-2001

Procedure Table

Pro_Nbr		    Pro_Desc		        Pro_Charge
----------		-----------   	    ---------------
13-08		      Throat culture	 	  15.00
27-45		      X-Ray			          62.00
52-14	      	Cardiogram	        135.00
60-00	        Blood Analysis		  58.00
88-20		      MRI		            	800.00

1) Assume a treatment procedure can be given to a patient only once per date.
2) A patient can receive the same treatment procedure from different physicians .

Hand in: 
A listing of each table. Show the commands used  to change these tables. */

-- create tables
create table Physician(
  Phys_ID number(3) primary key,
  Phys_Name varchar2(20),
  Phys_Phone varchar(12),
  Phys_Specialty varchar2(20));
/  

create table Patient(
  Pat_Nbr number (4) primary key,
  Pat_Name varchar2(20),
  Pat_Address varchar2(20),
  Pat_City varchar2(10),
  Pat_State varchar2(2),
  Pat_ZIP number(5),
  Pat_Room number(3),
  Pat_Bed number(1)); 
/

create table Procedure(
  Pro_Nbr	varchar2(5) primary key,
  Pro_Desc varchar2(15),
  Pro_Charge number(5, 2));
/

create table Treatment(
  Pat_Nbr	number(4) references Patient(Pat_Nbr),
  Phys_ID	number(3) references Physician(Phys_ID),
  Trt_Procedure varchar2(5) references Procedure(Pro_Nbr),
  Trt_Date date,
  primary key(Pat_Nbr, Trt_Date));
/

-- populate the tables
insert into Physician
  values(101, 'Wilcox, Chris', '512-329-1848', 'Eyes, Ears, Throat');
insert into Physician
  values(102, 'Nusca, Jane', '512-516-3947', 'Cardiovascular');
insert into Physician
  values(103,	'Gomez, Juan', '512-382-4987', 'Orthopedics');
insert into Physician
  values(104,	'Li, Jan', '512-516-3948', 'Cardiovascular');
insert into Physician
  values(105,	'Simmons, Alex', '512-442-5700', 'Hemotology');
/

insert into Patient
  values(1379, 'Cribbs, John', '2110 Main St.', 'Austin', 'TX',
         78711, 101, 1);
insert into Patient
  values(3249, 'Baker, Mary', '3547 W. 42nd St.', 'Berkeley', 'CA',
         94117, 137, 2);
insert into Patient
  values(4500, 'Garcia, Juan', '1533 Telegraph', 'Berkeley', 'CA',
         94117, 228, 2);
insert into Patient
  values(5116, 'Harris, Carol', '4710 Ave. E', 'Austin', 'TX',
         78705, 438, 1);
insert into Patient
  values(5872, 'Zimmer, Elka', '7988 Cedar', 'Cleveland', 'OH', 
         44060, 137, 1);
insert into Patient
  values(6213, 'Rose, David', '322 Bridge Ave.', 'Redwood', 'CA',
         94065, 100, 1);
insert into Patient
  values(7459, 'Smith, Chris', '788 Cummings', 'Cleveland', 'OH',
         44066, 438, 3);
insert into Patient
  values(8031, 'Fitch, Sylvia', '3380 Fox Ave.', 'Madison', 'WI',
         53711, 420, 4);
insert into Patient
  values(8659, 'Hernandez, Juan', '8300 Geneva Dr.', 'Austin', 'TX',
         78723, 350, 2);	
/

insert into Procedure
  values('13-08', 'Throat culture', 15.00);
insert into Procedure
  values('27-45', 'X-Ray', 62.00);
insert into Procedure
  values('52-14', 'Cardiogram', 135.00);
insert into Procedure
  values('60-00', 'Blood Analysis', 58.00);
insert into Procedure
  values('88-20', 'MRI', 800.00);
/

insert into Treatment
  values(3249, 101, '13-08', '12-FEB-1999');
insert into Treatment
  values(1379, 103, '27-45', '25-MAR-1999');
insert into Treatment
  values(3249, 103, '88-20', '22-JAN-1999');
insert into Treatment
  values(5116, 104, '52-14', '03-APR-1999');
insert into Treatment
  values(4500, 101, '13-08', '04-FEB-1999');
insert into Treatment
  values(8031, 102, '52-14', '15-MAR-2000');
insert into Treatment
  values(5116, 104, '52-14', '05-FEB-2001');
insert into Treatment
  values(5872, 105, '60-00', '13-FEB-2000');
insert into Treatment
  values(3249, 103, '88-20', '24-JAN-2000');
insert into Treatment
  values(8659, 104, '60-00', '08-APR-2001');
  
-- view the tables to verify the changes
select * from Physician;
select PAT_NBR, PAT_NAME, PAT_ADDRESS, PAT_CITY from Patient; -- broken up
select PAT_STATE, PAT_ZIP, PAT_ROOM, PAT_BED from Patient;  -- for readability
select * from Procedure;
select * from Treatment;
/

/* Problem 02

2. (50 Points) Construct a PL/SQL package named Hospital which operates on
    the Physician, Treatment, and Patient tables as you did in Lab #3 by
    creating your own tables. The Package should contain the following:
    
  A PL/SQL table named t_patTrt defined in the specification which contains
  a RECORD with the following fields: Pat_Nbr, Trt_Procedure, Phys_ID,
  Phys_Name, Phys_Specialty.
  
One exception: Named e_DupPhysFound.

A Procedure named BuildPatTbl, which will build a table of all treatments
for all patients. The table will be an output parameter. A second Input/Output
Parameter will be the number of rows returned in the table. The indexes 
in the table will start at 1 and be incremented by 1. For each treatment,
include Pat_Nbr, Trt_Procedure, Phys_ID, Phys_Name, and Phys_specialty
in the table.

2 overload functions, both named FindPatient, to check to see if a patient
is in the database either by patient number or name. That is, the input value
could be either the patient number or name. RETURN true, if the patient is
found: FALSE if the patient is not found.

A procedure named NewPhys which inserts a new physician into the physician
table. The input parameters are: Phys_ID, Phys_Name, Phys_Phone, and 
Phys_Specialty. The procedure should check to see if the physician is
already in the table. If he/she is in the table, raise the exception 
e_DupPhysFound. Do Not Check for any exceptions in this procedure. */

-- I have no idea how to create a table in a package specification or 
-- have a table be an output parameter of a procedure. None of this is
-- stuff we've covered at all. Instead, I'm creating the table ahead of time
-- and just altering it with the package. It has to be created here
-- or the package won't compile (table not found).

create table t_patTrt(
    t_patient number(4),
    t_treatment varchar2(5),
    t_phys_id number(3),
    t_phys_name varchar2(20),
    t_phys_spec varchar2(20));
/
-- create package specification
create or replace package Hospital is

  -- record to construct table type, compiles correctly, unused
  type type_rec_tpt is record(
    rv_patient Treatment.Pat_Nbr%type,
    rv_treatment Treatment.Trt_Procedure%type,
    rv_phys_id Treatment.Phys_ID%type,
    rv_phys_name Physician.Phys_Name%type,
    Rv_phys_spec Physician.Phys_Specialty%type);
    
  -- table to be built by BuildPatTbl, compiles correctly, unused
  type type_t_patTrt is table of type_rec_tpt
    index by binary_integer;
  
  -- procedure to build table
  procedure BuildPatTbl
    (pv_num_rows in out number);
  
  -- overloaded functions to find patients
  function FindPatient
    (fv_pat_name in patient.pat_name%type)
    return boolean;
  function FindPatient
    (fv_pat_nbr in patient.pat_nbr%type)
    return boolean;
  
  -- procedure to insert new physician
  procedure NewPhys
    (pv_phys_id in physician.Phys_ID%type,
     pv_phys_name in physician.Phys_Name%type,
     pv_phys_phone in physician.Phys_Phone%type,
     pv_phys_spec in physician.Phys_Specialty%type);

end Hospital;
/

-- create package body
create or replace package body Hospital is
  
-- procedure to build table
procedure BuildPatTbl
  (pv_num_rows in out number)
 is  
  cursor cur_table is 
    select t.Pat_Nbr, t.Trt_Procedure, Phys_ID,
                    y.Phys_Name, y.Phys_Specialty
     from Treatment t join  Physician y using (Phys_ID);
  
 begin
  pv_num_rows := 0;
  for rec_table in cur_table loop
   insert into t_patTrt
     values (rec_table.Pat_Nbr, rec_table.Trt_Procedure, rec_table.Phys_ID,
             rec_table.Phys_Name, rec_table.Phys_Specialty);
   pv_num_rows := pv_num_rows + 1;
  end loop;
  
 end BuildPatTbl;

-- overloaded functions to find patients
function FindPatient
  (fv_pat_name in patient.pat_name%type)
  return boolean
  is
 flag boolean := false;
 cursor cur_table is
  select Pat_Name from patient;
  
 begin
  for rec_table in cur_table loop
    if fv_pat_name = rec_table.Pat_Name then
      flag := true;
    end if;
  end loop;
  return flag;
 end FindPatient; 
 
function FindPatient
  (fv_pat_nbr in patient.pat_nbr%type)
  return boolean
  is
 flag boolean := false;
 cursor cur_table is
  select Pat_Nbr from patient;
  
 begin
  for rec_table in cur_table loop
    if fv_pat_nbr = rec_table.Pat_Nbr then
      flag := true;
    end if;
  end loop;
  return flag;
 end FindPatient;
  
-- procedure to insert new physician
procedure NewPhys
  (pv_phys_id in physician.Phys_ID%type,
   pv_phys_name in physician.Phys_Name%type,
   pv_phys_phone in physician.Phys_Phone%type,
   pv_phys_spec in physician.Phys_Specialty%type)
  is
   cursor cur_table is
     select Phys_ID from Physician;
     
  -- exception to be raised by NewPhys
  e_DupPhysFound exception;
    
 begin
  for rec_table in cur_table loop
   if pv_phys_id = rec_table.phys_id then
    raise e_DupPhysFound;
   end if;
  end loop;
  insert into Physician
    values(pv_phys_id, pv_phys_name, pv_phys_phone, pv_phys_spec);

  exception
   when e_DupPhysFound then
    dbms_output.put_line('Physician is already in table!');

 end NewPhys;
end Hospital;
/

/* Problem 03 

3.(20 Points) Write a driver to test the package above. The driver should
   do the following:
   
Call the FindPatient function with 	1) a valid Patient ID Number
2) a Valid Patient Name 3) an invalid Patient ID Number.
    
Use the NewPhys procedure to 1) Insert a new physician into the Physician table
2) attempt to insert a physician who already exists in the Physician table.
3) Check for the exception e_DupPhysFound in this driver

Delclare a table of the type t_PatTrt.

Call the Procedure BuildPatTbl which will store patients and treatments
in the above table. List the patients returned in the table. List all
fields in the table for each patient. */

-- driver for Hospital package
declare
 flag boolean; 
 
begin
  -- this section tests the FindPatient function
 flag := Hospital.FindPatient(3249);
 dbms_output.put('3249 returns ');
 if flag = true then
   dbms_output.put_line('true');
 else
   dbms_output.put_line('false');
 end if;
 
 flag := Hospital.FindPatient('Cribbs, John');
 dbms_output.put('Cribbs, John returns ');
 if flag = true then
   dbms_output.put_line('true');
 else
   dbms_output.put_line('false');
 end if;
 
 flag := Hospital.FindPatient('Knott, Reel');
 dbms_output.put('Knott, Reel returns ');
 if flag = true then
   dbms_output.put_line('true');
 else
   dbms_output.put_line('false');
 end if;
end;
/
 
 -- this section tests the NewPhys procedure
 begin
  Hospital.NewPhys(333, 'Knott, Reel', '512-884-4488', 'Leg Replacement');
  Hospital.NewPhys(101, 'Wilcox, Chris', '512-329-1848', 'Eyes, Ears, Throat');
end;
/

 -- show that our addition was actually added
 select * from Physician where Phys_ID = 333;
 /

-- this section tests BuildPatTbl
-- show that t_patTrt is empty
select * from t_patTrt;
/

-- call BuildPatTbl
declare
 rows_processed number(3);
begin
 Hospital.BuildPatTbl(rows_processed);
 -- show rows proccessed
 dbms_output.Put_line(rows_processed||' rows processed.');
end;
/

-- show that t_patTrt has been filled
select * from t_patTrt;
/
    
/* Problem 05

5.(30 Points) Write a Trigger for inserting into or updating the treatment
table, which checks the treatment date to ensure that it is no later than
today and no earlier than 3 months ago. If it violates this constraint,
raise an application error (-20100, ‘Invalid treatment date’) Test by
inserting 2 rows, one insert with an acceptable date, one with an invalid date.

Hand-in:Listing of the Trigger, Listing of the test results */

create or replace trigger update_treatment
  before insert or update of trt_date
  on Treatment
  for each row

 declare
  oldest_date date := add_months(sysdate, -3);
  
  begin
   if :new.trt_date > sysdate or
      :new.trt_date < oldest_date then
    raise_application_error(-20100, 'Invalid treatment date');
   end if;
    
end;
/

insert into Treatment
  values(8659, 104, '60-00', '10-JUL-2015');
insert into Treatment
  values(8659, 103, '60-00', '01-APR-2015');
  
-- ensure that 1st value was added and 2nd was not
select * from Treatment where pat_nbr = 8659;
/
  
-- cleanup
drop table t_patTrt;
drop table Treatment;
drop table Procedure;
drop table Patient;
drop table Physician;
/

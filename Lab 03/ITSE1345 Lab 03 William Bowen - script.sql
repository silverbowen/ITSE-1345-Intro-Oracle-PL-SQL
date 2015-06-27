/* William Bowen
   ITSE 1345
   Lab 03 */
   
set serveroutput on;
/

/* Problem 01

1.(20 Points) Write a PL/SQL procedure which will find the data for a given
  employee using the employee number. The procedure specification is as follows:
  
  Purpose: To retrieve and list the data for a given employee
  Input Parameter: The employee number
  nput/Output parameters: None
  Output Parameters: None
  Preconditions: The employee number should exist. If he/she does not exist, 
                 handle it with an exception and appropriate message. 
  Post Conditions: Print out each column in the employee row. The employee
                   table is unchanged.
                   - Use %ROWTYPE to define a structure in which to store
                     the column values.
                   - Write a simple driver to call and test the procedure.
                   - Test one valid employee (Empno = 7654) and one invalid
                     employee (Empno = 7888)  */

-- create procedure
create or replace procedure find_emp_data
  -- only one parameter
  (lv_emp_num in emp.empno%type)
  is
  -- used a record to hold the output, w/ the %rowtype indicator 
  rec_emp emp%rowtype;

  begin
    -- select the data for the parameter lv_emp_num
    select * into rec_emp from emp
    where empno = lv_emp_num;
    
    -- I labelled the output, for visual niceness
    dbms_output.put_line('Emp# LName  Job      '||
                         'Mgr  HireDate  Sal  Comm Dept');
    
    -- the data, formatted for easy reference
    dbms_output.put_line(rec_emp.empno||' '||rec_emp.ename||' '||
      rec_emp.job||' '||rec_emp.mgr||' '||rec_emp.hiredate||' '||
      rec_emp.sal||' '||rec_emp.comm||' '||rec_emp.deptno);
      
    -- handle no data found here
    exception
      when no_data_found then
        -- show error message
        dbms_output.put_line('Employee not found');
      
end; -- end procedure find_emp_data
/

-- simple drive, first call is valid, second is invalid
begin
  find_emp_data(7654);
  find_emp_data(7888);

end; -- end find_emp_data driver
/

/* Problem 02

2. (20 Points) Write a function which inputs two dates and compares the two
    dates. The function returns –1, 0, or +1 depending on whether the 1st date
    is less than, equal to, or greater than the 2nd date. (The time component
    is not to be considered here).

	Purpose: To compare two dates
	Input Parameters: 2 dates
	Input/Output parameters: None
	Output Parameters: None
	Return Value: Integer (-1, 0, +1)
	Preconditions: Dates in standard format
	Postconditions: Dates unchanged. Comparison Value Returned.
                 - Write a simple driver to call and test the procedure
                 - Test each of the three different possible comparison
                   values. */

-- create function
create or replace function compare_dates
  
  -- to variables in, the dates to compare
  (date1 in date,
   date2 in date)
   -- return the int
   return int
  is
  -- holding variable for our int to return
  lv_holder int;
  
  begin
    -- I like case statements. They're elegant
    case
      when date1 < date2 then
        lv_holder := -1;      -- store value to return later
      when date1 = date2 then -- (so we only have one return)
        lv_holder := 0;
      when date1 > date2 then
        lv_holder := 1;
    end case;
    
    -- return appropriate value
    return lv_holder;

end; -- end function compare_dates
/
  
-- simple test driver 
declare
  -- declare two dates to compare
  date1 date := '01-jan-11';
  date2 date := '02-feb-22';
  
  begin
    -- output results of comparison one
    dbms_output.put_line(date1||' and '||date2||' in returns   '
                         ||compare_dates(date1, date2));
      
    -- output results of comparison two  
    dbms_output.put_line(date1||' and '||date1||' in returns   '
                         ||compare_dates(date1, date1));
    
    -- output results of comparison three
    dbms_output.put_line(date2||' and '||date1||' in returns   '
                         ||compare_dates(date2, date1));

end;  -- end compare_dates driver
/

/* Problem 03 

3.(20 Points) Write a procedure which inputs an account ID and returns the
  customer information for that account.

	Purpose: To find the customer information for a given account number
	Input Parameters: Account ID
	Input/Output Parameters: None
	Output Parameters: Row of customer table that has the account ID
	Preconditions: Account ID is valid
	Postconditions: Customer Table unchanged. If customer found, customer row
                  returned, If customer not found, return Message “Cust_ID
                  not valid” and customer row is returned as garbage.
                  - Write a simple driver to call and test the procedure.
                    The driver should print out the fields of the row that
                    is returned. */

--create procedure
create or replace procedure cust_info
  -- two varaibles, acct_id in and a record of the row out
  (pv_acc_id in customer.account_id%type,
   rec_cust out customer%rowtype)
  is
  
  begin
    -- fill up the record w/ customers data
    select * into rec_cust from customer
    where account_id = pv_acc_id;

    -- if acct id not found
    exception
        when no_data_found then
          -- show error message
          dbms_output.put_line('Account_ID not valid');
          
          -- I wasn't sure what was meant by 'return garbage', so I just
          -- went ahead and filled in the record with obvious nonsense
          rec_cust.cust_id := 99999;
          rec_cust.cust_name := 'xxxxxxx';
          rec_cust.account_id := 'x-99999';
          rec_cust.account_type := 'xx';
          rec_cust.state := 'xx';
      
end; -- end procedure find_emp_data
/

-- simple driver to test procedure
declare
  -- using same record that procedure uses
  rec_cust customer%rowtype;
  
  begin
    -- get the info
    cust_info('A-11101', rec_cust);
    -- labelled output, for visual niceness
    dbms_output.put_line('Cust_ID   Cust_Name   Acct_ID   '||
                         'A_Type  State');
    -- print the info
    dbms_output.put_line(rec_cust.cust_id||'     '||rec_cust.cust_name||
                         '     '||rec_cust.account_id||'   '||
                         rec_cust.account_type||'      '||rec_cust.state);

    -- this one is invalid
    cust_info('B-11101', rec_cust);
    dbms_output.put_line('Cust_ID   Cust_Name   Acct_ID   '||
                         'A_Type  State');
    dbms_output.put_line(rec_cust.cust_id||'     '||rec_cust.cust_name||
                         '     '||rec_cust.account_id||'   '||
                         rec_cust.account_type||'      '||rec_cust.state);

end; -- end cust_info driver
/

/* Problem 04 

4. (20 Points) Write an anonymous block which updates the .Physician table.
   (As you can not update the .Physician Table, you will have to create your
   own table based on the structure and contents of the .Physician Table).
   Use named parameters to get values for Phys_ID, Phys_name, Phys_phone,
   and Phys_speciality. If the value for Phys_ID is in the Physician Table,
   Update the values of the remaining columns. If the Phys_ID is not in the
   Physician Table, INSERT a row into the Physician Table with those values.
   - Hint: Use variables for each of the columns above and assign a named 
          parameter to each of them. Then use the variable in the rest of
          the block.
   - Write a simple driver to test the block with a Phys_ID that is in the
     Physician Table and a Phys_ID that is not in the Physician Table. */

-- I assumed we were supposed to set the values of the Physician
-- table ourselves (I had no idea where I'd find a .Physician table).
create table Physician(
  Phys_ID number(4),
  Phys_name varchar2(20),
  Phys_phone number(10),
  Phys_specialty varchar2(20));
/  

-- populate the Physician table with some starter valuea
insert into Physician
  values(1234, 'Dr. Octopus', 1234567890, 'Squidology');
insert into Physician
  values(2005, 'Dr. Who', 4196322015 , 'Temporal Ontology');
/

-- view the table to verify the changes
select * from Physician;
/

-- Create block.
declare
  -- variables that are %types of the table
  -- values 1234, Blavatsky, 9876543210, Metaphysician
  lv_id Physician.Phys_ID%type := &id;
  lv_name Physician.Phys_name%type := '&name';
  lv_phone Physician.Phys_phone%type := &phone;
  lv_spec Physician.Phys_specialty%type := '&spec';
  
  -- variable for holding an integer
  lv_check number(1);
  
  begin
      
      -- see if our id is in the table
      select count(*) into lv_check from Physician
      where Phys_ID = lv_id;
      
      -- if to decide whether to update or insert
      if lv_check = 1 then
      
        -- update the table using bind variables
        update Physician
          set Phys_name = lv_name,
              Phys_phone = lv_phone,
              Phys_specialty = lv_spec
          where Phys_ID = lv_id;
          
      else
        -- or insert new values into table
        insert into Physician
          values (lv_id, lv_name, lv_phone, lv_spec);
          
      end if; -- end if
    
end; -- end anonymous block
/

-- I don't know any way to do a driver to call an anonymous block,
-- so I just ran it twice using 1234 and 9999 (in the table, new
-- to the table, respectively)
declare
  -- values 9999, Halle Tosis, 9999999999, Freshology
  lv_id Physician.Phys_ID%type := &id;
  lv_name Physician.Phys_name%type := '&name';
  lv_phone Physician.Phys_phone%type := &phone;
  lv_spec Physician.Phys_specialty%type := '&spec';
  lv_check number(1);
  begin
      select count(*) into lv_check from Physician
      where Phys_ID = lv_id;
      if lv_check = 1 then
        update Physician
          set Phys_name = lv_name,
              Phys_phone = lv_phone,
              Phys_specialty = lv_spec
          where Phys_ID = lv_id;
      else
        insert into Physician
          values (lv_id, lv_name, lv_phone, lv_spec);
      end if;
end; -- end 2nd run
/

-- Here is the new table
select * from Physician;
/

-- clean up database
drop table Physician;
/

/* Problem 05

5.(20 Points) Write a function that adjusts a string to a specific length.
	- If there are any leading spaces, delete them.
  - If the specified length is greater than the actual length of the string,
    the string is padded on the right by spaces.
  - If the specified length is less than the actual length of the string,
    the string is truncated on the right to the specified length.

  Input Parameters: String, Specified Length
  Output Parameters: None
  Input/Output Parameters: None
  Return Value: VARCHAR2 (adjusted string)

  Write a simple driver to test the function. Call the function with the
  following parameters:
    String: ‘Now is the Time.’
    Specified length = 6
    String: ‘Now is the Time.’
    Specified length = 25
    String: ‘bbbbNow is the Time.bbbbbbbbb’ (Where b = Blank Space)
    Specified length = 15

  Display the original string, the adjusted string and the length of
  the adjusted string. */

-- create function string_adjust
create or replace function string_adjust
  -- 2 variables in, string and desired length
  (fv_string in varchar2,
   fv_length in number)
   -- return a string
   return varchar2
  is
    
  begin
    -- skip straight to returning an ltrimmed/rpadded version of input
    return rpad(ltrim(fv_string), fv_length);
end; -- end string_adjust function
/

-- driver for string_adjust
begin
  -- first string - show unmodified, do string_adjust, show length
  -- I adda <end at the end, to make the end clearer
  dbms_output.put_line('Now is the Time.'||'<end');
  dbms_output.put_line(string_adjust('Now is the Time.', 6)||'<end');
  dbms_output.put_line(length(string_adjust('Now is the Time.', 6)));

  -- and again
  dbms_output.put_line('Now is the Time.'||'<end');
  dbms_output.put_line(string_adjust('Now is the Time.', 25)||'<end');
  dbms_output.put_line(length(string_adjust('Now is the Time.', 25)));
  
  -- and again
  dbms_output.put_line('    Now is the Time.         '||'<end');
  dbms_output.put_line(string_adjust('    Now is the Time.         ', 15)||
                                     '<end');
  dbms_output.put_line(length(string_adjust('    Now is the Time.         ',
                                            15)));
                                            
end; -- end string_adjust driver
/

/* William Bowen
   ITSE 1345
   Competency 2.2 */
   
/* problem 01 */

declare
  lv_test_date date := '10-DEC-1007';
  lv_test_num constant number(3) := 10;
  lv_test_txt varchar2(10);
  
begin
  lv_test_txt := 'Bowen';
  dbms_output.put_line(lv_test_date);
  dbms_output.put_line(lv_test_num);
  dbms_output.put_line(lv_test_txt);
  
end;
/

/* problem 02 in file 
   WB_2.2_prob02.doc */

/* problem 03 */

declare
  tst_num number (6, 2) := 42;
  
begin   
  if tst_num > 200 then
   dbms_output.put_line('This customer spent:');
   dbms_output.put_line(tst_num);
   dbms_output.put_line('They are rated HIGH.');       
  elsif tst_num > 100 then
   dbms_output.put_line('This customer spent:');
   dbms_output.put_line(tst_num);
   dbms_output.put_line('They are rated MID.');
  else
   dbms_output.put_line('This customer spent:');
   dbms_output.put_line(tst_num);
   dbms_output.put_line('They are rated LOW.');      
  end if;
  
end;
/

/* problem 04 */

declare
  tst_num number (6, 2) := 142;
  
begin   
  case
    when tst_num > 200 then
     dbms_output.put_line('This customer spent:');
     dbms_output.put_line(tst_num);
     dbms_output.put_line('They are rated HIGH.');       
    when tst_num > 100 then
     dbms_output.put_line('This customer spent:');
     dbms_output.put_line(tst_num);
     dbms_output.put_line('They are rated MID.');
    else
     dbms_output.put_line('This customer spent:');
     dbms_output.put_line(tst_num);
     dbms_output.put_line('They are rated LOW.');      
  end case;

end;
/

/* problem 05 */

variable tst_num number

begin
  :tst_num := 242;
end;
/
 
begin   
  if :tst_num > 200 then
   dbms_output.put_line('This customer spent:');
   dbms_output.put_line(:tst_num);
   dbms_output.put_line('They are rated HIGH.');       
  elsif :tst_num > 100 then
   dbms_output.put_line('This customer spent:');
   dbms_output.put_line(:tst_num);
   dbms_output.put_line('They are rated MID.');
  else
   dbms_output.put_line('This customer spent:');
   dbms_output.put_line(:tst_num);
   dbms_output.put_line('They are rated LOW.');      
  end if;      

end;
/

/* problem 06 */

declare
  price number (4, 2) := 16.65;
  amount number (6, 2) := 123.45;
  items number (1) := 0;
  
begin
  loop    
    exit when amount < (items + 1) * price;
    items := items + 1;
  end loop;
  
  dbms_output.put_line('You have:');
  dbms_output.put_line(amount);
  dbms_output.put_line('Each widget costs:');
  dbms_output.put_line(price);
  dbms_output.put_line('Widgets you can buy:');
  dbms_output.put_line(items);
  dbms_output.put_line('This will cost:');
  dbms_output.put_line(items * price);

end;
/

/* problem 07 in file
   WB-2.2_prob07.doc */
  
/*problem 08 */

declare
  membership char(1);
  items number (2);
  shipping number (4, 2);

begin
  membership := 'Y';
  items := 13;
    
  if items <= 0 then
    shipping := 0;
  elsif membership = 'Y' and  items > 10 then
    shipping := 9.00;
  elsif membership = 'Y' and items in (7, 8, 9, 10) then
    shipping := 7.00;
  elsif membership = 'Y' and items in (4, 5, 6) then
    shipping := 5.00;
  elsif membership = 'Y' and items in (1, 2, 3) then
    shipping := 3.00;
  elsif membership = 'N' and  items > 10 then
    shipping := 12.00;
  elsif membership = 'N' and items in (7, 8, 9, 10) then
    shipping := 10.00;
  elsif membership = 'N' and items in (4, 5, 6) then
    shipping := 7.50;
  else
    shipping := 5.00;
  end if;
    
  dbms_output.put_line('Member:');
  dbms_output.put_line(membership);
  dbms_output.put_line('Items:');
  dbms_output.put_line(items);
  dbms_output.put_line('Shipping cost:');
  dbms_output.put_line(shipping);
  
  end;
  /
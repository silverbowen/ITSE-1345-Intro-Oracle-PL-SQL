/* William Bowen
   ITSE 1345
   Competency 4.3 */

set serveroutput on;
 
/* Assignment 10-1 */

-- Here I'm logged on as <user>

-- Step 1) create trigger
create or replace trigger reorder
  after update of stock on bb_product
  for each row
  when (new.stock < old.reorder)
 
 begin     
     dbms_alert.signal('reorder',
         'Time to reorder product ID: '||to_char(:new.idproduct));

end;
/

-- Step 4) update table and trigger alert
update bb_product 
 set stock = -2
  where idproduct = 4;
/

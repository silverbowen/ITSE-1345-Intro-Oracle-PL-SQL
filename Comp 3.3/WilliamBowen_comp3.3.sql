/* William Bowen
   ITSE 1345
   Competency 3.3 */
   
set serveroutput on;

/* Assignment 6-1 */

-- create function
create or replace function dollar_fmt__sf
  (p_num number)
   return varchar2
  is
  lv_amount_txt varchar2(20);
begin
  lv_amount_txt := to_char(p_num, '$99,999.99');
  return lv_amount_txt;

end;
/

-- declare test variable
declare
  lv_amt_num number(8,2) := 9999.95;

-- call function  
begin
  dbms_output.put_line(dollar_fmt_sf(lv_amt_num));

end;
/

-- test w/ a select
select lpad(dollar_fmt_sf(shipping), 12) "    Shipping",
       lpad(dollar_fmt_sf(total), 11) "      Total"
from bb_basket
where idbasket = 3;
/

/* Assignment 6-2 */

-- create function
create or replace function tot_purch_sf
  (shopper_id bb_basket.idshopper%type)
   return bb_basket.total%type
  is
  total bb_basket.total%type;

begin
  select sum(total)
    into total
  from bb_basket
  where idshopper = shopper_id;
  
  return total;
  
end;
/

-- test function w/ a select
select distinct idshopper "Shopper ID",
       tot_purch_sf(idshopper) "Total Purchases"
from bb_basket;
/

/* Assignment 6-3 */

-- create function
create or replace function num_purch_sf
  (shopper_id bb_basket.idshopper%type)
   return number
  is
  orders number(3);

begin
  select count(idbasket)
    into orders
  from bb_basket
  where idshopper = shopper_id
    and orderplaced = 1; -- so we only get placed orders
  
  return orders;
  
end;
/


-- test function
select distinct idshopper "Shopper ID",
       num_purch_sf(idshopper) "# of Orders"
from bb_basket
where idshopper = 23;
/

/* Assignment 6-4 */

-- create function
create or replace function day_ord_sf
  (date_created bb_basket.dtcreated%type)
   return varchar2
  is
   week_day varchar2(10);

begin  -- using to_char and 'fmDay' to format
  week_day := to_char(date_created, 'fmDay');
  return week_day;

end;
/

-- test w/ a select
select idbasket "Basket #",
       lpad(day_ord_sf(dtcreated), 11) "Day Created"
from bb_basket;
/

-- test w/ another select
select distinct lpad(day_ord_sf(dtcreated), 11) "Day of Week",
       count(day_ord_sf(dtcreated)) "# of Orders"
from bb_basket
group by (day_ord_sf(dtcreated));
/
 
/* Assignment 6-5 */

-- create function
create or replace function ord_ship_sf
  (basket_id bb_basketstatus.idbasket%type)
   return varchar2
  is
  ship_date bb_basketstatus.dtstage%type;
  order_date bb_basket.dtordered%type;
  
begin
  select s.dtstage, b.dtordered
    into ship_date, order_date
  from bb_basketstatus s
    natural join bb_basket b
  where idbasket = basket_id
    and idstage = 5; -- ensure order has been shipped
  
  if (ship_date - order_date > 1) then
    return 'CHECK'; -- if it's taken more than one day to ship
  else
    return 'OK'; -- if it's one day or less
  end if;
  
end;
/

-- make a test host variable
variable host_id number;
begin
  :host_id := 3;
end;
/

-- test function
begin
dbms_output.put_line(ord_ship_sf(:host_id));
end;
/

/* Assignment 6-6 */

-- create function
create or replace function status_desc_sf
  (stage_id bb_basketstatus.idstage%type)
   return varchar2
  is
  description varchar2(26);

begin -- set description to whatever matches
  if (stage_id = 1) then
    description := 'Order submitted';
  elsif (stage_id = 2) then
    description := 'Accepted, sent to shipping';
  elsif (stage_id = 3) then
    description := 'Backordered';
  elsif (stage_id = 4) then
    description := 'Cancelled';
  else
    description := 'Shipped';
  end if;
  
  return description;

end;
/

-- test function
select dtstage, rpad(status_desc_sf(idstage), 26) "Status Description"
from bb_basketstatus
where idbasket = 4;
/

/* Assignment 6-7 */

--create function
create or replace function tax_calc_sf
  (basket_id bb_basket.idbasket%type)
   return bb_basket.total%type
  is -- lots of local variables
  subtot bb_basket.subtotal%type;
  ship_state bb_basket.shipstate%type;
  tax bb_tax.taxrate%type;
  tax_tot bb_basket.tax%type;
  
begin

  tax_tot := 0.0; -- initialize tax total to zero

  -- get subtotal and state
  select subtotal, shipstate
    into subtot, ship_state
  from bb_basket
  where idbasket = basket_id; -- ensure for our selected basket id only
  
  -- get tax rate for that state
  select taxrate
    into tax
  from bb_tax
  where state = ship_state;
  
  -- if the state is found, do the math
  tax_tot := subtot * tax;
  
  return tax_tot;
  
exception
   -- if the state isn't found in select #2
  when no_data_found then
    return tax_tot; -- this will return zero, because math never gets done
      
end;  
/

-- test function
select idbasket "Basket ID",
       tax_calc_sf(idbasket) "Tax Amount"
from bb_basket
where idbasket = 3;
/

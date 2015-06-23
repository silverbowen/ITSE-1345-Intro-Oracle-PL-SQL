/* William Bowen
   ITSE 1345
   Competency 3.2 */
   
set serveroutput on;

/* Assignment 5-1 */

create or replace procedure prod_name_sp
  (p_prodid  in bb_product.idproduct%type,
   p_descrip in bb_product.description%type)
  is
  
begin
  update bb_product
    set description = p_descrip
    where idproduct = p_prodid;
  commit;
  
end;
/

execute prod_name_sp(1, 'CapressoBar Model #388');
/

Column description heading 'description' format A50;
select idproduct, description from bb_product;
/

/* Assignment 5-2 */

create or replace procedure prod_add_sp
  (p_name    in bb_product.productname%type,
   p_descrip in bb_product.description%type,
   p_image   in bb_product.productimage%type,
   p_price   in bb_product.price%type,
   p_active  in bb_product.active%type)
  is
  
begin
  /* In order for this insert to work, we need to provide an ID
     as well, since the idproduct column is the primary key. This is
     accomplished with sequencename.nextval. */
  insert into bb_product
    (idproduct, productname, description,
     productimage, price, active)
    values (bb_prodid_seq.nextval, p_name,
            p_descrip, p_image, p_price, p_active);
  commit;
  
end;
/

begin  -- do input
prod_add_sp('Roasted Blend',
  'Well-balanced mix of roasted beans, medium body', 'roasted.jpg', 9.50, 1);
end;
/ 

-- See that input worked.
column productname format a15;
column description format a20;
column productimage format a12;
column price format a5;
column active format a6;
select idproduct, productname, description, productimage, price, active
  from bb_product
  where productname = 'Roasted Blend';
/

/* Assignment 5-3 */

create or replace procedure tax_cost_sp
  (p_state  in bb_tax.state%type,
   p_subtot in number,
   p_tax    out number) -- p_tax will return to the g_tax parameter
  is

begin
  select (taxrate * p_subtot) 
    into p_tax
  from bb_tax
  where state = p_state; -- if a no data found is thrown here
                         -- we know to set the tax rate to 0
exception
  when no_data_found then  -- this handler accomplishes that
    p_tax := 0;
end;
/

-- this code test that the value returned was correct
variable g_tax number;
execute tax_cost_sp('VA', 100, :g_tax);
print :g_tax;
/

/* Assignment 5-4 */

-- this is all input variables
create or replace procedure basket_confirm_sp
  (p_id    in bb_basket.idbasket%type,
   p_sub   in bb_basket.subtotal%type,
   p_ship  in bb_basket.shipping%type,
   p_tax   in bb_basket.tax%type,
   p_total in bb_basket.total%type)
  is
  
begin
-- and here they are used to update the row
  update bb_basket
    set orderplaced = 1, subtotal = p_sub,
         shipping = p_ship, tax = p_tax,
         total = p_total
    where idbasket = p_id;
  commit;
  
end;
/

-- three insert statements to allow testing
insert into bb_basket(idbasket, quantity, idshopper, orderplaced,
                subtotal, total, shipping, tax, dtcreated, promo)
  values (17, 2, 22, 0, 0, 0, 0, 0, '28-feb-07', 0);

insert into bb_basketitem(idbasketitem, idproduct, price, quantity,
                          idbasket, option1, option2)
  values (44, 7, 10.8, 3, 17, 2, 3);
  
insert into bb_basketitem(idbasketitem, idproduct, price, quantity,
                          idbasket, option1, option2)
  values (45, 8, 10.8, 3, 17, 2, 3);
commit;
/

-- the actual test
execute basket_confirm_sp(17, 64.80, 8.00, 1.94, 74.74);
/

-- proof that it worked
select subtotal, shipping, tax, total, orderplaced
  from bb_basket
  where idbasket = 17;
/

/* Assignment 5-5 */

-- more input variables
create or replace procedure status_ship_sp
  (p_id      in bb_basketstatus.idbasket%type,
   p_date    in bb_basketstatus.dtstage%type,
   p_shipper in bb_basketstatus.shipper%type,
   p_track   in bb_basketstatus.shippingnum%type)
  is

-- creating a new row with our old friend nextval
begin
  insert into bb_basketstatus
    (idstatus, idbasket, idstage, dtstage, shipper, shippingnum)
    values (bb_status_seq.nextval, p_id, 3, p_date, p_shipper, p_track);
  commit;
end;
/

-- make it so!
execute status_ship_sp(3, '20-FEB-07', 'UPS', 'zw2384yxk4957');
/

-- and the proof that it worked
select idstatus, idbasket,idstage,
  dtstage, shipper, shippingnum
from bb_basketstatus;
/

/* Assignment 5-6 */

-- here we have one in and two outs
create or replace procedure status_sp
  (p_id     in  bb_basketstatus.idbasket%type,
   p_date   out bb_basketstatus.dtstage%type,
   p_status out bb_basketstatus.notes%type)
  is
  -- but we also have a local variable
  lv_stage bb_basketstatus.idstage%type;

begin
  select idstage, dtstage -- selecting dtstage into p_date
    into lv_stage, p_date -- so we can return it
  from bb_basketstatus
  where idbasket = p_id -- subqueryto get max(dtstage)
  and dtstage = (select max(dtstage) from bb_basketstatus);
                -- because no group functions allowed here!
  case lv_stage -- case statements are elegent, IMHO
    when 1 then p_status := 'Submitted and received';
    when 2 then p_status := 'Confirmed, processed, sent to shipping';
    when 3 then p_status := 'Shipped';
    when 4 then p_status := 'Cancelled';
    when 5 then p_status := 'Backordered';
    else p_status := 'No status available';
  end case;

exception -- and no data found exception handled here
  when no_data_found then
    p_status := 'No status available';

end;
/  
 -- create our host variables
variable status_host varchar2;
variable date_host varchar2;
/

-- first test
execute status_sp(4, :date_host, :status_host);
/

-- outcome of test
print :date_host;
print :status_host;
/

-- second test
execute status_sp(6, :date_host, :status_host);
/

-- second outcome
print :date_host;
print :status_host;
/

/* Assignment 5-7 */

-- input parameters date month, year
create or replace procedure promo_ship_sp
  (p_date  in bb_basket.dtcreated%type,
   p_month in bb_promolist.month%type,
   p_year  in bb_promolist.year%type)
  is -- lots of local variables also
   lv_min bb_basket.idshopper%type;
   lv_max bb_basket.idshopper%type;
   lv_date bb_basket.dtcreated%type;
   lv_shopper bb_basket.idshopper%type;
   lv_dupe_id number; -- flag to ensure we violate PK constraint
   
-- get values for our loop
begin

  -- get shopper id values for for loop
  select min(idshopper), max(idshopper)
    into lv_min, lv_max
  from bb_basket;

  -- start loop
  for i in lv_min..lv_max loop
  
    -- get values for if statement  
    select max(dtcreated)
      into lv_date
    from bb_basket
    where idshopper = i;
    
    -- declare if, looking for dates before cutoff
    if p_date >= lv_date then
      select count(idshopper)
        into lv_dupe_id
      from bb_promolist
      where i = idshopper;
      
      -- check if the idshopper already exists in the promo
      -- table. If so the query returns 1 and we know to
      -- skip to next iteration of loop.
      if lv_dupe_id = 1 then continue;
      else
      -- if eligible insert the promo stuff
        insert into bb_promolist
          (idshopper, month, year, promo_flag, used)
          values (i, p_month, p_year, 1, 'N');
      end if;
    end if;
  end loop;

  commit;
end;
/

execute promo_ship_sp('15-FEB-12', 'APR', 2012);
/

select * from bb_promolist;
/

/* Assignment 5-8 */

-- add the in variables
create or replace procedure basket_add_sp
  (p_id    in bb_basketitem.idbasket%type,
   p_prod  in bb_basketitem.idproduct%type,
   p_price in bb_basketitem.price%type,
   p_qnty  in bb_basketitem.quantity%type,
   p_size  in bb_basketitem.option1%type,
   p_form  in bb_basketitem.option2%type)
  is
  
begin  -- insert into table
  insert into bb_basketitem (idbasketitem, idbasket,
    idproduct, price, quantity, option1, option2)
    values (bb_idbasketitem_seq.nextval, p_id, p_prod,
      p_price, p_qnty, p_size, p_form);

  commit;
end;
/

-- run the procedure
execute basket_add_sp(14, 8, 10.80, 1, 2, 4);
/

-- check the results
select * from bb_basketitem;
/
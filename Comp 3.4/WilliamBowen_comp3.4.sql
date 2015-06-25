/* William Bowen
   ITSE 1345
   Competency 3.4 */
   
set serveroutput on;

/* Assignment 7-1 */

CREATE OR REPLACE PACKAGE order_info_pkg IS
 FUNCTION ship_name_pf  
   (p_basket IN NUMBER)
   RETURN VARCHAR2;
 PROCEDURE basket_info_pp
  (p_basket IN NUMBER,
   p_shop OUT NUMBER,
   p_date OUT DATE);
END;
/

CREATE OR REPLACE PACKAGE BODY order_info_pkg IS
 FUNCTION ship_name_pf  
   (p_basket IN NUMBER)
   RETURN VARCHAR2
  IS
   lv_name_txt VARCHAR2(25);
 BEGIN
  SELECT shipfirstname||' '||shiplastname
   INTO lv_name_txt
   FROM bb_basket
   WHERE idBasket = p_basket;
  RETURN lv_name_txt;
 EXCEPTION
   WHEN NO_DATA_FOUND THEN
     DBMS_OUTPUT.PUT_LINE('Invalid basket id');
 END ship_name_pf;
 PROCEDURE basket_info_pp
  (p_basket IN NUMBER,
   p_shop OUT NUMBER,
   p_date OUT DATE)
  IS
 BEGIN
   SELECT idshopper, dtordered
    INTO p_shop, p_date
    FROM bb_basket
    WHERE idbasket = p_basket;
 EXCEPTION
   WHEN NO_DATA_FOUND THEN
     DBMS_OUTPUT.PUT_LINE('Invalid basket id');
 END basket_info_pp;
END;
/

/* Assignment 7-2 */

CREATE OR REPLACE PACKAGE order_info_pkg IS
 FUNCTION ship_name_pf  
   (p_basket IN NUMBER)
   RETURN VARCHAR2;
 PROCEDURE basket_info_pp
  (p_basket IN NUMBER,
   p_shop OUT NUMBER,
   p_date OUT DATE);
END;
/

CREATE OR REPLACE PACKAGE BODY order_info_pkg IS
 FUNCTION ship_name_pf  
   (p_basket IN NUMBER)
   RETURN VARCHAR2
  IS
   lv_name_txt VARCHAR2(25);
 BEGIN
  SELECT shipfirstname||' '||shiplastname
   INTO lv_name_txt
   FROM bb_basket
   WHERE idBasket = p_basket;
  RETURN lv_name_txt;
 EXCEPTION
   WHEN NO_DATA_FOUND THEN
     DBMS_OUTPUT.PUT_LINE('Invalid basket id');
 END ship_name_pf;
 PROCEDURE basket_info_pp
  (p_basket IN NUMBER,
   p_shop OUT NUMBER,
   p_date OUT DATE)
  IS
 BEGIN
   SELECT idshopper, dtordered
    INTO p_shop, p_date
    FROM bb_basket
    WHERE idbasket = p_basket;
 EXCEPTION
   WHEN NO_DATA_FOUND THEN
     DBMS_OUTPUT.PUT_LINE('Invalid basket id');
 END basket_info_pp;
END;
/

-- test procedure and function in block (returns nulls)
declare
  lv_id number := 12;
  lv_name varchar2(25);
  lv_shopper bb_basket.idshopper%type;
  lv_date bb_basket.dtcreated%type;
  
begin
  -- test function
  lv_name := order_info_pkg.ship_name_pf(lv_id);
  dbms_output.put_line(lv_id||' '||lv_name);
  
  -- test procedure
  order_info_pkg.basket_info_pp(lv_id, lv_shopper, lv_date);
  dbms_output.put_line(lv_id||' '||lv_shopper||' '||lv_date);

end;
/

-- test with select - again, prints nothing
select lpad(order_info_pkg.ship_name_pf(idbasket), 20)
            "ship_name_pf on 12"
from bb_basket
where idbasket = 12;
/

/* Assignment 7-3 */

CREATE OR REPLACE PACKAGE order_info_pkg IS
-- deleted function
 PROCEDURE basket_info_pp
  (p_basket IN NUMBER,
   p_shop OUT NUMBER,
   p_date OUT DATE,
   p_ship out varchar); -- added out variable
END;
/

CREATE OR REPLACE PACKAGE BODY order_info_pkg IS
 FUNCTION ship_name_pf  
   (p_basket IN NUMBER)
   RETURN VARCHAR2
  IS
   lv_name_txt VARCHAR2(25);
 BEGIN
  SELECT shipfirstname||' '||shiplastname
   INTO lv_name_txt
   FROM bb_basket
   WHERE idBasket = p_basket;
  RETURN lv_name_txt;
 EXCEPTION
   WHEN NO_DATA_FOUND THEN
     DBMS_OUTPUT.PUT_LINE('Invalid basket id');
 END ship_name_pf;
 PROCEDURE basket_info_pp
  (p_basket IN NUMBER,
   p_shop OUT NUMBER,
   p_date OUT DATE,
   p_ship out varchar) -- added out variable
  IS
 BEGIN
   SELECT idshopper, dtordered
    INTO p_shop, p_date
    FROM bb_basket
    WHERE idbasket = p_basket;
   p_ship := ship_name_pf(p_basket); -- out variable used here
 EXCEPTION
   WHEN NO_DATA_FOUND THEN
     DBMS_OUTPUT.PUT_LINE('Invalid basket id');
 END basket_info_pp;
END;
/

-- test procedure in block, this time I used basket
-- id 6, so we could actually see a name
declare
  lv_id number := 6;
  lv_name varchar2(25);
  lv_shopper bb_basket.idshopper%type;
  lv_date bb_basket.dtcreated%type;
  
begin
  -- test procedure
  order_info_pkg.basket_info_pp(lv_id, lv_shopper,
                                     lv_date, lv_name);
  dbms_output.put_line(lv_id||' '||lv_shopper
                      ||' '||lv_date||' '||lv_name);

end;
/

/* Assignment 7-4 */

-- create the function
create or replace function verify_user
  (usernm in varchar2,
   passwd in varchar2)
   return char
  is
   temp_user bb_shopper.username%type;
   confirm char(1) := 'N';

begin -- if this select succeed, we can return Y
  select username
    into temp_user
  from bb_shopper
  where password = passwd;
  
  confirm := 'Y';
  return confirm;

exception  -- if it fails, return N
  WHEN NO_DATA_FOUND THEN
     DBMS_OUTPUT.PUT_LINE('logon values are invalid');

end;
/

-- test w/ host variables 
variable g_ck char(1);

begin
  :g_ck := verify_user('gma1', 'goofy');
end;
/

-- it worked!
print g_ck
/

-- make it a package this time
create or replace package login_pckg is
  function verify_user
  (usernm in varchar2,
   passwd in varchar2)
   return char;
end;
/

-- body of the package
create or replace package body login_pckg is

  function verify_user
    (usernm in varchar2,  -- everything in the function is the same
     passwd in varchar2)
     return char
    is
     temp_user bb_shopper.username%type;
     confirm char(1) := 'N';
    
  begin
    select username
      into temp_user
    from bb_shopper
    where password = passwd;
  
    confirm := 'Y';
    return confirm;
    
  exception
  WHEN NO_DATA_FOUND THEN
     DBMS_OUTPUT.PUT_LINE('logon values are invalid');
     
  end verify_user;

end;
/

-- host variable  
variable g_ck char(1);

-- test, asignment and output in one block for convenience
begin
  :g_ck := login_pckg.verify_user('gma1', 'goofy');
  dbms_output.put_line(:g_ck);  -- it worked!
end;
/   
   
/* Assignment 7-5 */

create or replace package shop_query_pkg is
  
  -- first overloaded procedure, takes id
  procedure retrieve_shopper
    (lv_id in bb_shopper.idshopper%type,
     lv_name out varchar,
     lv_city out bb_shopper.city%type,
     lv_state out bb_shopper.state%type,
     lv_phone out bb_shopper.phone%type);
  
  -- second overloaded procedure, takes last name   
  procedure retrieve_shopper
    (lv_last in bb_shopper.lastname%type,
     lv_name out varchar,
     lv_city out bb_shopper.city%type,
     lv_state out bb_shopper.state%type,
     lv_phone out bb_shopper.phone%type);

end;
/


create or replace package body shop_query_pkg is
  
  -- first overloaded procedure, takes id
  procedure retrieve_shopper
    (lv_id in bb_shopper.idshopper%type,
     lv_name out varchar,
     lv_city out bb_shopper.city%type,
     lv_state out bb_shopper.state%type,
     lv_phone out bb_shopper.phone%type)
    is
    
  begin -- this is almost the same as 7-1
    select firstname||' '||lastname, city,
           state, phone
      into lv_name, lv_city, lv_state, lv_phone
    from bb_shopper
    where idshopper = lv_id;
  
  end retrieve_shopper;
  
  -- second overloaded procedure, takes last name   
  procedure retrieve_shopper
    (lv_last in bb_shopper.lastname%type,
     lv_name out varchar,
     lv_city out bb_shopper.city%type,
     lv_state out bb_shopper.state%type,
     lv_phone out bb_shopper.phone%type)
    is

  begin -- again same as 7-1
    select firstname||' '||lastname, city,
           state, phone
      into lv_name, lv_city, lv_state, lv_phone
    from bb_shopper
    where lastname = lv_last;
  
  end retrieve_shopper;
  
end;
/

-- test procedure in block shopper id 23, Ratman
declare
  lv_id number := 23;
  lv_last bb_shopper.lastname%type := 'Ratman';
  lv_name varchar2(25);
  lv_city  bb_shopper.city%type;
  lv_state bb_shopper.state%type;
  lv_phone bb_shopper.phone%type;
  
begin
  -- test procedure w/ id
  shop_query_pkg.retrieve_shopper(lv_id, lv_name,
                                     lv_city, lv_state, lv_phone);
  dbms_output.put_line(lv_name||' '||lv_city
                      ||' '||lv_state||' '||lv_phone);

  -- test procedure w/ last name
  shop_query_pkg.retrieve_shopper(lv_last, lv_name,
                                     lv_city, lv_state, lv_phone);
  dbms_output.put_line(lv_name||' '||lv_city
                      ||' '||lv_state||' '||lv_phone);

end;
/

/* Assignment 7-6 */

-- create a reference package w/ no body
create or replace package tax_rate_pkg is
  pv_tax_nc constant number := .035; -- all variables are constants
  pv_tax_tx constant number := .05;
  pv_tax_tn constant number := .02;
end;
/

-- test our body-less package by printing the variables
begin
  dbms_output.put_line(tax_rate_pkg.pv_tax_nc);
  dbms_output.put_line(tax_rate_pkg.pv_tax_tx);
  dbms_output.put_line(tax_rate_pkg.pv_tax_tn);

end;
/
  
/* Assignment 7-7 */

-- create a tax package
create or replace package tax_rate_pkg is
  
  -- spec a cursor to hold state and tax rate
  cursor cur_tax is
    select taxrate, state
    from bb_tax;
   
  -- spec a functionto get tax rate 
  function get_tax
    (pv_state in bb_tax.state%type)
    return bb_tax.taxrate%type;

end;
/

-- create a tax package body
create or replace package body tax_rate_pkg is
  
  -- define our function
  function get_tax
    (pv_state in bb_tax.state%type)
    return bb_tax.taxrate%type
   is
    -- we need a holding variable for the tax rate
    pv_tax bb_tax.taxrate%type := 0.00;
    
  begin -- use cursor for loop to find state and rate
    for rec_tax in cur_tax loop
        if rec_tax.state = pv_state then
          pv_tax := rec_tax.taxrate;
        
        end if;
    end loop;
    
    -- return the rate
    return pv_tax;
    
  end get_tax;

end;
/

-- test our package with NC
begin
  dbms_output.put_line('NC'||' '||tax_rate_pkg.get_tax('NC'));
end;
/

/* Assignment 7-8 */

CREATE OR REPLACE PACKAGE login_pkg IS
 
 pv_login_time timestamp; -- declare variable to hold timestamp
 
 pv_id_num NUMBER(3);
 FUNCTION login_ck_pf 
  (p_user IN VARCHAR2,
   p_pass IN VARCHAR2)
   RETURN CHAR;
   
END;
/  

CREATE OR REPLACE PACKAGE BODY login_pkg IS

  FUNCTION login_ck_pf 
  (p_user IN VARCHAR2,
   p_pass IN VARCHAR2)
   RETURN CHAR
  IS
   lv_ck_txt CHAR(1) := 'N';
   lv_id_num NUMBER(5);
   
  BEGIN
   SELECT idShopper
    INTO lv_id_num
    FROM bb_shopper
    WHERE username = p_user
     AND password = p_pass;
     
      lv_ck_txt := 'Y';
      pv_id_num := lv_id_num;
   RETURN lv_ck_txt;
   
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
   RETURN lv_ck_txt;
   
  END login_ck_pf;
  
  -- get the timestamp when login is called 
  begin
    select systimestamp
      into pv_login_time
    from dual;
   
END;
/

-- anonymous block for testing
declare
  -- a few local variables to hold needed data
  lv_user bb_shopper.username%type := 'Crackj';
  lv_passwd bb_shopper.password%type := 'flyby';
  lv_login char := 'N';
  
begin
  -- call the login function
  lv_login := login_pkg.login_ck_pf(lv_user, lv_passwd);
  
  -- print confirmation that we logged in and the time/date
  dbms_output.put_line(lv_login||'   '||login_pkg.pv_login_time);

end;
/
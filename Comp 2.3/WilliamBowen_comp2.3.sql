/* William Bowen
   ITSE 1345
   Competency 2.3 */
   
set serveroutput on

/* Assignment 3-1 */

variable g_basket number

begin
  :g_basket := 3;
end;
/

DECLARE
  lv_ship_date bb_basketstatus.dtstage%TYPE;
  lv_shipper_txt bb_basketstatus.shipper%TYPE;
  lv_ship_num bb_basketstatus.shippingnum%TYPE;
  lv_bask_num bb_basketstatus.idbasket%TYPE := :g_basket;

BEGIN
  SELECT dtstage, shipper, shippingnum
   INTO lv_ship_date, lv_shipper_txt, lv_ship_num
   FROM bb_basketstatus
   WHERE idbasket = lv_bask_num
    AND idstage = 5;
  DBMS_OUTPUT.PUT_LINE('Date Shipped: '||lv_ship_date);
  DBMS_OUTPUT.PUT_LINE('Shipper: '||lv_shipper_txt);
  DBMS_OUTPUT.PUT_LINE('Shipping #: '||lv_ship_num);
END;
/

variable g_basket number

begin
  :g_basket := 7;
end;
/

DECLARE
  lv_ship_date bb_basketstatus.dtstage%TYPE;
  lv_shipper_txt bb_basketstatus.shipper%TYPE;
  lv_ship_num bb_basketstatus.shippingnum%TYPE;
  lv_bask_num bb_basketstatus.idbasket%TYPE := :g_basket;
  
BEGIN
  SELECT dtstage, shipper, shippingnum
   INTO lv_ship_date, lv_shipper_txt, lv_ship_num
   FROM bb_basketstatus
   WHERE idbasket = lv_bask_num
    AND idstage = 5;
  DBMS_OUTPUT.PUT_LINE('Date Shipped: '||lv_ship_date);
  DBMS_OUTPUT.PUT_LINE('Shipper: '||lv_shipper_txt);
  DBMS_OUTPUT.PUT_LINE('Shipping #: '||lv_ship_num);
END;
/

/* Assignment 3-2 */

variable g_basket number

begin
  :g_basket := 3;
end;
/

DECLARE
  rec_ship bb_basketstatus%ROWTYPE;
  lv_bask_num bb_basketstatus.idbasket%TYPE := :g_basket;
  
BEGIN
  SELECT *
   INTO rec_ship
   FROM bb_basketstatus
   WHERE idbasket =  lv_bask_num
    AND idstage = 5;
  DBMS_OUTPUT.PUT_LINE('Date Shipped: '||rec_ship.dtstage);
  DBMS_OUTPUT.PUT_LINE('Shipper: '||rec_ship.shipper);
  DBMS_OUTPUT.PUT_LINE('Shipping #: '||rec_ship.shippingnum);
  DBMS_OUTPUT.PUT_LINE('Notes: '||rec_ship.notes);
END;
/

/* Assignment 3-3 */

variable g_shopper number

begin
  :g_shopper := 22;
end;
/

DECLARE
 lv_total_num NUMBER(6,2);
 lv_rating_txt VARCHAR2(4);
 lv_shop_num bb_basket.idshopper%TYPE := :g_shopper;
 
BEGIN
 SELECT SUM(total)
  into lv_total_num /*my add */
  FROM bb_basket
  WHERE idShopper = :g_shopper /* my add */ 
    AND orderplaced = 1
  GROUP BY idshopper;
  IF lv_total_num > 200 THEN
  /* begin my block */ 
    lv_rating_txt := 'HIGH';       
  elsif lv_total_num > 100 then
    lv_rating_txt := 'MID';       
  else
    lv_rating_txt := 'LOW';
  /* end my block */
  END IF; 
   DBMS_OUTPUT.PUT_LINE('Shopper '||:g_shopper||' is rated '||lv_rating_txt);
END;
/

SELECT SUM(total)
  FROM bb_basket
  WHERE idshopper = 22
    AND orderplaced = 1
  GROUP BY idshopper;
  
/* Assignment 3-4 */

variable g_shopper number

begin
  :g_shopper := 22;
end;
/

DECLARE
 lv_total_num NUMBER(6,2);
 lv_rating_txt VARCHAR2(4);
 lv_shop_num bb_basket.idshopper%TYPE := :g_shopper;
BEGIN
 SELECT SUM(total)
  into lv_total_num /*my add */
  FROM bb_basket
  WHERE idshopper = lv_shop_num /* my add */
    AND orderplaced = 1
  GROUP BY idshopper;
  /* begin my block */ 
  case
    when lv_total_num > 200 then
    lv_rating_txt := 'HIGH';     
    when lv_total_num > 100 then
    lv_rating_txt := 'MID';
    else
    lv_rating_txt := 'LOW';      
  end case;
  /* end my block */ 
   DBMS_OUTPUT.PUT_LINE('Shopper '||:g_shopper||' is rated '||lv_rating_txt);
END;
/

SELECT SUM(total)
  FROM bb_basket
  WHERE idshopper = 22
    AND orderplaced = 1
  GROUP BY idshopper;

/* Assignment 3-5 */

variable total_spending number
variable product_id number

begin
  :total_spending := 100;
  :product_id := 4;
end;
/

declare
  running_total number(4) := 0;
  product_cost number(3);
  i number (2) := 0;
  
begin
  select price
    into product_cost
    from bb_product
    where idproduct = :product_id;
  
  while :total_spending > (running_total + product_cost) loop
    running_total := running_total + product_cost;
    i := i + 1;
  end loop;
  
  dbms_output.put_line('you can buy '
    || i || ' widgets at $'
    || product_cost || ' each for $'
    || running_total || ' if you have $'
    || :total_spending || ' to spend.');
    
end;
/

/* Assignment 3-6 */

variable basket1 number
variable basket2 number

begin
  :basket1 := 5;
  :basket2 := 12;
end;
/

declare
  basket_quantity number(2);
  shipping_cost number (4, 2);
  
begin
  select quantity
   into basket_quantity
  from bb_basket
  where idbasket = :basket1; --sub :basket2 for testing
  
  if basket_quantity > 10 then
    shipping_cost := 12.00;
  elsif basket_quantity > 6 then
    shipping_cost := 10.00;
  elsif basket_quantity > 3 then
    shipping_cost := 7.50;
  elsif basket_quantity > 0 then
    shipping_cost := 5.00;
  else
    shipping_cost := 0.00;
  end if;
  
  dbms_output.put_line('Basket '
  || :basket1 -- sub basket2 for testing
  || ' has ' || basket_quantity
  || ' items. Shipping is' || to_char(shipping_cost, '$99.99'));
  
end;
/

/* Assignment 3-7 */

variable idbasket number
 
begin
  :basket2 := 12;
end;
/

declare
  basket bb_basket.idbasket%TYPE;
  sub bb_basket.subtotal%TYPE;
  ship bb_basket.shipping%TYPE;
  tax bb_basket.tax%TYPE;
  total bb_basket.total%TYPE;
    
begin
  select idbasket, subtotal,
        shipping, tax, total
  into basket, sub, ship,
        tax, total
  from bb_basket
  where idbasket = :basket2;
  
  dbms_output.put_line('Basket '
  || basket || ' has a subtotal of'
  || to_char(sub, '$99.99')
  || ', shipping is'
  || to_char(ship, '$99.99')
  || ','  || chr(10)
  || '          tax is'
  || to_char(tax, '$99.99')
  || ', and the total is'
  || to_char(total, '$99.99'));

end;
/
  
/* Assignment 3-8 */

variable idbasket number
 
begin
  :basket2 := 12;
end;
/

declare
  TYPE type_summary IS RECORD (
    basket bb_basket.idbasket%TYPE,
    sub bb_basket.subtotal%TYPE,
    ship bb_basket.shipping%TYPE,
    tax bb_basket.tax%TYPE,
    total bb_basket.total%TYPE);
  rec_basket type_summary;
  
begin
  select idbasket, subtotal,
        shipping, tax, total
  into rec_basket
  from bb_basket
  where idbasket = :basket2;
  
  dbms_output.put_line('Basket '
  || rec_basket.basket || ' has a subtotal of'
  || to_char(rec_basket.sub, '$99.99')
  || ', shipping is'
  || to_char(rec_basket.ship, '$99.99')
  || ','  || chr(10) || '          tax is'
  || to_char(rec_basket.tax, '$99.99')
  || ', and the total is'
  || to_char(rec_basket.total, '$99.99'));

end;
/
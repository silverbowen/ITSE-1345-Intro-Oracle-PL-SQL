/* William Bowen
   ITSE 1345
   Competency 2.3 */
   
set serveroutput on

/* Assignment 3-1 */

variable g_baskett number

begin
  :g_basket := 3;
end;
/

DECLARE
  lv_ship_date bb_basketstatus.dtstage%TYPE;
  lv_shipper_txt bb_basketstatus.shipper%TYPE;
  lv_ship_num bb_basketstatus.shippingnum%TYPE;
  lv_bask_num bb_basketstatus.idbasket%TYPE := 3;
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

begin
  :g_basket := 7;
end;
/

DECLARE
  lv_ship_date bb_basketstatus.dtstage%TYPE;
  lv_shipper_txt bb_basketstatus.shipper%TYPE;
  lv_ship_num bb_basketstatus.shippingnum%TYPE;
  lv_bask_num bb_basketstatus.idbasket%TYPE := 3;
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

begin
  :g_basket := 3;
end;
/

DECLARE
  rec_ship bb_basketstatus%ROWTYPE;
  lv_bask_num bb_basketstatus.idbasket%TYPE := 3;
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
 lv_shop_num bb_basket.idshopper%TYPE;
BEGIN
 SELECT SUM(total)
  into lv_total_num /*my add */
  FROM bb_basket
  WHERE idShopper = :g_shopper /* my add */ 
    AND orderplaced = 1
  GROUP BY idshopper;
  IF lv_total_num > 200 THEN
  /* begin my block */ 
    lvrating_txt := 'HIGH';       
  elsif :lv_total_num > 100 then
    lvrating_txt := 'MID';       
  else
    lvrating_txt := 'LOW';
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

begin
  :g_shopper := 22;
end;
/

DECLARE
 lv_total_num NUMBER(6,2);
 lv_rating_txt VARCHAR2(4);
 lv_shop_num bb_basket.idshopper%TYPE;
BEGIN
 SELECT SUM(total)
  into lv_total_num /*my add */
  FROM bb_basket
  WHERE idShopper = :g_shopper /* my add */ 
    AND orderplaced = 1
  GROUP BY idshopper;
  /* begin my block */ 
  case
    when lv_total_num > 200 then
    lvrating_txt := 'HIGH';     
    when lv_total_num > 100 then
    lvrating_txt := 'MID';
    else
    lvrating_txt := 'LOW';      
  end case;
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

/* Assignment 3-5 */

variable total_spending number
variable product_id number

begin
  :total_spending := 100;
  :product_id := 4;
end;
/

/* Assignment 3-6 */

/* Assignment 3-7 */

/* Assignment 3-8 */
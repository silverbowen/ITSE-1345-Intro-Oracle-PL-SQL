/* William Bowen
   ITSE 1345
   Competency 3.1 */
   
set serveroutput on

/* Assignment 4-1 */

variable g_basket number;

begin
  :g_basket := 6;
end;
/

DECLARE
   CURSOR cur_basket IS
     SELECT bi.idBasket, bi.quantity, p.stock
       FROM bb_basketitem bi INNER JOIN bb_product p
         USING (idProduct)
       WHERE bi.idBasket = 6;
   TYPE type_basket IS RECORD (
     basket bb_basketitem.idBasket%TYPE,
     qty bb_basketitem.quantity%TYPE,
     stock bb_product.stock%TYPE);
   rec_basket type_basket;
   lv_flag_txt CHAR(1) := 'Y';
BEGIN
   OPEN cur_basket;
   LOOP 
     FETCH cur_basket INTO rec_basket;
      EXIT WHEN cur_basket%NOTFOUND;
      IF rec_basket.stock < rec_basket.qty THEN lv_flag_txt := 'N'; END IF;
   END LOOP;
   CLOSE cur_basket;
   IF lv_flag_txt = 'Y' THEN DBMS_OUTPUT.PUT_LINE('All items in stock!'); END IF;
   IF lv_flag_txt = 'N' THEN DBMS_OUTPUT.PUT_LINE('All items NOT in stock!'); END IF;
END;
/

/* Assignment 4-2 */

DECLARE
   CURSOR cur_shopper IS
     SELECT a.idShopper, a.promo,  b.total                          
       FROM bb_shopper a, (SELECT b.idShopper, SUM(bi.quantity*bi.price) total
                            FROM bb_basketitem bi, bb_basket b
                            WHERE bi.idBasket = b.idBasket
                            GROUP BY idShopper) b
        WHERE a.idShopper = b.idShopper
     FOR UPDATE OF a.idShopper NOWAIT;
   lv_promo_txt CHAR(1);
BEGIN
  FOR rec_shopper IN cur_shopper LOOP
   lv_promo_txt := 'X';
   IF rec_shopper.total > 100 THEN 
          lv_promo_txt := 'A';
   END IF;
   IF rec_shopper.total BETWEEN 50 AND 99 THEN 
          lv_promo_txt := 'B';
   END IF;   
   IF lv_promo_txt <> 'X' THEN
     UPDATE bb_shopper
      SET promo = lv_promo_txt
      WHERE CURRENT OF cur_shopper;
   END IF;
  END LOOP;
  COMMIT;
END;
/

select s.idshopper, s.promo, sum(bi.quantity*bi.price)
from bb_shopper s, bb_basket b, bb_basketitem bi
where s.idshopper = b.idshopper
  and b.idbasket = bi.idbasket
group by s.idshopper, s.promo;
/

/* Assignment 4-3 */

UPDATE bb_shopper
  SET promo = NULL;
UPDATE bb_shopper
  SET promo = 'B'
  WHERE idShopper IN (21,23,25);
UPDATE bb_shopper
  SET promo = 'A'
  WHERE idShopper = 22;
COMMIT;
/

 -- removed begin and end statements
UPDATE bb_shopper
  SET promo = NULL
  WHERE promo IS NOT NULL;
commit;
select promo from bb_shopper;
/

/* Assignment 4-4 */

variable g_state char(2)
begin
  :g_state := 'NJ';
end;
/

DECLARE
  lv_tax_num NUMBER(2,2);
BEGIN
 CASE  'NJ' 
  WHEN 'VA' THEN lv_tax_num := .04;
  WHEN 'NC' THEN lv_tax_num := .02;  
  WHEN 'NY' THEN lv_tax_num := .06;  
 END CASE;
 DBMS_OUTPUT.PUT_LINE('tax rate = '||lv_tax_num);
END;
/

 -- solution 
DECLARE
  lv_tax_num NUMBER(2,2);
BEGIN
 CASE  'NJ' 
  WHEN 'VA' THEN lv_tax_num := .04;
  WHEN 'NC' THEN lv_tax_num := .02;  
  WHEN 'NY' THEN lv_tax_num := .06;  
 END CASE;
 DBMS_OUTPUT.PUT_LINE('tax rate = '||lv_tax_num);

exception -- exception handler added
  when case_not_found then
    dbms_output.put_line('No tax.');
  
END;
/

/* Assignment 4-5 */

variable G_SHOPPER number;
begin
  :G_SHOPPER := 99;
end;
/

-- solution
DECLARE
 rec_shopper bb_shopper%ROWTYPE;
BEGIN
 SELECT *
  INTO rec_shopper
  FROM bb_shopper
  WHERE idShopper = :G_SHOPPER;

exception -- exception handler added
  when no_data_found then
    dbms_output.put_line('Invalid shopper id.');

END;
/

/* Assignment 4-6 */

-- solution
-- declare exception
declare
  chk_constraint_violated exception;
  pragma exception_init(chk_constraint_violated, -002290);
  
BEGIN
  INSERT INTO bb_basketitem 
   VALUES (88,8,10.8,21,16,2,3);
   
exception -- exception handler added
  when chk_constraint_violated then
    dbms_output.put_line('Invalid shopper id.');
    
END;
/

/* Assignment 4-7 */

variable G_OLD number;
variable G_NEW number;

begin
  :G_OLD := 30;
  :G_NEW := 4;
end;
/

-- verify that basket id 30 doesn't exist
select idbasket
from bb_basketitem
where idbasket = 30;
/

-- solution
-- declare exception
declare
  idbasket_not_found exception;
  
BEGIN
  UPDATE bb_basketitem
   SET idBasket = :G_NEW
   WHERE idBasket = :G_OLD;
   
  -- raise exception
  if sql%notfound then
    raise idbasket_not_found;
  end if;
  
-- handle exception
exception
  when idbasket_not_found then
    dbms_output.put_line('Invalid original basket id.');
   
END;
/

/* Assignment 4-8 */

--verify math (this will show the raises to be given)
select empno, sal, (.06 * sal) proposed
    from employee
    where job != 'PRESIDENT';
/

declare
  cursor cur_emp is
    select empno, sal
    from employee
    where job != 'PRESIDENT'
    for update nowait;
  -- these are all named variables for ease of updating
  lv_raise number(2, 2) := .06;
  cap number (4) := 2000;
  sal_inc number(7, 2);
  total_inc number(8, 2) := 0; -- accumulator

begin
  -- using cursor for loop for expedience
  for rec_emp in cur_emp loop
    -- calculate potential increase
    sal_inc := (lv_raise * rec_emp.sal);
    -- set it to cap if more than cap
    if (sal_inc > cap) then
      sal_inc := cap;
    end if;
    -- ouput particulars for each employee
    dbms_output.put_line(rec_emp.empno ||
         ' is currently making:         $'
                          || rec_emp.sal);
    dbms_output.put_line(
        'They are eligible for a raise of: $' || sal_inc);
    dbms_output.put_line('This makes their new salary:      $'
                             || (rec_emp.sal + sal_inc));
    dbms_output.put_line('');
    -- if we had a way to get input indicating approval
    -- this would be the place to do that (with an if)
    -- instead, we go ahead and update
    update employee
      set sal = sal + sal_inc
      where current of cur_emp;
    -- here we add the raise amount to the accumulator
    total_inc := total_inc + sal_inc; 
  end loop;
  -- and we display the total raises
  dbms_output.put_line('Total salary increases were:      $'
    || total_inc);
  dbms_output.put_line('');
end;
/
-- verify the changes
select empno, sal from employee where job != 'PRESIDENT';
/

-- cleanup
rollback;
/
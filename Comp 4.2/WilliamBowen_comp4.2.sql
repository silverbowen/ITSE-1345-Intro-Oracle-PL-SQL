/* William Bowen
   ITSE 1345
   Competency 4.2 */

set serveroutput on;
 
/* Assignment 9-1 */

-- Run script to create trigger
CREATE OR REPLACE TRIGGER bb_reorder_trg
   AFTER UPDATE OF stock ON bb_product
   FOR EACH ROW 
DECLARE
  v_onorder_num NUMBER(4);
 BEGIN
  If :NEW.stock <= :NEW.reorder THEN
   SELECT SUM(qty)
    INTO v_onorder_num
    FROM bb_product_request
    WHERE idProduct = :NEW.idProduct
     AND dtRecd IS NULL;
   IF v_onorder_num IS NULL THEN v_onorder_num := 0; END IF;
   IF v_onorder_num = 0 THEN
     INSERT INTO bb_product_request (idRequest, idProduct, dtRequest, qty)
       VALUES (bb_prodreq_seq.NEXTVAL, :NEW.idProduct, SYSDATE, :NEW.reorder);
   END IF;
  END IF;
END;
/

-- Show that sale of one more of product 4
-- should initiate a reorder
select stock, reorder
 from bb_product
 where idProduct = 4;
/

-- Show that 4 is not currently up for reorder
select idproduct, idrequest, dtrequest, qty
 from bb_product_request;
/

-- Set stock equal to reorder number,
-- so trigger will fire
update bb_product
 set stock = 25
 where idProduct = 4;
/

-- Show that trigger fired
select idproduct, idrequest, dtrequest, qty
 from bb_product_request;
/

-- Rollback changes/disable trigger
rollback;
drop trigger bb_reorder_trg;
/ 

/* Assignment 9-2 */

-- create product request
insert into bb_product_request
    (idrequest, idproduct, dtrequest, qty)
  values (3, 5, sysdate, 45);
/

-- Creat trigger to handle updating stock
create or replace trigger bb_reqfill_trg
  after update of dtrecd on bb_product_request
  for each row
 
  begin
   /* update bb_product and set stock equal to
      the new qty (from bb_product_update) plus
      the old stock, where the id equals the
      id referenced by the update that fired 
      the trigger. */
   update bb_product
    set stock = :new.qty + stock
    where idproduct = :new.idproduct;
end;
/

-- show that product 5 is below reorder amount
select stock, reorder
 from bb_product
 where idproduct = 5;
 /
 
-- Show that 5 is currently up for reorder
select idproduct, idrequest, dtrequest, cost, qty
 from bb_product_request;
/

-- Do update and fire trigger
update bb_product_request
 set dtrecd = sysdate, cost = 225
 where idproduct = 5;
 /
 
 -- show that order was fulfilled
select idproduct, idrequest, dtrequest, cost, qty
 from bb_product_request;
/

-- show that trigger fired and stock was updated
select stock, reorder
 from bb_product
 where idproduct = 5;
/

-- Undo all our effort
rollback;
drop trigger bb_reqfill_trg;
/

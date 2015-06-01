/* William Bowen ITSE 1345 Competency 2.1 hands on*/

/* problem 01 */
select distinct idproduct from bb_basketitem order by idproduct;

/* problem 02 */
select b.idbasket, idproduct, p.productname, p.description
  from bb_basketitem b join bb_product p using (idproduct);
  
select b.idbasket, b.idproduct, p.productname, p.description
  from bb_basketitem b, bb_product p
  where b.idproduct = p.idproduct;

/* problem 03 */
select idbasket, idproduct, p.productname, p.description, s.lastname
  from bb_product p join bb_basketitem b using (idproduct)
  join  bb_basket k using (idbasket) join bb_shopper s using (idshopper);
  
select b.idbasket, b.idproduct, p.productname, p.description, s.lastname
  from bb_product p, bb_basketitem b, bb_basket k, bb_shopper s
  where p.idproduct = b.idproduct and b.idbasket = k.idbasket
    and k.idshopper = s.idshopper;
    
/* problem 04 */
select idbasket, idshopper, to_char(dtordered, 'Month DD, YYYY') dtordered
  from bb_basket where dtordered like '%FEB%';
  
/* problem 05 */
select idproduct, sum(quantity) as "TOTAL SOLD"
  from bb_basketitem
  group by idproduct;

/* problem 06*/
select idproduct, sum(quantity) as "TOTAL SOLD"
  from bb_basketitem
  group by idproduct
  having sum(quantity) < 3;
  
/* problem 07*/
select idproduct, productname, price
  from bb_product
  group by idproduct, productname, price
  having price > (select avg(price) from bb_product);
  
/* problem 08*/
create table contacts
  (Con_id number(4) constraint Con_id_pk primary key,
  Company_name varchar2(30) not null,
  Email varchar2(30),
  Last_date date default sysdate,
  Con_cnt number(3) check (con_cnt > 0));
  
/* problem 09 */
insert into contacts
  values (1, 'foo', 'bar@foo.com', sysdate, 123);
insert into contacts
  values (2, 'baz', 'baz@zoom.com', sysdate, 456);
commit;

/* problem 10*/
update contacts
  set email = 'foo@bar.com'
  where Con_id = 1;
select * from contacts;
rollback;
set serveroutput on;
create or replace procedure PROCEDURE_CANCEL_ORDER(
od_id in ofd_order_details.order_details_id%type)
as
var30 varchar(40);
EX_OD_EXCEPTION EXCEPTION;

BEGIN 

EXECUTE IMMEDIATE ('select ofd_order_details.status from ofd_order_details where  upper(ofd_order_details.order_details_id) =  UPPER ('''||od_id||''')') into var30;
if var30 = 'Cancelled' then
RAISE EX_OD_EXCEPTION;
end if;

update ofd_order_details set ofd_order_details.status = 'Cancelled' where ofd_order_details.order_details_id = od_id;
commit;
update ofd_products set ofd_products.product_quantity = ofd_products.product_quantity + (select ofd_order_details.quantity from ofd_order_details where ofd_order_details.order_details_id = od_id)
where ofd_products.product_id = (select ofd_order_details.product_id from ofd_order_details where ofd_order_details.order_details_id = od_id);
commit;

EXCEPTION
when EX_OD_EXCEPTION then
DBMS_OUTPUT.PUT_LINE('This order has already been cancelled');

rollback;
end;

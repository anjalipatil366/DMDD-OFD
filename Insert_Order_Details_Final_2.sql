set serveroutput on;
create or replace PROCEDURE  PROCEDURE_ORDERS_INSERT
(
p_dop in ofd_orders.date_of_purchase%type,
p_c_id in ofd_customer.customer_id%type,
p_ptype in ofd_orders.payment_type%type,
p_qty in ofd_order_details.quantity%type,
p_p_id in ofd_order_details.product_id%type,
p_status in ofd_order_details.status%type)
as 
o_id varchar(40);
od_id varchar(40);
EX_DOP_ISSUE EXCEPTION;
EX_PAYMENT_TYPE EXCEPTION;
EX_QTY_ISSUE EXCEPTION;
--EX_CUSTOMER_ISSUE EXCEPTION;
val20 NUMBER;
val30 NUMBER;
var70 NUMBER;
--val40 varchar(100);
--var71 varchar(40);
--var72 varchar(40);
EX_ID_ISSUE EXCEPTION;
pragma exception_init(EX_ID_ISSUE, -02291); 
--EX_PRD_ISSUE EXCEPTION;

BEGIN

EXECUTE IMMEDIATE ('select count(*) from ofd_orders') into val20;
if val20 = 0 then 
o_id:=concat('O','101');
elsif val20 > 0 then
select order_id into o_id from ofd_orders  where ofd_orders.order_id = (select max(ofd_orders.order_id) from ofd_orders);
o_id := 'O'|| (cast(substr(o_id,2,3) as number) + 2);
end if;

EXECUTE IMMEDIATE ('select count(*) from ofd_order_details') into val30;
if val30 = 0 then 
od_id:=concat('OD','101');
elsif val30 > 0 then
select order_details_id into od_id from ofd_order_details  where ofd_order_details.order_details_id = (select max(ofd_order_details.order_details_id) from ofd_order_details);
od_id := 'OD' || (cast(substr(od_id,3,3) as number) + 1);
end if;


if p_dop > sysdate then 
RAISE EX_DOP_ISSUE;
end if;

if p_ptype not in ('Debit_Card', 'Credit_Card', 'Gift_Card') then 
raise EX_PAYMENT_TYPE;
end if;

EXECUTE IMMEDIATE ('select ofd_products.product_quantity from ofd_products where upper(ofd_products.product_id) = upper('''||p_p_id||''')') into var70;
if var70< p_qty then 
RAISE EX_QTY_ISSUE;
end if;

--EXECUTE IMMEDIATE ('select ofd_customer.customer_id from ofd_customer where upper(ofd_customer.customer_id) = upper('''||p_c_id||''')') into var71;
--if var71 = 0 then 
--RAISE EX_CUS_ISSUE;
--end if;

--EXECUTE IMMEDIATE ('select ofd_products.product_id from ofd_products where upper(ofd_products.product_id) = upper('''||p_p_id||''')') into var72;
--if var72 = '0' then
--RAISE EX_PRD_ISSUE;
--end if;

insert into ofd_orders values (o_id, p_dop, p_c_id, p_ptype);
commit;
insert into ofd_order_details values (od_id, p_qty, p_p_id, o_id, p_status);
commit;
update ofd_products set ofd_products.product_quantity = ofd_products.product_quantity - p_qty where 
ofd_products.product_id = p_p_id;
commit;

EXCEPTION

WHEN EX_DOP_ISSUE then 
DBMS_OUTPUT.PUT_LINE('Date of purchase cannot be greater than todays date');

WHEN EX_PAYMENT_TYPE then
DBMS_OUTPUT.PUT_LINE('Payment type should be one of "Debit_Card", "Credit_Card" or "Gift_Card"');


WHEN EX_QTY_ISSUE then 
DBMS_OUTPUT.PUT_LINE ('Quantity cannot be greater than the available quanity in the inventory');

WHEN EX_ID_ISSUE then 
DBMS_OUTPUT.PUT_LINE ('You have not entered a valid customer ID or product_id');


--WHEN EX_PRD_ISSUE then 
--DBMS_OUTPUT.PUT_LINE ('You have not entered a valid Product ID');



rollback;
end;


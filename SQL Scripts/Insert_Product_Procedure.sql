create or replace PROCEDURE PROCEDURE_ADD_PRODUCTS(
p_name in ofd_products.product_name%type,
p_price in ofd_products.product_price%type,
p_quantity in ofd_products.product_quantity%type,
p_supplier_id in ofd_products.supplier_id%type,
p_category_id in ofd_products.category_id%type)
As
PR_id varchar(40);
EX_P_NAME_NULL EXCEPTION;
EX_P_PRICE_NULL EXCEPTION;
EX_P_QUANTITY_NULL EXCEPTION;
--EX_P_SUPPLIER_ISSUE EXCEPTION;
--EX_P_CATEGORY_ISSUE EXCEPTION;
EX_ID_ISSUE EXCEPTION;
pragma exception_init(EX_ID_ISSUE, -02291);
VAL10 Number;
VAL11 Number;

BEGIN 
execute immediate ('select count(*) from ofd_products') into val10;
if val10=0 then
PR_id := concat('P', '101');
elsif val10 > 0 then 
select product_id into PR_id from ofd_products where product_id = (select max(product_id) from ofd_products);
PR_id := 'P' || (cast(substr(PR_id,2,3) as number) + 1);
end if;

IF length(upper(p_name)) is null then
raise EX_P_NAME_NULL;
end if;

IF length(p_price) is null then
raise EX_P_PRICE_NULL;
end if;

IF length(p_quantity) is null then
raise EX_P_QUANTITY_NULL;
end if;


insert into ofd_products values (PR_id, p_name, p_price, p_quantity, p_supplier_id, p_category_id);
commit;

EXCEPTION
when EX_P_NAME_NULL then
DBMS_OUTPUT.PUT_LINE('Product name cannot be null, please enter a product name to enter the new record');

when EX_P_PRICE_NULL then 
DBMS_OUTPUT.PUT_LINE('Product price cannot be null, please enter the product price to enter the new record');

when EX_P_QUANTITY_NULL then 
DBMS_OUTPUT.PUT_LINE('Product quantity cannot be null, please provide a valid quantity for the product( do not enter negative values)');

when EX_ID_ISSUE then
DBMS_OUTPUT.PUT_LINE('Please provide a valid product ID and category ID');

rollback;
end;
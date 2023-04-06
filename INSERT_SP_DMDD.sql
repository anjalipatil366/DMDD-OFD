create table bp_customer (
customer_id varchar(10) constraint cpk PRIMARY KEY, 
first_name varchar(40) NOT NULL, 
last_name varchar(40),
email varchar(100) unique,
ssn number(10), 
city varchar(40)
);

insert into BP_customer(customer_id ,first_name ,last_name ,email, ssn, city)
    select 'C101', 'John', 'Cena', 'cenajohn@gmail.com', 4567, 'Boston' FROM DUAL UNION ALL
    select 'C102', 'Steve', 'Austin', 'steaustin@yahoo.com', 5346, 'Austin' FROM DUAL UNION ALL
    select 'C103', 'Alberto', 'Rio', 'rioalberto@rediff.com', 2648, 'New York' FROM DUAL UNION ALL
    select 'C104', 'Roman', 'Reigns', 'rreigns@yahoo.com', 5545, 'Boston' FROM DUAL UNION ALL
    select 'C105', 'Seth', 'Rollins', 'rollrockseth@yahoo.com', 4634, 'Cleveland' FROM DUAL UNION ALL
    select 'C106', 'Brock', 'Lesnar', 'lesnarbrock@gmail.com', 6663, 'Portland' FROM DUAL UNION ALL
    select 'C107', 'Stephanie', 'Mcmahon', 'mcmahonstep@rediff.com', 6646, 'Cleveland' FROM DUAL UNION ALL
    select 'C108', 'Charlotte', 'Brown', 'chaiflair1@gmail.com', 4634, 'Boston' FROM DUAL UNION ALL
    select 'C109', 'Becky', 'Lynch', 'lynyyy@yahoo.com', 6585, 'Boston' FROM DUAL UNION ALL
    select 'C110', 'David', 'Warner', 'warner31@outlook.com', 8436, 'Dallas' FROM DUAL;
    /
set serveroutput on;

-------------------------------- INSERT CUSTOMER STORED PROCEDURE ---------------------------------------

create or replace PROCEDURE PROCEDURE_ADD_CUSTOMER(
f_name in BP_customer.first_name%type,
l_name in BP_customer.last_name%type,
email_id in BP_customer.email%type,
ssn_id in BP_customer.ssn%type,
city_id in BP_customer.city%type)
As
C_id varchar(40);
EX_F_NAME_NULL EXCEPTION;
EX_EMAIL_ISSUE EXCEPTION;
EX_SSN_LENGTH EXCEPTION;
VAL1 Number;
VAL2 Number;

BEGIN 
execute immediate ('select count(*) from BP_Customer') into val1;
if val1=0 then
c_id := concat('C', '101');
elsif val1 > 0 then 
select customer_id into c_id from BP_customer where customer_id = (select max(customer_id) from BP_customer);
C_id := 'C' || (cast(substr(c_id,2,3) as number) + 1);
end if;

IF length(upper(f_name)) is null then
raise EX_F_NAME_NULL;
end if;

EXECUTE IMMEDIATE ('select count(*) from BP_customer where UPPER(email) = UPPER('''||EMAIL_ID||''') ') into val2;

if val2>0 then
raise ex_email_issue;
end if;

if length(ssn_id) > 10 then 
raise EX_SSN_LENGTH;
end if;

insert into BP_customer values (C_id, F_name, l_name, email_id, ssn_id, city_id);
--DMBMS_OUTPUT.PUT_LINE('Customer record  with the following details has been added to the customers table:' || ''' First Name: 
commit;

EXCEPTION
when EX_F_NAME_NULL then
DBMS_OUTPUT.PUT_LINE('First name cannot be null');

when EX_EMAIL_ISSUE then 
DBMS_OUTPUT.PUT_LINE('Customer account with this email already exists. Please provide a unique email id');

when EX_SSN_LENGTH then 
DBMS_OUTPUT.PUT_LINE('SSN greater than 10 digits. Please enter a valid SSN');

rollback;
end;

-------------------------------------------------------------------------------------------------------

EXECUTE PROCEDURE_ADD_CUSTOMER ('kEN', 'koss', 'kkoss@gmail.com', 123456789000, 'Boston');

select * from BP_customer;

create table BP_supplier (
supplier_id varchar(10) PRIMARY KEY,
supplier_name varchar(50) NOT NULL, 
city varchar(50),
phone number(10) NOT NULL
)

insert into BP_supplier (supplier_id ,supplier_name,city ,phone)
    select 'S101', 'home goods', 'Boston', 8574522785 from dual union all
    select 'S102', 'Wells furniture','Seattle',8887772222 from dual union all
    select 'S103', 'May Works','Portland',8887773333 from dual union all
    select 'S104', 'Kirchen Aid','Austin',8887774444 from dual union all
    select 'S105', 'Simple Modern ','Fermont',8887775555 from dual;

select * from BP_supplier;

-------------------------------- INSERT SUPPLIER STORED PROCEDURE ---------------------------------------


create or replace PROCEDURE PROCEDURE_ADD_SUPPLIER(
s_name in BP_supplier.supplier_name%type,
city_id in BP_supplier.city%type,
s_phone in BP_supplier.phone%type)
As
S_id varchar(40);
EX_S_NAME_NULL EXCEPTION;
EX_S_PHONE_NULL EXCEPTION;
EX_S_PHONE_ISSUE EXCEPTION;

VAL3 Number;
VAL4 Number;

BEGIN 
execute immediate ('select count(*) from BP_supplier') into val3;
if val3=0 then
S_id := concat('S', '101');
elsif val3 > 0 then 
select supplier_id into S_id from BP_supplier where supplier_id = (select max(supplier_id) from BP_supplier);
S_id := 'S' || (cast(substr(S_id,2,3) as number) + 1);
end if;

IF length(upper(s_name)) is null then
raise EX_S_NAME_NULL;
end if;

IF length(s_phone) is null then
raise EX_S_PHONE_NULL;
end if;

IF length(s_phone) > 10 then
raise EX_S_PHONE_ISSUE;
end if;


insert into BP_supplier values (S_id, S_name, city_id, s_phone);
commit;

EXCEPTION
when EX_S_NAME_NULL then
DBMS_OUTPUT.PUT_LINE('Supplier name cannot be null, please provide a supplier name');

when EX_S_PHONE_NULL then 
DBMS_OUTPUT.PUT_LINE('Phone nhumber cannot be null, please provide a phone number');

when EX_S_PHONE_ISSUE then 
DBMS_OUTPUT.PUT_LINE('Phone number cannot be greater then 10 digits. Please enter a valid phone number');

rollback;
end;

---------------------------------------------------------------------------------------

EXECUTE PROCEDURE_ADD_SUPPLIER( '', 'TEST CITY 1', 12345634);

SELECT * FROM BP_SUPPLIER;

create table BP_category (
category_id varchar(10) PRIMARY KEY, 
category_name varchar(50) DEFAULT 'General'
)

insert into BP_category (category_id, category_name)
    select 'CT101', 'living room' from dual union all
    select 'CT102', 'Organization' from dual union all
    select 'CT103', ' Bedding' from dual union all
    select 'CT104', 'Cleaning Appliances' from dual union all
    select 'CT105', 'Kitchen Appliances' from dual union all
    select 'CT106', 'Home Appliances' from dual;

select * from BP_category;


-------------------------------- INSERT CATEGORY STORED PROCEDURE ---------------------------------------


create or replace procedure PROCEDURE_ADD_CATEGORY(
cat_name in BP_category.category_name%type)
as 
cat_id varchar(40);
--cat_name varchar(40);
EX_CAT_NULL EXCEPTION;
val5 Number;

BEGIN
execute immediate ('select count(*) from BP_category') into val5;
if val5=0 then
cat_id := concat('CT', '101');
elsif val5 > 0 then 
select category_id into cat_id from BP_category where category_id = (select max(category_id) from BP_category);
cat_id := 'CT' || (cast(substr(cat_id,3,3) as number) + 1);
end if;

if length(cat_name) is null then
raise EX_CAT_NULL;
end if;

insert into BP_category values (cat_id, cat_name);
commit; 

EXCEPTION
when EX_CAT_NULL then 
DBMS_OUTPUT.PUT_LINE('You have not provided a category name. If you do not wish to provide a category name, please provide "General" as the category name eg: EXECUTE PROCEDURE_ADD_CATEGORY (General)');

rollback;
end;

-------------------------------------------------------------------------------------------

EXECUTE PROCEDURE_ADD_CATEGORY('TEST_CAT');

select * from BP_category;



-----------------------------------------------------------

create table BP_products(
product_id varchar(10) PRIMARY KEY,
product_name varchar(50) NOT NULL, 
product_price number(10, 2) NOT NULL, 
product_quantity number(10) NOT NULL, 
supplier_id varchar(10) REFERENCES BP_supplier(supplier_id),
category_id varchar(10) REFERENCES BP_category(category_id)
)

insert into BP_products (PRODUCT_ID, PRODUCT_NAME, PRODUCT_PRICE, PRODUCT_QUANTITY, SUPPLIER_ID, CATEGORY_ID)
    select 'P101', 'Upholstered Sofa', 885.99, 50, 'S101', 'CT101' FROM DUAL UNION ALL
    select 'P102', 'Futon', 437.99, 50, 'S101', 'CT101' FROM DUAL UNION ALL 
    select 'P103', 'Coffee Table', 253.99, 40, 'S101', 'CT101' FROM DUAL UNION ALL 
    select 'P104', 'Bookcase', 178.99, 40, 'S101', 'CT102' FROM DUAL UNION ALL 
    select 'P105', '3 Drawer Cabinet', 124.99, 25, 'S101', 'CT102' FROM DUAL UNION ALL 
    select 'P106', 'Queen Mattress', 160.99, 50, 'S102', 'CT103' FROM DUAL UNION ALL
    select 'P107', 'Twin Mattress', 120.99, 80, 'S102', 'CT103' FROM DUAL;
    
    
select * from BP_products;


------------------------------------------ INSERT PRODUCT STORED PROCEDURE ------------------------------------

create or replace PROCEDURE PROCEDURE_ADD_PRODUCTS(
p_name in BP_products.product_name%type,
p_price in BP_products.product_price%type,
p_quantity in BP_products.product_quantity%type,
p_supplier_id in BP_products.supplier_id%type,
p_category_id in BP_products.category_id%type)
As
PR_id varchar(40);
EX_P_NAME_NULL EXCEPTION;
EX_P_PRICE_NULL EXCEPTION;
EX_P_QUANTITY_NULL EXCEPTION;
EX_P_SUPPLIER_ISSUE EXCEPTION;
EX_P_CATEGORY_ISSUE EXCEPTION;
VAL10 Number;
VAL11 Number;

BEGIN 
execute immediate ('select count(*) from BP_products') into val10;
if val10=0 then
PR_id := concat('P', '101');
elsif val10 > 0 then 
select product_id into PR_id from BP_products where product_id = (select max(product_id) from BP_products);
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


if p_supplier_id not like 'S%' then 
RAISE EX_P_SUPPLIER_ISSUE;
end if;

if p_category_id not like 'CT%' then 
RAISE EX_P_CATEGORY_ISSUE;
end if;

insert into BP_products values (PR_id, p_name, p_price, p_quantity, p_supplier_id, p_category_id);
commit;

EXCEPTION
when EX_P_NAME_NULL then
DBMS_OUTPUT.PUT_LINE('Product name cannot be null, please enter a product name to enter the new record');

when EX_P_PRICE_NULL then 
DBMS_OUTPUT.PUT_LINE('Product price cannot be null, please enter the product price to enter the new record');

when EX_P_QUANTITY_NULL then 
DBMS_OUTPUT.PUT_LINE('Product quantity cannot be null, please provide a valid quantity for the product( do not enter negative values)');

when EX_P_SUPPLIER_ISSUE then 
DBMS_OUTPUT.PUT_LINE('provided supplier ID does not match with the suppliers we have on file. Please provide a valid supplier ID beginning with "S"');

when EX_P_CATEGORY_ISSUE then 
DBMS_OUTPUT.PUT_LINE('provided category ID does not match with the categories we have on file. Please provide a valid category ID beginning with "CT"');

rollback;
end;


EXECUTE PROCEDURE_ADD_PRODUCTS('TEST', 100.99, 98, 'S101', 'CT101');

select * from BP_products;


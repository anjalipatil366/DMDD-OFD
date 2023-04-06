create table supplier_proc (
supplier_id varchar(10) PRIMARY KEY,
supplier_name varchar(50) NOT NULL, 
city varchar(50),
phone number(10) NOT NULL
)
/
create table category_proc (
category_id varchar(10) PRIMARY KEY, 
category_name varchar(50) DEFAULT 'General'
)
/
create table Products_PROC(
product_id varchar(10) PRIMARY KEY,
product_name varchar(50) NOT NULL, 
product_price number(10, 2) NOT NULL, 
product_quantity number(10) NOT NULL, 
supplier_id varchar(10) REFERENCES supplier_proc(supplier_id),
category_id varchar(10) REFERENCES category_proc(category_id)
);
/
create table customer_proc (
customer_id varchar(10) constraint cpk PRIMARY KEY, 
first_name varchar(40) NOT NULL, 
last_name varchar(40),
email varchar(100) unique,
ssn number(10), 
city varchar(40)
)
/
create table orders_proc(
order_id varchar(10) constraint opk PRIMARY KEY, 
date_of_purchase DATE DEFAULT SYSDATE, 
customer_id varchar(10) references customer_proc(customer_id),
payment_type varchar(40) CHECK(payment_type in ('Debit_Card', 'Credit_Card','Gift_Card'))
)
/

create table order_details_proc (
order_details_id VARCHAR(10) constraint odpk PRIMARY KEY,
quantity number(10) NOT NULL,
product_id varchar(10) REFERENCES products_proc(product_id),
order_id varchar(10) REFERENCES orders_proc(order_id),
status varchar(40),
constraint cst CHECK(status in ('Completed', 'Cancelled', 'Confirmed')))
/

insert into supplier_proc (supplier_id ,supplier_name,city ,phone)
    select 'S101', 'home goods', 'Boston', 8574522785 from dual union all
    select 'S102', 'Wells furniture','Seattle',8887772222 from dual union all
    select 'S103', 'May Works','Portland',8887773333 from dual union all
    select 'S104', 'Kirchen Aid','Austin',8887774444 from dual union all
    select 'S105', 'Simple Modern ','Fermont',8887775555 from dual;



insert into category_proc (category_id, category_name)
    select 'CT101', 'living room' from dual union all
    select 'CT102', 'Organization' from dual union all
    select 'CT103', ' Bedding' from dual union all
    select 'CT104', 'Cleaning Appliances' from dual union all
    select 'CT105', 'Kitchen Appliances' from dual union all
    select 'CT106', 'Home Appliances' from dual;



insert into Products_PROC(PRODUCT_ID, PRODUCT_NAME, PRODUCT_PRICE, PRODUCT_QUANTITY, SUPPLIER_ID, CATEGORY_ID)
    select 'P101', 'Upholstered Sofa', 885.99, 50, 'S102', 'CT102' FROM DUAL UNION ALL
    select 'P102', 'Futon', 437.99, 50, 'S102', 'CT102' FROM DUAL UNION ALL 
    select 'P103', 'Coffee Table', 253.99, 40, 'S102', 'CT104' FROM DUAL UNION ALL 
    select 'P104', 'Bookcase', 178.99, 40, 'S102', 'CT106' FROM DUAL UNION ALL 
    select 'P105', '3 Drawer Cabinet', 124.99, 25, 'S102', 'CT105' FROM DUAL;
    
    
insert into orders_proc(order_id ,date_of_purchase ,customer_id ,payment_type)
    select 'O101','02/April/2023', 'C101', 'Credit_Card' FROM DUAL UNION ALL
    select 'O102','28/January/2023', 'C101','Credit_Card' FROM DUAL UNION ALL
    select 'O103','02/February/2023', 'C101','Credit_Card' FROM DUAL UNION ALL
    select 'O104','03/January/2023', 'C102','Credit_Card' FROM DUAL UNION ALL
    select 'O105','02/February/2023', 'C102','Credit_Card' FROM DUAL UNION ALL
    select 'O106','28/February/2023', 'C102','Credit_Card' FROM DUAL ;
    
insert into order_details_proc(order_details_id ,quantity ,product_id ,order_id,status)
    select 'OD102',2, 'P102','O101','Completed' FROM DUAL UNION ALL
    select 'OD103',2, 'P103','O102','Completed' FROM DUAL UNION ALL
    select 'OD104',2, 'P104','O103','Cancelled' FROM DUAL UNION ALL
    select 'OD105',2, 'P107','O103','Cancelled' FROM DUAL UNION ALL
    select 'OD106',1, 'P106','O103','Cancelled' FROM DUAL UNION ALL
    
SELECT * from Products_PROC;


CREATE OR REPLACE PROCEDURE update_product (
    p_id IN OUT VARCHAR2,
    p_name IN VARCHAR2,
    p_price IN NUMBER,
    p_quantity IN NUMBER,
    p_supplier_id IN OUT VARCHAR2,
    p_category_id IN OUT VARCHAR2
)
AS
    p_name_camel VARCHAR2(100);
BEGIN
    -- Check if p_id starts with "p"
    IF (p_id NOT LIKE 'P%') THEN
        RAISE_APPLICATION_ERROR(-20001, 'Product ID should start with "P".');
    END IF;
    
    -- Check if p_supplier_id starts with "S"
    IF (p_supplier_id NOT LIKE 'S%') THEN
        RAISE_APPLICATION_ERROR(-20002, 'Supplier ID should start with "S".');
    END IF;
    
    -- Check if p_category_id starts with "CT"
    IF (p_category_id NOT LIKE 'CT%') THEN
        RAISE_APPLICATION_ERROR(-20003, 'Category ID should start with "CT".');
    END IF;
    
   -- Convert p_name to camel case
    p_name_camel := INITCAP(p_name);
    
    -- Check if quantity and price are greater than or equal to zero
    IF (p_quantity < 0) THEN
        RAISE_APPLICATION_ERROR(-20004, 'Quantity cannot be less than zero.');
    END IF;
    
    IF (p_price < 0) THEN
        RAISE_APPLICATION_ERROR(-20005, 'Price cannot be less than zero.');
    END IF;
    
    -- Update the product information
    UPDATE Products_PROC
    SET 
        product_name = p_name_camel,
        product_price = p_price,
        product_quantity = p_quantity,
        supplier_id = p_supplier_id,
        category_id = p_category_id
    WHERE product_id = p_id;
    
    COMMIT;
END;
/


DECLARE
    v_product_id VARCHAR2(10):= 'P101';
    v_supplier_id VARCHAR2(10) := 'S102';
    v_category_id VARCHAR2(10) := 'CT104';
BEGIN
    UPDATE_PRODUCT(
        p_id => v_product_id,
        p_name => 'NAME PRODCUT',
        p_price => 9.99,
        p_quantity => 50,
        p_supplier_id => v_supplier_id,
        p_category_id => v_category_id
    );
    
    DBMS_OUTPUT.PUT_LINE('Product ID: ' || v_product_id);
END;
/

select * from Products_PROC;
/

CREATE OR REPLACE PROCEDURE update_supplier (
    s_id IN OUT VARCHAR2,
    s_name IN VARCHAR2,
    s_city IN VARCHAR2,
    s_phone IN NUMBER
)
AS
    v_name_camel_case VARCHAR2(100);
    v_city_camel_case VARCHAR2(100);
BEGIN
    -- Check if p_phone is not null and has 10 digits
    IF (s_phone IS NULL OR LENGTH(TRIM(TO_CHAR(s_phone))) != 10) THEN
        RAISE_APPLICATION_ERROR(-20002, 'Phone number must have 10 digits.');
    END IF;
    
    -- Check if p_id starts with "S"
    IF (s_id NOT LIKE 'S%') THEN
        RAISE_APPLICATION_ERROR(-20001, 'Supplier ID should start with "S".');
    END IF;
    
    -- Convert supplier_name and city to camel case
    --SELECT INITCAP(REPLACE(p_name, ' ', '')) INTO v_name_camel_case FROM dual;
    --SELECT INITCAP(REPLACE(p_city, ' ', '')) INTO v_city_camel_case FROM dual;
    
     
   -- Convert p_name to camel case
    v_name_camel_case := INITCAP(s_name);
    v_city_camel_case := INITCAP(s_city);
    
    -- Update the supplier
    UPDATE supplier_proc
    SET 
        supplier_name = v_name_camel_case,
        city = v_city_camel_case,
        phone = s_phone
    WHERE supplier_id = s_id;
    
    -- If no row is updated, insert a new supplier
    IF SQL%ROWCOUNT = 0 THEN
        INSERT INTO supplier_proc (supplier_id, supplier_name, city, phone)
        VALUES (s_id, v_name_camel_case, v_city_camel_case, s_phone);
    END IF;
    
    COMMIT;
END;
/

SELECT * FROM supplier_proc;
/



DECLARE
    supplier_id VARCHAR2(10) := 'S101';
    supplier_name VARCHAR2(100) := 'new supplier name';
    city VARCHAR2(50) := 'New York';
    phone NUMBER := 1231234123 ;

BEGIN
    update_supplier(s_id => supplier_id, s_name => supplier_name, s_city => city, s_phone => phone);
    COMMIT;
END;
/


CREATE OR REPLACE PROCEDURE update_category (
    p_category_id IN VARCHAR2,
    p_category_name IN VARCHAR2
)
AS
    v_category_name VARCHAR2(100);
BEGIN
    -- Check if category_id starts with 'CT'
    IF NOT REGEXP_LIKE(p_category_id, '^CT') THEN
        RAISE_APPLICATION_ERROR(-20001, 'Category ID should start with "CT".');
    END IF;

    -- Convert category_name to camel case
    v_category_name := INITCAP(p_category_name);

    -- Update the record in the table
    UPDATE category_proc
    SET category_name = v_category_name
    WHERE category_id = p_category_id;
    
    DBMS_OUTPUT.PUT_LINE('Record updated successfully.');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20002, 'Category ID not found.');
    WHEN OTHERS THEN
        RAISE;
END;
/

DECLARE
    category_id VARCHAR2(10) := 'CT102';
    category_name VARCHAR2(100) := 'new test category';
BEGIN
    update_category(p_category_id => category_id, p_category_name => category_name);
    COMMIT;
END;
/

select * from category_proc;


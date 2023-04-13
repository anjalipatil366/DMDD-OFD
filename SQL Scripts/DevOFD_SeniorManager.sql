show user; 

---select * from user_tables;

------------------------------------Clean Up Code for all the Tables of database

PURGE Recyclebin;
SET SERVEROUTPUT ON;
declare
Is_true number;
begin
Select count (*)
INTO Is_true
From USER_TABLES WHERE TABLE_NAME = 'OFD_ORDER_DETAILS';
IF Is_true >0
THEN
EXECUTE IMMEDIATE 'DROP TABLE OFD_ORDER_DETAILS';
END IF;
END;
/
declare
Is_true number;
begin
Select count (*)
INTO Is_true
From USER_TABLES WHERE TABLE_NAME = 'OFD_ORDERS';
IF Is_true >0
THEN
EXECUTE IMMEDIATE 'DROP TABLE OFD_ORDERS';
END IF;
END;
/
declare
Is_true number;
begin
Select count (*)
INTO Is_true
From USER_TABLES WHERE TABLE_NAME = 'OFD_CUSTOMER';
IF Is_true >0
THEN
EXECUTE IMMEDIATE 'DROP TABLE OFD_CUSTOMER';
END IF;
END;
/

declare
Is_true number;
begin
Select count (*)
INTO Is_true
From USER_TABLES WHERE TABLE_NAME = 'OFD_PRODUCTS';
IF Is_true >0
THEN
EXECUTE IMMEDIATE 'DROP TABLE OFD_PRODUCTS';
END IF;
END;
/
declare
Is_true number;
begin
Select count (*)
INTO Is_true
From USER_TABLES WHERE TABLE_NAME = 'OFD_SUPPLIER';
IF Is_true >0
THEN
EXECUTE IMMEDIATE 'DROP TABLE OFD_SUPPLIER';
END IF;
END;
/
declare
Is_true number;
begin
Select count (*)
INTO Is_true
From USER_TABLES WHERE TABLE_NAME = 'OFD_CATEGORY';
IF Is_true >0
THEN
EXECUTE IMMEDIATE 'DROP TABLE OFD_CATEGORY';
END IF;
END;
/

------------------------------------------------------------------TABLES CREATED

create table ofd_supplier (
supplier_id varchar(10) PRIMARY KEY,
supplier_name varchar(50) NOT NULL, 
city varchar(50),
phone number(10) NOT NULL
)
/
create table ofd_category (
category_id varchar(10) PRIMARY KEY, 
category_name varchar(50) DEFAULT 'General'
)
/
create table ofd_products(
product_id varchar(10) PRIMARY KEY,
product_name varchar(50) NOT NULL, 
product_price number(10, 2) NOT NULL, 
product_quantity number(10) NOT NULL, 
supplier_id varchar(10) REFERENCES ofd_supplier(supplier_id),
category_id varchar(10) REFERENCES ofd_category(category_id)
)
/
create table ofd_customer (
customer_id varchar(10) constraint cpk PRIMARY KEY, 
first_name varchar(40) NOT NULL, 
last_name varchar(40),
email varchar(100) unique,
ssn number(10), 
city varchar(40)
)
/
create table ofd_orders(
order_id varchar(10) constraint opk PRIMARY KEY, 
date_of_purchase DATE DEFAULT SYSDATE, 
customer_id varchar(10) references ofd_customer(customer_id),
payment_type varchar(40) CHECK(payment_type in ('Debit_Card', 'Credit_Card','Gift_Card'))
)
/

create table ofd_order_details (
order_details_id VARCHAR(10) constraint odpk PRIMARY KEY,
quantity number(10) NOT NULL,
product_id varchar(10) REFERENCES ofd_products(product_id),
order_id varchar(10) REFERENCES ofd_orders(order_id),
status varchar(40),
constraint cst CHECK(status in ('Completed', 'Cancelled', 'Confirmed')))
/

------------------------------Grant permission to read and write in the database


---Senior Manager 

---Customer User Permission 

---Table Access

grant select on ofd_supplier to ofd_supplier; 
grant select on ofd_products to ofd_supplier; 
grant select on ofd_category to ofd_supplier; 
 
---Procedure Access

---grant execute on update_supplier to ofd_supplier;

---Customer User Permission 

---Table Access

grant select on ofd_customer to ofd_customer; 
grant select on ofd_orders to ofd_customer;
grant select on ofd_order_details to ofd_customer; 

---Procedure Access

---grant execute on generate_bill to ofd_customer;
---grant execute on update_customer to ofd_supplier;


-------------------------------------------------------------------VIEWS CREATED 

---Top_customers: This view provides a list of the top customers based on their total order value. 

create or replace view ofd_top_customers as
select ROW_NUMBER() over (order by sum(od.quantity * p.product_price) desc) as rownumber, 
c.customer_id, c.first_name, c.last_name, sum(od.quantity * p.product_price) as total_value,
count(distinct o.order_id) as total_orders
from ofd_orders o
join ofd_order_details od on o.order_id = od.order_id
join ofd_customer c on o.customer_id = c.customer_id
join ofd_products p on p.product_id = od.product_id
group by c.customer_id, c.first_name, c.last_name
order by total_value desc;

---grant select on ofd_top_customers to senior_manager; 

---Orders_summary: This view aggregates information from the order and order_details tables to provide a summary of all orders and their associated products.

create or replace view ofd_orders_summary as 
select o.order_id, o.date_of_purchase, c.first_name, c.last_name, p.product_name, od.quantity, (od.quantity * p.product_price) as subtotal
from ofd_orders o
join ofd_customer c on o.customer_id = c.customer_id
join ofd_order_details od on o.order_id = od.order_id
join ofd_products p on od.product_id = p.product_id;


---Out_of_stock_products: This view lists all products that are currently out of stock.  

create or replace view ofd_out_of_stock_products as 
select * from (select p.product_id, p.product_name, s.supplier_name, ct.category_name, p.product_quantity as unit_in_stock
from ofd_products p 
join ofd_supplier s on p.supplier_id = s.supplier_id
join ofd_category ct on p.category_id = ct.category_id)
where unit_in_stock = 0;


---Average_Order_Value: This view provides the average order value over the last week

create or replace view ofd_avg_order_value_last_week as 
select p.product_name, avg(od.quantity * p.product_price) as avg_order_value
from ofd_orders o 
join ofd_order_details od on o.order_id = od.order_id
join ofd_products p on od.product_id = p.product_id
where o.date_of_purchase >= trunc(sysdate) - 7
group by p.product_name;


---Product_sales_by_supplier: This view shows the total sales for each supplier in the inventory, sorted by descending order of sales volume.

create or replace view ofd_product_sales_by_supplier as
select s.supplier_name, SUM(od.quantity) as total_quantity, SUM(od.quantity * p.product_price) as total_revenue
from ofd_supplier s
join ofd_products p on s.supplier_id = p.supplier_id
join ofd_order_details od on p.product_id = od.product_id
group by s.supplier_name
order by total_revenue desc;
 

---Sales_by_payment_type: This view show the total revenue generated by each payment method.

create or replace view ofd_sales_by_payment_type as
select o.payment_type, SUM(od.quantity * p.product_price) as total_revenue
from ofd_orders o 
join ofd_order_details od ON o.order_id = od.order_id
join ofd_products p on od.product_id = p.product_id
group by  o.payment_type
order by total_revenue desc;


---------------------------------------------------Insert data in all the tables


insert into ofd_supplier (supplier_id ,supplier_name,city ,phone)
    select 'S101', 'home goods', 'Boston', 8574522785 from dual union all
    select 'S102', 'Wells furniture','Seattle',8887772222 from dual union all
    select 'S103', 'May Works','Portland',8887773333 from dual union all
    select 'S104', 'Kirchen Aid','Austin',8887774444 from dual union all
    select 'S105', 'Simple Modern ','Fermont',8887775555 from dual;

select * from ofd_supplier;

insert into ofd_category (category_id, category_name)
    select 'CT101', 'living room' from dual union all
    select 'CT102', 'Organization' from dual union all
    select 'CT103', ' Bedding' from dual union all
    select 'CT104', 'Cleaning Appliances' from dual union all
    select 'CT105', 'Kitchen Appliances' from dual union all
    select 'CT106', 'Home Appliances' from dual;
    
select * from ofd_category;

insert into ofd_products (PRODUCT_ID, PRODUCT_NAME, PRODUCT_PRICE, PRODUCT_QUANTITY, SUPPLIER_ID, CATEGORY_ID)
    select 'P101', 'Upholstered Sofa', 885.99, 50, 'S101', 'CT101' FROM DUAL UNION ALL
    select 'P102', 'Futon', 437.99, 50, 'S101', 'CT101' FROM DUAL UNION ALL 
    select 'P103', 'Coffee Table', 253.99, 40, 'S101', 'CT101' FROM DUAL UNION ALL 
    select 'P104', 'Bookcase', 178.99, 40, 'S101', 'CT102' FROM DUAL UNION ALL 
    select 'P105', '3 Drawer Cabinet', 124.99, 25, 'S101', 'CT102' FROM DUAL UNION ALL 
    select 'P106', 'Queen Mattress', 160.99, 50, 'S102', 'CT103' FROM DUAL UNION ALL
    select 'P107', 'Twin Mattress', 120.99, 80, 'S102', 'CT103' FROM DUAL UNION ALL
    select 'P108', 'Comforter', 45.99, 100, 'S102', 'CT103' FROM DUAL UNION ALL
    select 'P109', 'Bedsheet', 21.89, 0, 'S102', 'CT103' FROM DUAL UNION ALL
    select 'P110', 'Quilt', 21.89, 4, 'S102', 'CT103' FROM DUAL UNION ALL
    select 'P111', 'Upright Vacuum Cleaner', 90.79, 50, 'S103', 'CT104' FROM DUAL UNION ALL
    select 'P112', 'Stick Vacuum Cleaner', 65.49, 60, 'S103', 'CT104' FROM DUAL UNION ALL
    select 'P113', 'Robotic vacuum', 108.99, 120, 'S103', 'CT104' FROM DUAL UNION ALL
    select 'P114', 'Steam Cleaner', 45.49, 0, 'S103', 'CT104' FROM DUAL UNION ALL
    select 'P115', 'Steam Mop', 79.49, 55, 'S103', 'CT104' FROM DUAL UNION ALL
    select 'P116', 'Microwave Oven', 119.99, 80, 'S104', 'CT105' FROM DUAL UNION ALL
    select 'P117', 'Food Processor', 45.45, 60, 'S104', 'CT105' FROM DUAL UNION ALL
    select 'P118', 'Air Fryer', 68.99, 90, 'S104', 'CT105' FROM DUAL UNION ALL
    select 'P119', 'Home coffee machine', 105.89, 100, 'S104', 'CT105' FROM DUAL UNION ALL
    select 'P120', 'Toaster', 20.49, 60, 'S104', 'CT105' FROM DUAL UNION ALL
    select 'P121', 'Dishwasher', 464.99, 4, 'S105', 'CT106' FROM DUAL UNION ALL
    select 'P122', 'Refrigerator', 650.89, 4, 'S105', 'CT106' FROM DUAL UNION ALL
    select 'P123', 'Mini Refrigerator', 324.49, 4, 'S105', 'CT106' FROM DUAL UNION ALL
    select 'P124', 'Range Hood', 324.49, 11, 'S105', 'CT106' FROM DUAL UNION ALL
    select 'P125', 'Wine and Beverage Refrigerator', 227.99, 3, 'S105', 'CT106' FROM DUAL;

select * from ofd_products;

insert into ofd_customer(customer_id ,first_name ,last_name ,email, ssn, city)
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

select * from ofd_customer;

insert into ofd_orders(order_id ,date_of_purchase ,customer_id ,payment_type)
    select 'O101','02/April/2023', 'C101', 'Credit_Card' FROM DUAL UNION ALL
    select 'O102','28/January/2023', 'C101','Credit_Card' FROM DUAL UNION ALL
    select 'O103','02/February/2023', 'C101','Credit_Card' FROM DUAL UNION ALL
    select 'O104','03/January/2023', 'C102','Credit_Card' FROM DUAL UNION ALL
    select 'O105','02/February/2023', 'C102','Credit_Card' FROM DUAL UNION ALL
    select 'O106','28/February/2023', 'C102','Credit_Card' FROM DUAL UNION ALL
    select 'O107','28/February/2023', 'C102','Credit_Card' FROM DUAL UNION ALL
    select 'O108','03/March/2023', 'C102','Credit_Card' FROM DUAL UNION ALL
    select 'O109','21/March/2023', 'C103','Credit_Card' FROM DUAL UNION ALL
    select 'O110','07/February/2023', 'C103','Credit_Card' FROM DUAL UNION ALL
    select 'O111','17/February/2023', 'C103','Credit_Card' FROM DUAL UNION ALL
    select 'O112','17/February/2023', 'C103','Credit_Card' FROM DUAL UNION ALL
    select 'O113','04/February/2023', 'C104','Credit_Card' FROM DUAL UNION ALL
    select 'O114','07/February/2023', 'C104','Credit_Card' FROM DUAL UNION ALL
    select 'O115','03/March/2023', 'C104','Credit_Card' FROM DUAL UNION ALL
    select 'O116','01/January/2023', 'C104','Credit_Card' FROM DUAL UNION ALL
    select 'O117','03/February/2023', 'C104','Credit_Card' FROM DUAL UNION ALL
    select 'O118','03/February/2023', 'C105','Credit_Card' FROM DUAL UNION ALL
    select 'O119','04/February/2023', 'C105','Credit_Card' FROM DUAL UNION ALL
    select 'O120','06/February/2023', 'C105','Credit_Card' FROM DUAL UNION ALL
    select 'O121','09/February/2023', 'C105','Credit_Card' FROM DUAL UNION ALL
    select 'O122','15/February/2023', 'C105','Credit_Card' FROM DUAL UNION ALL
    select 'O123','20/February/2023', 'C105','Credit_Card' FROM DUAL UNION ALL
    select 'O124','02/January/2023', 'C106','Credit_Card' FROM DUAL UNION ALL
    select 'O125','24/January/2023', 'C106','Credit_Card' FROM DUAL UNION ALL
    select 'O126','29/January/2023', 'C106','Credit_Card' FROM DUAL UNION ALL
    select 'O127','04/January/2023', 'C107','Credit_Card' FROM DUAL UNION ALL
    select 'O128','03/February/2023', 'C107','Credit_Card' FROM DUAL UNION ALL
    select 'O129','02/February/2023', 'C108','Debit_Card' FROM DUAL UNION ALL
    select 'O130','15/March/2023', 'C109','Gift_Card' FROM DUAL UNION ALL
    select 'O131','20/March/2023', 'C109','Credit_Card' FROM DUAL UNION ALL
    select 'O132','04/January/2023', 'C110','Credit_Card' FROM DUAL UNION ALL
    select 'O134','02/February/2023', 'C110','Credit_Card' FROM DUAL UNION ALL
    select 'O135','10/February/2023', 'C110','Credit_Card' FROM DUAL UNION ALL
    select 'O136','24/February/2023', 'C110','Credit_Card' FROM DUAL UNION ALL
    select 'O137','03/March/2023', 'C110','Gift_Card' FROM DUAL UNION ALL
    select 'O138','13/March/2023', 'C110','Debit_Card' FROM DUAL UNION ALL
    select 'O139','15/March/2023', 'C110','Debit_Card' FROM DUAL UNION ALL
    select 'O140','17/March/2023', 'C110','Credit_Card' FROM DUAL ;
    
select * from ofd_orders;

insert into ofd_order_details(order_details_id ,quantity ,product_id ,order_id,status)
    select 'OD102',2, 'P102','O101','Completed' FROM DUAL UNION ALL
    select 'OD103',2, 'P103','O102','Completed' FROM DUAL UNION ALL
    select 'OD104',2, 'P104','O103','Cancelled' FROM DUAL UNION ALL
    select 'OD105',2, 'P107','O103','Cancelled' FROM DUAL UNION ALL
    select 'OD106',1, 'P106','O103','Cancelled' FROM DUAL UNION ALL
    select 'OD107',1, 'P103','O104','Confirmed' FROM DUAL UNION ALL
    select 'OD108',3, 'P109','O105','Completed' FROM DUAL UNION ALL
    select 'OD109',5, 'P110','O106','Confirmed' FROM DUAL UNION ALL
    select 'OD110',3, 'P103','O107','Completed' FROM DUAL UNION ALL
    select 'OD111',2, 'P112','O108','Confirmed' FROM DUAL UNION ALL
    select 'OD112',1, 'P103','O108','Confirmed' FROM DUAL UNION ALL
    select 'OD113',2, 'P104','O109','Completed' FROM DUAL UNION ALL
    select 'OD114',1, 'P105','O109','Completed' FROM DUAL UNION ALL
    select 'OD115',1, 'P106','O109','Completed' FROM DUAL UNION ALL
    select 'OD116',1, 'P107','O109','Completed' FROM DUAL UNION ALL
    select 'OD117',3, 'P110','O110','Cancelled' FROM DUAL UNION ALL
    select 'OD118',2, 'P109','O110','Cancelled' FROM DUAL UNION ALL
    select 'OD119',1, 'P110','O111','Completed' FROM DUAL UNION ALL
    select 'OD120',1, 'P111','O112','Completed' FROM DUAL UNION ALL
    select 'OD121',2, 'P112','O113','Completed' FROM DUAL UNION ALL
    select 'OD122',3, 'P113','O113','Completed'  FROM DUAL UNION ALL
    select 'OD123',1, 'P114','O113','Completed' FROM DUAL UNION ALL
    select 'OD124',2, 'P115','O113','Completed'  FROM DUAL UNION ALL
    select 'OD125',1, 'P116','O114','Confirmed' FROM DUAL UNION ALL
    select 'OD126',1, 'P117','O114','Confirmed'  FROM DUAL UNION ALL
    select 'OD127',1, 'P118','O114','Confirmed' FROM DUAL UNION ALL
    select 'OD128',1, 'P119','O114','Confirmed'  FROM DUAL UNION ALL
    select 'OD129',4, 'P120','O114','Confirmed'  FROM DUAL UNION ALL
    select 'OD130',2, 'P121','O115','Confirmed'  FROM DUAL UNION ALL
    select 'OD131',1, 'P122','O115','Confirmed'  FROM DUAL UNION ALL
    select 'OD132',1, 'P123','O116','Confirmed'  FROM DUAL UNION ALL
    select 'OD133',2, 'P124','O116','Confirmed'  FROM DUAL UNION ALL
    select 'OD134',1, 'P125','O116','Confirmed'  FROM DUAL UNION ALL
    select 'OD135',1, 'P115','O117','Completed'  FROM DUAL UNION ALL
    select 'OD136',3, 'P112','O117','Completed'  FROM DUAL UNION ALL
    select 'OD137',2, 'P120','O117','Completed'  FROM DUAL UNION ALL
    select 'OD138',1, 'P107','O118','Completed'  FROM DUAL UNION ALL
    select 'OD139',1, 'P110','O119','Completed'  FROM DUAL UNION ALL
    select 'OD140',1, 'P109','O120','Completed'  FROM DUAL UNION ALL
    select 'OD141',2, 'P110','O121','Confirmed'  FROM DUAL UNION ALL
    select 'OD142',3, 'P111','O121','Confirmed'  FROM DUAL UNION ALL
    select 'OD143',2, 'P112','O122','Completed'  FROM DUAL UNION ALL
    select 'OD144',1, 'P113','O123','Completed'  FROM DUAL UNION ALL
    select 'OD145',1, 'P119','O124','Completed'  FROM DUAL UNION ALL
    select 'OD146',2, 'P120','O125','Confirmed'  FROM DUAL UNION ALL
    select 'OD147',1, 'P121','O125','Confirmed'  FROM DUAL UNION ALL
    select 'OD148',1, 'P122','O125','Confirmed'  FROM DUAL UNION ALL
    select 'OD149',2, 'P123','O126','Completed'  FROM DUAL UNION ALL
    select 'OD150',1, 'P124','O126','Completed'  FROM DUAL UNION ALL
    select 'OD151',2, 'P125','O126','Completed'  FROM DUAL UNION ALL
    select 'OD152',1, 'P105','O127','Completed'  FROM DUAL UNION ALL
    select 'OD153',2, 'P106','O127','Completed'  FROM DUAL UNION ALL
    select 'OD154',1, 'P107','O127','Completed'  FROM DUAL UNION ALL
    select 'OD155',1, 'P110','O127','Completed'  FROM DUAL UNION ALL
    select 'OD156',1, 'P105','O128','Completed'  FROM DUAL UNION ALL
    select 'OD157',1, 'P110','O129','Completed'  FROM DUAL UNION ALL
    select 'OD158',1, 'P111','O129','Completed'  FROM DUAL UNION ALL
    select 'OD159',1, 'P112','O129','Completed'  FROM DUAL UNION ALL
    select 'OD160',2, 'P113','O130','Confirmed'  FROM DUAL UNION ALL
    select 'OD161',2, 'P105','O130','Confirmed'  FROM DUAL UNION ALL
    select 'OD162',1, 'P106','O130','Confirmed'  FROM DUAL UNION ALL
    select 'OD163',1, 'P107','O131','Cancelled'  FROM DUAL UNION ALL
    select 'OD164',1, 'P110','O131','Cancelled'  FROM DUAL UNION ALL
    select 'OD165',1, 'P105','O132','Completed'  FROM DUAL UNION ALL
    select 'OD166',1, 'P119','O132','Completed'  FROM DUAL UNION ALL
    select 'OD167',2, 'P120','O132','Completed'  FROM DUAL UNION ALL
    select 'OD168',2, 'P121','O132','Completed'  FROM DUAL UNION ALL
    select 'OD169',1, 'P122','O132','Completed'  FROM DUAL UNION ALL
    select 'OD170',1, 'P123','O134','Confirmed'  FROM DUAL UNION ALL
    select 'OD171',4, 'P124','O134','Confirmed'  FROM DUAL UNION ALL
    select 'OD172',2, 'P125','O135','Completed'  FROM DUAL UNION ALL
    select 'OD173',1, 'P105','O135','Completed'  FROM DUAL UNION ALL
    select 'OD174',2, 'P106','O136','Completed'  FROM DUAL UNION ALL
    select 'OD175',3, 'P107','O136','Completed'  FROM DUAL UNION ALL
    select 'OD176',1, 'P110','O137','Cancelled'  FROM DUAL UNION ALL
    select 'OD177',2, 'P105','O138','Cancelled'  FROM DUAL UNION ALL
    select 'OD178',1, 'P110','O139','Completed'  FROM DUAL UNION ALL
    select 'OD179',1, 'P111','O140','Completed'  FROM DUAL;

select * from ofd_order_details;

--- SQL Devloper accessing views for business 

select * from ofd_top_customers;
select * from ofd_orders_summary;
select * from ofd_out_of_stock_products;
select * from ofd_avg_order_value_last_week;
select * from ofd_sales_by_payment_type;
select * from ofd_product_sales_by_supplier;


select * from user_tables;

commit;


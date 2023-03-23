show user;

---Customer can read/write in customer table

select * from senior_manager.ofd_customer;
    
---insert into senior_manager.ofd_customer(customer_id ,first_name ,last_name ,email, ssn, city)
---    select 'C101', 'John', 'Cena', 'cenajohn@gmail.com', 4567, 'Boston' FROM DUAL;

insert into senior_manager.ofd_customer(customer_id ,first_name ,last_name ,email, ssn, city)
    select 'C112', 'Kia', 'Brown', 'brownkia@gmail.com', 4568, 'Jersey' FROM DUAL;
---commit;

select * from senior_manager.ofd_customer;

---rollback;

---Customer only read orders and order_details table 
---Customer don't have access to supplier, products and category table

select * from senior_manager.ofd_orders;
select * from senior_manager.ofd_order_details;

---Customer can read from the Order_Summary view to know the order summary 

select * from senior_manager.ofd_orders_summary;


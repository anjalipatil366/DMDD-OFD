show user;

---Customer can read/write in customer table

select * from senior_manager.ofd_customer;

---Customer only read orders and order_details table 
---Customer don't have access to supplier, products and category table

select * from senior_manager.ofd_orders;
select * from senior_manager.ofd_order_details;

---Customer can read from the Order_Summary view to know the order summary 

select * from senior_manager.ofd_orders_summary;

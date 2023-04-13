show user;

---Supplier can read/write in supplier table

select * from senior_manager.ofd_supplier;

---Supplier only read products and category table 
---Supplier don't have access to customer, orders and order_details table

select * from senior_manager.ofd_products;
select * from senior_manager.ofd_category;

---Supplier can read from the Out_of_stock_products view to know which products are out of stock

select * from senior_manager.ofd_out_of_stock_products;
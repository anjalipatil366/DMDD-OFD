set serveroutput on;

execute procedure_cancel_order('OD102');

select * from ofd_order_details;

select * from ofd_products;
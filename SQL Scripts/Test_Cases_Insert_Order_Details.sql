set serveroutput on;

execute procedure_orders_insert('02-JAN-2023', 'C101', 'Debit_Card', 20, 'P101', 'Confirmed');

execute procedure_orders_insert('05-JUN-2023', 'C101', 'Debit_Card', 20, 'P101', 'Confirmed');

execute procedure_orders_insert('05-JAN-2023', 'C101', 'Forex_Card', 2, 'P101', 'Confirmed');

execute procedure_orders_insert('02-JAN-2023', 'C101', 'Debit_Card', 200, 'P101', 'Confirmed');

execute procedure_orders_insert('02-JAN-2023', 'C121', 'Debit_Card', 2, 'P101', 'Confirmed');

select * from ofd_products;

select * from ofd_orders;

select * from ofd_order_details;
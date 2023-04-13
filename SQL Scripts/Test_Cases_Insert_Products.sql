set serveroutput on;

execute procedure_add_products('Futon', 100, 4, 'S101', 'CT101');

execute procedure_add_products('', 100, 4, 'S101', 'CT101');

execute procedure_add_products('Bed', 100, '', 'S101', 'CT101');

execute procedure_add_products('Table', 100, 6, 'S121', 'CT101');


select * from ofd_products;
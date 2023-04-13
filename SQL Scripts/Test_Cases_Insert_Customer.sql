set serveroutput on;

execute procedure_add_customer ('John', 'Koss', 'jkoss@gmail.com', '1234567890', 'Dallas');

execute procedure_add_customer ('', 'Kloss', 'jkloss@gmail.com', '9876543210', 'Dallas');

execute procedure_add_customer ('John', 'Kloss', 'jkloss@gmail.com', '987654321078', 'Dallas');

execute procedure_add_customer ('James', 'Kloss', 'jkoss@gmail.com', '9876543210', 'Boston');

select * from ofd_customer;
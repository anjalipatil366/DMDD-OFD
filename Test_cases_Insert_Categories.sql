set serveroutput on;
Execute procedure_add_category('Automobile');

Execute procedure_add_category('');

select * from ofd_category;
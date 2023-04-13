set serveroutput on;

execute PROCEDURE_ADD_SUPPLIER ('Supply Hero', 'Houston', 9849053071);

execute PROCEDURE_ADD_SUPPLIER ('', 'Houston', 9849053071);

execute PROCEDURE_ADD_SUPPLIER ('Supply Hero 2', 'Houston', '');

execute PROCEDURE_ADD_SUPPLIER ('Supply Hero 3', 'Houston', 9876543211234);

select * from ofd_supplier;
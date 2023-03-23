show user; 

---Created Users of the Database

---(SQL Developer of the Database)
create user senior_manager identified by DMDD_ofd2023; 
alter user senior_manager quota unlimited on users; 

grant connect, resource to senior_manager;
grant create any view to senior_manager;
commit;


---(Supplier to the organization)
create user ofd_supplier_01 identified by DMDD_ofd2023;
alter user ofd_supplier_01 quota unlimited on users; 

grant connect, resource to ofd_supplier_01;
commit;

create user ofd_supplier_02 identified by DMDD_ofd2023;
alter user ofd_supplier_02 quota unlimited on users; 

grant connect, resource to ofd_supplier_02;
commit;


---(Customer to the organization)
create user ofd_customer_01 identified by DMDD_ofd2023;
alter user ofd_customer_01 quota unlimited on users; 

grant connect, resource to ofd_customer_01;
commit;


create user ofd_customer_02 identified by DMDD_ofd2023;
alter user ofd_customer_02 quota unlimited on users; 

grant connect, resource to ofd_customer_02;
commit;


create user ofd_customer_03 identified by DMDD_ofd2023;
alter user ofd_customer_03 quota unlimited on users; 

grant connect, resource to ofd_customer_03;
commit;









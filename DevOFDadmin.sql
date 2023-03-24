show user; 

PURGE Recyclebin;
SET SERVEROUTPUT ON;
DECLARE
  Is_true NUMBER;
BEGIN
  SELECT COUNT(*) INTO Is_true
  FROM all_users
  WHERE lower(username) = 'senior_manager';
  
  IF Is_true > 0 THEN
    EXECUTE IMMEDIATE 'DROP USER senior_manager CASCADE';
    DBMS_OUTPUT.PUT_LINE('User senior_manager dropped.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('User senior_manager does not exist.');
  END IF;
END;
/

DECLARE
  Is_true NUMBER;
BEGIN
  SELECT COUNT(*) INTO Is_true
  FROM all_users
  WHERE lower(username) = 'ofd_customer_01';
  
  IF Is_true > 0 THEN
    EXECUTE IMMEDIATE 'DROP USER ofd_customer_01';
    DBMS_OUTPUT.PUT_LINE('User ofd_customer_01 dropped.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('User ofd_customer_01 does not exist.');
  END IF;
END;
/

DECLARE
  Is_true NUMBER;
BEGIN
  SELECT COUNT(*) INTO Is_true
  FROM all_users
  WHERE lower(username) = 'ofd_customer_02';
  
  IF Is_true > 0 THEN
    EXECUTE IMMEDIATE 'DROP USER ofd_customer_02';
    DBMS_OUTPUT.PUT_LINE('User ofd_customer_02 dropped.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('User ofd_customer_02 does not exist.');
  END IF;
END;
/

DECLARE
  Is_true NUMBER;
BEGIN
  SELECT COUNT(*) INTO Is_true
  FROM all_users
  WHERE lower(username) = 'ofd_customer_03';
  
  IF Is_true > 0 THEN
    EXECUTE IMMEDIATE 'DROP USER ofd_customer_03';
    DBMS_OUTPUT.PUT_LINE('User ofd_customer_03 dropped.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('User ofd_customer_03 does not exist.');
  END IF;
END;
/

DECLARE
  Is_true NUMBER;
BEGIN
  SELECT COUNT(*) INTO Is_true
  FROM all_users
  WHERE lower(username) = 'ofd_supplier_01';
  
  IF Is_true > 0 THEN
    EXECUTE IMMEDIATE 'DROP USER ofd_supplier_01';
    DBMS_OUTPUT.PUT_LINE('User ofd_supplier_01 dropped.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('User ofd_supplier_01 does not exist.');
  END IF;
END;
/

DECLARE
  Is_true NUMBER;
BEGIN
  SELECT COUNT(*) INTO Is_true
  FROM all_users
  WHERE lower(username) = 'ofd_supplier_02';
  
  IF Is_true > 0 THEN
    EXECUTE IMMEDIATE 'DROP USER ofd_supplier_02';
    DBMS_OUTPUT.PUT_LINE('User ofd_supplier_02 dropped.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('User ofd_supplier_02 does not exist.');
  END IF;
END;
/

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









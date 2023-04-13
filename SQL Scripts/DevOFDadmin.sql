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
  WHERE lower(username) = 'ofd_customer';
  
  IF Is_true > 0 THEN
    EXECUTE IMMEDIATE 'DROP USER ofd_customer';
    DBMS_OUTPUT.PUT_LINE('User ofd_customer dropped.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('User ofd_customer does not exist.');
  END IF;
END;
/


DECLARE
  Is_true NUMBER;
BEGIN
  SELECT COUNT(*) INTO Is_true
  FROM all_users
  WHERE lower(username) = 'ofd_supplier';
  
  IF Is_true > 0 THEN
    EXECUTE IMMEDIATE 'DROP USER ofd_supplier';
    DBMS_OUTPUT.PUT_LINE('User ofd_supplier dropped.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('User ofd_supplier does not exist.');
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
create user ofd_supplier identified by DMDD_ofd2023;
alter user ofd_supplier quota unlimited on users; 

grant connect, resource to ofd_supplier;
commit;


---(Customer to the organization)
create user ofd_customer identified by DMDD_ofd2023;
alter user ofd_customer quota unlimited on users; 

grant connect, resource to ofd_customer;
commit;











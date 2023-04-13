SET SERVEROUTPUT ON;

--TEST CASES FOR PROCEDURE update_product


select * from OFD_SUPPLIER;
-- WHEN PROPER VALUES ARE PASSED AS PARAMETER

DECLARE
    supplier_id VARCHAR2(10) := 'S101';
    supplier_name VARCHAR2(100) := 'NEW SUPPLIER NAME';
    city VARCHAR2(50) := 'BOSTON';
    phone NUMBER := 1231234123 ;

BEGIN
    update_supplier(s_id => supplier_id, s_name => supplier_name, s_city => city, s_phone => phone);
    COMMIT;
END;
/

select * from OFD_SUPPLIER;
--notice that product name is converted to camel case

--TEST CASE WHEN SUPPLIER ID DOES NOT START WITH S

DECLARE
    supplier_id VARCHAR2(10) := '101';
    supplier_name VARCHAR2(100) := 'NEW SUPPLIER NAME';
    city VARCHAR2(50) := 'BOSTON';
    phone NUMBER := 1231234123 ;

BEGIN
    update_supplier(s_id => supplier_id, s_name => supplier_name, s_city => city, s_phone => phone);
    COMMIT;
END;
/

--TEST CASE WHEN PHONE NUMBER IS NOT EQUAL 10 DIGITS

DECLARE
    supplier_id VARCHAR2(10) := 'S101';
    supplier_name VARCHAR2(100) := 'NEW SUPPLIER NAME';
    city VARCHAR2(50) := 'BOSTON';
    phone NUMBER := 12312341 ;

BEGIN
    update_supplier(s_id => supplier_id, s_name => supplier_name, s_city => city, s_phone => phone);
    COMMIT;
END;
/

--TEST CASE WHEN PHONE NUMBER IS MORE 10 DIGITS

DECLARE
    supplier_id VARCHAR2(10) := 'S101';
    supplier_name VARCHAR2(100) := 'NEW SUPPLIER NAME';
    city VARCHAR2(50) := 'BOSTON';
    phone NUMBER := 123123414545454 ;

BEGIN
    update_supplier(s_id => supplier_id, s_name => supplier_name, s_city => city, s_phone => phone);
    COMMIT;
END;
/

SET SERVEROUTPUT ON;

--TEST CASES FOR PROCEDURE update_product
-- WHEN PROPER VALUES ARE PASSED AS PARAMETER

select * from ofd_products;
DECLARE
    v_product_id VARCHAR2(10):= 'P101';
    v_supplier_id VARCHAR2(10) := 'S102';
    v_category_id VARCHAR2(10) := 'CT105';
BEGIN
    UPDATE_PRODUCT(
        p_id => v_product_id,
        p_name => 'NAME PRODUCT ',
        p_price => 9.99,
        p_quantity => 50,
        p_supplier_id => v_supplier_id,
        p_category_id => v_category_id
    );
    
    DBMS_OUTPUT.PUT_LINE('Product ID: ' || v_product_id);
END;
/
select * from ofd_products;
--notice that product name is converted to camel case

--TEST CASE WHEN PRODUCT_ID, SUPPLIER_ID, CATEGORY_ID DOESNT START WITH P,S OR CT
DECLARE
    v_product_id VARCHAR2(10):= '101';
    v_supplier_id VARCHAR2(10) := '102';
    v_category_id VARCHAR2(10) := '105';
BEGIN
    UPDATE_PRODUCT(
        p_id => v_product_id,
        p_name => 'NAME PRODUCT ',
        p_price => 9.99,
        p_quantity => 50,
        p_supplier_id => v_supplier_id,
        p_category_id => v_category_id
    );
    
    DBMS_OUTPUT.PUT_LINE('Product ID: ' || v_product_id);
END;
/

--TEST CASE WHEN QUANTITY IS LESS THAN ZERO

DECLARE
    v_product_id VARCHAR2(10):= 'P101';
    v_supplier_id VARCHAR2(10) := 'S102';
    v_category_id VARCHAR2(10) := 'CT105';
BEGIN
    UPDATE_PRODUCT(
        p_id => v_product_id,
        p_name => 'NAME PRODUCT ',
        p_price => 9.99,
        p_quantity => -50,
        p_supplier_id => v_supplier_id,
        p_category_id => v_category_id
    );
    
    DBMS_OUTPUT.PUT_LINE('Product ID: ' || v_product_id);
END;
/
--TEST CASE WHEN PRICE IS LESS THAN ZERO

DECLARE
    v_product_id VARCHAR2(10):= 'P101';
    v_supplier_id VARCHAR2(10) := 'S102';
    v_category_id VARCHAR2(10) := 'CT105';
BEGIN
    UPDATE_PRODUCT(
        p_id => v_product_id,
        p_name => 'NAME PRODUCT ',
        p_price => -9.99,
        p_quantity => 50,
        p_supplier_id => v_supplier_id,
        p_category_id => v_category_id
    );
    
    DBMS_OUTPUT.PUT_LINE('Product ID: ' || v_product_id);
END;
/

--TEST CASE WHEN PRODUCT_ID DOES NOT EXIST
DECLARE
    v_product_id VARCHAR2(10):= 'P11002';
    v_supplier_id VARCHAR2(10) := 'S102';
    v_category_id VARCHAR2(10) := 'CT105';
BEGIN
    UPDATE_PRODUCT(
        p_id => v_product_id,
        p_name => 'NAME PRODUCT ',
        p_price => 9.99,
        p_quantity => 50,
        p_supplier_id => v_supplier_id,
        p_category_id => v_category_id
    );
    
    DBMS_OUTPUT.PUT_LINE('Product ID: ' || v_product_id);
END;
/

CREATE OR REPLACE PROCEDURE update_product (
    p_id IN OUT VARCHAR2,
    p_name IN VARCHAR2,
    p_price IN NUMBER,
    p_quantity IN NUMBER,
    p_supplier_id IN OUT VARCHAR2,
    p_category_id IN OUT VARCHAR2
)
AS
    p_name_camel VARCHAR2(100);
    v_product_count NUMBER;
BEGIN
    -- Check if p_id starts with "p"
    IF (p_id NOT LIKE 'P%') THEN
        RAISE_APPLICATION_ERROR(-20001, 'Product ID should start with "P".');
    END IF;
    
    -- Check if p_supplier_id starts with "S"
    IF (p_supplier_id NOT LIKE 'S%') THEN
        RAISE_APPLICATION_ERROR(-20002, 'Supplier ID should start with "S".');
    END IF;
    
    -- Check if p_category_id starts with "CT"
    IF (p_category_id NOT LIKE 'CT%') THEN
        RAISE_APPLICATION_ERROR(-20003, 'Category ID should start with "CT".');
    END IF;
    
    -- Convert p_name to camel case
    p_name_camel := INITCAP(p_name);
    
    -- Check if quantity and price are greater than or equal to zero
    IF (p_quantity < 0) THEN
        RAISE_APPLICATION_ERROR(-20004, 'Quantity cannot be less than zero.');
    END IF;
    
    IF (p_price < 0) THEN
        RAISE_APPLICATION_ERROR(-20005, 'Price cannot be less than zero.');
    END IF;
    
    -- Check if the product_id exists
    SELECT COUNT(*) INTO v_product_count
    FROM OFD_PRODUCTS
    WHERE product_id = p_id;
    
    IF (v_product_count = 0) THEN
        RAISE_APPLICATION_ERROR(-20006, 'Product ID does not exist.');
    END IF;
    
    -- Update the product information
    UPDATE OFD_PRODUCTS
    SET 
        product_name = p_name_camel,
        product_price = p_price,
        product_quantity = p_quantity,
        supplier_id = p_supplier_id,
        category_id = p_category_id
    WHERE product_id = p_id;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Product updated successfully.');
END;
/


CREATE OR REPLACE PROCEDURE update_supplier (
    s_id IN OUT VARCHAR2,
    s_name IN VARCHAR2,
    s_city IN VARCHAR2,
    s_phone IN NUMBER
)
AS
    v_name_camel_case VARCHAR2(100);
    v_city_camel_case VARCHAR2(100);
BEGIN
    -- Check if p_phone is not null and has 10 digits
    IF (s_phone IS NULL OR LENGTH(TRIM(TO_CHAR(s_phone))) != 10) THEN
        RAISE_APPLICATION_ERROR(-20002, 'Phone number must have 10 digits.');
    END IF;
    
    -- Check if p_id starts with "S"
    IF (s_id NOT LIKE 'S%') THEN
        RAISE_APPLICATION_ERROR(-20001, 'Supplier ID should start with "S".');
    END IF;
    
 
     
   -- Convert p_name to camel case
    v_name_camel_case := INITCAP(s_name);
    v_city_camel_case := INITCAP(s_city);
    
    -- Update the supplier
    UPDATE OFD_SUPPLIER
    SET 
        supplier_name = v_name_camel_case,
        city = v_city_camel_case,
        phone = s_phone
    WHERE supplier_id = s_id;
    
    -- If no row is updated, insert a new supplier
    IF SQL%ROWCOUNT = 0 THEN
        INSERT INTO ofd_supplier (supplier_id, supplier_name, city, phone)
        VALUES (s_id, v_name_camel_case, v_city_camel_case, s_phone);
    END IF;
    
    COMMIT;
END;
/



CREATE OR REPLACE PROCEDURE update_category (
    p_category_id IN VARCHAR2,
    p_category_name IN VARCHAR2
)
AS
    v_category_name VARCHAR2(100);
BEGIN
    -- Check if category_id starts with 'CT'
    IF NOT REGEXP_LIKE(p_category_id, '^CT') THEN
        RAISE_APPLICATION_ERROR(-20001, 'Category ID should start with "CT".');
    END IF;

    -- Convert category_name to camel case
    v_category_name := INITCAP(p_category_name);

    -- Update the record in the table
    UPDATE OFD_CATEGORY
    SET category_name = v_category_name
    WHERE category_id = p_category_id;
    
    DBMS_OUTPUT.PUT_LINE('Record updated successfully.');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20002, 'Category ID not found.');
    WHEN OTHERS THEN
        RAISE;
END;
/

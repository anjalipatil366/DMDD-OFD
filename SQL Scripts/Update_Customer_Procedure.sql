CREATE OR REPLACE PROCEDURE update_customer (
    p_customer_id IN VARCHAR2,
    p_first_name IN VARCHAR2,
    p_last_name IN VARCHAR2,
    p_email IN VARCHAR2,
    p_ssn IN NUMBER,
    p_city IN VARCHAR2
)
AS
v_customer_count number;
BEGIN
    -- Check if the customer_id exists
    SELECT COUNT(*) INTO v_customer_count
    FROM ofd_customer
    WHERE customer_id = p_customer_id;
    
    IF (v_customer_count = 0) THEN
        RAISE_APPLICATION_ERROR(-20001, 'Customer ID does not exist.');
    END IF;
    
    -- Check if customer_id starts with "C"
    IF (SUBSTR(p_customer_id, 1, 1) <> 'C') THEN
        RAISE_APPLICATION_ERROR(-20002, 'Customer ID should start with "C".');
    END IF;
    
    -- Check if first_name is not null
    IF (p_first_name IS NULL) THEN
        RAISE_APPLICATION_ERROR(-20003, 'First name cannot be null.');
    END IF;
    
    -- Check if email ends with ".com"
    IF (SUBSTR(p_email, -4) <> '.com') THEN
        RAISE_APPLICATION_ERROR(-20004, 'Email should end with ".com".');
    END IF;
    
    -- Check if ssn is 10 digits
    IF (LENGTH(p_ssn) <> 10) THEN
        RAISE_APPLICATION_ERROR(-20005, 'SSN should be 10 digits.');
    END IF;
    
    -- Update the customer information
    UPDATE ofd_customer
    SET 
        first_name = p_first_name,
        last_name = p_last_name,
        email = p_email,
        ssn = p_ssn,
        city = p_city
    WHERE customer_id = p_customer_id;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Customer updated successfully.');
END;
/
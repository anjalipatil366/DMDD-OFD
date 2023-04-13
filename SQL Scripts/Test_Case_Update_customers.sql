set serveroutput on;

--TEST CASES FOR PROCEDURE update_product
-- WHEN PROPER VALUES ARE PASSED AS PARAMETER

EXECUTE update_customer('C101', 'Jane', 'Doe', 'janedoe@example.com', 9876543210, 'San Francisco');


SELECT * FROM ofd_customer;

-- TEST WEHN CUSTOMER_ID DOES NOT START WITH C
BEGIN
    update_customer('101', 'John', 'Doe', 'johndoe@gmail.com', 123456789, 'New York');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

--TEST CASE WHEN FIRST NAME IS NULL
BEGIN
    update_customer('C123456789', NULL, 'Doe', 'johndoe@example.com', 1234567890, 'New York');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

-- TEST CASE WHEN EMAIL DOES NOT END WITH .COM
BEGIN
    update_customer('C123456789', 'Jane', 'Doe', 'janedoe@example.net', 1234567890, 'New York');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;


--TEST CASE WHEN SSN IS LESS THAN 10
BEGIN
    update_customer('C123456789', 'Jane', 'Doe', 'janedoe@example.com', 123456, 'New York');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

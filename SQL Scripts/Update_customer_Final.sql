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
EX_F_NAME_NULL EXCEPTION;
EX_SSN_ISSUE EXCEPTION;
EX_EMAIL_ISSUE EXCEPTION;

BEGIN
   if length(p_first_name) is null then
   RAISE EX_F_NAME_NULL;
   end if;
   
   if substr(p_email,-4) not in ('.com') then
   RAISE EX_EMAIL_ISSUE;
   end if;
    
   if length(p_ssn) <> 10 then
   RAISE EX_SSN_ISSUE;
   end if;
    -- Update the customer information
    UPDATE ofd_customer
    SET 
        first_name = p_first_name,
        last_name = p_last_name,
        email = p_email,
        ssn = p_ssn,
        city = p_city
    WHERE ofd_customer.customer_id = p_customer_id;
    
    COMMIT;
 
    
EXCEPTION
when EX_F_NAME_NULL then 
DBMS_OUTPUT.PUT_LINE('Please enter a first_name for the customer');

when EX_EMAIL_ISSUE then 
DBMS_OUTPUT.PUT_LINE('Please enter a valid email id ending with ".com"');

when EX_SSN_ISSUE then
DBMS_OUTPUT.PUT_LINE('Please enter a valid 10 digit SSN');

when others then 
DBMS_OUTPUT.PUT_LINE('Please enter a valid customer ID to update customer details');

rollback;

END;
/
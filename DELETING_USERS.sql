CREATE OR REPLACE PROCEDURE DELETE_USER(
  username IN VARCHAR2
)
IS
BEGIN
  -- Revoke any privileges the user may have
  EXECUTE IMMEDIATE 'REVOKE ALL PRIVILEGES FROM ' || username;

  -- Delete the user account
  EXECUTE IMMEDIATE 'DROP USER ' || username || ' CASCADE';

  -- Commit the transaction
  COMMIT;
  
  -- Display success message
  DBMS_OUTPUT.PUT_LINE('User ' || username || ' has been deleted.');
EXCEPTION
  -- If an error occurs, display error message and rollback transaction
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error deleting user: ' || SQLERRM);
    
END;
--/
--BEGIN
--  DELETE_USER('OFD_CUSTOMER_04');
--END;
--/
--SELECT username FROM all_users;



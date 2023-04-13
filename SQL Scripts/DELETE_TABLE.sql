CREATE OR REPLACE PROCEDURE delete_table (table_name IN VARCHAR2) AS
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE ' || table_name;
   DBMS_OUTPUT.PUT_LINE('Table ' || table_name || ' has been deleted.');
EXCEPTION
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error deleting table ' || table_name || ': ' || SQLERRM);
END;
/
--BEGIN
--delete_table('SUPPLIER_PROC');
--END;
/
SELECT owner, table_name FROM all_tables;




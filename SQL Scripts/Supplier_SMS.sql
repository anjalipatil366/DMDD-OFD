SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE send_low_stock_notification (p_product_id IN VARCHAR2)
AS
  v_subject VARCHAR2(100) := 'Low Stock Notification';
  v_message VARCHAR2(4000);
BEGIN
  FOR supplier_rec IN (
    SELECT DISTINCT s.supplier_name, s.phone, p.product_name
    FROM ofd_supplier s
    INNER JOIN ofd_products p ON s.supplier_id = p.supplier_id
    WHERE p.product_quantity < 10 AND p.product_id = p_product_id
  ) LOOP
    v_message := 'Dear Supplier, ' || CHR(10) ||RPAD(' ', 10) ||
                 'Some of your products in our inventory have low stock, with a quantity less than 10.' || CHR(10) ||RPAD(' ', 10) ||
                 'Please replenish stock as soon as possible for the following product: ' || supplier_rec.product_name || CHR(10) ||RPAD(' ', 10) ||
                 'Thank you for your cooperation.' || CHR(10) ||RPAD(' ', 10) ||
                 'Sincerely, ' || CHR(10) ||RPAD(' ', 10) ||
                 'WayFair';
    DBMS_OUTPUT.PUT_LINE('SMS sent to Supplier: ' || supplier_rec.supplier_name || ' (' || supplier_rec.phone || ')');
    DBMS_OUTPUT.PUT_LINE('Message: ' || v_message);
    
    DBMS_OUTPUT.PUT_LINE('Low Stock Notification SMS sent to suppliers with low stock products.');
  END LOOP;
  
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

BEGIN
send_low_stock_notification('P109');
END; 
/



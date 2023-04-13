-- Create the procedure
CREATE OR REPLACE PROCEDURE get_orders_summary
IS
BEGIN
  -- Declare variables to store the result of the query
  DECLARE
    v_order_id ofd_orders_summary.order_id%TYPE;
    v_date_of_purchase ofd_orders_summary.date_of_purchase%TYPE;
    v_first_name ofd_orders_summary.first_name%TYPE;
    v_last_name ofd_orders_summary.last_name%TYPE;
    v_product_name ofd_orders_summary.product_name%TYPE;
    v_quantity ofd_orders_summary.quantity%TYPE;
    v_subtotal ofd_orders_summary.subtotal%TYPE;
  BEGIN
    -- Fetch data from the ofd_orders_summary view into variables
    
    DBMS_OUTPUT.PUT_LINE('+-------------------------------+------------------------------+------------------------------+------------------------------+------------------------------+------------------------------+------------------------------+');
    DBMS_OUTPUT.PUT_LINE('|         Order ID              |         Date of Purchase     |         First Name           |         Last Name            |         Product Name         |           Quantity           |           Subtotal           |');
    DBMS_OUTPUT.PUT_LINE('+-------------------------------+------------------------------+------------------------------+------------------------------+------------------------------+------------------------------+------------------------------+'); 
    FOR orders_summary IN (SELECT * FROM ofd_orders_summary)
    LOOP
      v_order_id := orders_summary.order_id;
      v_date_of_purchase := orders_summary.date_of_purchase;
      v_first_name := orders_summary.first_name;
      v_last_name := orders_summary.last_name;
      v_product_name := orders_summary.product_name;
      v_quantity := orders_summary.quantity;
      v_subtotal := orders_summary.subtotal;

      -- Print the summary data in tabular form using RPAD and LPAD
      DBMS_OUTPUT.PUT_LINE(
            '| ' || RPAD(v_order_id, 30) || '|' ||
            LPAD('$' || v_date_of_purchase, 30) || '|' ||
            LPAD('$' || v_first_name, 30) || '|' ||
            LPAD('$' || v_last_name, 30) || '|'  ||
            LPAD('$' || v_product_name, 30) || '|' ||
            LPAD('$' || v_quantity, 30) || '|' ||
            LPAD('$' || v_subtotal, 30) || '|'
        );
    END LOOP;
        DBMS_OUTPUT.PUT_LINE('+-------------------------------+------------------------------+------------------------------+------------------------------+------------------------------+------------------------------+------------------------------+');
    
  END;
END;
/

-- Execute the procedure
BEGIN
  get_orders_summary;
END;
/



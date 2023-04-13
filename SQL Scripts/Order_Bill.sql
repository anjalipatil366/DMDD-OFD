SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE generate_bill (p_order_id IN VARCHAR2)
IS
    v_total_cost NUMBER := 0;
    v_customer_name ofd_customer.first_name%TYPE;
    v_customer_email ofd_customer.email%TYPE;
BEGIN
    -- Retrieve order details
    SELECT SUM(od.quantity * p.product_price) INTO v_total_cost
    FROM ofd_order_details od
    INNER JOIN ofd_products p ON od.product_id = p.product_id
    WHERE od.order_id = p_order_id;

    -- Retrieve customer information
  SELECT first_name, email INTO v_customer_name, v_customer_email
    FROM ofd_customer
  WHERE customer_id = (SELECT customer_id FROM ofd_orders WHERE order_id = p_order_id);

    -- Generate bill
    DBMS_OUTPUT.PUT_LINE('----------------------------------');
    DBMS_OUTPUT.PUT_LINE('            INVOICE             ');
    DBMS_OUTPUT.PUT_LINE('----------------------------------');
    DBMS_OUTPUT.PUT_LINE('Order ID: ' || p_order_id);
    DBMS_OUTPUT.PUT_LINE('Customer Name: ' || v_customer_name);
    DBMS_OUTPUT.PUT_LINE('Customer Email: ' || v_customer_email);
    DBMS_OUTPUT.PUT_LINE('----------------------------------');
    DBMS_OUTPUT.PUT_LINE('        ORDER DETAILS          ');
    DBMS_OUTPUT.PUT_LINE('----------------------------------');
    DBMS_OUTPUT.PUT_LINE('PRODUCT           | QUANTITY | PRICE');
    DBMS_OUTPUT.PUT_LINE('----------------------------------');

    -- Retrieve and display order items
    FOR order_item IN (SELECT p.product_name, od.quantity, p.product_price
                       FROM ofd_order_details od
                       INNER JOIN ofd_products p ON od.product_id = p.product_id
                       WHERE od.order_id = p_order_id)
    LOOP
        DBMS_OUTPUT.PUT_LINE(LPAD(order_item.product_name, 20) || ' | ' ||
                             RPAD(order_item.quantity, 8) || ' | ' ||
                             RPAD(order_item.product_price, 10));
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('----------------------------------');
    DBMS_OUTPUT.PUT_LINE('Total Cost: $' || v_total_cost);
    DBMS_OUTPUT.PUT_LINE('----------------------------------');
    DBMS_OUTPUT.PUT_LINE('Thank you for your purchase!');
END;
/

BEGIN
   generate_bill('O113');
EXCEPTION
   WHEN NO_DATA_FOUND THEN 
    DBMS_OUTPUT.PUT_LINE('Invalid Order Id!');
END;
/








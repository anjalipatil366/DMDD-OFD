SET SERVEROUTPUT ON;

-- Trigger to delete customer when they have 3 or more canceled orders
CREATE OR REPLACE TRIGGER trg_delete_customer
FOR INSERT OR UPDATE ON ofd_order_details
COMPOUND TRIGGER -- Use a compound trigger to handle multiple trigger events

    -- Declare variables for customer ID and canceled order count
    v_customer_id ofd_customer.customer_id%TYPE;
    v_canceled_order_count INTEGER := 0; -- Initialize to 0

    BEFORE EACH ROW IS
    BEGIN
        -- Get the customer ID for the current order detail
        SELECT ord.customer_id INTO v_customer_id
        FROM ofd_orders ord
        WHERE ord.order_id = :new.order_id;
    END BEFORE EACH ROW;

    AFTER EACH ROW IS
    BEGIN
        -- Get the count of canceled orders for the customer
        SELECT COUNT(*) INTO  v_canceled_order_count
        FROM ofd_order_details o
        JOIN ofd_orders ord ON o.order_id = ord.order_id
        JOIN ofd_customer c ON ord.customer_id = c.customer_id
        WHERE c.customer_id = v_customer_id AND o.status = 'canceled'
        GROUP BY c.customer_id;

        -- Delete the customer if they have 3 or more canceled orders
        IF v_canceled_order_count >= 3 THEN
            DELETE FROM ofd_customer WHERE customer_id = v_customer_id;
            DBMS_OUTPUT.PUT_LINE('Customer with ID ' || v_customer_id || ' has been deleted due to having 3 or more canceled orders.');
        END IF;
    END AFTER EACH ROW;

    AFTER STATEMENT IS
    BEGIN
        -- Handle "no data found" exception gracefully, if needed
        IF v_canceled_order_count = 0 THEN
            DBMS_OUTPUT.PUT_LINE('No data found for the given condition.');
        END IF;
    END AFTER STATEMENT;
END trg_delete_customer;
/

    












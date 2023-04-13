SET SERVEROUTPUT ON

CREATE OR REPLACE PROCEDURE ofd_sales_report AS
BEGIN

    -- Call the ofd_avg_order_value_last_week view to get the average order value last week
    DBMS_OUTPUT.PUT_LINE('Average Order Value Last Week:');
    DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------------'); 
    FOR avg_order_value IN (SELECT * FROM ofd_avg_order_value_last_week) LOOP
        DBMS_OUTPUT.PUT_LINE(
            RPAD('Product Name: ' || avg_order_value.product_name, 30) || 
            RPAD('Average Order Value: $' || avg_order_value.avg_order_value, 30)
        );
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------------------------------------------------------------------------------------'); 

    -- Call the ofd_product_sales_by_supplier view to get the product sales by supplier
    DBMS_OUTPUT.PUT_LINE('Product Sales by Supplier:');
    DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------------'); 
    FOR product_sales_by_supplier IN (SELECT * FROM ofd_product_sales_by_supplier) LOOP
        DBMS_OUTPUT.PUT_LINE(
            RPAD('Supplier Name: ' || product_sales_by_supplier.supplier_name, 30) || 
            RPAD('Total Quantity Sold: ' || product_sales_by_supplier.total_quantity, 30) ||
            RPAD('Total Revenue: $' || product_sales_by_supplier.total_revenue, 30)
        );
    END LOOP;
    
     DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------------------------------------------------------------------------------------'); 

    -- Call the ofd_sales_by_payment_type view to get the sales by payment type
    DBMS_OUTPUT.PUT_LINE('Sales by Payment Type:');
    DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------------'); 
    FOR sales_by_payment_type IN (SELECT * FROM ofd_sales_by_payment_type) LOOP
        DBMS_OUTPUT.PUT_LINE(
            RPAD('Payment Type: ' || sales_by_payment_type.payment_type, 30) || 
            RPAD('Total Revenue: $' || sales_by_payment_type.total_revenue, 30)
        );
    END LOOP;
    
     DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------------------------------------------------------------------------------------'); 
    
    -- Call the ofd_out_of_stock_products view to get the out of stock products
    DBMS_OUTPUT.PUT_LINE('Out of Stock Products:');
    DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------------'); 
    FOR out_of_stock_product IN (SELECT * FROM ofd_out_of_stock_products) LOOP
        DBMS_OUTPUT.PUT_LINE(
            RPAD('Product ID: ' || out_of_stock_product.product_id, 20) || 
            RPAD('Product Name: ' || out_of_stock_product.product_name, 30) || 
            RPAD('Supplier Name: ' || out_of_stock_product.supplier_name, 30) || 
            RPAD('Category: ' || out_of_stock_product.category_name, 20) || 
            RPAD('Units in Stock: ' || out_of_stock_product.unit_in_stock, 20)
        );
    END LOOP;
    
     DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------------------------------------------------------------------------------------'); 
    
    -- Call the ofd_top_customers view to get the top customers
    DBMS_OUTPUT.PUT_LINE('Top Customers:');
    DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------------'); 
    FOR customer IN (SELECT * FROM ofd_top_customers) LOOP
        DBMS_OUTPUT.PUT_LINE(
            RPAD('Customer ID: ' || customer.customer_id, 20) || 
            RPAD('First Name: ' || customer.first_name, 30) || 
            RPAD('Last Name: ' || customer.last_name, 30) || 
            LPAD('Total Order Value: $' || customer.total_value, 30) || 
            LPAD('Total Orders: ' || customer.total_orders, 20)
        );
    END LOOP;

END;
/
    BEGIN
    ofd_sales_report ;
END;
/







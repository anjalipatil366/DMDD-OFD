create or replace PROCEDURE PROCEDURE_ADD_SUPPLIER(
s_name in ofd_supplier.supplier_name%type,
city_id in ofd_supplier.city%type,
s_phone in ofd_supplier.phone%type)
As
S_id varchar(40);
EX_S_NAME_NULL EXCEPTION;
EX_S_PHONE_NULL EXCEPTION;
EX_S_PHONE_ISSUE EXCEPTION;

VAL3 Number;
VAL4 Number;

BEGIN 
execute immediate ('select count(*) from ofd_supplier') into val3;
if val3=0 then
S_id := concat('S', '101');
elsif val3 > 0 then 
select supplier_id into S_id from ofd_supplier where supplier_id = (select max(supplier_id) from ofd_supplier);
S_id := 'S' || (cast(substr(S_id,2,3) as number) + 1);
end if;

IF length(upper(s_name)) is null then
raise EX_S_NAME_NULL;
end if;

IF length(s_phone) is null then
raise EX_S_PHONE_NULL;
end if;

IF length(s_phone) > 10 then
raise EX_S_PHONE_ISSUE;
end if;


insert into ofd_supplier values (S_id, S_name, city_id, s_phone);
commit;

EXCEPTION
when EX_S_NAME_NULL then
DBMS_OUTPUT.PUT_LINE('Supplier name cannot be null, please provide a supplier name');

when EX_S_PHONE_NULL then 
DBMS_OUTPUT.PUT_LINE('Phone nhumber cannot be null, please provide a phone number');

when EX_S_PHONE_ISSUE then 
DBMS_OUTPUT.PUT_LINE('Phone number cannot be greater then 10 digits. Please enter a valid phone number');

rollback;
end;
create or replace PROCEDURE PROCEDURE_ADD_CUSTOMER(
f_name in ofd_customer.first_name%type,
l_name in ofd_customer.last_name%type,
email_id in ofd_customer.email%type,
ssn_id in ofd_customer.ssn%type,
city_id in ofd_customer.city%type)
As
C_id varchar(40);
EX_F_NAME_NULL EXCEPTION;
EX_EMAIL_ISSUE EXCEPTION;
EX_SSN_LENGTH EXCEPTION;
VAL1 Number;
VAL2 Number;

BEGIN 
execute immediate ('select count(*) from ofd_Customer') into val1;
if val1=0 then
c_id := concat('C', '101');
elsif val1 > 0 then 
select customer_id into c_id from ofd_customer where customer_id = (select max(customer_id) from ofd_customer);
C_id := 'C' || (cast(substr(c_id,2,3) as number) + 1);
end if;

IF length(upper(f_name)) is null then
raise EX_F_NAME_NULL;
end if;

EXECUTE IMMEDIATE ('select count(*) from ofd_customer where UPPER(email) = UPPER('''||EMAIL_ID||''') ') into val2;

if val2>0 then
raise ex_email_issue;
end if;

if length(ssn_id) > 10 then 
raise EX_SSN_LENGTH;
end if;

insert into ofd_customer values (C_id, F_name, l_name, email_id, ssn_id, city_id);
--DMBMS_OUTPUT.PUT_LINE('Customer record  with the following details has been added to the customers table:' || ''' First Name: 
commit;

EXCEPTION
when EX_F_NAME_NULL then
DBMS_OUTPUT.PUT_LINE('First name cannot be null');

when EX_EMAIL_ISSUE then 
DBMS_OUTPUT.PUT_LINE('Customer account with this email already exists. Please provide a unique email id');

when EX_SSN_LENGTH then 
DBMS_OUTPUT.PUT_LINE('SSN greater than 10 digits. Please enter a valid SSN');

rollback;
end;

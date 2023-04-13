create or replace procedure PROCEDURE_ADD_CATEGORY(
cat_name in ofd_category.category_name%type)
as 
cat_id varchar(40);
--cat_name varchar(40);
EX_CAT_NULL EXCEPTION;
val5 Number;

BEGIN
execute immediate ('select count(*) from ofd_category') into val5;
if val5=0 then
cat_id := concat('CT', '101');
elsif val5 > 0 then 
select category_id into cat_id from ofd_category where category_id = (select max(category_id) from ofd_category);
cat_id := 'CT' || (cast(substr(cat_id,3,3) as number) + 1);
end if;

if length(cat_name) is null then
raise EX_CAT_NULL;
end if;

insert into ofd_category values (cat_id, cat_name);
commit; 

EXCEPTION
when EX_CAT_NULL then 
DBMS_OUTPUT.PUT_LINE('You have not provided a category name. If you do not wish to provide a category name, please provide "General" as the category name eg: EXECUTE PROCEDURE_ADD_CATEGORY (General)');

rollback;
end;
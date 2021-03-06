select*from all_trigGers where trigger_name like '%BIU_ROW_TRM_SPC';

select DESCRIPTION||substr(TRIGGER_BODY,1,4000)TRIG_BODY from all_trigGers where trigger_name like '%BIU_ROW_TRM_SPC';

select substr(TRIGGER_BODY,1,4000)TRIG_BODY from all_trigGers where trigger_name like '%BIU_ROW_TRM_SPC';

select r.OWNER,t.OWNER,TRIGGER_NAME,t.TABLE_NAME,
'CREATE OR REPLACE TRIGGER '||t.owner||'.'||r.DESCRIPTION||SBREXT.MDSR_SUBSTR_LONG(trigger_name,r.owner)TRIG_BODY 
from all_trigGers r ,all_tables t
where trigger_name like '%BIU_ROW_TRM_SPC'
and t.table_name=r.table_name
order by 1,4;

select 'DROP trigger '||TRIGGER_NAME||';'
from all_trigGers r 
where trigger_name like '%BIU_ROW_TRM_SPC';

order by 1,4;

select r.OWNER,t.OWNER,TRIGGER_NAME,t.TABLE_NAME,'CREATE OR REPLACE TRIGGER '||r.DESCRIPTION||SBREXT.MDSR_SUBSTR_LONG(trigger_name,r.owner)TRIG_BODY 
from all_trigGers r ,all_tables t
where trigger_name like '%BIU_ROW_TRM_SPC'
and t.table_name=r.table_name
order by 2,4;

select owner,TRIGGER_NAME,TABLE_NAME,DESCRIPTION,TRIGGER_BODY 
from all_trigGers where trigger_name like '%BIU_ROW_TRM_SPC';


--SELECT rowid from all_trigGers where trigger_name like '%BIU_ROW_TRM_SPC';
--search_long(rowid)
CREATE OR REPLACE FUNCTION SBREXT.MDSR_SUBSTR_LONG ( trigger_name_in varchar2,owner_in varchar2)  RETURN varchar2 IS
    incoming    varchar2(32767);
    return_hold varchar2(4000);
Begin
    select TRIGGER_BODY into incoming from all_triggers
     where trigger_name = trigger_name_in
     and owner=owner_in;
    return_hold := substr(trim(incoming),1,3999);
    return return_hold;
END;
create or replace function search_long(r rowid) return varchar2 is
temporary_varchar varchar2(4000);
begin
select TRIGGER_BODY into temporary_varchar from all_triggers where rowid=r;
return temporary_varchar;
end;
select MDSR_SUBSTR_LONG(TRIGGER_BODY)TRIG_BODY from all_trigGers where trigger_name like '%BIU_ROW_TRM_SPC';


drop trigger SBREXT.VD_BIU_ROW_TRM_SPC
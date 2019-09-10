set serveroutput on size 1000000
SPOOL cadsrmeta-762.log  
CREATE TABLE SBR.DESIGNATION_TYPES_TEMP
(
  DETL_NAME      VARCHAR2(20 BYTE)              ,
  DESCRIPTION    VARCHAR2(60 BYTE),
  COMMENTS       VARCHAR2(2000 BYTE)
)
/
GRANT SELECT ON  SBR.DESIGNATION_TYPES_TEMP TO READONLY
/
GRANT SELECT ON  SBR.DESIGNATION_TYPES_TEMP TO GUEST
/
CREATE OR REPLACE procedure SBR.MDSR_INS_DES_TYPE
as
cursor c_desig  is select * from SBR.DESIGNATION_TYPES_TEMP;
v_ctn number;
errm varchar2(200);
begin
for i in c_desig loop

    select count(*) into v_ctn from SBR.DESIGNATION_TYPES_LOV
      where trim(DETL_NAME ) = trim(i.DETL_NAME );
 if V_ctn=0 then
begin   
   Insert into SBR.DESIGNATION_TYPES_LOV
   ( DETL_NAME,  DESCRIPTION,  COMMENTS,DATE_CREATED , CREATED_BY) VALUES (i.DETL_NAME,  i.DESCRIPTION,  i.COMMENTS, sysdate, 'SBR');
commit;
   EXCEPTION
   WHEN OTHERS then
   errm := substr(SQLERRM,1,100);
   insert into MDSR_designations_load_err ( NAME, COMMENTS,LOADDATE) values (i.DETL_NAME,'Error During insert '|| errm, sysdate);
        commit;
   end;
   else
    insert into MDSR_designations_load_err ( NAME, COMMENTS,LOADDATE) values (i.DETL_NAME,'Duplicate Type', sysdate);
 
        commit;
        end if;
   end loop;
commit;

end;
/
SPOOL OFF
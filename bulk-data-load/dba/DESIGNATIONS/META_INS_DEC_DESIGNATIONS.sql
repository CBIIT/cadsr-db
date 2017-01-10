set serveroutput on size 1000000
SPOOL cadsrmeta-637p.log
CREATE OR REPLACE procedure SBR.MDSR_INS_DEC_DESIGNATIONS
as
cursor c_desig is select * from MDSR_DESIGNATIONS_UPLOAD for update;
ac_id DESIGNATIONS.AC_IDSEQ%TYPE;
con_id DESIGNATIONS.CONTE_IDSEQ%TYPE;   
cursor c_ins is select * from MDSR_DES_UPLOAD_VW where conte_idseq is not null and ac_idseq is not null;
t_desig_id designations.desig_idseq%TYPE;
errm varchar2(200);
begin
for i in c_desig loop
    begin
    select conte_idseq into con_id from contexts_view where name = i.context;
    update MDSR_DESIGNATIONS_UPLOAD set conte_idseq = con_id where current of c_desig;
    exception
    when NO_DATA_FOUND then
    insert into MDSR_designations_load_err (PUBLICID, VERSION, LONGNAME, TYPE, CREATEDBY,
        DATECREATED, DATEMODIFIED, ID, LANGUAGENAME, MODIFIEDBY,
        NAME, TYPE2, DESIGNATIONCLASSSCHEMEITEMCOL, CONTEXT, AC_IDSEQ,
        CONTE_IDSEQ, COMMENTS, LOADDATE) values (i.PUBLICID, i.VERSION, i.LONGNAME, i.TYPE, i.CREATEDBY,
        i.DATECREATED, i.DATEMODIFIED, i.ID, i.LANGUAGENAME, i.MODIFIEDBY,
        i.NAME, i.TYPE2, i.DESIGNATIONCLASSSCHEMEITEMCOL, i.CONTEXT, i.AC_IDSEQ,
        i.CONTE_IDSEQ, 'Context ID Not Found.', sysdate);
         end;

    Begin
    select DEC_IDSEQ into ac_id from DATA_ELEMENT_CONCEPTS  where dec_id = i.publicid and version = i.version;
    update MDSR_DESIGNATIONS_UPLOAD set ac_idseq = ac_id where current of c_desig;
       EXCEPTION
    WHEN NO_DATA_FOUND then
    insert into MDSR_designations_load_err (PUBLICID, VERSION, LONGNAME, TYPE, CREATEDBY,
        DATECREATED, DATEMODIFIED, ID, LANGUAGENAME, MODIFIEDBY,
        NAME, TYPE2, DESIGNATIONCLASSSCHEMEITEMCOL, CONTEXT, AC_IDSEQ,
        CONTE_IDSEQ, COMMENTS, LOADDATE) values (i.PUBLICID, i.VERSION, i.LONGNAME, i.TYPE, i.CREATEDBY,
        i.DATECREATED, i.DATEMODIFIED, i.ID, i.LANGUAGENAME, i.MODIFIEDBY,
        i.NAME, i.TYPE2, i.DESIGNATIONCLASSSCHEMEITEMCOL, i.CONTEXT, i.AC_IDSEQ,
        i.CONTE_IDSEQ, 'DEC ID Not Found.', sysdate);
        End;
end loop;
commit;
dbms_output.put_line ('Update Complete....');
for i in c_ins loop
   select sbr.admincomponent_crud.cmr_guid into t_desig_id from dual;
   begin
   Insert into SBR.DESIGNATIONS
   (DESIG_IDSEQ, AC_IDSEQ, CONTE_IDSEQ, NAME, DETL_NAME, DATE_CREATED, CREATED_BY, LAE_NAME) VALUES (t_desig_id, i.ac_idseq, i.conte_idseq,i.name,i.type2  , sysdate, i.createdby, i.languagename);
commit;
   EXCEPTION
   WHEN OTHERS then
   errm := SQLERRM;
   insert into MDSR_designations_load_err (PUBLICID, VERSION, LONGNAME, TYPE, CREATEDBY,
        DATECREATED, DATEMODIFIED, ID, LANGUAGENAME, MODIFIEDBY,
        NAME, TYPE2, DESIGNATIONCLASSSCHEMEITEMCOL, CONTEXT, AC_IDSEQ,
        CONTE_IDSEQ, COMMENTS, LOADDATE) values (i.PUBLICID, i.VERSION, i.LONGNAME, i.TYPE, i.CREATEDBY,
        i.DATECREATED, i.DATEMODIFIED, i.ID, i.LANGUAGENAME, i.MODIFIEDBY,
        i.NAME, i.TYPE2, i.DESIGNATIONCLASSSCHEMEITEMCOL, i.CONTEXT, i.AC_IDSEQ,
        i.CONTE_IDSEQ,'Error During insert '|| errm, sysdate);
        commit;
   end;
   end loop;
commit;

end;
/
exec SBR.MDSR_INS_DEC_DESIGNATIONS;
SPOOL OFF
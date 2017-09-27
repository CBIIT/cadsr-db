set serveroutput on size 1000000
SPOOL cadsrmeta-581c.log

CREATE OR REPLACE procedure SBREXT.MDSR_CEATE_DESIGNATIONS(P_NAME IN VARCHAR2 DEFAULT 'P')
as
cursor c_desig is select * from SBREXT.MDSR_DESIGNATIONS_UPLOAD for update;
ac_id SBR.DESIGNATIONS.AC_IDSEQ%TYPE;
con_id SBR.DESIGNATIONS.CONTE_IDSEQ%TYPE;
cursor c_ins is select * from SBREXT.MDSR_DES_UPLOAD_VW where conte_idseq is not null and ac_idseq is not null;
t_desig_id SBR.designations.desig_idseq%TYPE;
errm varchar2(500);
begin
for i in c_desig loop
    begin
    select conte_idseq into con_id from contexts_view where name = NVL(i.context,'NCIP');
    update SBREXT.MDSR_DESIGNATIONS_UPLOAD set conte_idseq = con_id where current of c_desig;
    exception
    when NO_DATA_FOUND then
    insert into SBREXT.MDSR_designations_load_err (PUBLICID, VERSION, LONGNAME, TYPE, CREATEDBY,
        DATECREATED, DATEMODIFIED, ID, LANGUAGENAME, MODIFIEDBY,
        NAME, TYPE2, DESIGNATIONCLASSSCHEMEITEMCOL, CONTEXT, AC_IDSEQ,
        CONTE_IDSEQ, COMMENTS, LOADDATE) values (i.PUBLICID, i.VERSION, i.LONGNAME, i.TYPE, i.CREATEDBY,
        i.DATECREATED, i.DATEMODIFIED, i.ID, i.LANGUAGENAME, i.MODIFIEDBY,
        i.NAME, i.TYPE2, i.DESIGNATIONCLASSSCHEMEITEMCOL, i.CONTEXT, i.AC_IDSEQ,
        i.CONTE_IDSEQ, 'Context ID Not Found.', sysdate);
         end;

    Begin
    
    IF P_NAME='DATA_ELEMENTS' THEN
    select DE_IDSEQ into ac_id from SBR.DATA_ELEMENTS  where cde_id = i.publicid and version = i.version;
    ELSIF P_NAME='VALUE_DOMAINS' THEN
    select vd_idseq into ac_id from SBR.VALUE_DOMAINS where vd_id = i.publicid and version = i.version;
    ELSIF P_NAME='VALUE_MEANINGS' THEN
    select vm_idseq into ac_id from SBR.value_meanings where vm_id = i.publicid and version = i.version;
    ELSIF P_NAME='DATA_ELEMENT_CONCEPTS' THEN
    select DEC_IDSEQ into ac_id from SBR.DATA_ELEMENT_CONCEPTS  where dec_id = i.publicid and version = i.version;
    ELSIF P_NAME='OBJECT_CLASSES_EXT' THEN
    select OC_IDSEQ into ac_id from SBREXT.OBJECT_CLASSES_EXT  where oc_id = i.publicid and version = i.version;
     ELSIF P_NAME='PROPERTIES_EXT' THEN
    select PROP_IDSEQ into ac_id from SBREXT.PROPERTIES_EXT  where prop_id = i.publicid and version = i.version;
    ELSE
     insert into SBREXT.MDSR_designations_load_err (PUBLICID, VERSION, LONGNAME, TYPE, CREATEDBY,
        DATECREATED, DATEMODIFIED, ID, LANGUAGENAME, MODIFIEDBY,
        NAME, TYPE2, DESIGNATIONCLASSSCHEMEITEMCOL, CONTEXT, AC_IDSEQ,
        CONTE_IDSEQ, COMMENTS, LOADDATE) values (i.PUBLICID, i.VERSION, i.LONGNAME, i.TYPE, i.CREATEDBY,
        i.DATECREATED, i.DATEMODIFIED, i.ID, i.LANGUAGENAME, i.MODIFIEDBY,
        i.NAME, i.TYPE2, i.DESIGNATIONCLASSSCHEMEITEMCOL, i.CONTEXT, i.AC_IDSEQ,
        i.CONTE_IDSEQ, P_NAME||' Public ID is Not Found.', sysdate);
        END if;
    update SBREXT.MDSR_DESIGNATIONS_UPLOAD set ac_idseq = ac_id where current of c_desig;
       EXCEPTION
    WHEN NO_DATA_FOUND then
    insert into SBREXT.MDSR_designations_load_err (PUBLICID, VERSION, LONGNAME, TYPE, CREATEDBY,
        DATECREATED, DATEMODIFIED, ID, LANGUAGENAME, MODIFIEDBY,
        NAME, TYPE2, DESIGNATIONCLASSSCHEMEITEMCOL, CONTEXT, AC_IDSEQ,
        CONTE_IDSEQ, COMMENTS, LOADDATE) values (i.PUBLICID, i.VERSION, i.LONGNAME, i.TYPE, i.CREATEDBY,
        i.DATECREATED, i.DATEMODIFIED, i.ID, i.LANGUAGENAME, i.MODIFIEDBY,
        i.NAME, i.TYPE2, i.DESIGNATIONCLASSSCHEMEITEMCOL, i.CONTEXT, i.AC_IDSEQ,
        i.CONTE_IDSEQ, P_NAME||' Public ID is Not Found.', sysdate);
        End;
end loop;
commit;
dbms_output.put_line ('Update Complete....');
for i in c_ins loop
   select sbr.admincomponent_crud.cmr_guid into t_desig_id from dual;
   begin
   Insert into SBR.DESIGNATIONS
   (DESIG_IDSEQ, AC_IDSEQ, CONTE_IDSEQ, NAME, DETL_NAME, DATE_CREATED, CREATED_BY, LAE_NAME) VALUES (t_desig_id, i.ac_idseq, i.conte_idseq,i.name,i.type2  , sysdate, i.createdby,  NVL(i.LANGUAGENAME,'ENGLISH'));
commit;
   EXCEPTION
   WHEN OTHERS then
   errm := substr(SQLERRM,1,450);
   insert into SBREXT.MDSR_designations_load_err (PUBLICID, VERSION, LONGNAME, TYPE, CREATEDBY,
        DATECREATED, DATEMODIFIED, ID, LANGUAGENAME, MODIFIEDBY,
        NAME, TYPE2, DESIGNATIONCLASSSCHEMEITEMCOL, CONTEXT, AC_IDSEQ,
        CONTE_IDSEQ, COMMENTS, LOADDATE) values (i.PUBLICID, i.VERSION, i.LONGNAME, i.TYPE, i.CREATEDBY,
        i.DATECREATED, i.DATEMODIFIED, i.ID, NVL(i.LANGUAGENAME,'ENGLISH'), i.MODIFIEDBY,
        i.NAME, i.TYPE2, i.DESIGNATIONCLASSSCHEMEITEMCOL, i.CONTEXT, i.AC_IDSEQ,
        i.CONTE_IDSEQ,'Error During insert '|| errm, sysdate);
        commit;
   end;
   end loop;
commit;

end;
/
exec SBREXT.MDSR_CEATE_DESIGNATIONS('DATA_ELEMENTS');
SPOOL OFF
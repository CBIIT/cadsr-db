DROP PROCEDURE SBR.INS_DESIGNATIONS;

CREATE OR REPLACE procedure SBR.INS_DESIGNATIONS
as
cursor c_desig is select * from temp_designations for update;
ac_id DESIGNATIONS.AC_IDSEQ%TYPE;
con_id DESIGNATIONS.CONTE_IDSEQ%TYPE;
cursor c_ins is select * from temp_designations where conte_idseq is not null and ac_idseq is not null;
t_desig_id designations.desig_idseq%TYPE;
errm varchar2(200);
begin
for i in c_desig loop
    begin
    select conte_idseq into con_id from contexts_view where name = i.context;
    update temp_designations set conte_idseq = con_id where current of c_desig;
    exception
    when NO_DATA_FOUND then
    insert into designations_load_err (PUBLICID, VERSION, LONGNAME, TYPE, CREATEDBY,
        DATECREATED, DATEMODIFIED, ID, LANGUAGENAME, MODIFIEDBY,
        NAME, TYPE2, DESIGNATIONCLASSSCHEMEITEMCOL, CONTEXT, AC_IDSEQ,
        CONTE_IDSEQ, COMMENTS, LOADDATE) values (i.PUBLICID, i.VERSION, i.LONGNAME, i.TYPE, i.CREATEDBY,
        i.DATECREATED, i.DATEMODIFIED, i.ID, i.LANGUAGENAME, i.MODIFIEDBY,
        i.NAME, i.TYPE2, i.DESIGNATIONCLASSSCHEMEITEMCOL, i.CONTEXT, i.AC_IDSEQ,
        i.CONTE_IDSEQ, 'Context ID Not Found.', sysdate);
    end;

    Begin
    select vm_idseq into ac_id from value_meanings where vm_id = i.publicid and version = i.version;
    update temp_designations set ac_idseq = ac_id where current of c_desig;
    EXCEPTION
    WHEN NO_DATA_FOUND then
    insert into designations_load_err (PUBLICID, VERSION, LONGNAME, TYPE, CREATEDBY,
        DATECREATED, DATEMODIFIED, ID, LANGUAGENAME, MODIFIEDBY,
        NAME, TYPE2, DESIGNATIONCLASSSCHEMEITEMCOL, CONTEXT, AC_IDSEQ,
        CONTE_IDSEQ, COMMENTS, LOADDATE) values (i.PUBLICID, i.VERSION, i.LONGNAME, i.TYPE, i.CREATEDBY,
        i.DATECREATED, i.DATEMODIFIED, i.ID, i.LANGUAGENAME, i.MODIFIEDBY,
        i.NAME, i.TYPE2, i.DESIGNATIONCLASSSCHEMEITEMCOL, i.CONTEXT, i.AC_IDSEQ,
        i.CONTE_IDSEQ, 'VM ID Not Found.', sysdate);
    End;
end loop;
commit;
dbms_output.put_line ('Update Complete....');
for i in c_ins loop
   select sbr.admincomponent_crud.cmr_guid into t_desig_id from dual;
   begin
   Insert into SBR.DESIGNATIONS
   (DESIG_IDSEQ, AC_IDSEQ, CONTE_IDSEQ, NAME, DETL_NAME, DATE_CREATED, CREATED_BY, LAE_NAME) VALUES (t_desig_id, i.ac_idseq, i.conte_idseq,i.name,i.type2  , sysdate, i.createdby, i.languagename);

   EXCEPTION
   WHEN OTHERS then
   errm := SQLERRM;
   insert into designations_load_err (PUBLICID, VERSION, LONGNAME, TYPE, CREATEDBY,
        DATECREATED, DATEMODIFIED, ID, LANGUAGENAME, MODIFIEDBY,
        NAME, TYPE2, DESIGNATIONCLASSSCHEMEITEMCOL, CONTEXT, AC_IDSEQ,
        CONTE_IDSEQ, COMMENTS, LOADDATE) values (i.PUBLICID, i.VERSION, i.LONGNAME, i.TYPE, i.CREATEDBY,
        i.DATECREATED, i.DATEMODIFIED, i.ID, i.LANGUAGENAME, i.MODIFIEDBY,
        i.NAME, i.TYPE2, i.DESIGNATIONCLASSSCHEMEITEMCOL, i.CONTEXT, i.AC_IDSEQ,
        i.CONTE_IDSEQ,'Error During insert '|| errm, sysdate);
   end;
   end loop;
commit;

end;
 
/


DROP PROCEDURE SBR.MDSR_CLEAN_DE_QUEST;

CREATE OR REPLACE PROCEDURE SBR.MDSR_CLEAN_DE_QUEST AS
cursor C_DE is
 select  cde_id, version, ASL_NAME, latest_version_ind, DE_IDSEQ, Question
from sbr.data_elements ,
( select AC_IDSEQ from sbr.REFERENCE_DOCUMENTS where DCTL_NAME = 'Preferred Question Text' )RD_PQT
where  QUESTION is not NULL
and DE_IDSEQ=AC_IDSEQ(+)
and AC_IDSEQ is null;

errmsg VARCHAR2(2000):='';
BEGIN
for i in C_DE loop
begin

UPDATE SBR.DATA_ELEMENTS set QUESTION=NULL
where DE_IDSEQ=i.DE_IDSEQ;

commit;
dbms_output.put_line('cde_id, version:'||i.cde_id||'v'||i.version);
  EXCEPTION
    WHEN OTHERS THEN
        errmsg := SQLERRM;
        dbms_output.put_line('errmsg - '||errmsg||', '||' cde_id, version:'||i.cde_id||'v'||i.version);
        raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
 end;
  end loop;

END MDSR_CLEAN_DE_QUEST;
/


DROP PROCEDURE SBR.MDSR_DELETE_CONTEXT;

CREATE OR REPLACE PROCEDURE SBR.MDSR_DELETE_CONTEXT(p_Context_name in varchar) AS
/*Procedure was created to update CONTE_IDSEQ in allrelated to Context tables
  1.parametr p_Context_old presents Context name which has to be replaced by new.
  2.parametr pp_Context_new presents new Context name

*/

Vold_conte_idseq VARCHAR2(60);
Vnew_conte_idseq VARCHAR2(60);
V_cnt_old number;
V_cnt_new number;
V_error VARCHAR2(2000);

BEGIN

V_error := NULL;
select COUNT(*) into V_cnt_old from SBR.contexts where name =p_Context_name ;--and version=p_ver_CNT;
IF V_cnt_old=0 THEN
insert into SBR.MDSR_MODIFY_ERR_LOG VALUES('SBR.MDSR_DELETE_CONTEXT','SBR.contexts', sysdate ,p_Context_name||': Context does not exist.');
commit;
END IF;


IF V_cnt_old>0 THEN
select conte_idseq into Vold_conte_idseq from SBR.contexts where name =p_Context_name ;

select COUNT(*) into V_cnt_old from SBR.ADMINISTERED_COMPONENTS  where CONTE_IDSEQ=Vold_conte_idseq;
If V_cnt_old>0 THEN
V_error:=V_error||'SBR.ADMINISTERED_COMPONENTS,';
END if;

select COUNT(*) into V_cnt_old from SBR.CLASSIFICATION_SCHEMES  where CONTE_IDSEQ=Vold_conte_idseq;
If V_cnt_old>0 THEN
V_error:=V_error||'SBR.CLASSIFICATION_SCHEMES,';
END if;

select COUNT(*) into V_cnt_old from SBR.CONCEPTUAL_DOMAINS  where CONTE_IDSEQ=Vold_conte_idseq;
If V_cnt_old>0 THEN
V_error:=V_error||'SBR.CONCEPTUAL_DOMAINS,';
END if;

select COUNT(*) into V_cnt_old from SBR.CS_ITEMS  where CONTE_IDSEQ=Vold_conte_idseq;
If V_cnt_old>0 THEN
V_error:=V_error||'SBR.CS_ITEMS,';
END if;
select COUNT(*) into V_cnt_old from SBR.DATA_ELEMENTS  where CONTE_IDSEQ=Vold_conte_idseq;
If V_cnt_old>0 THEN
V_error:=V_error||'SBR.DATA_ELEMENTS,';
END if;
select COUNT(*) into V_cnt_old from SBR.DATA_ELEMENTS_BU  where CONTE_IDSEQ=Vold_conte_idseq;
If V_cnt_old>0 THEN
V_error:=V_error||'SBR.DATA_ELEMENTS_BU,';
END if;
select COUNT(*) into V_cnt_old from SBR.DATA_ELEMENT_CONCEPTS  where CONTE_IDSEQ=Vold_conte_idseq;
If V_cnt_old>0 THEN
V_error:=V_error||'SBR.DATA_ELEMENT_CONCEPTS,';
END if;
select COUNT(*) into V_cnt_old from SBR.DEFINITIONS  where CONTE_IDSEQ=Vold_conte_idseq;
If V_cnt_old>0 THEN
V_error:='SBR.DEFINITIONS,';
END if;
select COUNT(*) into V_cnt_old from SBR.DESIGNATIONS  where CONTE_IDSEQ=Vold_conte_idseq;
If V_cnt_old>0 THEN
V_error:=V_error||'SBR.DESIGNATIONS ,';
END if;
select COUNT(*) into V_cnt_old from SBR.REFERENCE_DOCUMENTS  where CONTE_IDSEQ=Vold_conte_idseq;
If V_cnt_old>0 THEN
V_error:='SBR.REFERENCE_DOCUMENTS,';
END if;

select COUNT(*) into V_cnt_old from SBR.VALUE_DOMAINS  where CONTE_IDSEQ=Vold_conte_idseq;
If V_cnt_old>0 THEN
V_error:=V_error||'SBR.VALUE_DOMAINS,';
END if;
select COUNT(*) into V_cnt_old from SBR.VALUE_MEANINGS  where CONTE_IDSEQ=Vold_conte_idseq;
If V_cnt_old>0 THEN
V_error:=V_error||'SBR.VALUE_MEANINGS,';
END if;
select COUNT(*) into V_cnt_old from SBR.VD_PVS  where CONTE_IDSEQ=Vold_conte_idseq;
If V_cnt_old>0 THEN
V_error:=V_error||'SBR.VD_PVS,';
END if;
select COUNT(*) into V_cnt_old from SBREXT.CONCEPTS_EXT  where CONTE_IDSEQ=Vold_conte_idseq;
If V_cnt_old>0 THEN
V_error:=V_error||'SBREXT.CONCEPTS_EXT,';
END if;
select COUNT(*) into V_cnt_old from SBREXT.OBJECT_CLASSES_EXT  where CONTE_IDSEQ=Vold_conte_idseq;
If V_cnt_old>0 THEN
V_error:=V_error||'SBREXT.OBJECT_CLASSES_EXT,';
END if;
select COUNT(*) into V_cnt_old from SBREXT.OC_RECS_EXT  where CONTE_IDSEQ=Vold_conte_idseq;
If V_cnt_old>0 THEN
V_error:=V_error||'SBREXT.OC_RECS_EXT,';
END if;
select COUNT(*) into V_cnt_old from SBREXT.PROPERTIES_EXT  where CONTE_IDSEQ=Vold_conte_idseq;
If V_cnt_old>0 THEN
V_error:='SBREXT.PROPERTIES_EXT,';
END if;
select COUNT(*) into V_cnt_old from SBREXT.PROTOCOLS_EXT  where CONTE_IDSEQ=Vold_conte_idseq;
If V_cnt_old>0 THEN
V_error:=V_error||'SBREXT.PROTOCOLS_EXT,';
END if;
select COUNT(*) into V_cnt_old from SBREXT.QUEST_CONTENTS_EXT  where CONTE_IDSEQ=Vold_conte_idseq;
If V_cnt_old>0 THEN
V_error:=V_error||'SBREXT.QUEST_CONTENTS_EXT,';
END if;
select COUNT(*) into V_cnt_old from SBREXT.REPRESENTATIONS_EXT  where CONTE_IDSEQ=Vold_conte_idseq;
If V_cnt_old>0 THEN
V_error:=V_error||'SBREXT.REPRESENTATIONS_EXT,';
END if;
select COUNT(*) into V_cnt_old from SBREXT.SN_RECIPIENT_EXT  where CONTE_IDSEQ=Vold_conte_idseq;
If V_cnt_old>0 THEN
V_error:=V_error||'SBREXT.SN_RECIPIENT_EXT,';
END if;
select COUNT(*) into V_cnt_old from SBREXT.STAGE_LOAD_PDF  where CONTE_IDSEQ=Vold_conte_idseq;
If V_cnt_old>0 THEN
V_error:=V_error||'SBREXT.STAGE_LOAD_PDF,';
END if;

END if;


If V_error is NOT NULL THEN
BEGIN
V_error:='Following tables reference to '||p_Context_name||':'||V_error;
insert into SBR.MDSR_MODIFY_ERR_LOG VALUES('SBR.MDSR_DELETE_CONTEXT','TABLES', sysdate ,V_error);
    commit;
     exception
  when others then
    V_error := substr(SQLERRM,1,1000);
      insert into SBR.MDSR_MODIFY_ERR_LOG VALUES('SBR.MDSR_DELETE_CONTEXT', 'TABLES',sysdate ,V_error);
     commit;
 END;
ELSE

V_error:=NULL;
BEGIN

BEGIN
delete from   SBR.UA_BUSINESS_ROLES   where  SCUA_IDSEQ  in (select SCUA_IDSEQ from SBR.SC_USER_ACCOUNTS where trim(scl_name) like p_Context_name||'%');
commit;
exception
when others then
    V_error := substr(SQLERRM,1,1000);
      insert into SBR.MDSR_MODIFY_ERR_LOG VALUES('SBR.MDSR_DELETE_CONTEXT', 'UA_BUSINESS_ROLES',sysdate ,V_error);
     commit;
END;

BEGIN
delete SBR.SC_USER_ACCOUNTS where trim(scl_name) like p_Context_name||'%';
commit;
exception
when others then
    V_error := substr(SQLERRM,1,1000);
      insert into SBR.MDSR_MODIFY_ERR_LOG VALUES('SBR.MDSR_DELETE_CONTEXT', 'SBR.SC_USER_ACCOUNTS',sysdate ,V_error);
     commit;
END;


BEGIN
delete SBR.AC_WF_RULES where trim(scl_name) like p_Context_name||'%';
  commit;
exception
when others then
    V_error := substr(SQLERRM,1,1000);
      insert into SBR.MDSR_MODIFY_ERR_LOG VALUES('SBR.MDSR_DELETE_CONTEXT', 'SBR.AC_WF_RULES',sysdate ,V_error);
     commit;
END;

BEGIN
delete SBR.AC_ACTIONS_MATRIX where trim(scl_name) like p_Context_name||'%';
  commit;
exception
when others then
    V_error := substr(SQLERRM,1,1000);
      insert into SBR.MDSR_MODIFY_ERR_LOG VALUES('SBR.MDSR_DELETE_CONTEXT', 'SBR.AC_ACTIONS_MATRIX',sysdate ,V_error);
     commit;
END;

BEGIN
delete SBR.GROUP_RECS where trim(CHILD_GRP_NAME) like p_Context_name||'%';
  commit;
exception
when others then
    V_error := substr(SQLERRM,1,1000);
      insert into SBR.MDSR_MODIFY_ERR_LOG VALUES('SBR.MDSR_DELETE_CONTEXT', 'SBR.GROUP_RECS',sysdate ,V_error);
     commit;
END;
/**/
BEGIN
delete SBR.SECURITY_CONTEXTS_LOV where trim(scl_name) like p_Context_name||'%';
  commit;
exception
when others then
    V_error := substr(SQLERRM,1,1000);
      insert into SBR.MDSR_MODIFY_ERR_LOG VALUES('SBR.MDSR_DELETE_CONTEXT', 'SBR.SECURITY_CONTEXTS_LOV',sysdate ,V_error);
     commit;
END;

BEGIN
delete SBR.USER_GROUPS where trim(grp_name) like p_Context_name||'%';
commit;
exception
when others then
    V_error := substr(SQLERRM,1,1000);
      insert into SBR.MDSR_MODIFY_ERR_LOG VALUES('SBR.MDSR_DELETE_CONTEXT', 'SBR.USER_GROUPS',sysdate ,V_error);
     commit;
END;

BEGIN
delete SBR.GROUPS where trim(grp_name) like p_Context_name||'%';
  commit;
exception
when others then
    V_error := substr(SQLERRM,1,1000);
      insert into SBR.MDSR_MODIFY_ERR_LOG VALUES('SBR.MDSR_DELETE_CONTEXT', 'SBR.GROUPS',sysdate ,V_error);
     commit;
END;

BEGIN
delete SBR.SC_CONTEXTS  where CONTE_IDSEQ=Vold_conte_idseq;
  commit;
exception
when others then
   V_error := substr(SQLERRM,1,1000);
      insert into SBR.MDSR_MODIFY_ERR_LOG VALUES('SBR.MDSR_DELETE_CONTEXT', 'SBR.SC_CONTEXTS',sysdate ,V_error);
     commit;
END;


BEGIN
delete SBR.CONTEXTS where trim(name) = p_Context_name;
exception
when others then
  V_error := substr(SQLERRM,1,1000);
      insert into SBR.MDSR_MODIFY_ERR_LOG VALUES('SBR.MDSR_DELETE_CONTEXT', 'CONTEXTS',sysdate ,V_error);
     commit;
END;


BEGIN
delete from SBR.GRP_BUSINESS_ROLES_VIEW where SCG_IDSEQ in (select SCG_IDSEQ from sbr.sc_groups where trim(SCL_NAME) like p_Context_name||'%');
exception
when others then
  V_error := substr(SQLERRM,1,1000);
      insert into SBR.MDSR_MODIFY_ERR_LOG VALUES('SBR.MDSR_DELETE_CONTEXT', 'SBR.GRP_BUSINESS_ROLES_VIEW',sysdate ,V_error);
     commit;
END;

BEGIN
delete from  sbr.sc_groups where trim(SCL_NAME) like p_Context_name||'%';
exception
when others then
  V_error := substr(SQLERRM,1,1000);
      insert into SBR.MDSR_MODIFY_ERR_LOG VALUES('SBR.MDSR_DELETE_CONTEXT', 'SBR.SC_GROUPS',sysdate ,V_error);
  commit;
END;
 commit;

exception
when others then
  V_error:=substr(SQLERRM,1,1000);
      insert into SBR.MDSR_MODIFY_ERR_LOG VALUES('SBR.MDSR_DELETE_CONTEXT', 'ALL',sysdate ,V_error);
  commit;
END;
END IF;

exception
when others then
  V_error:=substr(SQLERRM,1,1000);
        insert into SBR.MDSR_MODIFY_ERR_LOG VALUES('SBR.MDSR_DELETE_CONTEXT', 'ALL',sysdate ,V_error);
     commit;
END MDSR_DELETE_CONTEXT;
/


DROP PROCEDURE SBR.MDSR_INS_DEC_DESIGNATIONS;

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


DROP PROCEDURE SBR.MDSR_UPD_CONTE_IDSEQ;

CREATE OR REPLACE PROCEDURE SBR.MDSR_UPD_CONTE_IDSEQ(p_Context_old in varchar,p_Context_new in varchar,p_userName in varchar DEFAULT USER) AS
/*Procedure was created to update CONTE_IDSEQ in allrelated to Context tables
  1.parametr p_Context_old presents Context name which has to be replaced by new.
  2.parametr pp_Context_new presents new Context name

*/

Vold_conte_idseq VARCHAR2(60);
Vnew_conte_idseq VARCHAR2(60);
V_cnt_old number;
V_cnt_new number;
V_error VARCHAR2(2000);
V_error_VD VARCHAR2(2000);
V_user VARCHAR2(60);
V_PN_SUFF VARCHAR2(60);

BEGIN

V_PN_SUFF:=trim(p_Context_old);

V_error := NULL;
IF p_userName is null THEN
v_user:='USER';
else
v_user:=p_userName;
END IF;

select COUNT(*) into V_cnt_old from contexts where name =p_Context_old ;--and version=p_ver_CNT;
IF V_cnt_old=0 THEN
V_error :='Old Context does not exist. ';
END IF;
select COUNT(*) into V_cnt_new from contexts where name =p_Context_new ;
IF V_cnt_new=0 THEN
V_error :=V_error||' Newd Context does not exist. ';
END IF;


If V_error is NOT NULL
THEN
insert into SBR.MDSR_MODIFY_ERR_LOG VALUES('MDSR_UPD_CONTE_IDSEQ','1', sysdate ,V_error);
    commit;

ELSE
select conte_idseq into Vold_conte_idseq from contexts where name =p_Context_old ;
select conte_idseq into Vnew_conte_idseq from contexts where name =p_Context_new ;

dbms_output.put_line('error:'||V_error||',V_old:'||V_cnt_old||','||p_Context_old||'conte_IDSEQ:'||Vold_conte_idseq||';V_newd:'||V_cnt_new||','||p_Context_new||'conte_IDSEQ:'||Vnew_conte_idseq);

BEGIN

V_error := NULL;
UPDATE SBR.ADMINISTERED_COMPONENTS set CONTE_IDSEQ=Vnew_conte_idseq,PREFERRED_NAME=SUBSTR(V_PN_SUFF||'-'||PREFERRED_NAME,1,30),MODIFIED_BY=v_user,DATE_MODIFIED=SYSDATE where CONTE_IDSEQ=Vold_conte_idseq;
commit;
exception
when NO_DATA_FOUND THEN
NULL;
when others then
  V_error:=V_PN_SUFF||','||substr(SQLERRM,1,1000);

      insert into SBR.MDSR_MODIFY_ERR_LOG VALUES('MDSR_UPD_CONTE_IDSEQ','SBR.ADMINISTERED_COMPONENTS', sysdate ,V_error);
     commit;
     END;

BEGIN

V_error := NULL;
UPDATE SBR.CLASSIFICATION_SCHEMES set CONTE_IDSEQ=Vnew_conte_idseq,PREFERRED_NAME=SUBSTR(V_PN_SUFF||'-'||PREFERRED_NAME,1,30),MODIFIED_BY=v_user,DATE_MODIFIED=SYSDATE where CONTE_IDSEQ=Vold_conte_idseq;
commit;
exception
when NO_DATA_FOUND THEN
null;
when others then
   V_error:=substr(SQLERRM,1,1000);
      insert into SBR.MDSR_MODIFY_ERR_LOG VALUES('MDSR_UPD_CONTE_IDSEQ','SBR.CLASSIFICATION_SCHEMES', sysdate ,V_error);
     commit;
END;
BEGIN

V_error := NULL;
UPDATE SBR.CONCEPTUAL_DOMAINS set CONTE_IDSEQ=Vnew_conte_idseq,PREFERRED_NAME=SUBSTR(V_PN_SUFF||'-'||PREFERRED_NAME,1,30),MODIFIED_BY=v_user,DATE_MODIFIED=SYSDATE where CONTE_IDSEQ=Vold_conte_idseq;
commit;
exception
when NO_DATA_FOUND THEN
null;
when others then
  V_error := substr(SQLERRM,1,1000);

      insert into SBR.MDSR_MODIFY_ERR_LOG VALUES('MDSR_UPD_CONTE_IDSEQ','SBR.CONCEPTUAL_DOMAINS', sysdate ,V_error);
     commit;
END;

BEGIN
V_error := NULL;
UPDATE SBR.CS_ITEMS set CONTE_IDSEQ=Vnew_conte_idseq,PREFERRED_NAME=SUBSTR(V_PN_SUFF||'-'||PREFERRED_NAME,1,30),MODIFIED_BY=v_user,DATE_MODIFIED=SYSDATE where CONTE_IDSEQ=Vold_conte_idseq;
commit;
exception
when NO_DATA_FOUND THEN
null;
when others then
  V_error := substr(SQLERRM,1,1000);
      insert into SBR.MDSR_MODIFY_ERR_LOG VALUES('MDSR_UPD_CONTE_IDSEQ','SBR.CS_ITEMS', sysdate ,V_error);
     commit;
END;

BEGIN
V_error := NULL;
UPDATE SBR.DATA_ELEMENTS set CONTE_IDSEQ=Vnew_conte_idseq,PREFERRED_NAME=SUBSTR(V_PN_SUFF||'-'||PREFERRED_NAME,1,30),MODIFIED_BY=v_user,DATE_MODIFIED=SYSDATE where CONTE_IDSEQ=Vold_conte_idseq;
commit;
exception
when NO_DATA_FOUND THEN
null;
when others then
  V_error:=substr(SQLERRM,1,1000);
  --  V_error := substr(SQLERRM,1,2000);
      insert into SBR.MDSR_MODIFY_ERR_LOG VALUES('MDSR_UPD_CONTE_IDSEQ','SBR.DATA_ELEMENTS', sysdate ,V_error);
     commit;
END;
BEGIN
V_error := NULL;
UPDATE SBR.DATA_ELEMENTS_BU set CONTE_IDSEQ=Vnew_conte_idseq,PREFERRED_NAME=SUBSTR(V_PN_SUFF||'-'||PREFERRED_NAME,1,30),MODIFIED_BY=v_user,DATE_MODIFIED=SYSDATE where CONTE_IDSEQ=Vold_conte_idseq;
commit;
exception
when NO_DATA_FOUND THEN
null;
when others then
  V_error := substr(SQLERRM,1,1000);
  --  V_error := substr(SQLERRM,1,2000);
      insert into SBR.MDSR_MODIFY_ERR_LOG VALUES('MDSR_UPD_CONTE_IDSEQ','SBR.DATA_ELEMENTS_BU', sysdate ,V_error);
     commit;
END;
BEGIN
V_error := NULL;
UPDATE SBR.DATA_ELEMENT_CONCEPTS set CONTE_IDSEQ=Vnew_conte_idseq,PREFERRED_NAME=SUBSTR(V_PN_SUFF||'-'||PREFERRED_NAME,1,30),MODIFIED_BY=v_user,DATE_MODIFIED=SYSDATE where CONTE_IDSEQ=Vold_conte_idseq;
commit;
exception
when NO_DATA_FOUND THEN
null;
when others then
  V_error := substr(SQLERRM,1,1000);
  --  V_error := substr(SQLERRM,1,2000);
      insert into SBR.MDSR_MODIFY_ERR_LOG VALUES('MDSR_UPD_CONTE_IDSEQ','SBR.DATA_ELEMENT_CONCEPTS', sysdate ,V_error);
     commit;
END;
BEGIN
V_error := NULL;
UPDATE SBR.DEFINITIONS set CONTE_IDSEQ=Vnew_conte_idseq,MODIFIED_BY=v_user,DATE_MODIFIED=SYSDATE where CONTE_IDSEQ=Vold_conte_idseq;
commit;
exception
when NO_DATA_FOUND THEN
null;
when others then
  V_error := substr(SQLERRM,1,1000);
  --  V_error := substr(SQLERRM,1,2000);
      insert into SBR.MDSR_MODIFY_ERR_LOG VALUES('MDSR_UPD_CONTE_IDSEQ','SBR.DEFINITIONS', sysdate ,V_error);
     commit;
END;
BEGIN
V_error := NULL;
UPDATE SBR.DESIGNATIONS set CONTE_IDSEQ=Vnew_conte_idseq,MODIFIED_BY=v_user,DATE_MODIFIED=SYSDATE where CONTE_IDSEQ=Vold_conte_idseq;
commit;
exception
when NO_DATA_FOUND THEN
null;
when others then
  V_error := substr(SQLERRM,1,1000);
  --  V_error := substr(SQLERRM,1,2000);
      insert into SBR.MDSR_MODIFY_ERR_LOG VALUES('MDSR_UPD_CONTE_IDSEQ','SBR.DESIGNATIONS', sysdate ,V_error);
     commit;
END;
BEGIN
V_error := NULL;
UPDATE SBR.REFERENCE_DOCUMENTS set CONTE_IDSEQ=Vnew_conte_idseq,MODIFIED_BY=v_user,DATE_MODIFIED=SYSDATE where CONTE_IDSEQ=Vold_conte_idseq;
commit;
exception
when NO_DATA_FOUND THEN
null;
when others then
  V_error := substr(SQLERRM,1,1000);

      insert into SBR.MDSR_MODIFY_ERR_LOG VALUES('MDSR_UPD_CONTE_IDSEQ','SBR.REFERENCE_DOCUMENTS', sysdate ,V_error);
     commit;
END;
BEGIN
V_error_VD := NULL;
UPDATE SBR.VALUE_DOMAINS set CONTE_IDSEQ=Vnew_conte_idseq,PREFERRED_NAME=SUBSTR(V_PN_SUFF||'-'||PREFERRED_NAME,1,30),MODIFIED_BY=v_user,DATE_MODIFIED=SYSDATE where CONTE_IDSEQ=Vold_conte_idseq;
commit;
exception
when NO_DATA_FOUND THEN
null;
when others then
  V_error_VD := substr(SQLERRM,1,1000);

      insert into SBR.MDSR_MODIFY_ERR_LOG VALUES('MDSR_UPD_CONTE_IDSEQ','SBR.VALUE_DOMAINS', sysdate ,V_error_VD);
     commit;
END;
BEGIN
V_error := NULL;
UPDATE SBR.VALUE_MEANINGS set CONTE_IDSEQ=Vnew_conte_idseq,PREFERRED_NAME=SUBSTR(V_PN_SUFF||'-'||PREFERRED_NAME,1,30),MODIFIED_BY=v_user,DATE_MODIFIED=SYSDATE where CONTE_IDSEQ=Vold_conte_idseq;
commit;
exception
when NO_DATA_FOUND THEN
null;
when others then
  V_error := substr(SQLERRM,1,1000);

      insert into SBR.MDSR_MODIFY_ERR_LOG VALUES('MDSR_UPD_CONTE_IDSEQ','SBR.VALUE_MEANINGS', sysdate ,V_error);
     commit;
END;
BEGIN
IF V_error_VD is null then
BEGIN
V_error := NULL;
--UPDATE SBR.VD_PVS set CONTE_IDSEQ=Vnew_conte_idseq,MODIFIED_BY=v_user,DATE_MODIFIED=SYSDATE where CONTE_IDSEQ=Vold_conte_idseq;
merge into SBR.VD_PVS VD_PVS
   using (select VD.CONTE_IDSEQ,vd.vd_idseq ,pv.pv_idseq
   from
    SBR.VD_PVS VD_PVS,
SBR.VALUE_DOMAINS vd,
sbr.permissible_VALUES pv,
sbr.contexts c
  where vd.vd_idseq=VD_PVS.VD_IDSEQ
  and VD_PVS.PV_IDSEQ=pv.pv_idseq
  and c.name=p_Context_old
  and VD_PVS.CONTE_IDSEQ=c.CONTE_IDSEQ )VD
 on (VD.vd_idseq=VD_PVS.VD_IDSEQ
 and VD_PVS.PV_IDSEQ=vd.pv_idseq)
when matched then update set VD_PVS.CONTE_IDSEQ = vd.CONTE_IDSEQ;

commit;
exception

when others then
  V_error := substr(SQLERRM,1,1000);

      insert into SBR.MDSR_MODIFY_ERR_LOG VALUES('MDSR_UPD_CONTE_IDSEQ','SBR.VD_PVS', sysdate ,V_error);
     commit;
 end;
 else
   insert into SBR.MDSR_MODIFY_ERR_LOG VALUES('MDSR_UPD_CONTE_IDSEQ','SBR.VD_PVS', sysdate ,'Failed to update VD:'||V_error_VD);
     commit;
 end if;
END;
BEGIN
V_error := NULL;
UPDATE SBREXT.CONCEPTS_EXT set CONTE_IDSEQ=Vnew_conte_idseq,PREFERRED_NAME=SUBSTR(V_PN_SUFF||'-'||PREFERRED_NAME,1,30),MODIFIED_BY=v_user,DATE_MODIFIED=SYSDATE where CONTE_IDSEQ=Vold_conte_idseq;
commit;
exception
when NO_DATA_FOUND THEN
null;
when others then
  V_error := substr(SQLERRM,1,1000);

      insert into SBR.MDSR_MODIFY_ERR_LOG VALUES('MDSR_UPD_CONTE_IDSEQ','SBREXT.CONCEPTS_EXT', sysdate ,V_error);
     commit;
END;
BEGIN
V_error := NULL;
UPDATE SBREXT.OBJECT_CLASSES_EXT set CONTE_IDSEQ=Vnew_conte_idseq,PREFERRED_NAME=SUBSTR(V_PN_SUFF||'-'||PREFERRED_NAME,1,30),MODIFIED_BY=v_user,DATE_MODIFIED=SYSDATE where CONTE_IDSEQ=Vold_conte_idseq;
commit;
exception
when NO_DATA_FOUND THEN
null;
when others then
  V_error := substr(SQLERRM,1,1000);

      insert into SBR.MDSR_MODIFY_ERR_LOG VALUES('MDSR_UPD_CONTE_IDSEQ','SBREXT.OBJECT_CLASSES_EXT', sysdate ,V_error);
     commit;
END;
BEGIN
V_error := NULL;
UPDATE SBREXT.OC_RECS_EXT set CONTE_IDSEQ=Vnew_conte_idseq,PREFERRED_NAME=SUBSTR(V_PN_SUFF||'-'||PREFERRED_NAME,1,30),MODIFIED_BY=v_user,DATE_MODIFIED=SYSDATE where CONTE_IDSEQ=Vold_conte_idseq;
commit;
exception
when NO_DATA_FOUND THEN
null;
when others then
  V_error := substr(SQLERRM,1,1000);

      insert into SBR.MDSR_MODIFY_ERR_LOG VALUES('MDSR_UPD_CONTE_IDSEQ','SBREXT.OC_RECS_EXT', sysdate ,V_error);
     commit;
END;
BEGIN
V_error := NULL;
UPDATE SBREXT.PROPERTIES_EXT set CONTE_IDSEQ=Vnew_conte_idseq,PREFERRED_NAME=SUBSTR(V_PN_SUFF||'-'||PREFERRED_NAME,1,30),MODIFIED_BY=v_user,DATE_MODIFIED=SYSDATE where CONTE_IDSEQ=Vold_conte_idseq;
commit;
exception
when NO_DATA_FOUND THEN
null;
when others then
  V_error := substr(SQLERRM,1,1000);

      insert into SBR.MDSR_MODIFY_ERR_LOG VALUES('MDSR_UPD_CONTE_IDSEQ','SBREXT.PROPERTIES_EXT', sysdate ,V_error);
     commit;
END;
BEGIN
V_error := NULL;
UPDATE SBREXT.PROTOCOLS_EXT set CONTE_IDSEQ=Vnew_conte_idseq,PREFERRED_NAME=SUBSTR(V_PN_SUFF||'-'||PREFERRED_NAME,1,30),MODIFIED_BY=v_user,DATE_MODIFIED=SYSDATE where CONTE_IDSEQ=Vold_conte_idseq;
commit;
exception
when NO_DATA_FOUND THEN
null;
when others then
  V_error := substr(SQLERRM,1,1000);

      insert into SBR.MDSR_MODIFY_ERR_LOG VALUES('MDSR_UPD_CONTE_IDSEQ','SBREXT.PROTOCOLS_EXT', sysdate ,V_error);
     commit;
END;
BEGIN
V_error := NULL;
UPDATE SBREXT.QUEST_CONTENTS_EXT set CONTE_IDSEQ=Vnew_conte_idseq,PREFERRED_NAME=SUBSTR(V_PN_SUFF||'-'||PREFERRED_NAME,1,30),MODIFIED_BY=v_user,DATE_MODIFIED=SYSDATE where CONTE_IDSEQ=Vold_conte_idseq;
commit;
exception
when NO_DATA_FOUND THEN
null;
when others then
  V_error := substr(SQLERRM,1,1000);

      insert into SBR.MDSR_MODIFY_ERR_LOG VALUES('MDSR_UPD_CONTE_IDSEQ','SBREXT.QUEST_CONTENTS_EXT', sysdate ,V_error);
     commit;
END;
BEGIN
V_error := NULL;
UPDATE SBREXT.REPRESENTATIONS_EXT set CONTE_IDSEQ=Vnew_conte_idseq,PREFERRED_NAME=SUBSTR(V_PN_SUFF||'-'||PREFERRED_NAME,1,30),MODIFIED_BY=v_user,DATE_MODIFIED=SYSDATE where CONTE_IDSEQ=Vold_conte_idseq;
commit;
exception
when NO_DATA_FOUND THEN
null;
when others then
  V_error := substr(SQLERRM,1,1000);

      insert into SBR.MDSR_MODIFY_ERR_LOG VALUES('MDSR_UPD_CONTE_IDSEQ','SBREXT.REPRESENTATIONS_EXT', sysdate ,V_error);
     commit;
END;
BEGIN
V_error := NULL;
UPDATE SBREXT.SN_RECIPIENT_EXT set CONTE_IDSEQ=Vnew_conte_idseq,MODIFIED_BY=v_user,DATE_MODIFIED=SYSDATE where CONTE_IDSEQ=Vold_conte_idseq;
commit;
exception
when NO_DATA_FOUND THEN
null;
when others then
  V_error := substr(SQLERRM,1,1000);

      insert into SBR.MDSR_MODIFY_ERR_LOG VALUES('MDSR_UPD_CONTE_IDSEQ','SBREXT.SN_RECIPIENT_EXT', sysdate ,V_error);
     commit;
END;
BEGIN
V_error := NULL;
UPDATE SBREXT.STAGE_LOAD_PDF set CONTE_IDSEQ=Vnew_conte_idseq where CONTE_IDSEQ=Vold_conte_idseq;
commit;
exception
when NO_DATA_FOUND THEN
null;
when others then
  V_error := substr(SQLERRM,1,1000);

      insert into SBR.MDSR_MODIFY_ERR_LOG VALUES('MDSR_UPD_CONTE_IDSEQ','SBREXT.STAGE_LOAD_PDF', sysdate ,V_error);
     commit;
END;

END if;
exception
when NO_DATA_FOUND THEN
null;
when others then
  V_error:=V_error||','||substr(SQLERRM,1,1000);

      insert into SBR.MDSR_MODIFY_ERR_LOG VALUES('MDSR_UPD_CONTE_IDSEQ','', sysdate ,V_error);

     commit;
END MDSR_UPD_CONTE_IDSEQ;
/


DROP PROCEDURE SBR.MDSR_UPD_PV_END_DATE;

CREATE OR REPLACE procedure SBR.MDSR_upd_pv_end_date
as
errmsg VARCHAR2(500);
begin
update PERMISSIBLE_VALUES set end_date=to_date('10/06/2016','mm/dd/yyyy') ,MODIFIED_BY='DWARZEL',DATE_MODIFIED=SYSDATE
where PV_IDSEQ in(
select p.PV_IDSEQ from VD_PVS v,
value_domains d,
PERMISSIBLE_VALUES p
where d.VD_ID=2181490
 and v.VD_IDSEQ = d.VD_IDSEQ
 and v.conte_idseq=d.conte_idseq
 and p.PV_IDSEQ=v.PV_IDSEQ
 and p.value in ('progression/relapse','Toxicities','Unknown')
 and d.version=1);
commit;
update VD_PVS set end_date=to_date('10/06/2016','mm/dd/yyyy') ,MODIFIED_BY='DWARZEL',DATE_MODIFIED=SYSDATE
where VP_IDSEQ in(
select v.VP_IDSEQ from VD_PVS v,
value_domains d,
PERMISSIBLE_VALUES p
where d.VD_ID=2181490
 and v.VD_IDSEQ = d.VD_IDSEQ
 and v.conte_idseq=d.conte_idseq
 and p.PV_IDSEQ=v.PV_IDSEQ
 and p.value in ('progression/relapse','Toxicities','Unknown')
 and d.version=1);
commit;
EXCEPTION
    WHEN OTHERS THEN
        errmsg := SQLERRM;
        insert into PERMISSIBLE_VALUES_ERR(VALUE_DOMAIN_ID,VALUE_DOMAIN_VER,LONGNAME,comments,DATE_PROCESSED) VALUES (2181490, 1, 'progression/relapse'||',Toxicities'||',Unknown', errmsg, sysdate);

 commit;
end;
/


DROP PROCEDURE SBR.META_FIX_CD_VMS;

CREATE OR REPLACE PROCEDURE SBR.META_FIX_CD_VMS IS
v_date  date  ;
V_sdate date:=sysdate;
errmsg VARCHAR2(2000):='Non';
/******************************************************************************where
   NAME:       META_FIX_CD_VMS
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        8/11/2016   trushi2       1. Created this procedure.

   NOTES:
      Object Name:     META_FIX_SP_CHAR_PV
      Sysdate:         8/11/2016
      Date and Time:   8/11/2016, 12:31:43 PM, and 8/11/2016 12:31:43 PM
      Username:        trushi2 (set in TOAD Options, Procedure Editor)

******************************************************************************/
BEGIN


select to_date(to_char(sysdate,'mm/dd/yyyy')||'12:34:56','mm/dd/yyyyhh24:mi:ss')
into v_date from dual;

insert into SBR.CT_CD_VMS_BKUP
(CV_IDSEQ,
CD_IDSEQ            ,
SHORT_MEANING        ,
DESCRIPTION  ,
DATE_MODIFIED       ,
DATE_INSERT,
MODIFIED_BY         ,
VM_IDSEQ
)

select CV_IDSEQ,
CD_IDSEQ            ,
SHORT_MEANING        ,
DESCRIPTION  ,
DATE_MODIFIED       ,
SYSDATE,
MODIFIED_BY         ,
VM_IDSEQ
from SBR.CD_VMS
WHERE SBREXT.meta_FIND_SP_CHAR(short_meaning)>0 or SBREXT.meta_FIND_SP_CHAR(DESCRIPTION)>0 ;

commit;

UPDATE SBR.CD_VMS set
date_modified=v_date, modified_by='DWARZEL',
short_meaning=SBREXT.meta_CleanSP_CHAR(short_meaning)
where SBREXT.meta_FIND_SP_CHAR(short_meaning)>0;

UPDATE SBR.CD_VMS set
date_modified=v_date, modified_by='DWARZEL',
DESCRIPTION=SBREXT.meta_CleanSP_CHAR(DESCRIPTION)
where SBREXT.meta_FIND_SP_CHAR(DESCRIPTION)>0 ;

 commit;

 EXCEPTION
    WHEN OTHERS THEN
    errmsg := substr(SQLERRM,1,2000);
     dbms_output.put_line('errmsg  - '||errmsg);
     insert into SBREXT.META_SPCHAR_ERROR_LOG VALUES('META_FIX_CD_VMS',   sysdate ,errmsg);

     commit;
END META_FIX_CD_VMS;
/


DROP PROCEDURE SBR.META_FIX_DATA_ELEMENTS;

CREATE OR REPLACE PROCEDURE SBR.META_FIX_DATA_ELEMENTS IS
v_date  date  ;
V_sdate date:=sysdate;
errmsg VARCHAR2(2000):='Non';
/******************************************************************************
   NAME:       META_FIX_QUEST_CONTENTS_EXT
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        8/11/2016   trushi2       1. Created this procedure.

   NOTES:
      Object Name:     META_FIX_sp_char_VM
      Sysdate:         8/11/2016
      Date and Time:   8/11/2016, 12:31:43 PM, and 8/11/2016 12:31:43 PM
      Username:        trushi2 (set in TOAD Options, Procedure Editor)

******************************************************************************/
BEGIN


select to_date(to_char(sysdate,'mm/dd/yyyy')||'12:34:56','mm/dd/yyyyhh24:mi:ss')
into v_date from dual;

insert into  SBR.CT_DATA_ELEMENTS_BKUP
(
           DE_IDSEQ ,
           PREFERRED_DEFINITION,
           LONG_NAME,
           DATE_MODIFIED,
           DATE_INSERT,
           MODIFIED_BY
)

select     DE_IDSEQ ,
           PREFERRED_DEFINITION,
           LONG_NAME,
           DATE_MODIFIED,
           SYSDATE    ,
           MODIFIED_BY
from SBR.DATA_ELEMENTS
where SBREXT.meta_FIND_SP_CHAR(PREFERRED_DEFINITION)>0 ;
commit;

 UPDATE SBR.DATA_ELEMENTS set
date_modified=v_date, modified_by='DWARZEL',
LONG_NAME=SBREXT.meta_CleanSP_CHAR(LONG_NAME)
where SBREXT.meta_FIND_SP_CHAR(LONG_NAME)>0 ;


UPDATE SBR.DATA_ELEMENTS set
date_modified=v_date, modified_by='DWARZEL',
PREFERRED_DEFINITION=SBREXT.meta_CleanSP_CHAR(PREFERRED_DEFINITION)
where SBREXT.meta_FIND_SP_CHAR(PREFERRED_DEFINITION)>0 ;

 commit;
    EXCEPTION

    WHEN OTHERS THEN
       errmsg := substr(SQLERRM,1,2000);
         dbms_output.put_line('errmsg  - '||errmsg);
        insert into SBREXT.META_SPCHAR_ERROR_LOG VALUES('META_FIX_DATA_ELEMENTS',   sysdate ,errmsg);

     commit;
END META_FIX_DATA_ELEMENTS;
/


DROP PROCEDURE SBR.META_FIX_DATA_ELEMENT_CONC;

CREATE OR REPLACE PROCEDURE SBR.META_FIX_DATA_ELEMENT_CONC IS
v_date  date  ;
V_sdate date:=sysdate;
errmsg VARCHAR2(2000):='Non';
/******************************************************************************
   NAME:       META_FIX_DATA_ELEMENT_CONCEPTS11G
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        8/11/2016   trushi2       1. Created this procedure.

   NOTES:
      Object Name:     META_FIX_sp_char_VM
      Sysdate:         8/11/2016
      Date and Time:   8/11/2016, 12:31:43 PM, and 8/11/2016 12:31:43 PM
      Username:        trushi2 (set in TOAD Options, Procedure Editor)

******************************************************************************/
BEGIN


select to_date(to_char(sysdate,'mm/dd/yyyy')||'12:34:56','mm/dd/yyyyhh24:mi:ss')
into v_date from dual;

insert into  SBR.CT_DATA_ELEMENT_CONCEPTS_BKUP
(
           DEC_IDSEQ ,
           PREFERRED_DEFINITION,
           LONG_NAME,
           DATE_MODIFIED,
           DATE_INSERT,
           MODIFIED_BY
)

select     DEC_IDSEQ ,
           PREFERRED_DEFINITION,
           LONG_NAME,
           DATE_MODIFIED,
           SYSDATE    ,
           MODIFIED_BY
from SBR.DATA_ELEMENT_CONCEPTS
where SBREXT.meta_FIND_SP_CHAR(LONG_NAME)>0
or SBREXT.meta_FIND_SP_CHAR(PREFERRED_DEFINITION)>0 ;
commit;

 UPDATE SBR.DATA_ELEMENT_CONCEPTS set
date_modified=v_date, modified_by='DWARZEL',
LONG_NAME=SBREXT.meta_CleanSP_CHAR(LONG_NAME)
where SBREXT.meta_FIND_SP_CHAR(LONG_NAME)>0 ;


UPDATE SBR.DATA_ELEMENT_CONCEPTS set
date_modified=v_date, modified_by='DWARZEL',
PREFERRED_DEFINITION=SBREXT.meta_CleanSP_CHAR(PREFERRED_DEFINITION)
where SBREXT.meta_FIND_SP_CHAR(PREFERRED_DEFINITION)>0 ;

 commit;
    EXCEPTION
    WHEN OTHERS THEN
       errmsg := substr(SQLERRM,1,2000);
        insert into SBREXT.META_SPCHAR_ERROR_LOG VALUES('META_FIX_DATA_ELEMENT_CONC',   sysdate ,errmsg);

     commit;
END META_FIX_DATA_ELEMENT_CONC;
/


DROP PROCEDURE SBR.META_FIX_REF_DOC;

CREATE OR REPLACE PROCEDURE SBR.META_FIX_REF_DOC IS
v_date  date  ;
V_sdate date:=sysdate;
errmsg VARCHAR2(2000):='Non';
/******************************************************************************
   NAME:       META_FIX_REF_DOC
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        8/11/2016   trushi2       1. Created this procedure.

   NOTES:
      Object Name:     META_FIX_REF_DOC
      Sysdate:         8/11/2016
      Date and Time:   8/11/2016, 12:31:43 PM, and 8/11/2016 12:31:43 PM
      Username:        trushi2 (set in TOAD Options, Procedure Editor)

******************************************************************************/
BEGIN


insert into SBR.CT_REF_DOC_BKUP
(
RD_IDSEQ,
ORG_IDSEQ    ,
AC_IDSEQ   ,
ACH_IDSEQ   ,
AR_IDSEQ      ,
NAME         ,
DOC_TEXT ,
DATE_MODIFIED       ,
DATE_INSERT,
MODIFIED_BY,
COMMENTS
)

select
r.RD_IDSEQ,
r.ORG_IDSEQ    ,
r.AC_IDSEQ   ,
r.ACH_IDSEQ   ,
r.AR_IDSEQ      ,
r.NAME         ,
r.DOC_TEXT ,
r.DATE_MODIFIED       ,
SYSDATE,
R.MODIFIED_BY,
'Duplicate'
from SBR.REFERENCE_DOCUMENTS r,
SBR.REFERENCE_DOCUMENTS g
where
r.DCTL_NAME=g.DCTL_NAME
and r.AC_IDSEQ=g.AC_IDSEQ
and  SBREXT.meta_CleanSP_CHAR(r.NAME )=SBREXT.meta_CleanSP_CHAR(g.NAME) --replace(replace(replace(g.name,'&'||'#8804','<='),'&'||'#8805','>='),'&'||'#8800','>=')
and r.RD_IDSEQ<>g.RD_IDSEQ
and SBREXT.meta_FIND_SP_CHAR(r.NAME )>0
and r.RD_IDSEQ not in (select distinct RD_IDSEQ from SBR.CT_REF_DOC_BKUP where comments='Duplicate') ;

commit;

select to_date(to_char(sysdate,'mm/dd/yyyy')||'12:34:56','mm/dd/yyyyhh24:mi:ss')
into v_date from dual;



insert into SBR.CT_REF_DOC_BKUP
(
RD_IDSEQ,
ORG_IDSEQ    ,
AC_IDSEQ   ,
ACH_IDSEQ   ,
AR_IDSEQ      ,
NAME         ,
DOC_TEXT ,
DATE_MODIFIED       ,
DATE_INSERT,
MODIFIED_BY
)

select
RD_IDSEQ,
ORG_IDSEQ    ,
AC_IDSEQ   ,
ACH_IDSEQ   ,
AR_IDSEQ      ,
NAME         ,
DOC_TEXT ,
DATE_MODIFIED       ,
SYSDATE,
MODIFIED_BY
from SBR.REFERENCE_DOCUMENTS
where (SBREXT.meta_FIND_SP_CHAR(NAME)>0 or SBREXT.meta_FIND_SP_CHAR(DOC_TEXT)>0 )
and RD_IDSEQ not in (select distinct RD_IDSEQ from SBR.CT_REF_DOC_BKUP where comments='Duplicate') ;
commit;

UPDATE SBR.REFERENCE_DOCUMENTS set
date_modified=v_date, modified_by='DWARZEL',
NAME=SBREXT.meta_CleanSP_CHAR(name)
where SBREXT.meta_FIND_SP_CHAR(NAME)>0
and RD_IDSEQ not in (select distinct RD_IDSEQ from SBR.CT_REF_DOC_BKUP where comments='Duplicate') ;


UPDATE SBR.REFERENCE_DOCUMENTS set
date_modified=v_date, modified_by='DWARZEL',
DOC_TEXT=SBREXT.meta_CleanSP_CHAR(DOC_TEXT)
where SBREXT.meta_FIND_SP_CHAR(DOC_TEXT)>0
and RD_IDSEQ not in (select distinct RD_IDSEQ from SBR.CT_REF_DOC_BKUP where comments='Duplicate') ;

 commit;

 EXCEPTION
    WHEN OTHERS THEN
    errmsg := substr(SQLERRM,1,2000);
    insert into SBREXT.META_SPCHAR_ERROR_LOG VALUES('META_FIX_REF_DOC',   sysdate ,errmsg);

     commit;
END META_FIX_REF_DOC;
/


DROP PROCEDURE SBR.META_FIX_SP_CHAR_PV;

CREATE OR REPLACE PROCEDURE SBR.META_FIX_SP_CHAR_PV IS
v_date  date  ;
V_sdate date:=sysdate;
errmsg VARCHAR2(2000):='Non';
/******************************************************************************
   NAME:       META_FIX_sp_char_PV
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        8/11/2016   trushi2       1. Created this procedure.

   NOTES:
      Object Name:     META_FIX_SP_CHAR_PV
      Sysdate:         8/11/2016
      Date and Time:   8/11/2016, 12:31:43 PM, and 8/11/2016 12:31:43 PM
      Username:        trushi2 (set in TOAD Options, Procedure Editor)

******************************************************************************/
BEGIN


select to_date(to_char(sysdate,'mm/dd/yyyy')||'12:34:56','mm/dd/yyyyhh24:mi:ss')
into v_date from dual;

insert into SBR.CT_PERMISSIBLE_VALUES_BKUP
(
PV_IDSEQ            ,
VALUE               ,
SHORT_MEANING        ,
MEANING_DESCRIPTION  ,
DATE_MODIFIED       ,
DATE_INSERT,
MODIFIED_BY         ,
VM_IDSEQ
)

select PV_IDSEQ            ,
VALUE               ,
SHORT_MEANING        ,
MEANING_DESCRIPTION  ,
DATE_MODIFIED       ,
SYSDATE,
MODIFIED_BY         ,
VM_IDSEQ
from SBR.PERMISSIBLE_VALUES
WHERE SBREXT.meta_FIND_SP_CHAR(short_meaning)>0 or SBREXT.meta_FIND_SP_CHAR(MEANING_DESCRIPTION)>0 ;
commit;

UPDATE SBR.PERMISSIBLE_VALUES set
date_modified=v_date, modified_by='DWARZEL',
short_meaning=SBREXT.meta_CleanSP_CHAR(short_meaning)
where SBREXT.meta_FIND_SP_CHAR(short_meaning)>0;


UPDATE SBR.PERMISSIBLE_VALUES set
date_modified=v_date, modified_by='DWARZEL',
MEANING_DESCRIPTION=SBREXT.meta_CleanSP_CHAR(MEANING_DESCRIPTION)
where SBREXT.meta_FIND_SP_CHAR(MEANING_DESCRIPTION)>0 ;
 commit;

 EXCEPTION
    WHEN OTHERS THEN
    errmsg := substr(SQLERRM,1,2000);
    insert into SBREXT.META_SPCHAR_ERROR_LOG VALUES('META_FIX_SP_CHAR_PV',   sysdate ,errmsg);

     commit;
END META_FIX_SP_CHAR_PV;
/


DROP PROCEDURE SBR.META_FIX_SP_CHAR_VM;

CREATE OR REPLACE PROCEDURE SBR.META_FIX_SP_CHAR_VM IS
tmpVar NUMBER;
V_date date:=sysdate;
errmsg VARCHAR2(2000):='Non';
/******************************************************************************
   NAME:       META_FIX_sp_char_VM
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        8/11/2016   trushi2       1. Created this procedure.

   NOTES:
      Object Name:     META_FIX_sp_char_VM
      Sysdate:         8/11/2016
      Date and Time:   8/11/2016, 12:31:43 PM, and 8/11/2016 12:31:43 PM
      Username:        trushi2 (set in TOAD Options, Procedure Editor)

******************************************************************************/
BEGIN

select to_date(to_char(sysdate,'mm/dd/yyyy')||'12:34:56','mm/dd/yyyyhh24:mi:ss')
into v_date from dual;

insert into  SBR.CT_VALUE_MEANINGS_BKUP
(
  SHORT_MEANING        ,
  DESCRIPTION         ,
  DATE_MODIFIED        ,
  DATE_INSERT,
  MODIFIED_BY          ,
  VM_IDSEQ              ,
  PREFERRED_NAME        ,
  PREFERRED_DEFINITION  ,
  LONG_NAME             ,
  VERSION              ,
  VM_ID                 ,
  CHANGE_NOTE
)
select SHORT_MEANING        ,
  DESCRIPTION         ,
  DATE_MODIFIED        ,
  SYSDATE        ,
  MODIFIED_BY          ,
  VM_IDSEQ              ,
  PREFERRED_NAME        ,
  PREFERRED_DEFINITION  ,
  LONG_NAME             ,
  VERSION              ,
  VM_ID                ,
  CHANGE_NOTE
from SBR.VALUE_MEANINGS
where SBREXT.meta_FIND_SP_CHAR(short_meaning)>0
or SBREXT.meta_FIND_SP_CHAR(LONG_NAME)>0
or SBREXT.meta_FIND_SP_CHAR(PREFERRED_DEFINITION)>0
or SBREXT.meta_FIND_SP_CHAR(DESCRIPTION)>0 ;
commit;


UPDATE SBR.VALUE_MEANINGS set
date_modified=v_date, modified_by='DWARZEL',
short_meaning=SBREXT.meta_CleanSP_CHAR(short_meaning)
where  SBREXT.meta_FIND_SP_CHAR(short_meaning)>0;

UPDATE SBR.VALUE_MEANINGS set
date_modified=v_date, modified_by='DWARZEL',
DESCRIPTION=SBREXT.meta_CleanSP_CHAR(DESCRIPTION)
where SBREXT.meta_FIND_SP_CHAR(DESCRIPTION)>0 ;

UPDATE SBR.VALUE_MEANINGS set
date_modified=v_date, modified_by='DWARZEL',
LONG_NAME=SBREXT.meta_CleanSP_CHAR(LONG_NAME)
where SBREXT.meta_FIND_SP_CHAR(LONG_NAME)>0 ;


UPDATE SBR.VALUE_MEANINGS set
date_modified=v_date, modified_by='DWARZEL',
preferred_definition=SBREXT.meta_CleanSP_CHAR(preferred_definition)
where SBREXT.meta_FIND_SP_CHAR(PREFERRED_DEFINITION)>0 ;

commit;
  EXCEPTION
   WHEN OTHERS THEN
    rollback;
    errmsg := substr(SQLERRM,1,2000);
         dbms_output.put_line('errmsg  - '||errmsg);
        insert into SBREXT.META_SPCHAR_ERROR_LOG VALUES('META_FIX_SP_CHAR_VM',   sysdate ,errmsg);

     commit;
END META_FIX_SP_CHAR_VM;
/


DROP PROCEDURE SBR.META_FIX_VALUE_DOMAINS;

CREATE OR REPLACE PROCEDURE SBR.META_FIX_VALUE_DOMAINS IS
v_date  date  ;
V_sdate date:=sysdate;
errmsg VARCHAR2(2000):='Non';
/******************************************************************************
   NAME:       META_FIX_VALUE_DOMAINS
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        8/11/2016   trushi2       1. Created this procedure.

   NOTES:
      Object Name:     META_FIX_sp_char_VM
      Sysdate:         8/11/2016
      Date and Time:   8/11/2016, 12:31:43 PM, and 8/11/2016 12:31:43 PM
      Username:        trushi2 (set in TOAD Options, Procedure Editor)

******************************************************************************/
BEGIN


select to_date(to_char(sysdate,'mm/dd/yyyy')||'12:34:56','mm/dd/yyyyhh24:mi:ss')
into v_date from dual;

insert into  SBR.CT_VALUE_DOMAINS_BKUP
(
            VD_IDSEQ   ,
            VD_ID ,
            VERSION ,
           PREFERRED_NAME,
           PREFERRED_DEFINITION,
           LONG_NAME,
           DATE_MODIFIED,
           DATE_INSERT,
           MODIFIED_BY
)

select     VD_IDSEQ   ,
           VD_ID ,
           VERSION ,
           PREFERRED_NAME,
           PREFERRED_DEFINITION,
           LONG_NAME,
           DATE_MODIFIED,
           SYSDATE    ,
           MODIFIED_BY
from SBR.VALUE_DOMAINS
where SBREXT.meta_FIND_SP_CHAR(LONG_NAME)>0
or SBREXT.meta_FIND_SP_CHAR(PREFERRED_DEFINITION)>0 ;
commit;

 UPDATE SBR.VALUE_DOMAINS set
date_modified=v_date, modified_by='DWARZEL',
LONG_NAME=SBREXT.meta_CleanSP_CHAR(LONG_NAME)
where SBREXT.meta_FIND_SP_CHAR(LONG_NAME)>0 ;


UPDATE SBR.VALUE_DOMAINS set
date_modified=v_date, modified_by='DWARZEL',
preferred_definition=SBREXT.meta_CleanSP_CHAR(preferred_definition)
where SBREXT.meta_FIND_SP_CHAR(PREFERRED_DEFINITION)>0 ;

 commit;
    EXCEPTION

    WHEN OTHERS THEN
       errmsg := substr(SQLERRM,1,2000);
         dbms_output.put_line('errmsg  - '||errmsg);
        insert into SBREXT.META_SPCHAR_ERROR_LOG VALUES('META_FIX_VALUE_DOMAINS',   sysdate ,errmsg);

     commit;
END META_FIX_VALUE_DOMAINS;
/


DROP PROCEDURE SBR.META_UPLOAD_CONTACT_SP;

CREATE OR REPLACE PROCEDURE SBR.META_UPLOAD_CONTACT_SP IS

---contacts do not exist
CURSOR C1 IS
select distinct u.Public_ID,u.VERSION ,u.RANK_ORDER,
u.ORGANISATION,u.LNAME,u.FNAME, u.CTL_NAME ,u.CYBER_ADDRESS
from SBR.META_UPLOAD_CONTACT u
 left outer join  SBR.CONTACT_COMMS c
 on c.ctl_name=u.ctl_name
 and c.cyber_address=u.cyber_address
 where  ccomm_IDSEQ is null;

 ---CDE do not exist
CURSOR C2 IS
select distinct u.Public_ID,u.VERSION,u.RANK_ORDER,
u.ORGANISATION,u.LNAME,u.FNAME, u.CTL_NAME ,u.CYBER_ADDRESS
from SBR.META_UPLOAD_CONTACT u
 left outer join  SBR.DATA_ELEMENTS  e
 on cde_id=  Public_ID
 and u.version=e.version
 where  DE_IDSEQ is null;

---CDE have contacts
CURSOR C3 IS
select distinct u.Public_ID,u.VERSION,u.RANK_ORDER,
u.ORGANISATION,u.LNAME,u.FNAME, u.CTL_NAME ,u.CYBER_ADDRESS,C.ORG_IDSEQ,C.PER_IDSEQ
from SBR.META_UPLOAD_CONTACT u
inner join  SBR.DATA_ELEMENTS  e
on cde_id=  Public_ID
and u.version=e.version
inner join SBREXT.CABIO31_AC_CONTACTS_VIEW  c
on DE_IDSEQ=AC_IDSEQ;

errmsg VARCHAR(110);
v_cnt NUMBER ;
v_check NUMBER;


 v_PERID VARCHAR(50);
 v_ORGID VARCHAR(50);

BEGIN

---contacts do not exist
select count(*) into v_cnt from
SBR.META_UPLOAD_CONTACT u
 left outer join  SBR.CONTACT_COMMS c
 on c.ctl_name=u.ctl_name
 and c.cyber_address=u.cyber_address
 where  ccomm_IDSEQ is null;

 IF(v_cnt > 0) THEN
 FOR q_rec IN C1 LOOP
  BEGIN


   insert into SBR.META_UPLOAD_ERROR_LOG
   select
   'contacts do not exist',
   SYSDATE,
   'SBR.META_UPLOAD_CONTACT_SP',
   q_rec.ctl_name||','||q_rec.cyber_address||','||q_rec.ORGANISATION
   from SBR.META_UPLOAD_CONTACT u
 where ctl_name=q_rec.ctl_name
 and cyber_address=q_rec.cyber_address ;

 UPDATE  SBR.META_UPLOAD_CONTACT set COMMENTS='ERROR'
 where Public_ID=q_rec.Public_ID
and VERSION=q_rec.VERSION
 and ctl_name=q_rec.ctl_name
 and cyber_address=q_rec.cyber_address;

 EXCEPTION WHEN OTHERS THEN
  errmsg := substr(SQLERRM,1,100);
   insert into SBR.META_UPLOAD_ERROR_LOG VALUES( errmsg, SYSDATE,   'SBR.META_UPLOAD_CONTACT_SP',  q_rec.Public_ID||','||q_rec.VERSION||','||q_rec.ctl_name||','||q_rec.cyber_address||','||q_rec.ORGANISATION||','||errmsg
   ) ;
   commit;
 END;

/*
---CDE do not exist
  select*from SBR.META_UPLOAD_CONTACT u
 left outer join  SBR.DATA_ELEMENTS  e
 on cde_id=  Public_ID
 and u.version=e.version
 where  DE_IDSEQ is null;

 ---CDE have contacts
 select*from SBR.META_UPLOAD_CONTACT u
 inner join  SBR.DATA_ELEMENTS  e
 on cde_id=  Public_ID
 and u.version=e.version
inner join SBREXT.CABIO31_AC_CONTACTS_VIEW  c
on DE_IDSEQ=AC_IDSEQ;*/

END LOOP;
END IF;

---CDE do not exist
select count(*) into v_cnt from SBR.META_UPLOAD_CONTACT u
 left outer join  SBR.DATA_ELEMENTS  e
 on cde_id=  Public_ID
 and u.version=e.version
 where  DE_IDSEQ is null;

 IF(v_cnt > 0) THEN
 FOR rec IN C2 LOOP
  BEGIN

   insert into SBR.META_UPLOAD_ERROR_LOG
   select
   'CDE do not exist',
   SYSDATE,
   'SBR.META_UPLOAD_CONTACT_SP',
  rec.Public_ID||','||rec.VERSION
  from SBR.META_UPLOAD_CONTACT u
 where  Public_ID=  rec.Public_ID
 and u.version=rec.version;

   commit;
 UPDATE  SBR.META_UPLOAD_CONTACT set COMMENTS='ERROR'
 where Public_ID=rec.Public_ID
and VERSION=rec.VERSION
 and ctl_name=rec.ctl_name
 and cyber_address=rec.cyber_address;
 commit;
  EXCEPTION WHEN OTHERS THEN
  errmsg := substr(SQLERRM,1,100);

   insert into SBR.META_UPLOAD_ERROR_LOG VALUES( errmsg, SYSDATE,   'SBR.META_UPLOAD_CONTACT_SP',   rec.Public_ID||','||rec.VERSION||','||rec.ctl_name||','||rec.cyber_address||','||errmsg);
   commit;
 END;

END LOOP;
END IF;
/*

 ---CDE have contacts
 select*from SBR.META_UPLOAD_CONTACT u
 inner join  SBR.DATA_ELEMENTS  e
 on cde_id=  Public_ID
 and u.version=e.version
inner join SBREXT.CABIO31_AC_CONTACTS_VIEW  c
on DE_IDSEQ=AC_IDSEQ;*/
select count(*) into v_cnt from SBR.META_UPLOAD_CONTACT u
 inner join  SBR.DATA_ELEMENTS  e
 on cde_id=  Public_ID
 and u.version=e.version
inner join SBREXT.CABIO31_AC_CONTACTS_VIEW  c
on DE_IDSEQ=AC_IDSEQ;

 IF(v_cnt > 0) THEN
 FOR q_rec IN C3 LOOP
  BEGIN


  select PER_IDSEQ, ORG_IDSEQ into  v_PERID, v_ORGID
  from SBR.CONTACT_COMMS c
  where  c.ctl_name=q_rec.ctl_name
  and c.cyber_address=q_rec.cyber_address ;

  dbms_output.put_line('this is PER_IDSEQ, ORG_IDSEQ:'||v_PERID||','||v_PERID);
  IF NVL(v_PERID,'NF') <> q_rec.PER_IDSEQ and NVL(v_ORGID,'NF') <> q_rec.ORG_IDSEQ
  THEN

   insert into SBR.META_UPLOAD_ERROR_LOG
   select
   'CDE has contacts',
   SYSDATE,
   'SBR.META_UPLOAD_CONTACT_SP',
   q_rec.ctl_name||','||q_rec.cyber_address||','||q_rec.ORGANISATION
   from SBR.META_UPLOAD_CONTACT u
 where  Public_ID=  q_rec.Public_ID
 and q_rec.version=version;


 UPDATE  SBR.META_UPLOAD_CONTACT set COMMENTS='ERROR'
 where Public_ID=q_rec.Public_ID and VERSION=q_rec.VERSION
 and ctl_name=q_rec.ctl_name and cyber_address=q_rec.cyber_address;
 commit;
 ELSE
  UPDATE  SBR.META_UPLOAD_CONTACT set COMMENTS='CDE has same contacts'
 where Public_ID=q_rec.Public_ID and VERSION=q_rec.VERSION
 and ctl_name=q_rec.ctl_name and cyber_address=q_rec.cyber_address;
 END IF;
   commit;
 EXCEPTION WHEN OTHERS THEN
  errmsg := substr(SQLERRM,1,100);
  insert into SBR.META_UPLOAD_ERROR_LOG VALUES(   errmsg,
   SYSDATE,
   'SBR.META_UPLOAD_CONTACT_SP',
   q_rec.Public_ID||','||q_rec.VERSION||','||q_rec.ctl_name||','||q_rec.cyber_address||','||q_rec.ORGANISATION||','||errmsg) ;
   commit;
 END;
END LOOP;
END IF;





DECLARE

CURSOR C5 IS
select *
from SBR.META_UPLOAD_CONTACT   where COMMENTS is null;

 v_acc_idseq VARCHAR(50);
 v_DEC_IDSEQ VARCHAR(50);
 v_DE_IDSEQ VARCHAR(50);
 V_CONTE_IDSEQ VARCHAR(50);
 V_VD_IDSEQ VARCHAR(50);
 v_PER_ID VARCHAR(50);
 v_ORG_ID VARCHAR(50);
begin
select count(*) into v_cnt from SBR.META_UPLOAD_CONTACT u
 where COMMENTS is null;

 IF(v_cnt > 0) THEN
 FOR q_rec IN C5 LOOP
  BEGIN

 select admincomponent_crud.cmr_guid into v_acc_idseq from dual;


 select e.DE_IDSEQ,e.CONTE_IDSEQ,e.VD_IDSEQ,e.DEC_IDSEQ
 into V_DE_IDSEQ,V_CONTE_IDSEQ,V_VD_IDSEQ,V_DEC_IDSEQ
 from  SBR.DATA_ELEMENTS  e
 where cde_id=  q_rec.Public_ID
 and VERSION=q_rec.version;


 If q_rec.Lname is not null then
 select per_IDSEQ into V_PER_ID from SBR.CONTACT_COMMS c
 where  ctl_name=q_rec.ctl_name
 and cyber_address=q_rec.cyber_address and per_IDSEQ is not null;
 V_ORG_ID:=null;
 else
 select ORG_IDSEQ into V_ORG_ID from SBR.CONTACT_COMMS c
 where  ctl_name=q_rec.ctl_name
 and cyber_address=q_rec.cyber_address and ORG_IDSEQ is not null;
 V_PER_ID:=null;
 end if;

    INSERT INTO SBR.AC_CONTACTS (ACC_IDSEQ                   ,
    ORG_IDSEQ  ,
    PER_IDSEQ      ,
    AC_IDSEQ       ,
    RANK_ORDER     ,
    DATE_CREATED  ,
    CREATED_BY     ,
    CONTACT_ROLE
    )
    VALUES (v_acc_idseq    ,
    V_ORG_ID  ,
    V_PER_ID        ,
    V_DE_IDSEQ     ,
    q_rec.RANK_ORDER     ,
    SYSDATE  ,
    'DWARZEL'     ,
    q_rec.CROLE );
   commit;

 EXCEPTION WHEN OTHERS THEN
  errmsg := substr(SQLERRM,1,100);
  insert into SBR.META_UPLOAD_ERROR_LOG VALUES(   errmsg,   SYSDATE,   'SBR.META_UPLOAD_CONTACT_SP',   q_rec.Public_ID||','||q_rec.VERSION||','||q_rec.ctl_name||','||q_rec.cyber_address||','||q_rec.ORGANISATION||','||errmsg
   );
   commit;

 END;
END LOOP;
END IF;
END;

END;
/


DROP PROCEDURE SBR.PR_CLEAN_END_DATE;

CREATE OR REPLACE PROCEDURE SBR."PR_CLEAN_END_DATE" (p_PublicID IN number,p_ver_VD in varchar,p_ver_VM in varchar,p_name varchar ,
p_value varchar ,p_vm_id number,p_enddate date,p_newdate date)AS
/*Procedure was created to update End Date in SBR.PERMISSIBLE_VALUES and SBR.VD_PVS tables
  1.parametr p_PublicID presents Publick Id in section Value Domain Details in browser from VALUE_DOMAINS table
  2.parametr p_ver_VD presents Version in section Value Domain Details in browser from VALUE_DOMAINS table
  3.parametr p_name presents Context Name in section Value Domain Details in browser from CONTEXTS table
  4.parametr p_ver_CNT presents Context version in section Value Domain Details in browser from CONTEXTS table--,p_ver_CNT in varchar
  5.parametr p_ver_VD presents Version in section Value Domain Details in browser from VALUE_MININGS table?
  6.parametr p_prefName presents Prefferd Nane in section Value Domain Details in browser from VALUE_MININGS table--,p_prefNameVD in varchar
  7.parametr p_value presents value from PERMISSIBLE_VALUES
*/

V_vm_idseq VARCHAR2(300);
V_pv_idseq VARCHAR2(300);
V_vd_idseq VARCHAR2(300);
V_conte_idseq VARCHAR2(300);
v_vp_idseq VARCHAR2(300);
v_enddate date;
V_cnt1 number;
V_cnt2 number;

BEGIN

select conte_idseq into V_conte_idseq from contexts where name =p_name ;--and version=p_ver_CNT;

dbms_output.put_line('1 V_conte_idseq; '||V_conte_idseq);
select vm_idseq into v_vm_idseq from sbr.value_meanings where vm_id=p_vm_id  and  version=p_ver_VM;--and conte_idseq=V_conte_idseq

dbms_output.put_line('2 v_vm_idseq; '||v_vm_idseq);
select vd_idseq into V_vd_idseq from VALUE_DOMAINS  where VD_ID=p_PublicID and version=p_ver_vd;
dbms_output.put_line('3 V_vd_idseq; '||V_vd_idseq);

select COUNT(*) into V_cnt1 from PERMISSIBLE_VALUES where  vm_idseq=v_vm_idseq and value=p_value;
if V_cnt1>0

then
select pv_idseq, end_date into V_pv_idseq,v_enddate from PERMISSIBLE_VALUES where  vm_idseq=v_vm_idseq and value=p_value;

dbms_output.put_line('4 V_pv_idseq; '||V_pv_idseq||','||v_enddate);

if p_enddate is null then

select COUNT(*) into v_cnt2 from VD_PVS  where VD_IDSEQ = V_vd_idseq and conte_idseq=v_conte_idseq
and pv_idseq=V_pv_idseq and   END_DATE  is null;
if v_cnt2>0 then
select vp_idseq , end_date into v_vp_idseq,v_enddate from VD_PVS  where VD_IDSEQ = V_vd_idseq and conte_idseq=v_conte_idseq
and pv_idseq=V_pv_idseq and   END_DATE  is null;
end if;
else

select count(*) into v_cnt2 from VD_PVS  where VD_IDSEQ = V_vd_idseq and conte_idseq=v_conte_idseq
and pv_idseq=V_pv_idseq and   ltrim(rtrim(END_DATE))   = p_enddate;
if v_cnt2>0 then
select vp_idseq , end_date into v_vp_idseq,v_enddate from VD_PVS  where VD_IDSEQ = V_vd_idseq and conte_idseq=v_conte_idseq
and pv_idseq=V_pv_idseq and   ltrim(rtrim(END_DATE))   = p_enddate;
end if;
end if;
dbms_output.put_line('5 vp_idseq; '||v_vp_idseq||','||v_enddate||',count='||v_cnt2);


update SBR.PERMISSIBLE_VALUES  set end_date=p_newdate
where vm_idseq=v_vm_idseq and value=p_value;

if p_enddate is null and v_cnt2>0 then

update SBR.VD_PVS  set end_date=p_newdate
where VD_IDSEQ = V_vd_idseq and conte_idseq=v_conte_idseq
and pv_idseq=V_pv_idseq and  END_DATE is null;

elsif p_enddate is not null and v_cnt2>0 then

update SBR.VD_PVS  set end_date=p_newdate
where VD_IDSEQ = V_vd_idseq and conte_idseq=v_conte_idseq
and pv_idseq=V_pv_idseq and  ltrim(rtrim(END_DATE)) = p_enddate;
end if;
end if;
commit;
exception
      when others then
  NULL;
END PR_CLEAN_END_DATE;

 
/


DROP PROCEDURE SBR.UPD_PV;

CREATE OR REPLACE procedure SBR.upd_pv
as
cursor c_upd_pv is select * from temp_permissible_values;
errmsg VARCHAR2(500);
begin
for i in c_upd_pv loop
    begin

        UPDATE SBR.PERMISSIBLE_VALUES pv
        SET pv.VALUE = i.NEW_PV
        , DATE_MODIFIED = sysdate
        , MODIFIED_BY = i.MODIFIED_BY
        WHERE pv.PV_IDSEQ in
            (
                -- this returns the PV_IDSEQs for all PVs assoc'd with the VD
                SELECT VD_PVS.PV_IDSEQ
                FROM VD_PVS
                WHERE VD_PVS.VD_IDSEQ = (
                    SELECT vd.VD_IDSEQ
                    FROM VALUE_DOMAINS vd
                    WHERE
                    VD_ID = i.VALUE_DOMAIN_ID
                    AND VERSION = i.VALUE_DOMAIN_VER
                )
            )
        AND pv.VALUE = i.EXISTING_PV;
        IF SQL%ROWCOUNT = 0 THEN
        insert into PERMISSIBLE_VALUES_ERR VALUES (i.VALUE_DOMAIN_ID, i.VALUE_DOMAIN_VER, i.LONGNAME, i.TYPE, i.EXISTING_PV, i.DATE_MODIFIED, i.MODIFIED_BY, i.NEW_PV, 'Row Not Updated Due to Existing PV Not Found', sysdate);
        END IF;
    EXCEPTION
    WHEN OTHERS THEN
        errmsg := SQLERRM;
        insert into PERMISSIBLE_VALUES_ERR VALUES (i.VALUE_DOMAIN_ID, i.VALUE_DOMAIN_VER, i.LONGNAME, i.TYPE, i.EXISTING_PV, i.DATE_MODIFIED, i.MODIFIED_BY, i.NEW_PV, errmsg, sysdate);
    end;
end loop;
commit;
end;
 
/


DROP PROCEDURE SBR.UPD_PV_ENDDATE;

CREATE OR REPLACE PROCEDURE SBR.upd_pv_enddate(p_vd_ID IN number,p_ver in varchar,p_value in varchar ,p_date in varchar)
AS
errmsg VARCHAR2(2000);
begin
        UPDATE SBR.PERMISSIBLE_VALUES pv
        SET END_DATE = to_date(p_date,'DD-MON-YY')
        WHERE pv.VALUE = p_value
        and pv.PV_IDSEQ in
            (   SELECT pvs.PV_IDSEQ
                FROM VD_PVS pvs,VALUE_DOMAINS vd
                WHERE pvs.VD_IDSEQ = vd.VD_IDSEQ
                and VD_ID = p_vd_ID
                AND VERSION = p_ver);

        UPDATE SBR.vd_pvs  pvs
        SET END_DATE = to_date(p_date,'DD-MON-YY')
        WHERE VD_IDSEQ in (
                select vd_idseq
                from value_domains
                where VD_ID = p_vd_ID
                AND VERSION = p_ver)
            and PV_IDSEQ in
                (select PV.PV_IDSEQ from permissible_values pv,vd_pvs pvs1, value_domains vd
                where  PV.PV_IDSEQ = pvs1.PV_IDSEQ
                AND  pvs1.vd_idseq = VD.VD_IDSEQ
                AND VD.vd_id = p_vd_ID and VD.VERSION = p_ver
                and pv.value = p_value);
   commit;
 EXCEPTION

    WHEN OTHERS THEN
    rollback;
     errmsg := 'ERROR when update END_DATE for vd_ID='||p_vd_ID||', ver='||p_ver||' ,PV value='||p_value;
     errmsg := substr(trim(errmsg||':'|| SQLERRM),1,1900);
     dbms_output.put_line(errmsg);
    insert into PERMISSIBLE_VALUES_ERR (COMMENTS,DATE_PROCESSED) VALUES (errmsg, sysdate);

 commit;
end;
 
/


DROP PROCEDURE SBR.UPD_PV_NEW;

CREATE OR REPLACE procedure SBR.upd_pv_new
as
cursor c_upd_pv is select * from temp_permissible_values;
tvp_idseq VD_PVS.VP_IDSEQ%TYPE;
tpv_idseq VD_PVS.PV_IDSEQ%TYPE;
tpv_idseq2 VD_PVS.PV_IDSEQ%TYPE;
tvd_idseq VD_PVS.VD_IDSEQ%TYPE;
tvm_idseq PERMISSIBLE_VALUES.VM_IDSEQ%TYPE;
tshortmeaning PERMISSIBLE_VALUES.SHORT_MEANING%TYPE;
tmeaning_desc PERMISSIBLE_VALUES.MEANING_DESCRIPTION%TYPE;
t_pv_id PERMISSIBLE_VALUES.PV_IDSEQ%TYPE;
errmsg VARCHAR2(500);

begin
for i in c_upd_pv loop
    begin
        Begin
        -- Step 1
            SELECT VD_PVS.VP_IDSEQ, VD_PVS.PV_IDSEQ, VD_PVS.VD_IDSEQ, pv.VM_IDSEQ ValueMeaningID, pv.SHORT_MEANING, pv.MEANING_DESCRIPTION
            into tvp_idseq, tpv_idseq, tvd_idseq, tvm_idseq, tshortmeaning, tmeaning_desc
            FROM VD_PVS, PERMISSIBLE_VALUES pv
            WHERE VD_PVS.VD_IDSEQ = ( SELECT vd.VD_IDSEQ FROM VALUE_DOMAINS vd WHERE VD_ID = i.value_domain_id AND VERSION = i.value_domain_ver )
            AND VD_PVS.PV_IDSEQ = pv.PV_IDSEQ
            AND pv.VALUE = i.existing_pv;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
            insert into PERMISSIBLE_VALUES_ERR VALUES (i.VALUE_DOMAIN_ID, i.VALUE_DOMAIN_VER, i.LONGNAME, i.TYPE, i.EXISTING_PV, i.DATE_MODIFIED, i.MODIFIED_BY, i.NEW_PV, 'Row Not Updated Due to Existing PV Not Found', sysdate);
            goto nextrec;
        END;

        Begin
        -- Step 2
            SELECT PV_IDSEQ into tpv_idseq2
            FROM PERMISSIBLE_VALUES
            WHERE VM_IDSEQ = tvm_idseq
            AND VALUE = i.new_pv;

        -- If Step 2 returns a value
            UPDATE VD_PVS set PV_IDSEQ = tpv_idseq2, date_modified = sysdate WHERE VP_IDSEQ = tvp_idseq;
            IF SQL%ROWCOUNT = 0 THEN
            insert into PERMISSIBLE_VALUES_ERR VALUES (i.VALUE_DOMAIN_ID, i.VALUE_DOMAIN_VER, i.LONGNAME, i.TYPE, i.EXISTING_PV, i.DATE_MODIFIED, i.MODIFIED_BY, i.NEW_PV, 'Row Not Updated Due to Value Domain ID Not Found', sysdate);
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN  --Insert New Record in PV
            Begin
            select sbr.admincomponent_crud.cmr_guid into t_pv_id from dual;
            INSERT INTO PERMISSIBLE_VALUES (PV_IDSEQ
            , VALUE
            , SHORT_MEANING
            , MEANING_DESCRIPTION
            , BEGIN_DATE
            , DATE_CREATED
            , CREATED_BY
            , DATE_MODIFIED
            , MODIFIED_BY
            , VM_IDSEQ)
            VALUES (t_pv_id
            , i.NEW_PV
            , tshortmeaning
            , tmeaning_desc
            , sysdate
            , sysdate
            , i.MODIFIED_BY
            , NULL
            , NULL
            , tvm_idseq);
            EXCEPTION
            WHEN OTHERS THEN
            errmsg := SQLERRM;
            insert into PERMISSIBLE_VALUES_ERR VALUES (i.VALUE_DOMAIN_ID, i.VALUE_DOMAIN_VER, i.LONGNAME, i.TYPE, i.EXISTING_PV, i.DATE_MODIFIED, i.MODIFIED_BY, i.NEW_PV, 'Error during Insert of New PV. '|| errmsg, sysdate);
            end;

            begin
            UPDATE VD_PVS SET PV_IDSEQ = t_pv_id, date_modified = sysdate WHERE VP_IDSEQ = tvp_idseq;
            IF SQL%ROWCOUNT = 0 THEN
            insert into PERMISSIBLE_VALUES_ERR VALUES (i.VALUE_DOMAIN_ID, i.VALUE_DOMAIN_VER, i.LONGNAME, i.TYPE, i.EXISTING_PV, i.DATE_MODIFIED, i.MODIFIED_BY, i.NEW_PV, 'Row Not Updated Due to vp_idseq Not Found', sysdate);
            END IF;
            exception
            WHEN OTHERS THEN
            errmsg := SQLERRM;
            insert into PERMISSIBLE_VALUES_ERR VALUES (i.VALUE_DOMAIN_ID, i.VALUE_DOMAIN_VER, i.LONGNAME, i.TYPE, i.EXISTING_PV, i.DATE_MODIFIED, i.MODIFIED_BY, i.NEW_PV, 'Error in Update of VD_PVS '|| errmsg, sysdate);
            end;
        END;
    EXCEPTION
    WHEN OTHERS THEN
        errmsg := SQLERRM;
        insert into PERMISSIBLE_VALUES_ERR VALUES (i.VALUE_DOMAIN_ID, i.VALUE_DOMAIN_VER, i.LONGNAME, i.TYPE, i.EXISTING_PV, i.DATE_MODIFIED, i.MODIFIED_BY, i.NEW_PV, errmsg, sysdate);
    end;
    <<nextrec>>
     Null; -- process next record.
end loop;
commit;
end;
 
/

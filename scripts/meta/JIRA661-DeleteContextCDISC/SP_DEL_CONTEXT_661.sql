set serveroutput on size 1000000
SPOOL cadsrmeta-661.log

ALTER TABLE SBR.MDSR_MODIFY_ERR_LOG
MODIFY TABLE_NAME     CHAR(1000) 
/
CREATE OR REPLACE PUBLIC SYNONYM MDSR_MODIFY_ERR_LOG FOR SBR.MDSR_MODIFY_ERR_LOG;
GRANT SELECT ON MDSR_MODIFY_ERR_LOG TO PUBLIC;
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
insert into SBR.MDSR_MODIFY_ERR_LOG VALUES('MDSR_UPD_CONTE_IDSEQ','SBR.contexts', sysdate ,'Context does not exist. ');
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
  V_error:=V_error||substr(SQLERRM,1,1000);
  --  V_error := substr(SQLERRM,1,2000);
      insert into SBR.MDSR_MODIFY_ERR_LOG VALUES('SBR.MDSR_DELETE_CONTEXT', 'ALL',sysdate ,V_error);
  

END;
END IF;

exception
 
when others then
  V_error:=V_error||substr(SQLERRM,1,1000);
        insert into SBR.MDSR_MODIFY_ERR_LOG VALUES('SBR.MDSR_DELETE_CONTEXT', 'ALL',sysdate ,V_error);
     commit;
END MDSR_DELETE_CONTEXT;
/
exec SBR.MDSR_DELETE_CONTEXT('CDISC');
SPOOL OFF
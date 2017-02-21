set serveroutput on size 1000000
SPOOL cadsrmeta-661.log

CREATE OR REPLACE PUBLIC SYNONYM MDSR_MODIFY_ERR_LOG FOR SBR.MDSR_MODIFY_ERR_LOG;
GRANT SELECT ON MDSR_MODIFY_ERR_LOG TO PUBLIC;

CREATE OR REPLACE PROCEDURE SBR.MDSR_DELETE_CONTEXT (p_Context_name in varchar) AS
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
select COUNT(*) into V_cnt_old from contexts where name =p_Context_name ;--and version=p_ver_CNT;
IF V_cnt_old=0 THEN
V_error :='Context does not exist. ';
END IF;


If V_error is NOT NULL 
THEN
insert into SBR.MDSR_MODIFY_ERR_LOG VALUES('MDSR_UPD_CONTE_IDSEQ', sysdate ,V_error);
    commit;
    
ELSE
select conte_idseq into Vold_conte_idseq from contexts where name =p_Context_name ;--and version=p_ver_CNT;

select COUNT(*) into V_cnt_old from SBR.ADMINISTERED_COMPONENTS  where CONTE_IDSEQ=Vold_conte_idseq; 
If V_cnt_old>0 THEN
V_error:='SBR.ADMINISTERED_COMPONENTS,';
END if;

select COUNT(*) into V_cnt_old from SBR.CLASSIFICATION_SCHEMES  where CONTE_IDSEQ=Vold_conte_idseq;
If V_cnt_old>0 THEN
V_error:='SBR.CLASSIFICATION_SCHEMES,';
END if;
 
select COUNT(*) into V_cnt_old from SBR.CONCEPTUAL_DOMAINS  where CONTE_IDSEQ=Vold_conte_idseq; 
If V_cnt_old>0 THEN
V_error:='SBR.CONCEPTUAL_DOMAINS,';
END if;

select COUNT(*) into V_cnt_old from SBR.CS_ITEMS  where CONTE_IDSEQ=Vold_conte_idseq;
If V_cnt_old>0 THEN
V_error:='SBR.CS_ITEMS,';
END if; 
select COUNT(*) into V_cnt_old from SBR.DATA_ELEMENTS  where CONTE_IDSEQ=Vold_conte_idseq; 
If V_cnt_old>0 THEN
V_error:='SBR.DATA_ELEMENTS,';
END if;

select COUNT(*) into V_cnt_old from SBR.DATA_ELEMENT_CONCEPTS  where CONTE_IDSEQ=Vold_conte_idseq; 
If V_cnt_old>0 THEN
V_error:='SBR.DATA_ELEMENT_CONCEPTS,';
END if;
select COUNT(*) into V_cnt_old from SBR.DEFINITIONS  where CONTE_IDSEQ=Vold_conte_idseq; 
If V_cnt_old>0 THEN
V_error:='SBR.DEFINITIONS,';
END if;
select COUNT(*) into V_cnt_old from SBR.DESIGNATIONS  where CONTE_IDSEQ=Vold_conte_idseq; 
If V_cnt_old>0 THEN
V_error:='SBR.DESIGNATIONS ,';
END if;
select COUNT(*) into V_cnt_old from SBR.REFERENCE_DOCUMENTS  where CONTE_IDSEQ=Vold_conte_idseq; 
If V_cnt_old>0 THEN
V_error:='SBR.REFERENCE_DOCUMENTS,';
END if;

select COUNT(*) into V_cnt_old from SBR.VALUE_DOMAINS  where CONTE_IDSEQ=Vold_conte_idseq; 
If V_cnt_old>0 THEN
V_error:='SBR.VALUE_DOMAINS,';
END if;
select COUNT(*) into V_cnt_old from SBR.VALUE_MEANINGS  where CONTE_IDSEQ=Vold_conte_idseq; 
If V_cnt_old>0 THEN
V_error:='SBR.VALUE_MEANINGS,';
END if;
select COUNT(*) into V_cnt_old from SBR.VD_PVS  where CONTE_IDSEQ=Vold_conte_idseq; 
If V_cnt_old>0 THEN
V_error:='SBR.VD_PVS,';
END if;
select COUNT(*) into V_cnt_old from SBREXT.CONCEPTS_EXT  where CONTE_IDSEQ=Vold_conte_idseq; 
If V_cnt_old>0 THEN
V_error:='SBREXT.CONCEPTS_EXT,';
END if;
select COUNT(*) into V_cnt_old from SBREXT.OBJECT_CLASSES_EXT  where CONTE_IDSEQ=Vold_conte_idseq; 
If V_cnt_old>0 THEN
V_error:='SBREXT.OBJECT_CLASSES_EXT,';
END if;
select COUNT(*) into V_cnt_old from SBREXT.OC_RECS_EXT  where CONTE_IDSEQ=Vold_conte_idseq; 
If V_cnt_old>0 THEN
V_error:='SBREXT.OC_RECS_EXT,';
END if;
select COUNT(*) into V_cnt_old from SBREXT.PROPERTIES_EXT  where CONTE_IDSEQ=Vold_conte_idseq; 
If V_cnt_old>0 THEN
V_error:='SBREXT.PROPERTIES_EXT,';
END if;
select COUNT(*) into V_cnt_old from SBREXT.PROTOCOLS_EXT  where CONTE_IDSEQ=Vold_conte_idseq; 
If V_cnt_old>0 THEN
V_error:='SBREXT.PROTOCOLS_EXT,';
END if;
select COUNT(*) into V_cnt_old from SBREXT.QUEST_CONTENTS_EXT  where CONTE_IDSEQ=Vold_conte_idseq;
If V_cnt_old>0 THEN
V_error:='SBREXT.QUEST_CONTENTS_EXT,';
END if; 
select COUNT(*) into V_cnt_old from SBREXT.REPRESENTATIONS_EXT  where CONTE_IDSEQ=Vold_conte_idseq;
If V_cnt_old>0 THEN
V_error:='SBREXT.REPRESENTATIONS_EXT,';
END if; 
select COUNT(*) into V_cnt_old from SBREXT.SN_RECIPIENT_EXT  where CONTE_IDSEQ=Vold_conte_idseq;
If V_cnt_old>0 THEN
V_error:='SBREXT.SN_RECIPIENT_EXT,';
END if; 
select COUNT(*) into V_cnt_old from SBREXT.STAGE_LOAD_PDF  where CONTE_IDSEQ=Vold_conte_idseq; 
If V_cnt_old>0 THEN
V_error:='SBREXT.STAGE_LOAD_PDF,';
END if;
END IF;


If V_error is NOT NULL 
THEN
V_error:='Following tables reference to '||p_Context_name||':'||V_error;
insert into SBR.MDSR_MODIFY_ERR_LOG VALUES('SBR.MDSR_DELETE_CONTEXT', sysdate ,V_error);
     commit;
ELSE 
delete SBR.SECURITY_CONTEXTS_LOV where scl_name like p_Context_name||'%';
delete SBR.GROUPS where grp_name like p_Context_name||'%';
delete SBR.USER_GROUPS where grp_name like p_Context_name||'%';
delete SBR.SC_CONTEXTS  where CONTE_IDSEQ=Vold_conte_idseq; 
delete SBR.CONTEXTS where name = p_Context_name;

    commit;
END IF;

 --select*from sbr.user_groups where grp_name like 'CDISC%'; 
-- select*from SBR.SECURITY_CONTEXTS_LOV where scl_name like 'CDISC%';


exception
when NO_DATA_FOUND THEN
null; 
when others then
  V_error:=V_error||SQLCODE||substr(SQLERRM,1,1000);
  --  V_error := substr(SQLERRM,1,2000);
      insert into SBR.MDSR_MODIFY_ERR_LOG VALUES('SBR.MDSR_DELETE_CONTEXT', sysdate ,V_error);
     commit;
END MDSR_DELETE_CONTEXT;
/

SPOOL OFF
set serveroutput on size 1000000
SPOOL cadsrmeta-661.log

ALTER TABLE SBR.MDSR_MODIFY_ERR_LOG
MODIFY TABLE_NAME     CHAR(1000) 
/
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
select COUNT(*) into V_cnt_old from SBR.contexts where name =p_Context_name ;--and version=p_ver_CNT;
IF V_cnt_old=0 THEN
V_error :='Context does not exist. ';
END IF;


If V_error is NOT NULL 
THEN
V_error:='Following tables reference to '||p_Context_name||':'||V_error;
insert into SBR.MDSR_MODIFY_ERR_LOG VALUES('SBR.MDSR_DELETE_CONTEXT',V_error, sysdate ,V_error);
     commit;
ELSE 


BEGIN
delete SBR.SC_USER_ACCOUNTS where trim(scl_name) like p_Context_name||'%';
 commit;
exception
when NO_DATA_FOUND THEN
null; 
when others then
    V_error := substr(SQLERRM,1,1000);
      insert into SBR.MDSR_MODIFY_ERR_LOG VALUES('SBR.MDSR_DELETE_CONTEXT', 'SBR.SC_USER_ACCOUNTS',sysdate ,V_error);
     commit;
END;


BEGIN
delete SBR.AC_WF_RULES where trim(scl_name) like p_Context_name||'%';
  commit;
exception
when NO_DATA_FOUND THEN
null; 
when others then
    V_error := substr(SQLERRM,1,1000);
      insert into SBR.MDSR_MODIFY_ERR_LOG VALUES('SBR.MDSR_DELETE_CONTEXT', 'SBR.AC_WF_RULES',sysdate ,V_error);
     commit;
END;

BEGIN

delete SBR.AC_ACTIONS_MATRIX where trim(scl_name) like p_Context_name||'%';
  commit;
exception
when NO_DATA_FOUND THEN
null; 
when others then
    V_error := substr(SQLERRM,1,1000);
      insert into SBR.MDSR_MODIFY_ERR_LOG VALUES('SBR.MDSR_DELETE_CONTEXT', 'SBR.AC_ACTIONS_MATRIX',sysdate ,V_error);
     commit;
END;


BEGIN

delete SBR.GROUP_RECS where trim(CHILD_GRP_NAME) like p_Context_name||'%';
  commit;
exception
when NO_DATA_FOUND THEN
null; 
when others then
    V_error := substr(SQLERRM,1,1000);
      insert into SBR.MDSR_MODIFY_ERR_LOG VALUES('SBR.MDSR_DELETE_CONTEXT', 'SBR.GROUP_RECS',sysdate ,V_error);
     commit;
END;
BEGIN
delete SBR.SECURITY_CONTEXTS_LOV where trim(scl_name) like p_Context_name||'%';
  commit;
exception
when NO_DATA_FOUND THEN
null; 
when others then
    V_error := substr(SQLERRM,1,1000);
      insert into SBR.MDSR_MODIFY_ERR_LOG VALUES('SBR.MDSR_DELETE_CONTEXT', 'SBR.SECURITY_CONTEXTS_LOV',sysdate ,V_error);
     commit;
END;
BEGIN
delete SBR.USER_GROUPS where trim(grp_name) like p_Context_name||'%';
  commit;
exception
when NO_DATA_FOUND THEN
null; 
when others then
    V_error := substr(SQLERRM,1,1000);
      insert into SBR.MDSR_MODIFY_ERR_LOG VALUES('SBR.MDSR_DELETE_CONTEXT', 'SBR.USER_GROUPS',sysdate ,V_error);
     commit;
END;
BEGIN
delete SBR.GROUPS where trim(grp_name) like p_Context_name||'%';
  commit;
exception
when NO_DATA_FOUND THEN
null; 
when others then
    V_error := substr(SQLERRM,1,1000);
      insert into SBR.MDSR_MODIFY_ERR_LOG VALUES('SBR.MDSR_DELETE_CONTEXT', 'SBR.GROUPS',sysdate ,V_error);
     commit;
END;

BEGIN
delete SBR.SC_CONTEXTS  where CONTE_IDSEQ=Vold_conte_idseq; 
  commit;
exception
when NO_DATA_FOUND THEN
null; 
when others then
   V_error := substr(SQLERRM,1,1000);
      insert into SBR.MDSR_MODIFY_ERR_LOG VALUES('SBR.MDSR_DELETE_CONTEXT', 'SBR.SC_CONTEXTS',sysdate ,V_error);
     commit;
END;
BEGIN
delete SBR.CONTEXTS where name = p_Context_name;
exception
when NO_DATA_FOUND THEN
null; 
when others then
  V_error := substr(SQLERRM,1,1000);
      insert into SBR.MDSR_MODIFY_ERR_LOG VALUES('SBR.MDSR_DELETE_CONTEXT', 'CONTEXTS',sysdate ,V_error);
     commit;
END;



    commit;
END IF;

exception
when NO_DATA_FOUND THEN
null; 
when others then
  V_error:=V_error||substr(SQLERRM,1,1000);
  --  V_error := substr(SQLERRM,1,2000);
      insert into SBR.MDSR_MODIFY_ERR_LOG VALUES('SBR.MDSR_DELETE_CONTEXT', 'ALL',sysdate ,V_error);
     commit;
END MDSR_DELETE_CONTEXT;
/
exec SBR.MDSR_DELETE_CONTEXT('CDISC');
SPOOL OFF
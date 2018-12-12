set serveroutput on size 1000000
SPOOL cadsrmeta-745.log
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
exec SBR.MDSR_UPD_CONTE_IDSEQ('NINDS','NCIP','SBR');

exec SBR.MDSR_DELETE_CONTEXT('NINDS');
SPOOL OFF
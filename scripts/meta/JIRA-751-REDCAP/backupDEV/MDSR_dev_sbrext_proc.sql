DROP PROCEDURE SBREXT.MDSR_CDE_XML_TRANSFORM;

CREATE OR REPLACE PROCEDURE SBREXT.MDSR_CDE_XML_TRANSFORM IS

l_file_name VARCHAR2(500):='TRANSFORM CDE XML';
 errmsg VARCHAR2(500):='Non';
BEGIN

--delite tags---- <DE_Contest>
UPDATE SBREXT.MDSR_CDE_XML_TEMP set text=replace(text,'<ROW>'||chr(10));
UPDATE SBREXT.MDSR_CDE_XML_TEMP set text=replace(text,'</ROW>'||chr(10));
UPDATE SBREXT.MDSR_CDE_XML_TEMP set text=replace(text,'<ROWSET>'||chr(10));
UPDATE SBREXT.MDSR_CDE_XML_TEMP set text=replace(text,'</ROWSET>'||chr(10));
UPDATE SBREXT.MDSR_CDE_XML_TEMP set text=replace(text,'<DataElementList/>'||chr(10));
update SBREXT.MDSR_CDE_XML_TEMP set text=replace(text,'<MDSR_749_VALUEDOMAIN_T>'||chr(10) );
update SBREXT.MDSR_CDE_XML_TEMP set text=replace(text,'</MDSR_749_VALUEDOMAIN_T>'||chr(10) );
update SBREXT.MDSR_CDE_XML_TEMP set text=replace(text,'<MDSR_749_VALUEDOMAIN_T/>'||chr(10) );
--rename tags

update SBREXT.MDSR_CDE_XML_TEMP set text=replace(text,'MDSR_CDE_749_T','DataElement');
UPDATE SBREXT.MDSR_CDE_XML_TEMP set text=replace(text,'MDSR_749_ALTERNATENAME_ITEM_T','ALTERNATENAMELIST_ITEM');
update SBREXT.MDSR_CDE_XML_TEMP set text=replace(text,'MDSR_749_REFERENCEDOCUMENT_T','REFERENCEDOCUMENTSLIST_ITEM');
UPDATE SBREXT.MDSR_CDE_XML_TEMP set text=replace(text,'MDSR_749_PV_ITEM_T','PermissibleValues_ITEM');
update SBREXT.MDSR_CDE_XML_TEMP set text=replace(text,'<?xml version="1.0"?>','<?xml version="1.0" encoding="UTF-8"?>');


  commit;
 EXCEPTION
    WHEN OTHERS THEN
   errmsg := SQLERRM;
         dbms_output.put_line('errmsg  - '||errmsg);
     insert into SBREXT.MDSR_CDE_XML_REPORT_ERR VALUES (l_file_name,  errmsg, sysdate);
     commit;

END ;
/


DROP PROCEDURE SBREXT.MDSR_CDE_XML_TRANSFORM_FILE;

CREATE OR REPLACE PROCEDURE SBREXT.MDSR_CDE_XML_TRANSFORM_file(P_file IN  VARCHAR2) IS

l_file_name VARCHAR2(500):='CDE XML';
 errmsg VARCHAR2(500):='Non';
BEGIN



--delite tags---- <DE_Contest>
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<ROW>'||chr(10));
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</ROW>'||chr(10));

UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<DE_Contest>'||chr(10));
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</DE_Contest>'||chr(10));
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<MDSR_DEC_VD_XML_T>'||chr(10));
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</MDSR_DEC_VD_XML_T>'||chr(10));
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</MDSR_FB_VD_XML_T>'||chr(10));
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<MDSR_DEC_XML_T>'||chr(10));
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</MDSR_DEC_XML_T>'||chr(10));

UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<referenceDocument_x005F_xx>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</referenceDocument_x005F_xx>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<referenceDocument_x005F_xx/>'||chr(10) );

UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</definition_x005F_xx>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<definition_x005F_xx>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<definition_x005F_xx/>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<PermissibleValue_x005F_xx>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</PermissibleValue_x005F_xx>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<PermissibleValue_x005F_xx/>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</designation_x005F_xx>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<designation_x005F_xx>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<designation_x005F_xx/>'||chr(10) );

UPDATE MDSR_FB_XML_TEMP set text=replace(text,' <valueDomainConcept/>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<validValues_x005F_xx>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</validValues_x005F_xx>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<validValues_x005F_xx/>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<instruction/>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<headerInstruction/>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<footerInstruction/>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<REF_DOC>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</REF_DOC>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<REF_DOC/>'||chr(10) );
update MDSR_FB_XML_TEMP set text=replace(text,'</ROW>'||chr(10) );
update MDSR_FB_XML_TEMP set text=replace(text,'<ROW>'||chr(10) );
--rename tags

UPDATE MDSR_FB_XML_TEMP set text=replace(text,'ROWSET','dataElements');

update MDSR_FB_XML_TEMP set text=replace(text,'MDSR_CDE_XML_T','dataElement');
update MDSR_FB_XML_TEMP set text=replace(text,'MDSR_CDE_RD_XML_T','referenceDocument');
update MDSR_FB_XML_TEMP set text=replace(text,'<?xml version="1.0"?>','<?xml version="1.0" encoding="UTF-8"?>');
update MDSR_FB_XML_TEMP set text=replace(text,'DATA_ELEMENT_x005F_xx','dataElement');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'MDSR_CDE_PV_XML_T','permissibleValue');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'MDSR_CDE_DESIGN_XML_T','designation');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'MDSR_CDE_DEFIN_XML_T','definition');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'MDSR_CDE_VD_XML_T','valueDomain');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'MDSR_FB_VDCon_XML_T','valueDomainConcept');
--dataElementDerivation

UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<workflowStatus>','<workflowStatusName>');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<workflowStatus/>','<workflowStatusName/>');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</workflowStatus>','</workflowStatusName>');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<publicid>','<publicID>');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</publicid>','</publicID>');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<publicId>','<publicID>');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</publicId>','</publicID>');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<Datatype>','<datatypeName>');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</Datatype>','</datatypeName>');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</longname>','</longName>');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<longname>','<longName>');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</Name>','</name>');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<Name>','<name>');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</url>','</URL>');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<url>','<URL>');



  commit;
 EXCEPTION
    WHEN OTHERS THEN
   errmsg := SQLERRM;
         dbms_output.put_line('errmsg  - '||errmsg);
     --   insert into SBREXT.MDSR_FB_XML_REPORT_ERR VALUES (l_file_name,  errmsg, sysdate);
     commit;

END ;
/


DROP PROCEDURE SBREXT.MDSR_CDE_XML_TRANSFORM_OLD;

CREATE OR REPLACE PROCEDURE SBREXT.MDSR_CDE_XML_TRANSFORM_old IS

l_file_name VARCHAR2(500):='CDE XML';
 errmsg VARCHAR2(500):='Non';
BEGIN

--delite tags---- <DE_Contest>
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<ROW>'||chr(10));
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</ROW>'||chr(10));
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<ROWSET>'||chr(10));
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</ROWSET>'||chr(10));

UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<DE_Contest>'||chr(10));
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</DE_Contest>'||chr(10));
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<DE_Contest/>'||chr(10));

update MDSR_FB_XML_TEMP set text=replace(text,'<MDSR_749_VD_T>'||chr(10) );
update MDSR_FB_XML_TEMP set text=replace(text,'</MDSR_749_VD_T>'||chr(10) );
update MDSR_FB_XML_TEMP set text=replace(text,'<MDSR_749_VD_T/>'||chr(10) );
--rename tags

UPDATE MDSR_FB_XML_TEMP set text=replace(text,'ROWSET','DataElementList');
update MDSR_FB_XML_TEMP set text=replace(text,'MDSR_CDE_749_T','DataElement');

UPDATE MDSR_FB_XML_TEMP set text=replace(text,'designation_x005F_xx','ALTERNATENAMELIST');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'MDSR_749_DESIGN_T','ALTERNATENAMELIST_ITEM');

UPDATE MDSR_FB_XML_TEMP set text=replace(text,'referenceDocument_x005F_xx','REFERENCEDOCUMENTSLIST') ;
update MDSR_FB_XML_TEMP set text=replace(text,'MDSR_749_RD_T','REFERENCEDOCUMENTSLIST_ITEM');

update MDSR_FB_XML_TEMP set text=replace(text,'<?xml version="1.0"?>','<?xml version="1.0" encoding="UTF-8"?>');
--update MDSR_FB_XML_TEMP set text=replace(text,'DATA_ELEMENT_x005F_xx','dataElement');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'PermissibleValue_x005F_xx','PermissibleValues' );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'MDSR_749_PV_T','PermissibleValues_ITEM');

UPDATE MDSR_FB_XML_TEMP set text=replace(text,'language','Language');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'longName','LongName');






  commit;
 EXCEPTION
    WHEN OTHERS THEN
   errmsg := SQLERRM;
         dbms_output.put_line('errmsg  - '||errmsg);
     --   insert into SBREXT.MDSR_FB_XML_REPORT_ERR VALUES (l_file_name,  errmsg, sysdate);
     commit;

END ;
/


DROP PROCEDURE SBREXT.MDSR_CEATE_DESIGNATIONS;

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


DROP PROCEDURE SBREXT.MDSR_CLEAN_DE_QUEST;

CREATE OR REPLACE PROCEDURE SBREXT.MDSR_CLEAN_DE_QUEST AS
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

  EXCEPTION
    WHEN OTHERS THEN
        errmsg := SQLERRM;
        dbms_output.put_line('errmsg - '||errmsg||', '||' cde_id, version:'||i.cde_id||'v'||i.version);
        raise_application_error(-20000, SQLCODE||', '||' cde_id, version:'||i.cde_id||'v'||i.version);
 end;
  end loop;

commit;

END MDSR_CLEAN_DE_QUEST;
/


DROP PROCEDURE SBREXT.MDSR_RECAP_FORM_FIX_SQL;

CREATE OR REPLACE PROCEDURE SBREXT.MDSR_RECAP_FORM_FIX_SQL(p_run IN NUMBER) as

CURSOR c_form IS
select long_name,rf.FORM_NAME_NEW,rf.preferred_definition correct_def,q.preferred_definition,q.modified_by,q.DATE_MODIFIED,qc_id,qc_idseq,created_by,date_created,QTL_NAME,version
from sbrext.quest_contents_ext q,
SBREXT.MDSR_REDCAP_FORM_FL rf
where q.long_name=rf.FORM_NAME_NEW
and q.qtl_name='CRF'
and length(trim(q.preferred_definition))<>length(trim(rf.preferred_definition))
and NVL(modified_by,'FORMLOADER') ='FORMLOADER';


 l_FORM_name      VARCHAR2 (100):='NA';
   l_where       VARCHAR2 (1000);
   l_SQL         CLOB:=null;
   l_update       VARCHAR2 (4000);
   l_qtl        VARCHAR2 (3):='CRF';
   I_FR_ID  VARCHAR2 (30);
   errmsg VARCHAR2(500):='Non';
   v_protocol VARCHAR2(50):='';
   formatme CLOB;
   formatstr CLOB ;
BEGIN
FOR rec IN c_form LOOP
BEGIN
      l_FORM_name:=rec.long_name;
      UPDATE sbrext.quest_contents_ext  set preferred_definition=rec.correct_def
      where rec.qc_idseq=rec.qc_idseq;
      insert into SBREXT.MDSR_QUEST_CONTENTS_REDCAP_BK
          ( QC_IDSEQ,  QC_ID ,  VERSION ,  QTL_NAME, PREFERRED_DEFINITION   ,  LONG_NAME ,  DATE_CREATED,
  CREATED_BY , DATE_MODIFIED,MODIFIED_BY,  DATE_INSERTED)      VALUES
       ( rec.QC_IDSEQ,  rec.QC_ID ,  rec.VERSION ,  rec.QTL_NAME, rec.PREFERRED_DEFINITION   ,  rec.LONG_NAME ,  rec.DATE_CREATED,
  rec.CREATED_BY , rec.DATE_MODIFIED,rec.MODIFIED_BY, SYSDATE);

     
  commit;
      
    EXCEPTION
    WHEN OTHERS THEN
    errmsg := SQLERRM;
         dbms_output.put_line('errmsg insert - '||errmsg);
         rollback;     
       insert into SBREXT.MDSR_QUEST_CONTENTS_UPDATE_ERR values(rec.QC_ID,rec.QTL_NAME, errmsg ,SYSDATE);
     commit;
     END;
     END LOOP;
     END;
/


DROP PROCEDURE SBREXT.MDSR_RECAP_FRINST_FIX_SQL;

CREATE OR REPLACE PROCEDURE SBREXT.MDSR_RECAP_FRINST_FIX_SQL(p_run IN NUMBER) as


CURSOR c_mod IS
select i.long_name,rf.FORM_NAME_NEW,rf.instructions,i.preferred_definition,i.modified_by,i.DATE_MODIFIED,i.qc_id,i.qc_idseq,i.created_by,i.date_created,i.QTL_NAME,i.version

from sbrext.quest_contents_ext f,
sbrext.quest_contents_ext i,
SBREXT.MDSR_REDCAP_FORM_FL  rf
where i.dn_crf_idseq =f.qc_idseq 
and f.long_name =rf.FORM_NAME_NEW
and f.QTL_NAME='CRF'
and  i.QTL_NAME ='FORM_INSTR'
--and m.date_created>sysdate-11
and --i.long_name <>rf.FORM_NAME_NEW
trim(instructions)<>trim(i.long_name)
and NVL(i.modified_by,'FORMLOADER') ='FORMLOADER';


 l_FORM_name      VARCHAR2 (100):='NA';
   l_where       VARCHAR2 (1000);
   l_SQL         CLOB:=null;
   l_update       VARCHAR2 (4000);
   l_qtl        VARCHAR2 (3):='CRF';
   I_FR_ID  VARCHAR2 (30);
   errmsg VARCHAR2(500):='Non';
   v_protocol VARCHAR2(50):='';
   v_ctn number;
   formatme CLOB;
   formatstr CLOB ;
BEGIN
FOR rec IN c_mod LOOP
BEGIN


       
     UPDATE sbrext.quest_contents_ext  
     set preferred_definition= rec.instructions,long_name=rec.FORM_NAME_NEW
     where   qc_idseq =rec.qc_idseq;
      insert into SBREXT.MDSR_QUEST_CONTENTS_REDCAP_BK
          ( QC_IDSEQ,  QC_ID ,  VERSION ,  QTL_NAME, PREFERRED_DEFINITION   ,  LONG_NAME ,  DATE_CREATED,
  CREATED_BY , DATE_MODIFIED,MODIFIED_BY,  DATE_INSERTED)      VALUES
       ( rec.QC_IDSEQ,  rec.QC_ID ,  rec.VERSION ,  rec.QTL_NAME, rec.PREFERRED_DEFINITION   ,  rec.LONG_NAME ,  rec.DATE_CREATED,
  rec.CREATED_BY , rec.DATE_MODIFIED,rec.MODIFIED_BY, SYSDATE);

     
  commit;
      
    EXCEPTION
    WHEN OTHERS THEN
    errmsg := SQLERRM;
         dbms_output.put_line('errmsg insert - '||errmsg);
         rollback;     
       insert into SBREXT.MDSR_QUEST_CONTENTS_UPDATE_ERR values(rec.QC_ID,rec.QTL_NAME, errmsg ,SYSDATE);
     commit;
     END;
     END LOOP;
     END;
/


DROP PROCEDURE SBREXT.MDSR_RECAP_MODE_FIX_SQL;

CREATE OR REPLACE PROCEDURE SBREXT.MDSR_RECAP_MODE_FIX_SQL(p_run IN NUMBER) as


CURSOR c_mod IS
select form_name,trim(section_new) correct_mod_name,m.long_name ,m.preferred_definition,SECTION_SEQ ,m.display_order ,m.QC_IDSEQ,m.qc_id,m.VERSION,
m.modified_by,m.DATE_MODIFIED,m.created_by,m.date_created,m.QTL_NAME
from sbrext.quest_contents_ext f,
sbrext.quest_contents_ext m,
SBREXT.MDSR_REDCAP_SECTION_FL r
where m.dn_crf_idseq =f.qc_idseq 
and f.long_name =r.form_name
and f.QTL_NAME='CRF'
and  m.QTL_NAME ='MODULE'
and SECTION_SEQ=m.display_order
--and m.date_created>sysdate-11
and trim(section_new)<>trim(m.long_name)
and NVL(m.modified_by,'FORMLOADER') ='FORMLOADER';


 l_FORM_name      VARCHAR2 (100):='NA';
   l_where       VARCHAR2 (1000);
   l_SQL         CLOB:=null;
   l_update       VARCHAR2 (4000);
   l_qtl        VARCHAR2 (3):='CRF';
   I_FR_ID  VARCHAR2 (30);
   errmsg VARCHAR2(500):='Non';
   v_protocol VARCHAR2(50):='';
   v_ctn number;
   formatme CLOB;
   formatstr CLOB ;
BEGIN
FOR rec IN c_mod LOOP
BEGIN


       
     UPDATE sbrext.quest_contents_ext  
     set preferred_definition= rec.correct_mod_name,long_name=rec.correct_mod_name
     where   qc_idseq =rec.qc_idseq;
      insert into SBREXT.MDSR_QUEST_CONTENTS_REDCAP_BK
          ( QC_IDSEQ,  QC_ID ,  VERSION ,  QTL_NAME, PREFERRED_DEFINITION   ,  LONG_NAME ,  DATE_CREATED,
  CREATED_BY , DATE_MODIFIED,MODIFIED_BY,  DATE_INSERTED)      VALUES
       ( rec.QC_IDSEQ,  rec.QC_ID ,  rec.VERSION ,  rec.QTL_NAME, rec.PREFERRED_DEFINITION   ,  rec.LONG_NAME ,  rec.DATE_CREATED,
  rec.CREATED_BY , rec.DATE_MODIFIED,rec.MODIFIED_BY, SYSDATE);

     
  commit;
      
    EXCEPTION
    WHEN OTHERS THEN
    errmsg := SQLERRM;
         dbms_output.put_line('errmsg insert - '||errmsg);
         rollback;     
       insert into SBREXT.MDSR_QUEST_CONTENTS_UPDATE_ERR values(rec.QC_ID,rec.QTL_NAME, errmsg ,SYSDATE);
     commit;
     END;
     END LOOP;
     END;
/


DROP PROCEDURE SBREXT.MDSR_RECAP_QUEST_FIX_SQL;

CREATE OR REPLACE PROCEDURE SBREXT.MDSR_RECAP_QUEST_FIX_SQL(p_run IN NUMBER) as



CURSOR c_quest IS
select form_name_new,m.long_name mod_name,form_question correct_question,instructions,
i.long_name incorrect_instr,m.display_order mod_order, i.display_order ,i.PREFERRED_DEFINITION,
i.qc_id,i.VERSION,i.QC_IDSEQ,i.QTL_NAME,i.CREATED_BY,i.MODIFIED_BY,i.date_modified,i.DATE_CREATED
from sbrext.quest_contents_ext f,
SBREXT.MDSR_REDCAP_QC_FL r,
sbrext.quest_contents_ext  q,
sbrext.quest_contents_ext  i,
sbrext.quest_contents_ext  m
--,REDCAP_SECTION_751 s
where m.dn_crf_idseq =f.qc_idseq 
and f.long_name=r.form_name_new
and q.p_MOD_IDSEQ=m.qc_idseq
and i.P_QST_IDSEQ =q.QC_IDSEQ
and f.QTL_NAME='CRF'
and m.QTL_NAME='MODULE'
and q.QTL_NAME ='QUESTION'
and i.QTL_NAME ='QUESTION_INSTR'
and m.display_order=r.SECTION_SEQ
and q.display_order=r.SECTION_Q_SEQ
and NVL(i.modified_by,'FORMLOADER') ='FORMLOADER'
and instructions<>i.long_name
order by 1,5,6;


 l_FORM_name      VARCHAR2 (100):='NA';
   l_where       VARCHAR2 (1000);
   l_SQL         CLOB:=null;
   l_update       VARCHAR2 (4000);
   l_qtl        VARCHAR2 (3):='CRF';
   I_FR_ID  VARCHAR2 (30);
   errmsg VARCHAR2(500):='Non';
   v_protocol VARCHAR2(50):='';
   v_ctn number;
   formatme CLOB;
   formatstr CLOB ;
BEGIN
FOR rec IN c_quest LOOP
BEGIN


       
     UPDATE sbrext.quest_contents_ext  
     set preferred_definition= rec.instructions,long_name=rec.instructions
     where   qc_idseq =rec.qc_idseq;
      insert into SBREXT.MDSR_QUEST_CONTENTS_REDCAP_BK
          ( QC_IDSEQ,  QC_ID ,  VERSION ,  QTL_NAME, PREFERRED_DEFINITION   ,  LONG_NAME ,  DATE_CREATED,
  CREATED_BY , DATE_MODIFIED,MODIFIED_BY,  DATE_INSERTED)      VALUES
       ( rec.QC_IDSEQ,  rec.QC_ID ,  rec.VERSION ,  rec.QTL_NAME, rec.PREFERRED_DEFINITION   ,  rec.incorrect_instr ,  rec.DATE_CREATED,
  rec.CREATED_BY , rec.DATE_MODIFIED,rec.MODIFIED_BY, SYSDATE);

     
  commit;
      
    EXCEPTION
    WHEN OTHERS THEN
    errmsg := SQLERRM;
         dbms_output.put_line('errmsg insert - '||errmsg);
         rollback;     
       insert into SBREXT.MDSR_QUEST_CONTENTS_UPDATE_ERR values(rec.QC_ID,rec.QTL_NAME, errmsg ,SYSDATE);
     commit;
     END;
     END LOOP;
     END;
/


DROP PROCEDURE SBREXT.MDSR_RECAP_QUEST_INSTR_FIX_SQL;

CREATE OR REPLACE PROCEDURE SBREXT.MDSR_RECAP_QUEST_INSTR_FIX_SQL(p_run IN NUMBER) as



CURSOR c_quest IS
select form_name_new,m.long_name mod_name,form_question correct_question,instructions,
i.long_name incorrect_instr,m.display_order mod_order, i.display_order ,i.PREFERRED_DEFINITION,
i.qc_id,i.VERSION,i.QC_IDSEQ,i.QTL_NAME,i.CREATED_BY,i.MODIFIED_BY,i.date_modified,i.DATE_CREATED
from sbrext.quest_contents_ext f,
SBREXT.MDSR_REDCAP_QC_FL r,
sbrext.quest_contents_ext  q,
sbrext.quest_contents_ext  i,
sbrext.quest_contents_ext  m
--,REDCAP_SECTION_751 s
where m.dn_crf_idseq =f.qc_idseq 
and f.long_name=r.form_name_new
and q.p_MOD_IDSEQ=m.qc_idseq
and i.P_QST_IDSEQ =q.QC_IDSEQ
and f.QTL_NAME='CRF'
and m.QTL_NAME='MODULE'
and q.QTL_NAME ='QUESTION'
and i.QTL_NAME ='QUESTION_INSTR'
and m.display_order=r.SECTION_SEQ
and q.display_order=r.SECTION_Q_SEQ
and NVL(i.modified_by,'FORMLOADER') ='FORMLOADER'
and instr(i.long_name,instructions)=0
order by 1,5,6;


 l_FORM_name      VARCHAR2 (100):='NA';
   l_where       VARCHAR2 (1000);
   l_SQL         CLOB:=null;
   l_update       VARCHAR2 (4000);
   l_qtl        VARCHAR2 (3):='CRF';
   I_FR_ID  VARCHAR2 (30);
   errmsg VARCHAR2(500):='Non';
   v_protocol VARCHAR2(50):='';
   v_ctn number;
   formatme CLOB;
   formatstr CLOB ;
BEGIN
FOR rec IN c_quest LOOP
BEGIN


       
     UPDATE sbrext.quest_contents_ext  
     set preferred_definition= rec.instructions,long_name=rec.instructions
     where   qc_idseq =rec.qc_idseq;
      insert into SBREXT.MDSR_QUEST_CONTENTS_REDCAP_BK
          ( QC_IDSEQ,  QC_ID ,  VERSION ,  QTL_NAME, PREFERRED_DEFINITION   ,  LONG_NAME ,  DATE_CREATED,
  CREATED_BY , DATE_MODIFIED,MODIFIED_BY,  DATE_INSERTED)      VALUES
       ( rec.QC_IDSEQ,  rec.QC_ID ,  rec.VERSION ,  rec.QTL_NAME, rec.PREFERRED_DEFINITION   ,  rec.incorrect_instr ,  rec.DATE_CREATED,
  rec.CREATED_BY , rec.DATE_MODIFIED,rec.MODIFIED_BY, SYSDATE);

     
  commit;
      
    EXCEPTION
    WHEN OTHERS THEN
    errmsg := SQLERRM;
         dbms_output.put_line('errmsg insert - '||errmsg);
         rollback;     
       insert into SBREXT.MDSR_QUEST_CONTENTS_UPDATE_ERR values(rec.QC_ID,rec.QTL_NAME, errmsg ,SYSDATE);
     commit;
     END;
     END LOOP;
     END;
/


DROP PROCEDURE SBREXT.MDSR_UPDATE_DE_QUEST;

CREATE OR REPLACE PROCEDURE SBREXT.MDSR_UPDATE_DE_QUEST AS
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

  EXCEPTION
    WHEN OTHERS THEN
        errmsg := SQLERRM;
        dbms_output.put_line('errmsg2 - '||errmsg);    
        raise_application_error(-20000, SQLCODE);          
 end;
  end loop;

commit;

END MDSR_UPDATE_DE_QUEST;
/


DROP PROCEDURE SBREXT.MDSR_XML_CDE_INSERT;

CREATE OR REPLACE PROCEDURE SBREXT.MDSR_xml_CDE_insert as

CURSOR c_gr IS
SELECT  distinct GROUP_NUMBER GROUP_NUMBER from sbrext.MDSR_CONTEXT_GROUP_749_VW
--where GROUP_NUMBER<6
  order by 1 ;/**/


 l_file_name      VARCHAR2 (100):='NA';
   l_file_path      VARCHAR2 (200);
   l_result         CLOB:=null;
   l_xmldoc          CLOB:=null;
   l_pid        VARCHAR2 (30);
   I_FR_ID  VARCHAR2 (30);
   errmsg VARCHAR2(500):='Non';
   v_protocol VARCHAR2(50):='';
BEGIN
FOR rec IN c_gr LOOP
BEGIN
        if rec.GROUP_NUMBER<12 then
        SELECT  distinct name into l_file_name from sbrext.MDSR_CONTEXT_GROUP_749_VW
        where GROUP_NUMBER=rec.GROUP_NUMBER       ;
        elsif rec.GROUP_NUMBER=12 then
        l_file_name:='CCR_COG_NIDCR';
        elsif rec.GROUP_NUMBER=13 then
       l_file_name:='Alliance_DCP_ECOGACRIN';
       elsif rec.GROUP_NUMBER=14 then
       l_file_name:='BBRB_NRG_Theradex_PSCC_SPORE';
       else
       l_file_name:='Others';
       end if;

         l_file_name :='CDE_'||l_file_name||'_'||rec.GROUP_NUMBER||'.xml';
        SELECT dbms_xmlgen.getxml( 'select*from  MDSR_DE_XML_749_VW where "GROUP_NUMBER" ='||''''||rec.GROUP_NUMBER||'''')
 INTO l_result
        FROM DUAL ;
        insert into SBREXT.MDSR_CDE_XML_TEMP(TEXT,FILE_NAME,  CREATED_DATE) VALUES (l_result, l_file_name ,SYSDATE);

      --dbms_xslprocessor.clob2file(l_xmldoc,  l_file_path, l_file_name, nls_charset_id('UTF8'));

      commit;
    EXCEPTION
    WHEN OTHERS THEN
    errmsg := SQLERRM;
         dbms_output.put_line('errmsg insert - '||errmsg);
       insert into SBREXT.MDSR_CDE_XML_REPORT_ERR VALUES ('CDE_XML',  errmsg, sysdate);

     commit;
     END;
     END LOOP;
END;
/


DROP PROCEDURE SBREXT.MDSR_XML_CDE_INSERTTEST;

CREATE OR REPLACE PROCEDURE SBREXT.MDSR_xml_CDE_inserttest as

CURSOR c_gr IS
SELECT  distinct GROUP_NUMBER GROUP_NUMBER from sbrext.MDSR_CONTEXT_GROUP_749_VW
--where GROUP_NUMBER<6
  order by 1 ;/**/


 l_file_name      VARCHAR2 (100):='NA';
   l_file_path      VARCHAR2 (200);
   l_result         CLOB:=null;
   l_xmldoc          CLOB:=null;
   l_pid        VARCHAR2 (30);
   I_FR_ID  VARCHAR2 (30);
   errmsg VARCHAR2(500):='Non';
   v_protocol VARCHAR2(50):='';
BEGIN
FOR rec IN c_gr LOOP
BEGIN
        if rec.GROUP_NUMBER<12 then
        SELECT  distinct name into l_file_name from sbrext.MDSR_CONTEXT_GROUP_749_VW
        where GROUP_NUMBER=rec.GROUP_NUMBER       ;
        elsif rec.GROUP_NUMBER=12 then
        l_file_name:='CCR_COG_NIDCR';
        elsif rec.GROUP_NUMBER=13 then
       l_file_name:='Alliance_DCP_ECOGACRIN';
       elsif rec.GROUP_NUMBER=14 then
       l_file_name:='BBRB_NRG_Theradex_PSCC_SPORE';
       else
       l_file_name:='Others';
       end if;

         l_file_name :='CDE_'||l_file_name||'_'||rec.GROUP_NUMBER||'.xml';
        SELECT dbms_xmlgen.getxml( 'select*from  MDSR_DE_XML_749_VW where "GROUP_NUMBER" ='||''''||rec.GROUP_NUMBER||'''')
 INTO l_result
        FROM DUAL ;
        insert into SBREXT.MDSR_CDE_XML_TEMP(TEXT,FILE_NAME,  CREATED_DATE) VALUES (l_result, l_file_name ,SYSDATE);

      --dbms_xslprocessor.clob2file(l_xmldoc,  l_file_path, l_file_name, nls_charset_id('UTF8'));

      commit;
    EXCEPTION
    WHEN OTHERS THEN
    errmsg := SQLERRM;
         dbms_output.put_line('errmsg insert - '||errmsg);
       insert into SBREXT.MDSR_CDE_XML_REPORT_ERR VALUES ('CDE_XML',  errmsg, sysdate);

     commit;
     END;
     END LOOP;
END;
/


DROP PROCEDURE SBREXT.META_FIX_OBJECT_CLASSES_EXT;

CREATE OR REPLACE PROCEDURE SBREXT.META_FIX_OBJECT_CLASSES_EXT IS
v_date  date  ;
V_sdate date:=sysdate;
errmsg VARCHAR2(2000):='Non';
/******************************************************************************
   NAME:       META_FIX_OBJECT_CLASSES_EXT
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

insert into  SBREXT.CT_OBJECT_CLASSES_EXT_BKUP
(
           OC_IDSEQ ,
           PREFERRED_DEFINITION,
           LONG_NAME,
           DATE_MODIFIED,
           DATE_INSERT,
           MODIFIED_BY
)

select     OC_IDSEQ ,
           PREFERRED_DEFINITION,
           LONG_NAME,
           DATE_MODIFIED,
           SYSDATE    ,
           MODIFIED_BY
from SBREXT.OBJECT_CLASSES_EXT
where SBREXT.meta_FIND_SP_CHAR(LONG_NAME)>0
or SBREXT.meta_FIND_SP_CHAR(PREFERRED_DEFINITION)>0 ;

commit;
 UPDATE SBREXT.OBJECT_CLASSES_EXT set
date_modified=v_date, modified_by='DWARZEL',
LONG_NAME=SBREXT.meta_CleanSP_CHAR(LONG_NAME)
where SBREXT.meta_FIND_SP_CHAR(LONG_NAME)>0 ;


UPDATE SBREXT.OBJECT_CLASSES_EXT set
date_modified=v_date, modified_by='DWARZEL',
PREFERRED_DEFINITION=SBREXT.meta_CleanSP_CHAR(PREFERRED_DEFINITION)
where SBREXT.meta_FIND_SP_CHAR(PREFERRED_DEFINITION)>0 ;

 commit;
    EXCEPTION
    WHEN OTHERS THEN
       errmsg := substr(SQLERRM,1,2000);
       insert into SBREXT.META_SPCHAR_ERROR_LOG VALUES('META_FIX_OBJECT_CLASSES_EXT',   sysdate ,errmsg);

     commit;
END META_FIX_OBJECT_CLASSES_EXT;
/


DROP PROCEDURE SBREXT.META_FIX_PROPERTIES_EXT;

CREATE OR REPLACE PROCEDURE SBREXT.META_FIX_PROPERTIES_EXT IS
v_date  date  ;
V_sdate date:=sysdate;
errmsg VARCHAR2(2000):='Non';
/******************************************************************************
   NAME:       META_FIX_CD_VMS
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        8/11/2016   trushi2       1. Created this procedure.

   NOTES:
      Object Name:     META_FIX_CD_VMS
      Sysdate:         8/11/2016
      Date and Time:   8/11/2016, 12:31:43 PM, and 8/11/2016 12:31:43 PM
      Username:        trushi2 (set in TOAD Options, Procedure Editor)

******************************************************************************/
BEGIN


select to_date(to_char(sysdate,'mm/dd/yyyy')||'12:34:56','mm/dd/yyyyhh24:mi:ss')
into v_date from dual;

insert into SBREXT.CT_PROPERTIES_EXT_BKUP
(PROP_IDSEQ              ,
  PREFERRED_NAME        ,
  LONG_NAME            ,
  PREFERRED_DEFINITION  ,
  CONTE_IDSEQ           ,
  VERSION               ,
  ASL_NAME              ,
  CHANGE_NOTE           ,
  DEFINITION_SOURCE     ,
  DATE_INSERT           ,
  DATE_MODIFIED        ,
  MODIFIED_BY          ,
  PROP_ID
)

select
PROP_IDSEQ              ,
  PREFERRED_NAME        ,
  LONG_NAME            ,
  PREFERRED_DEFINITION  ,
  CONTE_IDSEQ           ,
  VERSION               ,
  ASL_NAME              ,
  CHANGE_NOTE           ,
  DEFINITION_SOURCE     ,
  SYSDATE           ,
  DATE_MODIFIED        ,
  MODIFIED_BY          ,
  PROP_ID
from SBREXT.PROPERTIES_EXT
where SBREXT.meta_FIND_SP_CHAR(LONG_NAME)>0
or SBREXT.meta_FIND_SP_CHAR(PREFERRED_DEFINITION)>0 ;

commit;
UPDATE SBREXT.PROPERTIES_EXT  set
date_modified=v_date, modified_by='DWARZEL',
LONG_NAME=SBREXT.meta_CleanSP_CHAR(LONG_NAME)
where SBREXT.meta_FIND_SP_CHAR(LONG_NAME)>0 ;


UPDATE SBREXT.PROPERTIES_EXT  set
date_modified=v_date, modified_by='DWARZEL',
PREFERRED_DEFINITION=SBREXT.meta_CleanSP_CHAR(PREFERRED_DEFINITION)
where SBREXT.meta_FIND_SP_CHAR(PREFERRED_DEFINITION)>0 ;

 commit;

 EXCEPTION

    WHEN OTHERS THEN

    errmsg := substr(SQLERRM,1,2000);
         dbms_output.put_line('errmsg  - '||errmsg);
        insert into SBREXT.META_SPCHAR_ERROR_LOG VALUES('META_FIX_PROPERTIES_EXT',   sysdate ,errmsg);

     commit;
END META_FIX_PROPERTIES_EXT;
/


DROP PROCEDURE SBREXT.META_FIX_REPRESENTATIONS_EXT;

CREATE OR REPLACE PROCEDURE SBREXT.META_FIX_REPRESENTATIONS_EXT IS
v_date  date  ;
V_sdate date:=sysdate;
errmsg VARCHAR2(2000):='Non';
/******************************************************************************
   NAME:       META_FIX_REPRESENTATIONS_EXT
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

insert into  SBREXT.CT_REPRESENTATIONS_EXT_BKUP
(
             REP_IDSEQ  ,
           PREFERRED_DEFINITION,
           LONG_NAME,
           DATE_MODIFIED,
           DATE_INSERT,
           MODIFIED_BY
)

select     REP_IDSEQ ,
           PREFERRED_DEFINITION,
           LONG_NAME,
           DATE_MODIFIED,
           SYSDATE    ,
           MODIFIED_BY
from SBREXT.REPRESENTATIONS_EXT
where SBREXT.meta_FIND_SP_CHAR(LONG_NAME)>0
or SBREXT.meta_FIND_SP_CHAR(PREFERRED_DEFINITION)>0 ;
commit;

 UPDATE SBREXT.REPRESENTATIONS_EXT set
date_modified=v_date, modified_by='DWARZEL',
LONG_NAME=SBREXT.meta_CleanSP_CHAR(LONG_NAME)
where SBREXT.meta_FIND_SP_CHAR(LONG_NAME)>0 ;


UPDATE SBREXT.REPRESENTATIONS_EXT set
date_modified=v_date, modified_by='DWARZEL',
PREFERRED_DEFINITION=SBREXT.meta_CleanSP_CHAR(PREFERRED_DEFINITION)
where SBREXT.meta_FIND_SP_CHAR(PREFERRED_DEFINITION)>0 ;
 commit;
    EXCEPTION
    WHEN OTHERS THEN
       errmsg := substr(SQLERRM,1,2000);
       insert into SBREXT.META_SPCHAR_ERROR_LOG VALUES('META_FIX_REPRESENTATIONS_EXT',   sysdate ,errmsg);

     commit;
END META_FIX_REPRESENTATIONS_EXT;
/


DROP PROCEDURE SBREXT.META_FIX_SPCHAR_VV_ATT_EXT;

CREATE OR REPLACE PROCEDURE SBREXT.META_FIX_SPCHAR_VV_ATT_EXT IS
v_date  date  ;
V_sdate date:=sysdate;
errmsg VARCHAR2(2000):='Non';
/******************************************************************************
   NAME:       META_FIX_SPCHAR_VV_ATT_EXT
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        8/11/2016   trushi2       1. Created this procedure.

   NOTES:
      Object Name:     META_FIX_SPCHAR_VV_ATT_EXT
      Sysdate:         8/11/2016
      Date and Time:   8/11/2016, 12:31:43 PM, and 8/11/2016 12:31:43 PM
      Username:        trushi2 (set in TOAD Options, Procedure Editor)

******************************************************************************/
BEGIN


select to_date(to_char(sysdate,'mm/dd/yyyy')||'12:34:56','mm/dd/yyyyhh24:mi:ss')
into v_date from dual;

insert into  SBREXT.CT_VALID_VALUES_ATT_EXT_BKUP
(
  QC_IDSEQ          ,
  MEANING_TEXT      ,
  DATE_MODIFIED     ,
  DATE_INSERT,
  MODIFIED_BY       ,
  DESCRIPTION_TEXT
)

select QC_IDSEQ          ,
  MEANING_TEXT      ,
  DATE_MODIFIED     ,
  SYSDATE,
  MODIFIED_BY       ,
  DESCRIPTION_TEXT
from SBREXT.VALID_VALUES_ATT_EXT
WHERE SBREXT.meta_FIND_SP_CHAR(MEANING_TEXT)>0 or
 SBREXT.meta_FIND_SP_CHAR(DESCRIPTION_TEXT)>0;

commit;


UPDATE SBREXT.VALID_VALUES_ATT_EXT set
date_modified=v_date, modified_by='DWARZEL',
MEANING_TEXT=SBREXT.meta_CleanSP_CHAR(MEANING_TEXT)
where SBREXT.meta_FIND_SP_CHAR(MEANING_TEXT)>0;


UPDATE SBREXT.VALID_VALUES_ATT_EXT set
date_modified=v_date, modified_by='DWARZEL',
DESCRIPTION_TEXT=SBREXT.meta_CleanSP_CHAR(DESCRIPTION_TEXT)
where SBREXT.meta_FIND_SP_CHAR(DESCRIPTION_TEXT)>0;

 commit;
 EXCEPTION

    WHEN OTHERS THEN
       errmsg := substr(SQLERRM,1,2000);
         dbms_output.put_line('errmsg  - '||errmsg);
        insert into SBREXT.META_SPCHAR_ERROR_LOG VALUES('META_FIX_SPCHAR_VV_ATT_EXT',   sysdate ,errmsg);

     commit;
END META_FIX_SPCHAR_VV_ATT_EXT;
/


DROP PROCEDURE SBREXT.PROCESS_NEW_QTNS_AND_VVS;

CREATE OR REPLACE PROCEDURE SBREXT.Process_New_Qtns_And_Vvs(P_CRF_NAME IN VARCHAR2) IS
/******************************************************************************
   NAME:       Process_New_Qtns_And_Vvs
   PURPOSE:    This procedure process the new questions and valid values after the match algorithm
			   has been executed. It processes the not exact match Questions and Valid Values creating
			   Data element Concepts, value domains, data elements, reference documents
			   and finally updating the quest_content_ext for questions and valid values setting the
			   status to exact match.

			   Processing of matching DE's which have CDE_ID's is not correct. Currently the code
			   assumes that a match never occurs.
			   Processing is incorrect for questions which have been marked as EXACT MATCH by the match algorithm
			   however the corressponding valid values are not marked as exact matches. These questions
			   will not be processed currently.

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        03/06/2002  Harsh Marwaha




******************************************************************************/
  /*
  ** This cursor gets the CRF data for a given CRF preferred name
  */
  CURSOR C_GET_CRF_DATA(B_CRF_NAME IN VARCHAR2) IS
     SELECT qce.qc_idseq,
            qce.conte_idseq context_id,
            qce.long_name
     FROM   QUEST_CONTENTS_EXT qce
     WHERE qce.preferred_name = B_CRF_NAME
     AND   qce.qtl_name = 'CRF';
  R_CONTEXT            C_GET_CRF_DATA%ROWTYPE;
  /*
  ** This query gets the no EXACT MATCH  questions and valid values for a particular CRF
  ** in the display order.
  */
  CURSOR C_NO_MATCH_QTNS_VVS(B_QC_IDSEQ IN VARCHAR2) IS
  (SELECT  qce1.qc_idseq      form_idseq,
           qce1.CONTE_IDSEQ   context_idseq,
	   qce2.qc_idseq      module_idseq,
	   qce3.qc_idseq      question_idseq,
	   qce4.qc_idseq      vv_idseq,
	   qce3.de_idseq      de_idseq,
	   qce4.vp_idseq      vp_id_seq,
	   qce1.long_name     crf_name,
	   qce2.long_name     module_name,
	   qce3.long_name     de_long_name_in_qce,
	   qce4.long_name     valid_value,
	   qce3.preferred_definition qce_preferred_definition,
	   qce3.submitted_long_cde_name ,
	   qce3.asl_name ques_asl_name,
	   qce4.asl_name vv_asl_name,
	   qce4.qtl_name,
	   qce4.PREFERRED_NAME  PREFERRED_NAME
FROM   QUEST_CONTENTS_EXT qce1,
	   QUEST_CONTENTS_EXT qce2,
	   QUEST_CONTENTS_EXT qce3,
	   QUEST_CONTENTS_EXT qce4,
	   QC_RECS_EXT qre1,
	   QC_RECS_EXT qre2,
	   QC_RECS_EXT qre3
WHERE  qce1.qtl_name = 'CRF'
AND    qce1.QC_IDSEQ = B_QC_IDSEQ
AND    qce1.qc_idseq = qre1.p_qc_idseq
AND    qce2.qc_idseq  = qre1.c_qc_idseq
AND    qce2.LATEST_VERSION_IND = 'Yes'
AND	   qre1.rl_name   = 'FORM_MODULE'
AND    qce2.qtl_name  = 'MODULE'
AND    qre1.c_qc_idseq   = qre2.p_qc_idseq (+)
AND    qre2.c_qc_idseq   = qce3.qc_idseq (+)
AND    qce3.qtl_name (+) = 'QUESTION'
AND    qce3.LATEST_VERSION_IND(+) = 'Yes'
AND    qce3.ASL_NAME <> 'EXACT MATCH'
AND    qre2.rl_name (+)  = 'MODULE_ELEMENT'
AND    qce4.qtl_name (+) = 'VALID_VALUE'
AND    qce4.ASL_NAME <> 'EXACT MATCH'
AND    qce4.LATEST_VERSION_IND(+) = 'Yes'
AND    qre3.p_qc_idseq (+)= qre2.c_qc_idseq
AND    qre3.c_qc_idseq = qce4.qc_idseq (+))
UNION
(SELECT qce1.qc_idseq   form_idseq,
       qce1.conte_idseq  context_idseq,
	   qce2.qc_idseq    module_idseq,
	   qce3.qc_idseq    question_idseq,
	   ' '              vv_idseq, -- The space is set for vv_idseq so that the question element comes
	   qce3.de_idseq    de_idseq, -- first after the sort.
	   NULL             vp_idseq,
	   qce1.long_name   crf_name,
	   qce2.long_name   module_name,
	   qce3.long_name   de_long_name_in_qce,
	   NULL             valid_value,
	   qce3.preferred_definition qce_preferred_definition,
	   qce3.submitted_long_cde_name ,
	   qce3.asl_name ques_asl_name,
	   NULL vv_asl_name,
	   qce3.QTL_NAME,
	   qce3.PREFERRED_NAME PREFERRED_NAME
FROM   QUEST_CONTENTS_EXT qce1,
	   QUEST_CONTENTS_EXT qce2,
	   QUEST_CONTENTS_EXT qce3,
	   QC_RECS_EXT qre1,
	   QC_RECS_EXT qre2
WHERE  qce1.qtl_name = 'CRF'
AND    qce1.QC_IDSEQ = B_QC_IDSEQ
AND    qce1.qc_idseq = qre1.p_qc_idseq
AND    qce2.qc_idseq  = qre1.c_qc_idseq
AND    qce2.LATEST_VERSION_IND = 'Yes'
AND    qre1.rl_name   = 'FORM_MODULE'
AND    qce2.qtl_name  = 'MODULE'
AND    qre1.c_qc_idseq   = qre2.p_qc_idseq (+)
AND    qre2.c_qc_idseq   = qce3.qc_idseq (+)
AND    qce3.qtl_name (+) = 'QUESTION'
AND    qce3.LATEST_VERSION_IND(+) = 'Yes'
AND    qce3.ASL_NAME <> 'EXACT MATCH'
AND    qre2.rl_name (+)  = 'MODULE_ELEMENT')
ORDER BY    form_idseq, module_idseq,  question_idseq,  vv_idseq;

    /*
    ** Cursor to get the count of conceptual domain id for a given context.
    */
    CURSOR C_GET_CD_COUNT(B_CONTE_IDSEQ IN VARCHAR2) IS
      SELECT COUNT(CD.CD_IDSEQ)
      FROM   SBR.CONCEPTUAL_DOMAINS CD
      WHERE  CD.CONTE_IDSEQ = B_CONTE_IDSEQ;
    v_cd_count       NUMBER(10);
    /*
    ** Cursor to get the conceptual domain id for a given context.
    */
    CURSOR C_GET_CD_ID(B_CONTE_IDSEQ IN VARCHAR2) IS
      SELECT CD.CD_IDSEQ
      FROM   SBR.CONCEPTUAL_DOMAINS CD
      WHERE  CD.CONTE_IDSEQ = B_CONTE_IDSEQ;
    R_CD                  C_GET_CD_ID%ROWTYPE;

   /*
   ** Cursor to check if the data element concent exists for this context.
   */
   CURSOR C_CHK_DEC(B_CTX_LONG_NAME IN VARCHAR2) IS
     SELECT DEC.DEC_IDSEQ
     FROM   SBR.DATA_ELEMENT_CONCEPTS DEC
     WHERE  DEC.LONG_NAME = B_CTX_LONG_NAME;
   V_DEC_IDSEQ      SBR.DATA_ELEMENT_CONCEPTS.DEC_IDSEQ%TYPE;
-- Exceptions
    E_CRF_NOTFOUND        EXCEPTION;
    E_CD_NOTFOUND         EXCEPTION;
    E_MULTIPLE_CD         EXCEPTION;
	E_DATA_ELEMENT_EXISTS EXCEPTION;
-- Data Element Concept items
    V_DEC_RETURN_CODE            VARCHAR2(100);
    V_DEC_VERSION            SBR.DATA_ELEMENT_CONCEPTS.VERSION%TYPE;
	V_DEC_CONTE_IDSEQ	     SBR.DATA_ELEMENT_CONCEPTS.CONTE_IDSEQ%TYPE;
    V_DEC_PREFERRED_NAME	 SBR.DATA_ELEMENT_CONCEPTS.PREFERRED_NAME%TYPE;
	V_DEC_CD_IDSEQ           SBR.DATA_ELEMENT_CONCEPTS.CD_IDSEQ%TYPE;
    V_DEC_ASL_NAME           SBR.DATA_ELEMENT_CONCEPTS.ASL_NAME%TYPE;
	V_DEC_LONG_NAME          SBR.DATA_ELEMENT_CONCEPTS.LONG_NAME%TYPE;
    V_DEC_OCL_NAME           SBR.DATA_ELEMENT_CONCEPTS.OCL_NAME%TYPE;
	V_DEC_PREFERRED_DEFINITION SBR.DATA_ELEMENT_CONCEPTS.PREFERRED_DEFINITION%TYPE;
    V_DEC_LATEST_VERSION_IND SBR.DATA_ELEMENT_CONCEPTS.LATEST_VERSION_IND%TYPE;
    V_DEC_PROPL_NAME         SBR.DATA_ELEMENT_CONCEPTS.PROPL_NAME%TYPE;
    V_DEC_PROPERTY_QUALIFIER SBR.DATA_ELEMENT_CONCEPTS.PROPERTY_QUALIFIER%TYPE;
    V_DEC_OBJ_CLASS_QUALIFIER SBR.DATA_ELEMENT_CONCEPTS.OBJ_CLASS_QUALIFIER%TYPE;
    V_DEC_BEGIN_DATE         SBR.DATA_ELEMENT_CONCEPTS.BEGIN_DATE%TYPE;
    V_DEC_END_DATE           SBR.DATA_ELEMENT_CONCEPTS.END_DATE%TYPE;
    V_DEC_DATE_CREATED       SBR.DATA_ELEMENT_CONCEPTS.DATE_CREATED%TYPE;
    V_DEC_CREATED_BY         SBR.DATA_ELEMENT_CONCEPTS.CREATED_BY%TYPE;
    V_DEC_CHANGE_NOTE        SBR.DATA_ELEMENT_CONCEPTS.CHANGE_NOTE%TYPE;
    V_DEC_MODIFIED_BY        SBR.DATA_ELEMENT_CONCEPTS.MODIFIED_BY%TYPE;
    V_DEC_DATE_MODIFIED      SBR.DATA_ELEMENT_CONCEPTS.DATE_MODIFIED%TYPE;
    V_DEC_DELETED_IND         VARCHAR2(30);
-- Value Domain Elements.
    CURSOR C_CHK_VD (B_PREFERRED_NAME IN VARCHAR2, B_VERSION IN NUMBER, B_CONTE_IDSEQ IN VARCHAR2) IS
	  SELECT  VD.VD_IDSEQ
	  FROM SBR.VALUE_DOMAINS VD
	  WHERE VD.VERSION = B_VERSION
	  AND  VD.PREFERRED_NAME = B_PREFERRED_NAME
	  AND  VD.CONTE_IDSEQ = B_CONTE_IDSEQ;
    V_VD_RETURN_CODE	      VARCHAR2(100);
    V_VD_ACTION               VARCHAR2(20);
    V_VD_IDSEQ	              SBR.VALUE_DOMAINS.VD_IDSEQ%TYPE;
    V_VD_CONTE_IDSEQ	      SBR.VALUE_DOMAINS.CONTE_IDSEQ%TYPE;
    V_VD_PREFERRED_NAME	      SBR.VALUE_DOMAINS.PREFERRED_NAME%TYPE;
    V_VD_VERSION	          SBR.VALUE_DOMAINS.VERSION%TYPE;
    V_VD_PREFERRED_DEFINITION SBR.VALUE_DOMAINS.PREFERRED_DEFINITION%TYPE;
    V_VD_CD_IDSEQ	          SBR.VALUE_DOMAINS.CD_IDSEQ%TYPE;
    V_VD_ASL_NAME	          SBR.VALUE_DOMAINS.ASL_NAME%TYPE;
    V_VD_LATEST_VERSION_IND   SBR.VALUE_DOMAINS.LATEST_VERSION_IND%TYPE;
    V_VD_DTL_NAME	          SBR.VALUE_DOMAINS.DTL_NAME%TYPE;
    V_VD_MAX_LENGTH_NUM       SBR.VALUE_DOMAINS.MAX_LENGTH_NUM%TYPE;
    V_VD_LONG_NAME	          SBR.VALUE_DOMAINS.FORML_NAME%TYPE;
    V_VD_FORML_NAME 	      SBR.VALUE_DOMAINS.FORML_NAME%TYPE;
    V_VD_FORML_DESCRIPTION    SBR.FORMATS_LOV.DESCRIPTION%TYPE;
    V_VD_FORML_COMMENT        SBR.FORMATS_LOV.COMMENTS%TYPE;
    V_VD_UOML_NAME            SBR.VALUE_DOMAINS.UOML_NAME%TYPE;
    V_VD_UOML_DESCRIPTION     SBR.UNIT_OF_MEASURES_LOV.DESCRIPTION%TYPE;
    V_VD_UOML_COMMENT         SBR.UNIT_OF_MEASURES_LOV.COMMENTS%TYPE;
    V_VD_LOW_VALUE_NUM	      SBR.VALUE_DOMAINS.LOW_VALUE_NUM%TYPE;
    V_VD_HIGH_VALUE_NUM	      SBR.VALUE_DOMAINS.HIGH_VALUE_NUM%TYPE;
    V_VD_MIN_LENGTH_NUM	      SBR.VALUE_DOMAINS.MIN_LENGTH_NUM%TYPE;
    V_VD_DECIMAL_PLACE 	      SBR.VALUE_DOMAINS.DECIMAL_PLACE%TYPE;
    V_VD_CHAR_SET_NAME	      SBR.VALUE_DOMAINS.CHAR_SET_NAME%TYPE;
    V_VD_BEGIN_DATE	          SBR.VALUE_DOMAINS.BEGIN_DATE%TYPE;
    V_VD_END_DATE	          SBR.VALUE_DOMAINS.END_DATE%TYPE;
    V_VD_CHANGE_NOTE	      SBR.VALUE_DOMAINS.CHANGE_NOTE%TYPE;
    V_VD_TYPE_FLAG	          SBR.VALUE_DOMAINS.VD_TYPE_FLAG%TYPE;
    V_VD_CREATED_BY	          SBR.VALUE_DOMAINS.CREATED_BY%TYPE;
    V_VD_DATE_CREATED	      SBR.VALUE_DOMAINS.DATE_CREATED%TYPE;
    V_VD_MODIFIED_BY	      SBR.VALUE_DOMAINS.MODIFIED_BY%TYPE;
    V_VD_DATE_MODIFIED	      SBR.VALUE_DOMAINS.DATE_MODIFIED%TYPE;
    V_VD_DELETED_IND	      VARCHAR2(30);
-- Cursor to check whether data element exists or not.
   CURSOR C_CHK_DE(B_VERSION IN SBR.DATA_ELEMENTS.VERSION%TYPE
                  ,B_PREFERRED_NAME IN SBR.DATA_ELEMENTS.PREFERRED_NAME%TYPE
				  ,B_CONTE_IDSEQ IN SBR.DATA_ELEMENTS.CONTE_IDSEQ%TYPE) IS
     SELECT COUNT(*)
	 FROM   SBR.DATA_ELEMENTS DE
	 WHERE DE.VERSION = B_VERSION
	 AND  DE.PREFERRED_NAME = B_PREFERRED_NAME
	 AND  DE.CONTE_IDSEQ = B_CONTE_IDSEQ;
	V_DE_COUNT               NUMBER(5) := 0;
-- Valid Value count, A counter to keep the number of valid values for a domain.
    VV_COUNT                  NUMBER(5):= 0;
--  Data element column variables
    V_DE_RETURN_CODE	      VARCHAR2(100);
    V_DE_ACTION               VARCHAR2(20);
    V_DE_DATE_CREATED         SBR.DATA_ELEMENTS.DATE_CREATED%TYPE;
    V_DE_BEGIN_DATE           SBR.DATA_ELEMENTS.BEGIN_DATE%TYPE;
    V_DE_CREATED_BY           SBR.DATA_ELEMENTS.CREATED_BY%TYPE;
    V_DE_END_DATE             SBR.DATA_ELEMENTS.END_DATE%TYPE;
    V_DE_DATE_MODIFIED        SBR.DATA_ELEMENTS.DATE_MODIFIED%TYPE;
    V_DE_MODIFIED_BY          SBR.DATA_ELEMENTS.MODIFIED_BY%TYPE;
    V_DE_CHANGE_NOTE          SBR.DATA_ELEMENTS.CHANGE_NOTE%TYPE;
    V_DE_DE_IDSEQ             SBR.DATA_ELEMENTS.DE_IDSEQ%TYPE;
    V_DE_VERSION              SBR.DATA_ELEMENTS.VERSION%TYPE;
    V_DE_CONTE_IDSEQ          SBR.DATA_ELEMENTS.CONTE_IDSEQ%TYPE;
    V_DE_PREFERRED_NAME       SBR.DATA_ELEMENTS.PREFERRED_NAME%TYPE;
    V_DE_VD_IDSEQ             SBR.DATA_ELEMENTS.VD_IDSEQ%TYPE;
    V_DE_DEC_IDSEQ            SBR.DATA_ELEMENTS.DEC_IDSEQ%TYPE;
    V_DE_PREFERRED_DEFINITION SBR.DATA_ELEMENTS.PREFERRED_DEFINITION%TYPE;
    V_DE_ASL_NAME             SBR.DATA_ELEMENTS.ASL_NAME%TYPE;
    V_DE_LONG_NAME            SBR.DATA_ELEMENTS.LONG_NAME%TYPE;
    V_DE_LATEST_VERSION_IND   SBR.DATA_ELEMENTS.LATEST_VERSION_IND%TYPE;
    V_DE_DELETED_IND          SBR.DATA_ELEMENTS.DELETED_IND%TYPE;
-- Reference Document column variables
    V_RD_RETURN_CODE	      VARCHAR2(100);
    V_RD_ACTION               VARCHAR2(20);
    V_RD_RD_IDSEQ             SBR.REFERENCE_DOCUMENTS.RD_IDSEQ%TYPE;
    V_RD_NAME                 SBR.REFERENCE_DOCUMENTS.NAME%TYPE;
    V_RD_ORG_IDSEQ            SBR.REFERENCE_DOCUMENTS.ORG_IDSEQ%TYPE;
    V_RD_DCTL_NAME            SBR.REFERENCE_DOCUMENTS.DCTL_NAME%TYPE;
    V_RD_AC_IDSEQ             SBR.REFERENCE_DOCUMENTS.AC_IDSEQ%TYPE;
    V_RD_ACH_IDSEQ            SBR.REFERENCE_DOCUMENTS.ACH_IDSEQ%TYPE;
    V_RD_AR_IDSEQ             SBR.REFERENCE_DOCUMENTS.AR_IDSEQ%TYPE;
    V_RD_RDTL_NAME            SBR.REFERENCE_DOCUMENTS.RDTL_NAME%TYPE;
    V_RD_DOC_TEXT             SBR.REFERENCE_DOCUMENTS.DOC_TEXT%TYPE;
    V_RD_DATE_CREATED         SBR.REFERENCE_DOCUMENTS.DATE_CREATED%TYPE;
    V_RD_CREATED_BY           SBR.REFERENCE_DOCUMENTS.CREATED_BY%TYPE;
    V_RD_DATE_MODIFIED        SBR.REFERENCE_DOCUMENTS.DATE_MODIFIED%TYPE;
    V_RD_MODIFIED_BY          SBR.REFERENCE_DOCUMENTS.MODIFIED_BY%TYPE;
    V_RD_URL                  SBR.REFERENCE_DOCUMENTS.URL%TYPE;
	-- Cursor to check if the Reference document exists
	CURSOR C_CHK_RD(B_AC_IDSEQ IN VARCHAR2, B_NAME IN VARCHAR2, B_DCTL_NAME IN VARCHAR2) IS
	  SELECT rd.RD_IDSEQ
	  FROM   SBR.REFERENCE_DOCUMENTS RD
	  WHERE RD.AC_IDSEQ = B_AC_IDSEQ
	  AND   RD.NAME = B_NAME
	  AND   RD.DCTL_NAME = B_DCTL_NAME;
-- Designation column variables.
    V_DS_RETURN_CODE	      VARCHAR2(100);
    V_DS_ACTION               VARCHAR2(20);
    V_DS_DESIG_IDSEQ          SBR.DESIGNATIONS.DESIG_IDSEQ%TYPE;
    V_DS_AC_IDSEQ             SBR.DESIGNATIONS.AC_IDSEQ%TYPE;
    V_DS_CONTE_IDSEQ          SBR.DESIGNATIONS.CONTE_IDSEQ%TYPE;
    V_DS_NAME                 SBR.DESIGNATIONS.NAME%TYPE;
    V_DS_DETL_NAME            SBR.DESIGNATIONS.DETL_NAME%TYPE;
    V_DS_DATE_CREATED         SBR.DESIGNATIONS.DATE_CREATED%TYPE;
    V_DS_CREATED_BY           SBR.DESIGNATIONS.CREATED_BY%TYPE;
    V_DS_DATE_MODIFIED        SBR.DESIGNATIONS.DATE_MODIFIED%TYPE;
    V_DS_MODIFIED_BY          SBR.DESIGNATIONS.MODIFIED_BY%TYPE;
    V_DS_LAE_NAME             SBR.DESIGNATIONS.LAE_NAME%TYPE;
-- Cursor to get the disease.
-- This is currently from the staging table, but when the classifications of the CRF are loaded
-- this cursor should be changed.
--  This cursor gets the context name.
   CURSOR C_GET_CON_NAME(B_CONTE_IDSEQ IN VARCHAR2) IS
   SELECT C.NAME
   FROM CONTEXTS C
   WHERE C.CONTE_IDSEQ=NVL(B_CONTE_IDSEQ,'ZZZZZZZ');
   V_CON_NAME        CONTEXTS.NAME%TYPE;
-- This cursor gets the disease using the context name from above.
   CURSOR C_GET_DISEASE (B_CONTEXT_NAME VARCHAR2) IS
     SELECT SL.DISEASE
	 FROM  STAGE_LOAD_PDF SL
	 WHERE SL.CONTE = B_CONTEXT_NAME;
   V_DISEASE        STAGE_LOAD_PDF.DISEASE%TYPE;
-- Cursor to get the next ID from the CDE_ID_SEQ
   CURSOR C_GET_CDE_ID IS
     SELECT CDE_ID_SEQ.NEXTVAL
	 FROM DUAL;
   V_CDE_ID          NUMBER(20);
-- Permissible Values column declarations.
    V_PV_RETURN_CODE	     VARCHAR2(100);
    V_PV_ACTION              VARCHAR2(20);
    V_PV_PV_IDSEQ            SBR.PERMISSIBLE_VALUES.PV_IDSEQ%TYPE;
    V_PV_VALUE               SBR.PERMISSIBLE_VALUES.VALUE%TYPE;
    V_PV_SHORT_MEANING       SBR.PERMISSIBLE_VALUES.SHORT_MEANING%TYPE;
    V_PV_MEANING_DESCRIPTION SBR.PERMISSIBLE_VALUES.MEANING_DESCRIPTION%TYPE;
    V_PV_BEGIN_DATE          SBR.PERMISSIBLE_VALUES.BEGIN_DATE%TYPE;
    V_PV_END_DATE            SBR.PERMISSIBLE_VALUES.END_DATE%TYPE;
    V_PV_HIGH_VALUE_NUM      SBR.PERMISSIBLE_VALUES.HIGH_VALUE_NUM%TYPE;
    V_PV_LOW_VALUE_NUM       SBR.PERMISSIBLE_VALUES.LOW_VALUE_NUM%TYPE;
    V_PV_DATE_CREATED        SBR.PERMISSIBLE_VALUES.DATE_CREATED%TYPE;
    V_PV_CREATED_BY          SBR.PERMISSIBLE_VALUES.CREATED_BY%TYPE;
    V_PV_DATE_MODIFIED       SBR.PERMISSIBLE_VALUES.DATE_MODIFIED%TYPE;
    V_PV_MODIFIED_BY         SBR.PERMISSIBLE_VALUES.MODIFIED_BY%TYPE;
-- VD_PVS column variables
    V_PD_RETURN_CODE	     VARCHAR2(100);
    V_PD_ACTION              VARCHAR2(20);
    V_PD_VP_IDSEQ            SBR.VD_PVS.VP_IDSEQ%TYPE;
    V_PD_VD_IDSEQ            SBR.VD_PVS.VD_IDSEQ%TYPE;
    V_PD_PV_IDSEQ            SBR.VD_PVS.PV_IDSEQ%TYPE;
    V_PD_CONTE_IDSEQ         SBR.VD_PVS.CONTE_IDSEQ%TYPE;
    V_PD_DATE_CREATED        SBR.VD_PVS.DATE_CREATED%TYPE;
    V_PD_CREATED_BY          SBR.VD_PVS.CREATED_BY%TYPE;
    V_PD_DATE_MODIFIED       SBR.VD_PVS.DATE_MODIFIED%TYPE;
    V_PD_MODIFIED_BY         SBR.VD_PVS.MODIFIED_BY%TYPE;
-- Cursor to check the count of values associated with the Value Domain
    CURSOR C_GET_VALUE_COUNT(B_VD_IDSEQ IN SBR.VD_PVS.VD_IDSEQ%TYPE) IS
	  SELECT COUNT(*)
	  FROM  SBR.VD_PVS VDPVS
	  WHERE VDPVS.VD_IDSEQ = B_VD_IDSEQ;
    V_VDPVS_CNT              NUMBER(10);
-- Flag to show debug messages.
    V_DEBUG                  NUMBER(1) := 1;
	V_ERROR_MESG             ERRORS_EXT.ERROR_TEXT%TYPE;
	V_ERROR_COUNT            NUMBER(10) := 0;
-- Variables for value meanings lov
     V_VM_RETURN_CODE	     VARCHAR2(100);
     V_VM_ACTION              VARCHAR2(20);
     V_VM_SHORT_MEANING         sbr.VALUE_MEANINGS_LOV.SHORT_MEANING%TYPE;
     V_VM_DESCRIPTION           sbr.VALUE_MEANINGS_LOV.DESCRIPTION%TYPE;
     V_VM_COMMENTS              sbr.VALUE_MEANINGS_LOV.COMMENTS%TYPE;
     V_VM_BEGIN_DATE            sbr.VALUE_MEANINGS_LOV.BEGIN_DATE%TYPE;
     V_VM_END_DATE              sbr.VALUE_MEANINGS_LOV.END_DATE%TYPE;
     V_VM_DATE_CREATED          sbr.VALUE_MEANINGS_LOV.DATE_CREATED%TYPE;
     V_VM_CREATED_BY            sbr.VALUE_MEANINGS_LOV.CREATED_BY%TYPE;
     V_VM_DATE_MODIFIED         sbr.VALUE_MEANINGS_LOV.DATE_MODIFIED%TYPE;
     V_VM_MODIFIED_BY           sbr.VALUE_MEANINGS_LOV.MODIFIED_BY%TYPE;
-- Cursor to check value meaning.
    CURSOR C_CHK_VM(B_SHORT_MEANING IN VARCHAR2) IS
	  SELECT COUNT(*)
	  FROM  SBR.VALUE_MEANINGS_LOV VM
	  WHERE VM.SHORT_MEANING = B_SHORT_MEANING;
	V_SHORT_MEAN_CNT           NUMBER(10);
    V_PAR_MATCH_DE_IDSEQ       SBR.DATA_ELEMENTS.DE_IDSEQ%TYPE;
	V_RETURN_CODE              VARCHAR2(30);
	V_IS_VD_MATCHED            BOOLEAN;
-- Cursor to get the VD_IDSEQ, and DEC_IDSEQ for a given DE_IDSEQ
    CURSOR C_GET_DE_KEYS (B_DE_IDSEQ IN VARCHAR2) IS
	   SELECT   DE.DEC_IDSEQ
	           ,DE.VD_IDSEQ
	   FROM     DATA_ELEMENTS DE
	   WHERE DE.DE_IDSEQ = B_DE_IDSEQ;
	R_DE_KEYS      C_GET_DE_KEYS%ROWTYPE;
--Cursor to count the valid values of a question:
CURSOR C_CNT_VVS (B_QSTN_QC_IDSEQ IN CHAR) IS
  SELECT COUNT(*)
  FROM   QC_RECS_EXT QR
  WHERE  QR.P_QC_IDSEQ = B_QSTN_QC_IDSEQ
  AND    QR.RL_NAME = 'ELEMENT_VALUE';
V_IS_ENUMERATED    BOOLEAN;
V_PERFECT_MATCH    BOOLEAN;
V_VVS_COUNT        NUMBER(10);
-- Cursor to get the pv_idseq for the valid value
CURSOR C_GET_PV_IDSEQ( B_VALUE IN VARCHAR2, B_PREFERRED_NAME IN VARCHAR2) IS
  SELECT PV.pv_idseq
  FROM   SBR.PERMISSIBLE_VALUES PV
  WHERE  PV.VALUE =B_VALUE
  AND   PV.SHORT_MEANING = B_PREFERRED_NAME;
-- Cursor to get the vp_idseq for valid value
CURSOR C_GET_VP_IDSEQ(B_VD_IDSEQ IN VARCHAR2, B_CONTE_IDSEQ IN VARCHAR2, B_PV_IDSEQ IN VARCHAR2) IS
  SELECT  vp.vp_idseq
  FROM  VD_PVS vp
  WHERE vp.VD_IDSEQ = B_VD_IDSEQ
  AND   vp.CONTE_IDSEQ = B_CONTE_IDSEQ
  AND  vp.pv_IDSEQ = B_PV_IDSEQ;
BEGIN

--Check if the CRF exist and retrieve CRF name and ID

  OPEN C_GET_CRF_DATA(P_CRF_NAME);
  FETCH C_GET_CRF_DATA INTO R_CONTEXT;
  IF C_GET_CRF_DATA%NOTFOUND THEN
     RAISE E_CRF_NOTFOUND;
  END IF;
  CLOSE C_GET_CRF_DATA;
--Temporary, chack if there is more than one conceptual domain for this context.
--This NEEDS TO BE FIXED.
  OPEN  C_GET_CD_COUNT(R_CONTEXT.CONTEXT_ID);
  FETCH C_GET_CD_COUNT INTO V_CD_COUNT;
  CLOSE C_GET_CD_COUNT;
   IF (V_CD_COUNT = 0)  THEN
     RAISE E_CD_NOTFOUND;
  ELSE
    IF (V_CD_COUNT > 1) THEN
       RAISE E_MULTIPLE_CD;
    END IF;
  END IF;
--Retrive the conceptual domain
  OPEN C_GET_CD_ID(R_CONTEXT.CONTEXT_ID);
  FETCH C_GET_CD_ID INTO R_CD;
  CLOSE C_GET_CD_ID;
--
--LOOP on QUEST_CONTENTS_EXT. That's the main loop
--
  FOR R_QTNS_VVS IN C_NO_MATCH_QTNS_VVS(R_CONTEXT.QC_IDSEQ) LOOP
      IF (R_QTNS_VVS.QTL_NAME = 'QUESTION') THEN
      dbms_output.put_line(' In question');
         -- Check if the question is enumerated
         OPEN C_CNT_VVS(R_QTNS_VVS.QUESTION_IDSEQ);
         FETCH C_CNT_VVS INTO V_VVS_COUNT;
         CLOSE C_CNT_VVS;
         IF (V_VVS_COUNT > 0) THEN
            V_IS_ENUMERATED := TRUE;
         ELSE
            V_IS_ENUMERATED := FALSE;
         END IF;
         -- Check if there is a partial match .
		-- find_min_cde_id(V_RETURN_CODE,R_QTNS_VVS.QUESTION_IDSEQ, V_PAR_MATCH_DE_IDSEQ);
		 -- Currently always set it for no match, later if match function is fixed
		 -- modify the section for match to correctly use CDE_ID
		 V_PAR_MATCH_DE_IDSEQ := NULL;
		 IF ((V_PAR_MATCH_DE_IDSEQ IS NOT NULL)) THEN
		  -- There is a partial match get the DEC_IDSEQ and VD_IDSEQ
		  -- This is wrong currently as the find_min_cde_id returns the cde_id
		  -- and not the de_idseq. This should be modified to use the cde_id
		  	 OPEN C_GET_DE_KEYS(V_PAR_MATCH_DE_IDSEQ);
			 FETCH C_GET_DE_KEYS INTO  R_DE_KEYS;
			 CLOSE C_GET_DE_KEYS;
			 IF (V_IS_ENUMERATED) THEN
			    -- Check if there is a match on valid values
			    NULL;
			    Compare_Qc_Vd_Valid_Values(V_RETURN_CODE, R_QTNS_VVS.QUESTION_IDSEQ, R_DE_KEYS.VD_IDSEQ,V_IS_VD_MATCHED);
			 ELSE
			    V_RETURN_CODE := NULL;
			    V_IS_VD_MATCHED := TRUE;
			 END IF;
		  ELSE
		    V_IS_VD_MATCHED := FALSE;
		  END IF;
			 IF ((V_IS_VD_MATCHED)) THEN
			    -- There is  a VD match use these values for further processing
			    V_VD_IDSEQ := R_DE_KEYS.VD_IDSEQ;
			    V_DEC_IDSEQ := R_DE_KEYS.DEC_IDSEQ;
			    V_DE_DE_IDSEQ := V_PAR_MATCH_DE_IDSEQ;
			    V_PERFECT_MATCH := TRUE;
			 ELSE
			 -- This is the case when value domain does not match
			 -- Create the DEC, VD , RD ....
			         V_PERFECT_MATCH := FALSE;
				 V_DEC_IDSEQ := NULL;
				--Check for the data element concept
				 OPEN C_CHK_DEC(r_qtns_vvs.de_long_name_in_qce);
				 FETCH C_CHK_DEC INTO V_DEC_IDSEQ;
				 CLOSE C_CHK_DEC;
				 -- Create a new Data Element Concept if none found
				 IF V_DEC_IDSEQ IS NULL THEN
				       V_DEC_LONG_NAME := R_QTNS_VVS.DE_LONG_NAME_IN_QCE;
				       V_DEC_OCL_NAME := NULL;
				       V_DEC_CONTE_IDSEQ := R_CONTEXT.CONTEXT_ID;
				       V_DEC_PROPL_NAME := NULL;
				       V_DEC_PROPERTY_QUALIFIER := NULL;
				       V_DEC_OBJ_CLASS_QUALIFIER := NULL;
				       V_DEC_PREFERRED_NAME := R_QTNS_VVS.PREFERRED_NAME;
				       V_DEC_PREFERRED_DEFINITION := R_QTNS_VVS.QCE_PREFERRED_DEFINITION;
					V_DEC_BEGIN_DATE := NULL;
					V_DEC_END_DATE := NULL;
					V_DEC_CHANGE_NOTE := NULL;
					V_DEC_CREATED_BY := NULL;
					V_DEC_DATE_CREATED := NULL;
					V_DEC_MODIFIED_BY := NULL;
					V_DEC_DATE_MODIFIED := NULL;
					V_DEC_DELETED_IND := NULL;
					V_DEC_VERSION := 3.0;
						V_DEC_CD_IDSEQ := R_CD.CD_IDSEQ;
					V_DEC_ASL_NAME := 'RETIRED PHASED OUT';
					V_DEC_LATEST_VERSION_IND := 'Yes';
				    Sbrext_Set_Row.SET_DEC(
							 V_DEC_RETURN_CODE
							,'INS'
							,V_DEC_IDSEQ
							,V_DEC_PREFERRED_NAME
							,V_DEC_CONTE_IDSEQ
							,V_DEC_VERSION
							,V_DEC_PREFERRED_DEFINITION
							,V_DEC_CD_IDSEQ
							,V_DEC_ASL_NAME
							,V_DEC_LATEST_VERSION_IND
							,V_DEC_LONG_NAME
							,V_DEC_OCL_NAME
							,V_DEC_PROPL_NAME
							,V_DEC_PROPERTY_QUALIFIER
							,V_DEC_OBJ_CLASS_QUALIFIER
							,V_DEC_BEGIN_DATE
							,V_DEC_END_DATE
							,V_DEC_CHANGE_NOTE
							,V_DEC_CREATED_BY
							,V_DEC_DATE_CREATED
							,V_DEC_MODIFIED_BY
							,V_DEC_DATE_MODIFIED
							,V_DEC_DELETED_IND);
						 DBMS_OUTPUT.PUT_LINE(' DEC Insert '||NVL(V_DEC_RETURN_CODE,' Insert fine')||Get_Api_Error(V_DEC_RETURN_CODE));
				 END IF;
					 -- Create a new Value Domain.
					 V_VD_ACTION := 'INS';
				 V_VD_IDSEQ := NULL;
				 V_VD_PREFERRED_NAME := TRANSLATE (Set_Name.ABBREVIATE_NAME(R_QTNS_VVS.DE_LONG_NAME_IN_QCE),'1234567890qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM_()><+=%-,.*&$#@!?/\{}[]|~`;:" ''',
			'1234567890qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM_');
				 V_VD_CONTE_IDSEQ := R_CONTEXT.CONTEXT_ID;
				 V_VD_VERSION := '3.0';
				 V_VD_PREFERRED_DEFINITION := R_QTNS_VVS.QCE_PREFERRED_DEFINITION;
				 V_VD_CD_IDSEQ := R_CD.CD_IDSEQ;
				 V_VD_ASL_NAME := 'RETIRED PHASED OUT';
				 V_VD_LATEST_VERSION_IND := 'Yes';
				 V_VD_DTL_NAME := 'ALPHANUMERIC';
				 V_VD_MAX_LENGTH_NUM := 0;
				 V_VD_LONG_NAME := NULL;
				 V_VD_FORML_NAME := NULL;
				 V_VD_FORML_DESCRIPTION := NULL;
				 V_VD_FORML_COMMENT := NULL;
				 V_VD_UOML_NAME := NULL;
				 V_VD_UOML_DESCRIPTION := NULL;
				 V_VD_UOML_COMMENT := NULL;
				 V_VD_LOW_VALUE_NUM := NULL;
				 V_VD_HIGH_VALUE_NUM := NULL;
				 V_VD_MIN_LENGTH_NUM := NULL;
				 V_VD_DECIMAL_PLACE := NULL;
				 V_VD_CHAR_SET_NAME := NULL;
				 V_VD_BEGIN_DATE := NULL;
				 V_VD_END_DATE := NULL;
				 V_VD_CHANGE_NOTE := NULL;
				 V_VD_CREATED_BY := NULL;
				 V_VD_DATE_CREATED := NULL;
				 V_VD_MODIFIED_BY := NULL;
				 V_VD_DATE_MODIFIED := NULL;
				 V_VD_DELETED_IND := NULL;
					 -- Initialize the Valid Value count flag to N
			         IF (V_IS_ENUMERATED) THEN
				     V_VD_TYPE_FLAG := 'E';
				 ELSE
				     V_VD_TYPE_FLAG := 'N';
				 END IF;
					 -- Check if the value domain already exists if not then insert.
                     -- This cursor fetch should be replaced by API get calls.
					 OPEN C_CHK_VD(V_VD_PREFERRED_NAME, V_VD_VERSION, R_CONTEXT.CONTEXT_ID);
					 FETCH C_CHK_VD
					 INTO V_VD_IDSEQ;
					 IF (C_CHK_VD%NOTFOUND) THEN
					    V_VD_IDSEQ := NULL;
					 END IF;
					 CLOSE C_CHK_VD;
					 IF (V_VD_IDSEQ IS NULL ) THEN
					 Sbrext_Set_Row.SET_VD(
					       V_VD_RETURN_CODE
					      ,V_VD_ACTION
					      ,V_VD_IDSEQ
					      ,V_VD_PREFERRED_NAME
					      ,V_VD_CONTE_IDSEQ
					      ,V_VD_VERSION
					      ,V_VD_PREFERRED_DEFINITION
					      ,V_VD_CD_IDSEQ
					      ,V_VD_ASL_NAME
					      ,V_VD_LATEST_VERSION_IND
					      ,V_VD_DTL_NAME
					      ,V_VD_MAX_LENGTH_NUM
					      ,V_VD_LONG_NAME
					      ,V_VD_FORML_NAME
					      ,V_VD_FORML_DESCRIPTION
					      ,V_VD_FORML_COMMENT
					      ,V_VD_UOML_NAME
					      ,V_VD_UOML_DESCRIPTION
					      ,V_VD_UOML_COMMENT
					      ,V_VD_LOW_VALUE_NUM
					      ,V_VD_HIGH_VALUE_NUM
					      ,V_VD_MIN_LENGTH_NUM
					      ,V_VD_DECIMAL_PLACE
					      ,V_VD_CHAR_SET_NAME
					      ,V_VD_BEGIN_DATE
					      ,V_VD_END_DATE
					      ,V_VD_CHANGE_NOTE
					      ,V_VD_TYPE_FLAG
					      ,V_VD_CREATED_BY
					      ,V_VD_DATE_CREATED
					      ,V_VD_MODIFIED_BY
					      ,V_VD_DATE_MODIFIED
					      ,V_VD_DELETED_IND);
					 DBMS_OUTPUT.PUT_LINE(' VD Insert '||V_VD_IDSEQ||' '||v_vD_PREFERRED_NAME||' '||Get_Api_Error(V_VD_RETURN_CODE));
					END IF;
					-- Create a new data element.
				 V_DE_DATE_CREATED := NULL;
				 V_DE_BEGIN_DATE := NULL;
				 V_DE_CREATED_BY := NULL;
					 V_DE_ACTION:='INS';
				 V_DE_END_DATE := NULL;
				 V_DE_DATE_MODIFIED := NULL;
				 V_DE_MODIFIED_BY := NULL;
				 V_DE_CHANGE_NOTE := NULL;
				 V_DE_DE_IDSEQ := NULL;
				 V_DE_VERSION := 3.0;
				 V_DE_CONTE_IDSEQ := R_CONTEXT.CONTEXT_ID;
				 V_DE_PREFERRED_NAME := R_QTNS_VVS.PREFERRED_NAME;
				 V_DE_VD_IDSEQ := V_VD_IDSEQ;
				 V_DE_DEC_IDSEQ := V_DEC_IDSEQ;
				 V_DE_PREFERRED_DEFINITION := R_QTNS_VVS.QCE_PREFERRED_DEFINITION;
				 V_DE_ASL_NAME := 'RETIRED PHASED OUT';
				 V_DE_LONG_NAME := R_QTNS_VVS.de_long_name_in_qce;
				 V_DE_LATEST_VERSION_IND := 'Yes';
				 V_DE_DELETED_IND := NULL;
				    -- Check if the data element exists if so raise an exception
					-- This cursor fetch should be replaced by API get calls
				    OPEN C_CHK_DE(V_DE_VERSION,V_DE_PREFERRED_NAME,V_DE_CONTE_IDSEQ);
				    FETCH C_CHK_DE INTO V_DE_COUNT;
					CLOSE C_CHK_DE;
					IF V_DE_COUNT > 0 THEN
					   RAISE E_DATA_ELEMENT_EXISTS;
					END IF;
					 Sbrext_Set_Row.SET_DE(
					V_DE_RETURN_CODE
				       ,V_DE_ACTION
				       ,V_DE_DE_IDSEQ
				       ,V_DE_PREFERRED_NAME
				       ,V_DE_CONTE_IDSEQ
				       ,V_DE_VERSION
				       ,V_DE_PREFERRED_DEFINITION
				       ,V_DE_DEC_IDSEQ
				       ,V_DE_VD_IDSEQ
				       ,V_DE_ASL_NAME
				       ,V_DE_LATEST_VERSION_IND
				       ,V_DE_LONG_NAME
				       ,V_DE_BEGIN_DATE
				       ,V_DE_END_DATE
				       ,V_DE_CHANGE_NOTE
				       ,V_DE_CREATED_BY
				       ,V_DE_DATE_CREATED
				       ,V_DE_MODIFIED_BY
				       ,V_DE_DATE_MODIFIED
				       ,V_DE_DELETED_IND);
					  DBMS_OUTPUT.PUT_LINE(' DE INSERT '||NVL(V_DE_RETURN_CODE,' INSERT fine')||Get_Api_Error(V_DE_RETURN_CODE));
				  -- Create the reference document.
				     V_RD_RETURN_CODE := NULL;
				     V_RD_ACTION := 'INS';
				 V_RD_RD_IDSEQ := NULL;
				 V_RD_NAME :=  TRANSLATE (Set_Name.ABBREVIATE_NAME(R_QTNS_VVS.DE_LONG_NAME_IN_QCE),'1234567890qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM_()><+=%-,.*&$#@!?/\{}[]|~`;:" ''',
			'1234567890qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM_');
				 V_RD_ORG_IDSEQ := NULL;
				 V_RD_DCTL_NAME := 'LONG_NAME';
				 V_RD_AC_IDSEQ := V_DE_DE_IDSEQ;
				 V_RD_ACH_IDSEQ := NULL;
				 V_RD_AR_IDSEQ := NULL;
				 V_RD_RDTL_NAME := 'TEXT';
				 V_RD_DOC_TEXT := R_QTNS_VVS.DE_LONG_NAME_IN_QCE;
				 V_RD_DATE_CREATED := NULL;
				 V_RD_CREATED_BY := NULL;
				 V_RD_DATE_MODIFIED := NULL;
				 V_RD_MODIFIED_BY := NULL;
				 V_RD_URL := NULL;
					 -- Check if the reference document exists if not then insert
					 OPEN C_CHK_RD(V_RD_AC_IDSEQ,V_RD_NAME,V_RD_DCTL_NAME);
					 FETCH C_CHK_RD INTO V_RD_RD_IDSEQ;
					 IF (C_CHK_RD%NOTFOUND) THEN
					    V_RD_RD_IDSEQ := NULL;
					 END IF;
					 CLOSE C_CHK_RD;
					 IF (V_RD_RD_IDSEQ IS NULL) THEN
				    Sbrext_Set_Row.SET_RD(
					 V_RD_RETURN_CODE
					,V_RD_ACTION
					,V_RD_RD_IDSEQ
					,V_RD_NAME
					,V_RD_DCTL_NAME
					,V_RD_AC_IDSEQ
					,V_RD_ACH_IDSEQ
					,V_RD_AR_IDSEQ
					,V_RD_DOC_TEXT
					,V_RD_ORG_IDSEQ
					,V_RD_URL
					,V_RD_CREATED_BY
					,V_RD_DATE_CREATED
					,V_RD_MODIFIED_BY
					,V_RD_DATE_MODIFIED);
					    DBMS_OUTPUT.PUT_LINE(' RD INSERT '||NVL(V_RD_RETURN_CODE,' INSERT fine')||Get_Api_Error(V_Rd_RETURN_CODE));
					 END IF;
			      -- Create the designation.
				     -- Get the CDE ID
				     OPEN C_GET_CDE_ID;
				     FETCH C_GET_CDE_ID INTO V_CDE_ID;
				     CLOSE C_GET_CDE_ID;
				     -- Get the disease
					 OPEN C_GET_CON_NAME(R_CONTEXT.CONTEXT_ID);
					 FETCH C_GET_CON_NAME INTO V_CON_NAME;
					 CLOSE C_GET_CON_NAME;
				     OPEN C_GET_DISEASE( V_CON_NAME);
				     FETCH C_GET_DISEASE INTO V_DISEASE;
				     CLOSE C_GET_DISEASE;
				     V_DS_RETURN_CODE := NULL;
				     V_DS_ACTION := 'INS';
				     V_DS_DESIG_IDSEQ := NULL;
				 V_DS_AC_IDSEQ := V_DE_DE_IDSEQ;
				 V_DS_CONTE_IDSEQ := R_CONTEXT.CONTEXT_ID;
				 V_DS_NAME := V_CDE_ID||V_DISEASE;
				 V_DS_DETL_NAME := 'CDE_ID';
				 V_DS_DATE_CREATED := NULL;
				 V_DS_CREATED_BY := NULL;
				 V_DS_DATE_MODIFIED := NULL;
				 V_DS_MODIFIED_BY := NULL;
				 V_DS_LAE_NAME := NULL;
				 Sbrext_Set_Row.SET_DES(
				    V_DS_RETURN_CODE
				   ,V_DS_ACTION
				   ,V_DS_DESIG_IDSEQ
				   ,V_DS_NAME
				   ,V_DS_DETL_NAME
				   ,V_DS_AC_IDSEQ
				   ,V_DS_CONTE_IDSEQ
				   ,V_DS_LAE_NAME
				   ,V_DS_CREATED_BY
				   ,V_DS_DATE_CREATED
				   ,V_DS_MODIFIED_BY
				   ,V_DS_DATE_MODIFIED);
			   	   DBMS_OUTPUT.PUT_LINE(' DS INSERT '||NVL(V_DS_RETURN_CODE,' INSERT fine')||V_DS_NAME||' :'||Get_Api_Error(V_DS_RETURN_CODE));
			     END IF; --Else Value domain does match.
		-- Update the status of the current question to exact match
	        UPDATE QUEST_CONTENTS_EXT
	        SET    DE_IDSEQ = V_DE_DE_IDSEQ
	              ,ASL_NAME = 'EXACT MATCH'
	        WHERE  QC_IDSEQ = R_QTNS_VVS.QUESTION_IDSEQ;
      ELSE
	   -- If this is a valid value for the Question add the valid value to the value domain.
	   --
	       IF ((R_QTNS_VVS.QTL_NAME = 'VALID_VALUE')) THEN
	          IF NOT (V_PERFECT_MATCH) THEN
	             -- Do the processing for valid values only if it is a perfect match
		       -- If required insert the short meaning
			   V_VM_ACTION := 'INS';
			   V_VM_RETURN_CODE := NULL;
			   V_VM_SHORT_MEANING := R_QTNS_VVS.PREFERRED_NAME;
			   V_VM_DESCRIPTION := NULL;
			   V_VM_COMMENTS := NULL;
			   V_VM_BEGIN_DATE := NULL;
			   V_VM_END_DATE := NULL;
			   V_VM_DATE_CREATED := NULL;
			   V_VM_CREATED_BY := NULL;
			   V_VM_DATE_MODIFIED := NULL;
			   V_VM_MODIFIED_BY := NULL;
			   OPEN C_CHK_VM(V_VM_SHORT_MEANING) ;
			   FETCH C_CHK_VM INTO V_SHORT_MEAN_CNT;
			   CLOSE C_CHK_VM;
			   IF (V_SHORT_MEAN_CNT = 0) THEN
			      Sbrext_Set_Row.SET_VM(
                          V_VM_RETURN_CODE
                         ,V_VM_ACTION
                         ,V_VM_SHORT_MEANING
                         ,V_VM_DESCRIPTION
                         ,V_VM_COMMENTS
                         ,V_VM_BEGIN_DATE
                         ,V_VM_END_DATE
                         ,V_VM_CREATED_BY
                         ,V_VM_DATE_CREATED
                         ,V_VM_MODIFIED_BY
                         ,V_VM_DATE_MODIFIED);
						 DBMS_OUTPUT.PUT_LINE(' VM INSERT '||NVL(V_VM_RETURN_CODE,' INSERT fine')||' '||Get_Api_Error(V_VM_RETURN_CODE));
			   END IF;

		       V_PV_ACTION := 'INS';
			   V_PV_RETURN_CODE := NULL;
               V_PV_PV_IDSEQ := NULL;
               V_PV_VALUE := SUBSTR(R_QTNS_VVS.VALID_VALUE,1,255);
               V_PV_SHORT_MEANING := R_QTNS_VVS.PREFERRED_NAME;
               V_PV_MEANING_DESCRIPTION := NULL;
               V_PV_BEGIN_DATE := SYSDATE;
               V_PV_END_DATE := NULL;
               V_PV_HIGH_VALUE_NUM := NULL;
               V_PV_LOW_VALUE_NUM := NULL;
               V_PV_DATE_CREATED := NULL;
               V_PV_CREATED_BY := NULL;
               V_PV_DATE_MODIFIED := NULL;
               V_PV_MODIFIED_BY :=	NULL;
		       Sbrext_Set_Row.SET_PV(
                  V_PV_RETURN_CODE
                 ,V_PV_ACTION
                 ,V_PV_PV_IDSEQ
                 ,V_PV_VALUE
                 ,V_PV_SHORT_MEANING
                 ,V_PV_BEGIN_DATE
                 ,V_PV_MEANING_DESCRIPTION
                 ,V_PV_LOW_VALUE_NUM
                 ,V_PV_HIGH_VALUE_NUM
                 ,V_PV_END_DATE
                 ,V_PV_CREATED_BY
                 ,V_PV_DATE_CREATED
                 ,V_PV_MODIFIED_BY
                 ,V_PV_DATE_MODIFIED);
				 DBMS_OUTPUT.PUT_LINE(' PV INSERT '||NVL(V_PV_RETURN_CODE,' INSERT fine')||' '||V_PV_SHORT_MEANING||' '||Get_Api_Error(V_PV_RETURN_CODE));
			   IF (V_PV_RETURN_CODE IS NULL) THEN
			         V_PD_RETURN_CODE := NULL;
					 V_PD_ACTION := 'INS';
			     -- Insert a record in VD_PVS to associate this valid value with the value domain
				     V_PD_VP_IDSEQ := NULL;
					 -- Associate to the value domain inserted earlier.
                     V_PD_VD_IDSEQ := V_VD_IDSEQ;
					 -- Associate the permissible value inserted earlier.
                     V_PD_PV_IDSEQ := V_PV_PV_IDSEQ;
                     V_PD_CONTE_IDSEQ := R_CONTEXT.CONTEXT_ID;
                     V_PD_DATE_CREATED := NULL;
                     V_PD_CREATED_BY := NULL;
                     V_PD_DATE_MODIFIED := NULL;
                     V_PD_MODIFIED_BY := NULL;
					 Sbrext_Set_Row.SET_VD_PVS(
                         V_PD_RETURN_CODE
                        ,V_PD_ACTION
                        ,V_PD_VP_IDSEQ
                        ,V_PD_VD_IDSEQ
                        ,V_PD_PV_IDSEQ
                        ,V_PD_CONTE_IDSEQ
                        ,V_PD_DATE_CREATED
                        ,V_PD_CREATED_BY
                        ,V_PD_MODIFIED_BY
                        ,V_PD_DATE_MODIFIED);
					DBMS_OUTPUT.PUT_LINE(' PD INSERT '||NVL(V_PD_RETURN_CODE,' INSERT fine')||' '||V_VD_IDSEQ||' '||Get_Api_Error(V_PD_RETURN_CODE));
			   END IF;

		        ELSE
		          -- Get the existing PV_IDSEQ;
		          OPEN C_GET_PV_IDSEQ(SUBSTR(R_QTNS_VVS.VALID_VALUE,1,255),R_QTNS_VVS.PREFERRED_NAME);
		          FETCH C_GET_PV_IDSEQ INTO V_PV_PV_IDSEQ;
		          CLOSE C_GET_PV_IDSEQ;
		          OPEN C_GET_VP_IDSEQ(V_VD_IDSEQ, R_CONTEXT.CONTEXT_ID, V_PV_PV_IDSEQ);
		          FETCH C_GET_VP_IDSEQ INTO V_PD_VP_IDSEQ;
		          CLOSE C_GET_VP_IDSEQ;
			END IF; -- Perfect Match
		-- Update the status of the current valid value to exact match
	        UPDATE QUEST_CONTENTS_EXT
	        SET    VP_IDSEQ =  V_PD_VP_IDSEQ
	              ,ASL_NAME = 'EXACT MATCH'
	        WHERE  QC_IDSEQ = R_QTNS_VVS.VV_IDSEQ;

	   END IF; -- Valid Value
      END IF;
  END LOOP;
EXCEPTION
  WHEN E_CRF_NOTFOUND THEN
     RAISE_APPLICATION_ERROR(-20000,'Could NOT find the input CRF.');
  WHEN E_CD_NOTFOUND THEN
     RAISE_APPLICATION_ERROR(-20000,'Could NOT find a Conceptual Domain.');
  WHEN  E_MULTIPLE_CD THEN
     RAISE_APPLICATION_ERROR(-20000,'Multiple  Conceptual Domains FOUND.');
  WHEN E_DATA_ELEMENT_EXISTS THEN
     RAISE_APPLICATION_ERROR(-20000,'Data element already EXISTS IN the DATABASE.');
END Process_New_Qtns_And_Vvs;

 
/


DROP PROCEDURE SBREXT.REDCAPSACTION_POPULATE2;

CREATE OR REPLACE PROCEDURE SBREXT.redCapSaction_populate2 
AS

CURSOR CUR_RC IS select r.protocol,FORM_NAME,r.QUESTION,SECTION, SECTION_SEQ 
FROM SBREXT.REDCAP_PROTOCOL_test r,
REDCAP_SECTION_VW v
where r.protocol=v.PROTOCOL
and NVL(SECTION,'A')<>'A'
and r.QUESTION=v.QUESTION
order by r.protocol,FORM_NAME,QUESTION;
 errmsg VARCHAR2(2000):='';
 V_sec_N number;
 V_sec_QN number;
 V_pr_SEC_N number;
 V_MIN_SEC_Q number;
 
BEGIN
for i in CUR_RC loop
BEGIN
 IF i.QUESTION=0 then 
 V_sec_N :=0; 
 ELSE
 SELECT min(question) into V_MIN_SEC_Q 
 from SBREXT.REDCAP_PROTOCOL_test
 where SECTION is not NULL
 and protocol=i.protocol
 and FORM_NAME=i.FORM_NAME;
 IF V_MIN_SEC_Q=i.QUESTION THEN
 
 V_sec_N :=1;
 ELSE
 
 V_sec_N :=V_sec_N+1;
 END IF;
 END IF;
 
 UPDATE REDCAP_PROTOCOL_NEW SET SECTION_SEQ=V_sec_N , SECTION_Q_SEQ=0
 WHERE protocol=i.protocol
 and FORM_NAME=i.FORM_NAME
 and QUESTION =i.QUESTION
 and SECTION=i.SECTION;
 
 
 EXCEPTION
 WHEN OTHERS THEN
 errmsg := SQLERRM;
 dbms_output.put_line('errmsg3 - '||errmsg);
 -- insert into META_CONCEPTS_EXT_ERROR_LOG VALUES (errmsg,sysdate,i.PREFERRED_NAME,i.LONG_NAME ,i.PREFERRED_DEFINITION);
 end; 
 end loop;

commit;

END ;
/


DROP PROCEDURE SBREXT.REMOVE_CRF;

CREATE OR REPLACE PROCEDURE SBREXT.Remove_Crf(p_crf_idseq IN CHAR) IS


CURSOR crf_child IS
SELECT  c_qc_idseq, rl_name
FROM QC_RECS_EXT
WHERE p_qc_idseq =  p_crf_idseq;


CURSOR mod_child(p_mod_idseq IN CHAR) IS
SELECT  c_qc_idseq, rl_name
FROM QC_RECS_EXT
WHERE p_qc_idseq =  p_mod_idseq
AND rl_name NOT IN ('MODULE_FORM');


CURSOR element_child(p_qct_idseq IN CHAR) IS
SELECT  c_qc_idseq, rl_name
FROM QC_RECS_EXT
WHERE p_qc_idseq =  p_qct_idseq
AND rl_name NOT IN ('ELEMENT_MODULE');

CURSOR vv_child(p_vv_idseq IN CHAR) IS
SELECT  c_qc_idseq, rl_name
FROM QC_RECS_EXT
WHERE p_qc_idseq =  p_vv_idseq
AND rl_name NOT IN ('VALUE_ELEMENT');

v_loop_name VARCHAR2(20);

BEGIN

FOR c_rec IN crf_child LOOP
--if child is a module then fild it's children
  IF c_rec.rl_name = 'FORM_MODULE' THEN
    FOR m_rec IN mod_child(c_rec.c_qc_idseq) LOOP
      IF m_rec.rl_name = 'MODULE_ELEMENT' THEN
	  --if child is a question it's children
        FOR e_rec IN element_child(m_rec.c_qc_idseq) LOOP
           IF e_rec.rl_name = 'ELEMENT_VALUE' THEN
		   --if child is a value then find it's children
              FOR v_rec IN vv_child(e_rec.c_qc_idseq) LOOP
               --remove forward relationship
                   DELETE FROM QC_RECS_EXT
                   WHERE p_qc_idseq = e_rec.c_qc_idseq
                   AND  c_qc_idseq = v_Rec.c_qc_idseq;

               --remove backward relationship
                   DELETE FROM QC_RECS_EXT
                    WHERE p_qc_idseq = v_rec.c_qc_idseq
                    AND  c_qc_idseq = e_rec.c_qc_idseq;

               --remove designation of children
                   DELETE FROM designations
                    WHERE ac_idseq = v_rec.c_qc_idseq;

               --remove match results for children
                   DELETE FROM MATCH_RESULTS_EXT
                    WHERE qc_crf_idseq = v_rec.c_qc_idseq
                    OR qc_submit_idseq = v_rec.c_qc_idseq
                    OR qc_match_idseq = v_rec.c_qc_idseq;

               --remove ac for children
                   DELETE FROM administered_components
                   WHERE ac_idseq = v_rec.c_qc_idseq;



               --remove children record
			     BEGIN
                    DELETE FROM QUEST_CONTENTS_EXT
                    WHERE qc_idseq = v_rec.c_qc_idseq;

			     EXCEPTION WHEN OTHERS THEN
			       dbms_output.put_line(v_rec.c_qc_idseq||' '||v_Rec.rl_name);
			     END;
				 dbms_output.put_line('VV');
              END LOOP;
           END IF;
        --remove any relationship with data element as the parent
           DELETE FROM QC_RECS_EXT
           WHERE p_qc_idseq = m_rec.c_qc_idseq
           AND  c_qc_idseq = e_rec.c_qc_idseq;

          --remove backward relationship
           DELETE FROM QC_RECS_EXT
           WHERE p_qc_idseq = e_rec.c_qc_idseq
           AND  c_qc_idseq = m_Rec.c_qc_idseq;

          --remove designation of children
           DELETE FROM designations
           WHERE ac_idseq = e_rec.c_qc_idseq;

          --remove match results for children
           DELETE FROM MATCH_RESULTS_EXT
           WHERE qc_crf_idseq = e_rec.c_qc_idseq
           OR qc_submit_idseq = e_rec.c_qc_idseq
           OR qc_match_idseq = e_rec.c_qc_idseq;


          --remove ac for children
           DELETE FROM administered_components
           WHERE ac_idseq = e_rec.c_qc_idseq;

			  BEGIN
                 DELETE FROM QUEST_CONTENTS_EXT
                 WHERE qc_idseq = e_rec.c_qc_idseq;

			  EXCEPTION WHEN OTHERS THEN
			    dbms_output.put_line(e_rec.c_qc_idseq||' '||e_Rec.rl_name);
			  END;
				 dbms_output.put_line('DE');
        END LOOP;
      END IF;

      --remove forward relationship
        DELETE FROM QC_RECS_EXT
        WHERE p_qc_idseq = c_rec.c_qc_idseq
        AND  c_qc_idseq = m_rec.c_qc_idseq;

      --remove backward relationship
        DELETE FROM QC_RECS_EXT
        WHERE p_qc_idseq = m_rec.c_qc_idseq
        AND  c_qc_idseq = c_Rec.c_qc_idseq;

       --remove designation of children
        DELETE FROM designations
        WHERE ac_idseq = m_rec.c_qc_idseq;

       --remove match results for children
        DELETE FROM MATCH_RESULTS_EXT
        WHERE qc_crf_idseq = m_rec.c_qc_idseq
        OR qc_submit_idseq = m_rec.c_qc_idseq
         OR qc_match_idseq = m_rec.c_qc_idseq;

       --remove ac for children
         DELETE FROM administered_components
        WHERE ac_idseq = m_rec.c_qc_idseq;

			  BEGIN
                 DELETE FROM QUEST_CONTENTS_EXT
                 WHERE qc_idseq = m_rec.c_qc_idseq;

			  EXCEPTION WHEN OTHERS THEN
			    dbms_output.put_line(m_rec.c_qc_idseq||' '||m_rec.rl_name);
			  END;


 dbms_output.put_line('QC');
    END LOOP;
  END IF;
 --remove forward relationship
   DELETE FROM QC_RECS_EXT
   WHERE p_qc_idseq = p_crf_idseq
   AND  c_qc_idseq = c_Rec.c_qc_idseq;

 --remove backward relationship
    DELETE FROM QC_RECS_EXT
    WHERE p_qc_idseq = c_rec.c_qc_idseq
    AND  c_qc_idseq = p_crf_idseq;

 --remove designation of children
    DELETE FROM designations
    WHERE ac_idseq = c_rec.c_qc_idseq;

--remove match results for children
    DELETE FROM MATCH_RESULTS_EXT
    WHERE qc_crf_idseq = c_rec.c_qc_idseq
    OR qc_submit_idseq = c_rec.c_qc_idseq
    OR qc_match_idseq = c_rec.c_qc_idseq;

--remove ac for children
    DELETE FROM administered_components
    WHERE ac_idseq = c_rec.c_qc_idseq;


--remove children record
    DELETE FROM QUEST_CONTENTS_EXT
    WHERE qc_idseq = c_rec.c_qc_idseq;

END LOOP;

 --remove designation of crf
    DELETE FROM designations
    WHERE ac_idseq = p_crf_idseq;

--remove match results for children
    DELETE FROM MATCH_RESULTS_EXT
    WHERE qc_crf_idseq = p_Crf_idseq
    OR qc_submit_idseq = p_Crf_idseq
    OR qc_match_idseq = p_Crf_idseq;

--remove cpt
    DELETE FROM CRF_TOOL_PARAMETER_EXT
    WHERE qc_idseq = p_Crf_idseq;

--remove ac for children
    DELETE FROM administered_components
    WHERE ac_idseq = p_crf_idseq;



			  BEGIN
                 DELETE FROM QUEST_CONTENTS_EXT
                 WHERE qc_idseq = p_crf_idseq;

			  EXCEPTION WHEN OTHERS THEN
			    dbms_output.put_line(p_crf_idseq);
			  END;
						 dbms_output.put_line('CRF');
END;

 
/


DROP PROCEDURE SBREXT.TEST_COMPARE;

CREATE OR REPLACE PROCEDURE SBREXT.Test_Compare AS
v_de_idseq CHAR(36);
BEGIN

Compare_De('A056A959-029D-32FA-E034-080020C9C0E0'
                    ,'99BA9DC8-2095-4E69-E034-080020C9C0E0'
                    ,'4-Character NSABP Code'
                    ,NULL
                    ,v_de_idseq );
dbms_output.put_line('n'||v_de_idseq);

END;

 
/


DROP PROCEDURE SBREXT.TEST_UPD_ALL_QUESTIONS;

CREATE OR REPLACE PROCEDURE SBREXT.test_upd_all_questions IS
v_return_code          VARCHAR2(30);
v_error_text		   VARCHAR2(2000);

BEGIN
   sbrext_ss_api.update_all_questions(prm_crf_idseq => 'A0E240A0-FD2A-46A0-E034-080020C9C0E0'
                                     ,prm_reviewer_action => 'Draft New'
									 ,prm_return_code => v_return_code
									 ,prm_error_text => v_error_text
									 );
END;

 
/


DROP PROCEDURE SBREXT.UPDATE_VP;

CREATE OR REPLACE PROCEDURE SBREXT.Update_Vp(p_qc_idseq IN CHAR
                    ,p_vd_idseq IN CHAR) IS



CURSOR q_vv IS
SELECT long_name,preferred_definition,qc_idseq
FROM QUEST_CONTENTS_EXT
WHERE qtl_name = 'VALID_VALUE'
AND p_qst_idseq = p_qc_idseq;

v_vp CHAR(36);

v_check_en NUMBER;

BEGIN
SELECT COUNT(*) INTO v_check_en
FROM vd_pvs
WHERE vd_idseq = p_vd_idseq;
IF(v_check_en > 0) THEN
 FOR q_rec IN q_vv LOOP
  BEGIN
   SELECT vp_idseq INTO v_vp
   FROM vd_pvs v, permissible_values p
   WHERE v.pv_idseq = p.pv_idseq
   AND v.vd_idseq = p_vd_idseq
   AND p.value = q_rec.long_name
   AND UPPER(p.short_meaning) = UPPER(q_rec.preferred_definition);

   UPDATE QUEST_CONTENTS_EXT
   SET vp_idseq = v_vp
   ,match_ind = 'E'
   ,asl_name = 'EXACT MATCH'
   WHERE qc_idseq = q_rec.qc_idseq;
 EXCEPTION WHEN NO_DATA_FOUND THEN
  NULL;
 END;
END LOOP;
END IF;
END;

 
/


DROP PROCEDURE SBREXT.UPLOAD_VALIDATE_CONCEPTS;

CREATE OR REPLACE PROCEDURE SBREXT.UPLOAD_VALIDATE_CONCEPTS AS

cursor c_load is
    select PREFERRED_NAME ,  LONG_NAME ,  PREFERRED_DEFINITION,EVS_SOURCE, ORIGIN, SOURCE_DEFINITION
    from
    (select count(*) cnt,trim(PREFERRED_NAME) PREFERRED_NAME,  trim(LONG_NAME) LONG_NAME,
    trim(PREFERRED_DEFINITION)PREFERRED_DEFINITION,trim(EVS_SOURCE) EVS_SOURCE,
    trim(ORIGIN) ORIGIN, trim(SOURCE_DEFINITION) SOURCE_DEFINITION from SBREXT."MDSR_CONCEPTS_EXT_TEMP"
    where PREFERRED_NAME is not null
    --where PREFERRED_NAME='C131048'
    group BY PREFERRED_NAME ,  LONG_NAME ,  PREFERRED_DEFINITION,EVS_SOURCE, ORIGIN, SOURCE_DEFINITION)
    ORDER BY LONG_NAME;

errmsg VARCHAR2(2000):='';
v_pname  VARCHAR2(100) ;
v_lname  VARCHAR2(500) ;
v_desc  VARCHAR2(3000) ;
v_cnt number;
v_source number;
v_conte_idseq  VARCHAR2(50) ;
v_con_idseq  VARCHAR2(50) ;
v_con_id number;
BEGIN

for i in c_load loop

begin

errmsg :='';
----
         IF i.LONG_NAME is null  or i.PREFERRED_DEFINITION is null
            THEN
             errmsg :=' The columns:LONG_NAME and PREFERRED_DEFINITION must hold values; ';

            end if;

             dbms_output.put_line(i.LONG_NAME||'i.LONG_NAME');

         IF i.LONG_NAME is not null  and i.PREFERRED_DEFINITION is not null and i.EVS_SOURCE is null and i.ORIGIN is null
         and  i.SOURCE_DEFINITION is null
            THEN
            i.EVS_SOURCE :='NCI_CONCEPT_CODE';
            i.ORIGIN :='NCI Thesuarus';
            i.SOURCE_DEFINITION := 'NCI';
            end if;




            IF i.LONG_NAME is not null  and i.PREFERRED_DEFINITION is not null and(i.EVS_SOURCE is null or i.ORIGIN is null  or  i.SOURCE_DEFINITION is null)
            THEN
             errmsg :='NOT all columns hold values; ';
            end if;


            SELECT count(*) into v_source
            FROM SBREXT.CONCEPT_SOURCES_LOV_EXT
            WHERE   trim(CONCEPT_SOURCE) = trim(i.EVS_SOURCE)
            and i.EVS_SOURCE is not null;

             IF v_source < 1 and i.EVS_SOURCE is not null THEN
            errmsg :=errmsg||'Invalid SOURCE '||i.EVS_SOURCE||'; ';
            end if;

           --dbms_output.put_line(i.EVS_SOURCE||'');

            select CONTE_IDSEQ into v_CONTE_IDSEQ from contexts
            where trim(name)='NCIP' and version=1;
            SELECT count(*) into v_cnt
            FROM CONCEPTS_EXT
            WHERE   trim(PREFERRED_NAME) = trim(i.PREFERRED_NAME)
            and version=1 and CONTE_IDSEQ=v_CONTE_IDSEQ;

            IF v_cnt > 0 THEN
            errmsg :=errmsg||'Existing PREFERRED_NAME; ';
            end if;

            IF length(trim(i.PREFERRED_NAME))>30 then
                errmsg :=errmsg||'PREFERRED_NAME is '||length(trim(i.PREFERRED_NAME))||' Characters. It must not exceed 30; ';
            END IF;

            IF length(trim(i.LONG_NAME))>255 then
                errmsg :=errmsg||'LONG_NAME is '||length(trim(i.LONG_NAME))||' Characters. It must not exceed 255; ';
            END IF;


            IF length(trim(i.PREFERRED_DEFINITION))>2000 then
                  errmsg :=errmsg||'PREFERRED_DEFINITION is '||length(trim(i.PREFERRED_DEFINITION))||' Characters. It must not exceed 2000; ';
            END IF;

            IF length(trim(errmsg))>1 then
            -- dbms_output.put_line('errmsg2 - '||errmsg);
            insert into MDSR_CONCEPTS_EXT_ERROR_LOG VALUES (errmsg,sysdate,i.PREFERRED_NAME,i.LONG_NAME ,i.PREFERRED_DEFINITION,i.EVS_SOURCE,i.ORIGIN,i.SOURCE_DEFINITION);

           ELSE

              select cde_id_seq.nextval into v_con_id      from dual;

              select admincomponent_crud.cmr_guid into v_con_idseq from dual;

              select CONTE_IDSEQ into v_CONTE_IDSEQ from contexts
              where trim(name)='NCIP' and version=1;
             -- dbms_output.put_line('v_con_id - '||v_con_id||',v_con_idseq-'||v_con_idseq||',v_CONTE_IDSEQ-'||v_CONTE_IDSEQ);
              insert into SBREXT.CONCEPTS_EXT
              (   CON_IDSEQ              ,
                  PREFERRED_NAME         ,
                  LONG_NAME              ,
                  PREFERRED_DEFINITION   ,
                  CONTE_IDSEQ           ,
                  VERSION               ,
                  ASL_NAME              ,
                  LATEST_VERSION_IND    ,
                  DEFINITION_SOURCE     ,
                  DATE_CREATED         ,
                  ORIGIN                ,
                  CREATED_BY          ,
                  CON_ID                ,
                  EVS_SOURCE )
              VALUES

                  (v_CON_IDSEQ,                    --CON_IDSEQ            NOT NULL,
                   i.PREFERRED_NAME,              --PREFERRED_NAME        NOT NULL,
                   i.LONG_NAME,                   --LONG_NAME
                   i.PREFERRED_DEFINITION,        --PREFERRED_DEFINITION  NOT NULL,
                   v_CONTE_IDSEQ,                 --CONTE_IDSEQ           NOT NULL,
                   1,                             --  VERSION             NOT NULL,
                   'RELEASED',                    -- ASL_NAME             NOT NULL,
                   'Yes',                         --LATEST_VERSION_IND
                    i.SOURCE_DEFINITION  ,  --DEFINITION_SOURCE
                   sysdate,                       --DATE_CREATED
                    i.ORIGIN ,         --ORIGIN
                   'SBREXT',                      -- CREATED_BY
                   v_CON_ID,                      --CON_ID NOT NULL,
                   i.EVS_SOURCE );                --EVS_SOURCE
    commit;
            END IF;

  EXCEPTION
    WHEN OTHERS THEN
        errmsg := SQLERRM;
        dbms_output.put_line('errmsg3 - '||errmsg);
                  insert into MDSR_CONCEPTS_EXT_ERROR_LOG VALUES (errmsg,sysdate,i.PREFERRED_NAME,i.LONG_NAME ,i.PREFERRED_DEFINITION,
				  i.EVS_SOURCE, i.ORIGIN, i.SOURCE_DEFINITION);
 end;
  end loop;

commit;

END ;
/


DROP PROCEDURE SBREXT.UPLOAD_VALIDATE_ORIGINS;

CREATE OR REPLACE PROCEDURE SBREXT.UPLOAD_VALIDATE_ORIGINS AS
cursor c_load is
 select SRC_NAME, DESCRIPTION  from
 (select count(*) cnt,trim(SRC_NAME)SRC_NAME, trim(DESCRIPTION) DESCRIPTION from SBREXT."ORIGIN_TEMP"
 where SRC_NAME is not null
   group BY SRC_NAME, DESCRIPTION
   ORDER BY SRC_NAME, DESCRIPTION);

errmsg VARCHAR2(2000):='';

v_name  VARCHAR2(500) ;
v_desc  VARCHAR2(2000) ;
v_cnt number;
BEGIN

for i in c_load loop

begin

errmsg:='A';
SELECT count(*) into v_cnt
            FROM SOURCES_EXT
            WHERE   trim(SRC_NAME) = trim(i.SRC_NAME);

            IF v_cnt > 0 THEN
            errmsg :='Exsisting ORIGIN';
            end if;
            IF length(trim(i.SRC_NAME))>500 then
            IF length(trim(errmsg))>1 then
            errmsg :=errmsg||';Origin Name is '||length(trim(i.SRC_NAME))||' Characters. It must not xceed 500';
            ELSE
            errmsg :=errmsg||'Origin Name is '||length(trim(i.SRC_NAME))||' Characters. It must not xceed 500';
            END IF;
            END IF;

             IF length(trim(i.DESCRIPTION))>2000 then
            IF length(trim(errmsg))>1 then
            errmsg :=errmsg||';DESCRIPTION is '||length(trim(i.SRC_NAME))||' Characters. It must not xceed 2000';
            ELSE
            errmsg :=errmsg||'DESCRIPTION is '||length(trim(i.SRC_NAME))||' Characters. It must not xceed 2000';
            END IF;
            END IF;
            IF length(trim(errmsg))>1 then
             dbms_output.put_line('errmsg2 - '||errmsg);
            insert into ORIGIN_TEMP_ERROR_LOG VALUES (i.SRC_NAME,i.DESCRIPTION,sysdate,errmsg);

           ELSE
              insert into SOURCES_EXT
              (	"SRC_NAME" , 	"DESCRIPTION" , 	"DATE_CREATED" , 	"CREATED_BY")
              VALUES ( i.SRC_NAME,i.DESCRIPTION,sysdate,'SBREXT' );
            END IF;

  EXCEPTION
    WHEN OTHERS THEN
        errmsg := SQLERRM;
        dbms_output.put_line('errmsg2 - '||errmsg);
               insert into ORIGIN_TEMP_ERROR_LOG VALUES ( i.SRC_NAME,i.DESCRIPTION,sysdate,errmsg );
 end;
  end loop;

commit;

END UPLOAD_VALIDATE_ORIGINS;
 
/


DROP PROCEDURE SBREXT.UPLOAD_VALIDATE_PROTOCOL;

CREATE OR REPLACE PROCEDURE SBREXT.UPLOAD_VALIDATE_PROTOCOL AS

cursor c_prot is select *
from sbrext.MDSR_PROTOCOLS_TEMP ;
errmsg VARCHAR2(4000):='';
v_proto_idseq  VARCHAR2(500) ;
v_protoid number;
v_conte_idseq  VARCHAR2(500) ;
v_org_idseq  VARCHAR2(500) ;
v_cnt number:=0;
v_length number :=0;

begin
for i in c_prot loop

   begin
          IF   length(trim(i.PREFERRED_DEFINITION))> 2000 then
            i.PREFERRED_DEFINITION:= substr(trim(i.PREFERRED_DEFINITION),1,1990)||' TRUNCATED';
          end if;
          errmsg  :='';
          IF   i.PROTOCOL_ID is null then
          errmsg:='PROTOCOL id IS NULL';
          end if;

          IF   i.PREFERRED_name is null then
          IF  length(NVL(errmsg,'A'))>1 THEN
          errmsg:= errmsg||';PREFERRED name IS NULL';
          ELSE
          errmsg:= errmsg||'PREFERRED name IS NULL';
          END IF;
          end if;

          IF   i.PREFERRED_DEFINITION is null then
          IF  length(NVL(errmsg,'A'))>1 THEN
          errmsg:= errmsg||';PREFERRED_DEFINITION IS NULL';
          ELSE
          errmsg:= errmsg||'PREFERRED_DEFINITION IS NULL';
          END IF;
          END IF;

          IF   i.long_name is null then
          IF  length(errmsg)>1 THEN
          errmsg:= errmsg||';Long name IS NULL';
          ELSE
          errmsg:= errmsg||'Long name IS NULL';
          END IF;
          end if;

          IF i.workflow  is null then
          IF  length(errmsg)>1 THEN
          errmsg:= errmsg||';Workflow IS NULL';
          ELSE
          errmsg:= errmsg||'Workflow  IS NULL';
          END IF;
          end if;



          v_cnt:=0;
          IF   i.CONTEXT  is null then
          IF  length(errmsg)>1 THEN
          errmsg:= errmsg||'; Context IS NULL';
          ELSE
          errmsg:= errmsg||' Context  IS NULL';
          END IF;
          else
          select count(*)  into v_cnt from sbr.contexts where trim(name) =trim(i.CONTEXT);
          IF v_cnt = 0 THEN
          if length(errmsg)>1 THEN
           errmsg:= errmsg||';Invailid Context ';
           else
           errmsg:= errmsg||'Invailid Context ';
           end if;
           else
           select conte_idseq into v_conte_idseq from sbr.contexts where trim(name) =trim(i.CONTEXT);
           end if;
           end if;


          v_cnt:=0;
          IF i.lead_org is not null then
          select count(*) into v_cnt from SBR.ORGANIZATIONS where name=i.lead_org;

          IF v_cnt = 0 THEN
          if length(errmsg)>1 THEN
          errmsg:= errmsg||';Invailid Organisation ';
          else
          errmsg:= errmsg||'Invailid Organisation ';
          end if;
          end if;
          end if;



          IF   length(trim(i.origin))> 500 then
          DBMS_output.put_line('Origin IS '||length(trim(i.origin))||' Characters;It has to be not over 500');
          IF  length(errmsg)>1 THEN
          errmsg:= errmsg||'; Origin IS '||length(trim(i.origin))||' Characters;It has to be not over 500' ;
          ELSE
          errmsg:= errmsg||' Origin IS '||length(trim(i.origin))||' Characters;It has to be not over 500' ;
          END IF;
          end if;




          IF trim(i.TYPE) not IN ('Treatment trials', 'Prevention trials', 'Screening trials', 'Quality of Life trials') THEN
           i.TYPE:=null;

          end if;

        IF length(errmsg)>1 then
         dbms_output.put_line('err+ length - '||length(errmsg)||'errmsg1 - '||errmsg);

           insert into MDSR_PROTOCOLS_ERR_LOG VALUES (i.PROTOCOL_ID,sysdate,errmsg, i.PREFERRED_name, i.LONG_NAME,i.PREFERRED_DEFINITION,   i.CONTEXT, i.WORKFLOW,i.origin ,i.TYPE,i.PHASE,i.LEAD_ORG);
       -- goto nextrec;
         end IF;



        IF (NVL(errmsg,'A'))='A' or errmsg='' then


            select sbr.admincomponent_crud.cmr_guid into v_PROTO_IDSEQ from dual;
            select cde_id_seq.nextval into V_protoid from dual;

            INSERT INTO protocols_EXT (PROTO_IDSEQ
            ,version
            ,CONTE_IDSEQ
            ,PREFERRED_NAME
	        ,PREFERRED_DEFINITION
            ,ASL_NAME
	        ,LONG_NAME
            ,TYPE
	        ,PHASE
	        ,LEAD_ORG
            ,PROTOCOL_ID
            ,PROTO_ID
            ,DATE_CREATED
            ,CREATED_BY

            )

           VALUES (v_PROTO_IDSEQ
            ,'1'
            , v_CONTE_IDSEQ
            ,i.PREFERRED_NAME
	        ,i.PREFERRED_DEFINITION
            ,i.workflow
	        ,i.LONG_NAME
            ,NULL
	        ,i.PHASE
	        ,V_org_idseq
            ,i.PROTOCOL_ID
            ,v_protoid--TO_NUMBER(REGEXP_REPLACE(trim(i.PROTOCOL_ID),'[^0-9]+', ''))--TO_NUMBER(REGEXP_REPLACE(i.PROTOCOL_ID,'[^a-zA-Z'']',''))--remove alpha characters from string
            ,SYSDATE
            ,'DWARZEL'

            );
            end if;


 EXCEPTION
    WHEN OTHERS THEN
        errmsg := SQLERRM;
         dbms_output.put_line('errmsg5 - '||errmsg);
                insert into MDSR_PROTOCOLS_ERR_LOG VALUES (i.PROTOCOL_ID,sysdate,errmsg, i.PREFERRED_name, i.LONG_NAME,i.PREFERRED_DEFINITION,   i.CONTEXT, i.WORKFLOW,i.origin ,i.TYPE,i.PHASE,i.LEAD_ORG);
 commit;
 end;

 end loop;
 commit;
 end;
/


DROP PROCEDURE SBREXT.UPLOAD_VALIDATE_PROTOCOL_DIST;

CREATE OR REPLACE PROCEDURE SBREXT.UPLOAD_VALIDATE_PROTOCOL_DIST AS

cursor c_prot is select t.*
from sbrext.MDSR_PROTOCOLS_TEMP t ,
sbrext.protocols_ext p
where t.PREFERRED_NAME=p.PREFERRED_NAME(+)
and p.PREFERRED_NAME is null;
errmsg VARCHAR2(4000):='';
v_proto_idseq  VARCHAR2(500) ;
v_protoid number;
v_conte_idseq  VARCHAR2(500) ;
v_org_idseq  VARCHAR2(500) ;
v_cnt number:=0;
v_length number :=0;

begin
for i in c_prot loop

   begin
          IF   length(trim(i.PREFERRED_DEFINITION))> 2000 then
            i.PREFERRED_DEFINITION:= substr(trim(i.PREFERRED_DEFINITION),1,1990)||' TRUNCATED';
          end if;
          errmsg  :='';
          IF   i.PROTOCOL_ID is null then
          errmsg:='PROTOCOL id IS NULL';
          end if;

          IF   i.PREFERRED_name is null then
          IF  length(NVL(errmsg,'A'))>1 THEN
          errmsg:= errmsg||';PREFERRED name IS NULL';
          ELSE
          errmsg:= errmsg||'PREFERRED name IS NULL';
          END IF;
          end if;

          IF   i.PREFERRED_DEFINITION is null then
          IF  length(NVL(errmsg,'A'))>1 THEN
          errmsg:= errmsg||';PREFERRED_DEFINITION IS NULL';
          ELSE
          errmsg:= errmsg||'PREFERRED_DEFINITION IS NULL';
          END IF;
          END IF;

          IF   i.long_name is null then
          IF  length(errmsg)>1 THEN
          errmsg:= errmsg||';Long name IS NULL';
          ELSE
          errmsg:= errmsg||'Long name IS NULL';
          END IF;
          end if;

          IF i.workflow  is null then
          IF  length(errmsg)>1 THEN
          errmsg:= errmsg||';Workflow IS NULL';
          ELSE
          errmsg:= errmsg||'Workflow  IS NULL';
          END IF;
          end if;



          v_cnt:=0;
          IF   i.CONTEXT  is null then
          IF  length(errmsg)>1 THEN
          errmsg:= errmsg||'; Context IS NULL';
          ELSE
          errmsg:= errmsg||' Context  IS NULL';
          END IF;
          else
          select count(*)  into v_cnt from sbr.contexts where trim(name) =trim(i.CONTEXT);
          IF v_cnt = 0 THEN
          if length(errmsg)>1 THEN
           errmsg:= errmsg||';Invailid Context ';
           else
           errmsg:= errmsg||'Invailid Context ';
           end if;
           else
           select conte_idseq into v_conte_idseq from sbr.contexts where trim(name) =trim(i.CONTEXT);
           end if;
           end if;


          v_cnt:=0;
          IF i.lead_org is not null then
          select count(*) into v_cnt from SBR.ORGANIZATIONS where name=i.lead_org;

          IF v_cnt = 0 THEN
          if length(errmsg)>1 THEN
          errmsg:= errmsg||';Invailid Organisation ';
          else
          errmsg:= errmsg||'Invailid Organisation ';
          end if;
          end if;
          end if;



          IF   length(trim(i.origin))> 500 then
          DBMS_output.put_line('Origin IS '||length(trim(i.origin))||' Characters;It has to be not over 500');
          IF  length(errmsg)>1 THEN
          errmsg:= errmsg||'; Origin IS '||length(trim(i.origin))||' Characters;It has to be not over 500' ;
          ELSE
          errmsg:= errmsg||' Origin IS '||length(trim(i.origin))||' Characters;It has to be not over 500' ;
          END IF;
          end if;




          IF trim(i.TYPE) not IN ('Treatment trials', 'Prevention trials', 'Screening trials', 'Quality of Life trials') THEN
           i.TYPE:=null;

          end if;

        IF length(errmsg)>1 then
         dbms_output.put_line('err+ length - '||length(errmsg)||'errmsg1 - '||errmsg);

           insert into MDSR_PROTOCOLS_ERR_LOG VALUES (i.PROTOCOL_ID,sysdate,errmsg, i.PREFERRED_name, i.LONG_NAME,i.PREFERRED_DEFINITION,   i.CONTEXT, i.WORKFLOW,i.origin ,i.TYPE,i.PHASE,i.LEAD_ORG);
       -- goto nextrec;
         end IF;



        IF (NVL(errmsg,'A'))='A' or errmsg='' then


            select sbr.admincomponent_crud.cmr_guid into v_PROTO_IDSEQ from dual;
            select cde_id_seq.nextval into V_protoid from dual;

            INSERT INTO protocols_EXT (PROTO_IDSEQ
            ,version
            ,CONTE_IDSEQ
            ,PREFERRED_NAME
	        ,PREFERRED_DEFINITION
            ,ASL_NAME
	        ,LONG_NAME
            ,TYPE
	        ,PHASE
	        ,LEAD_ORG
            ,PROTOCOL_ID
            ,PROTO_ID
            ,DATE_CREATED
            ,CREATED_BY

            )

           VALUES (v_PROTO_IDSEQ
            ,'1'
            , v_CONTE_IDSEQ
            ,i.PREFERRED_NAME
	        ,i.PREFERRED_DEFINITION
            ,i.workflow
	        ,i.LONG_NAME
            ,NULL
	        ,i.PHASE
	        ,V_org_idseq
            ,i.PROTOCOL_ID
            ,v_protoid--TO_NUMBER(REGEXP_REPLACE(trim(i.PROTOCOL_ID),'[^0-9]+', ''))--TO_NUMBER(REGEXP_REPLACE(i.PROTOCOL_ID,'[^a-zA-Z'']',''))--remove alpha characters from string
            ,SYSDATE
            ,'DWARZEL'

            );
            end if;


 EXCEPTION
    WHEN OTHERS THEN
        errmsg := SQLERRM;
         dbms_output.put_line('errmsg5 - '||errmsg);
                insert into MDSR_PROTOCOLS_ERR_LOG VALUES (i.PROTOCOL_ID,sysdate,errmsg, i.PREFERRED_name, i.LONG_NAME,i.PREFERRED_DEFINITION,   i.CONTEXT, i.WORKFLOW,i.origin ,i.TYPE,i.PHASE,i.LEAD_ORG);
 commit;
 end;

 end loop;
 commit;
 end;
/


DROP PROCEDURE SBREXT.XML_REDCOP_INSERT751;

CREATE OR REPLACE PROCEDURE SBREXT.xml_RedCop_insert751 as
  

CURSOR c_protocol IS
SELECT   group_number
FROM REDCOP_PR_GROUP_VW_751 r
order by group_number;


 l_file_name      VARCHAR2 (100):='NA';
   l_file_path      VARCHAR2 (200);
   l_result         CLOB:=null;
   l_xmldoc          CLOB:=null;
   l_protocol        VARCHAR2 (30);
   errmsg VARCHAR2(500):='Non';
   v_protocol VARCHAR2(50):='';
BEGIN 
 FOR rec IN c_protocol LOOP  
 BEGIN 
        l_file_path := 'SBREXT_DIR';       
       -- v_protocol:=rec.protocol ;
         l_file_name := rec.group_number||'_'||SYSDATE;
        
        SELECT dbms_xmlgen.getxml( 'select* from MSDRDEV.REDCAP_FORM_COLLECT_VW_751 where "collectionName" ='||''''||rec.group_number||'''')
        INTO l_result
        FROM DUAL ;
        insert into REDCAP_XML VALUES (rec.group_number,l_result, l_file_name ,SYSDATE);
 
      --dbms_xslprocessor.clob2file(l_xmldoc,  l_file_path, l_file_name, nls_charset_id('UTF8'));

      
    EXCEPTION
    WHEN OTHERS THEN
    errmsg := SQLERRM;
         dbms_output.put_line('errmsg  - '||errmsg);
        insert into REPORTS_ERROR_LOG VALUES (substr(l_file_name,1,49),  errmsg, sysdate);
        
     commit;   
        END;
END LOOP;

END;
/


DROP PROCEDURE SBREXT.XML_VD_DESIGNATIONS;

CREATE OR REPLACE PROCEDURE SBREXT.xml_vd_designations as
   l_file_name      VARCHAR2 (30);
   l_file_path      VARCHAR2 (200);
   l_xmldoc          CLOB:=null;
   errmsg VARCHAR2(500):='Non';
BEGIN

l_file_path := 'SBREXT_DIR';
l_file_name := 'XMLQuery.xml';


SELECT sys_xmlgen(cdebrowser_vd_t4 (
             vd.vd_id,
             vd.preferred_name,
             vd.preferred_definition,
             vd.long_name,
             vd.version,
             vd.asl_name,
             CAST (
                MULTISET (
                   SELECT pv.VALUE,
                          pv.short_meaning,
                          vm.VM_ID  ,
                         Vm.Version,
                          CAST (
                             MULTISET (
                                SELECT des_conte.name,
                                       des_conte.version,
                                      replace(  replace(wm_concat( replace(des.name,',','@@@')),',','|'),'@@@',','),
                                       des.detl_name,
                                       des.lae_name
                                  FROM sbr.designations des,
                                       sbr.contexts des_conte
                                 WHERE vm.vm_idseq = des.AC_IDSEQ(+)
                                       AND des.conte_idseq =  des_conte.conte_idseq(+)
                                 group by des_conte.name,des_conte.version, des.detl_name, des.lae_name) AS cdebrowser_altname_list_t)      "AlternateNameList"
                     FROM sbr.permissible_values pv,
                          sbr.vd_pvs vp,
                          value_meanings vm
                    WHERE     vp.vd_idseq = vd.vd_idseq
                          AND vp.pv_idseq = pv.pv_idseq
                          AND pv.vm_idseq = vm.vm_idseq) AS DE_VALID_VALUE_DESIG_TP_LIST))).getClobVal() as XML_QUERY

                    into l_xmldoc

     FROM sbr.data_elements de,
          sbrext.cdebrowser_de_dec_view dec,
          sbr.contexts de_conte,
          sbr.value_domains vd,
          sbr.contexts vd_conte,
          sbr.contexts cd_conte,
          sbr.conceptual_domains cd,
          sbr.ac_registrations ar,
          cdebrowser_complex_de_view ccd,
          sbrext.representations_ext rep,
          sbr.contexts rep_conte
    WHERE     de.de_idseq = dec.de_idseq
          AND de.conte_idseq = de_conte.conte_idseq
          AND de.vd_idseq = vd.vd_idseq
          AND vd.conte_idseq = vd_conte.conte_idseq
          AND vd.cd_idseq = cd.cd_idseq
          AND cd.conte_idseq = cd_conte.conte_idseq
          AND de.de_idseq = ar.ac_idseq(+)
          AND de.de_idseq = ccd.p_de_idseq(+)
          AND vd.rep_idseq = rep.rep_idseq(+)
          AND rep.conte_idseq = rep_conte.conte_idseq(+)
          AND de.cde_id = '5473'
          AND de.version = '10';

dbms_xslprocessor.clob2file(l_xmldoc,  l_file_path, l_file_name, nls_charset_id('UTF8'));
--  insert into REPORTS_ERROR_LOG VALUES (l_file_name,l_xmldoc,  errmsg, sysdate);

    EXCEPTION
    WHEN OTHERS THEN
   errmsg := SQLERRM;
         dbms_output.put_line('errmsg  - '||errmsg);
        insert into REPORTS_ERROR_LOG VALUES (l_file_name,  errmsg, sysdate);

END;
 
/


CREATE OR REPLACE PUBLIC SYNONYM PROCESS_NEW_QTNS_AND_VVS FOR SBREXT.PROCESS_NEW_QTNS_AND_VVS;


CREATE OR REPLACE PUBLIC SYNONYM REMOVE_CRF FOR SBREXT.REMOVE_CRF;


CREATE OR REPLACE PUBLIC SYNONYM TEST_COMPARE FOR SBREXT.TEST_COMPARE;


CREATE OR REPLACE PUBLIC SYNONYM TEST_UPD_ALL_QUESTIONS FOR SBREXT.TEST_UPD_ALL_QUESTIONS;


CREATE OR REPLACE PUBLIC SYNONYM UPDATE_VP FOR SBREXT.UPDATE_VP;


CREATE OR REPLACE SYNONYM SBR.PROCESS_NEW_QTNS_AND_VVS FOR SBREXT.PROCESS_NEW_QTNS_AND_VVS;


CREATE OR REPLACE SYNONYM SBR.REMOVE_CRF FOR SBREXT.REMOVE_CRF;


CREATE OR REPLACE SYNONYM SBR.TEST_COMPARE FOR SBREXT.TEST_COMPARE;


CREATE OR REPLACE SYNONYM SBR.TEST_UPD_ALL_QUESTIONS FOR SBREXT.TEST_UPD_ALL_QUESTIONS;


CREATE OR REPLACE SYNONYM SBR.UPDATE_VP FOR SBREXT.UPDATE_VP;


GRANT EXECUTE, DEBUG ON SBREXT.PROCESS_NEW_QTNS_AND_VVS TO SBR WITH GRANT OPTION;

GRANT EXECUTE, DEBUG ON SBREXT.REMOVE_CRF TO SBR WITH GRANT OPTION;

GRANT EXECUTE, DEBUG ON SBREXT.TEST_COMPARE TO SBR WITH GRANT OPTION;

GRANT EXECUTE, DEBUG ON SBREXT.TEST_UPD_ALL_QUESTIONS TO SBR WITH GRANT OPTION;

GRANT EXECUTE, DEBUG ON SBREXT.UPDATE_VP TO SBR WITH GRANT OPTION;

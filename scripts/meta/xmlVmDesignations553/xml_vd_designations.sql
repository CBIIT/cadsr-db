create or replace TYPE          "CDEBROWSER_ALTNAME_T2"    as object(
    "ContextName"                                        VARCHAR2(30)
    ,"ContextVersion"                                     NUMBER(4,2)
    ,"AlternateName"                                      VARCHAR2(2000)
    ,"AlternateNameType"                                  VARCHAR2(20)
    ,"Language"                                           VARCHAR2(30))
/

create or replace TYPE          "CDEBROWSER_ALTNAME_LIST_T"  AS TABLE OF CDEBROWSER_ALTNAME_T2
/    
    
create or replace TYPE          "DE_VALID_VALUE_DESIG_TP" as object(
    ValidValue varchar2(255),
    ValueMeaning varchar2(255),
     VmPublicId Number,
    VmVersion Number(4,2),
    AltName cdebrowser_altname_list_t)
/

create or replace TYPE          "DE_VALID_VALUE_DESIG_TP_LIST" AS TABLE OF DE_VALID_VALUE_DESIG_TP
/

create or replace TYPE        "CDEBROWSER_VD_T4"  AS OBJECT
( "PublicId"         NUMBER,
  "PreferredName"          VARCHAR2 (30),
  "PreferredDefinition"    VARCHAR2 (2000),
  "LongName"      VARCHAR2(255),
  "Version"                NUMBER (4,2),
  "WorkflowStatus"         VARCHAR2 (20),
   "PermissibleValues"    DE_VALID_VALUE_DESIG_TP_LIST
)
/

--------------------------------------------------------
--  DDL for table REPORTS_ERROR_LOG
--------------------------------------------------------
create table REPORTS_ERROR_LOG(	"FILE_NAME" VARCHAR2(50 BYTE), 

	"ERROR" VARCHAR2(1100 BYTE), 

	"DATE_PROCESSED" DATE )
/
create or replace PROCEDURE          "xml_vd_designations" as
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
exec  "SBREXT"."xml_vd_designations";
/
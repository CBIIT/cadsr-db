   SELECT de.de_idseq ,CON_ID CONCEPT_PUBLIC_ID,C.PREFERRED_NAME CONCEPT_CODE,C.LONG_NAME CONCEPT_NAME,
          de.cde_id DE_PublicId,de.version DE_VERSION,         
          de.long_name DE_long_name, de_conte.name DE_Context , 
          de.preferred_name DE_PREFER_NAME,
          DE.QUESTION  Preferred_question_text,
          de.preferred_definition DE_DEFINITION,          
          de.origin DE_ORIGIN,          
          DE.CHANGE_NOTE DE_CHANGE_NOTE,
          DE.ASL_NAME DE_WORKFLOW_STATUS,
          AR.REGISTRATION_STATUS DE_REGISTRATION_STATUS,
          de.Created_by DE_Created_by, de.date_created DE_Date_Created,de.modified_by DE_Modified_by, de.DATE_MODIFIED DE_DATE_MODIFIED,
          VD.VD_id VD_PublicId,VD.version VD_VERSION,         
          VD.long_name VD_long_name, VD_conte.name VD_Context , 
          VD.preferred_name VD_PREFER_NAME,          
          VD.preferred_definition VD_DEFINITION,          
          VD.origin VD_ORIGIN,          
          VD.CHANGE_NOTE VD_CHANGE_NOTE,
          VD.ASL_NAME VD_WORKFLOW_STATUS,
          ar_VD.REGISTRATION_STATUS VD_REGISTRATION_STATUS,
          vd.dtl_name,
          vd.max_length_num,
          vd.min_length_num,
          vd.high_value_num,
          vd.low_value_num,
          vd.DECIMAL_PLACE,
          vd.FORML_NAME,          
          VD.Created_by VD_Created_by, VD.date_created VD_Date_Created,VD.modified_by VD_Modified_by, VD.DATE_MODIFIED VD_DATE_MODIFIED,
     
           CAST (
             MULTISET (
                select distinct F.QC_ID ,F.version ,F.LONG_NAME ,CF_CONTE.NAME,M.LONG_NAME, F.QTL_NAME,p.LONG_NAME ,F.ASL_NAME 
                FROM  SBREXT.QUEST_CONTENTS_EXT  Q,          
                  SBREXT.QUEST_CONTENTS_EXT  F,
                  SBR.CONTEXTS CF_conte,
                  SBREXT.QUEST_CONTENTS_EXT  M,
                  SBREXT.PROTOCOLS_EXT P,
                  SBREXT.PROTOCOL_QC_EXT PQ
                  where Q.DN_CRF_IDSEQ=F.QC_IDSEQ    
                  AND M.DN_CRF_IDSEQ=F.QC_IDSEQ            
                  AND Q.P_MOD_IDSEQ=M.QC_IDSEQ          
                  AND F.CONTE_IDSEQ=CF_conte.CONTE_IDSEQ  
                  and F.QC_IDSEQ=PQ.QC_IDSEQ (+)  
                  and PQ.PROTO_IDSEQ=P.PROTO_IDSEQ (+) 
                  and F.QTL_NAME IN ('CRF','TEMPLATE')
                  and Q.QTL_NAME='QUESTION' 
                  and M.QTL_NAME='MODULE'
                  AND F.ASL_NAME not like '%RETIRED%' 
                  and Q.DE_IDSEQ(+) = de.de_idseq ) 
        AS SBREXT.HARMONY_FORM_PROTO_LIST_T) FORMS  ,
                           
          CAST (
             MULTISET (
                SELECT admin_component_with_id_t (
                                    csv.cs_id,
                                    csv.cs_context_name,
                                    csv.cs_context_version,
                                    csv.preferred_name,
                                    csv.version),
                                    csv.csi_name,
                                    csv.csitl_name,
                                    csv.csi_id,
                                    csv.csi_version
                  FROM sbrext.cdebrowser_cs_view csv
                 WHERE de.de_idseq = csv.ac_idseq(+)) AS cdebrowser_csi_list_t)
             classifications  
     FROM      
         
SBR.DATA_ELEMENTS DE,
SBR.VALUE_DOMAINS VD ,
SBREXT.CON_DERIVATION_RULES_EXT DR,
SBREXT.CONCEPTS_EXT C ,
SBR.AC_REGISTRATIONS_VIEW AR ,  
SBR.AC_REGISTRATIONS_VIEW AR_VD ,
SBR.contexts de_conte,
SBR.contexts vd_conte 
     WHERE   VD.VD_IDSEQ=DE.VD_IDSEQ
         AND VD.CONDR_IDSEQ= DR.CONDR_IDSEQ
         AND INSTR(DR.NAME,C.PREFERRED_NAME)>0
         AND DE.ASL_NAME not like '%RETIRED%'            
         AND de.conte_idseq = de_conte.conte_idseq
        AND vd.conte_idseq = vd_conte.conte_idseq  
        AND de.DE_IDSEQ = ar.AC_IDSEQ(+)
        AND vd.vd_IDSEQ =AR_VD.AC_IDSEQ(+)
   /*replace below values for CONCEPT_NAME,CONCEPT_PUBLIC_ID or CONCEPT_CODE
   Currently query is case insensitive (Time Point, time point, Time point, Timepoint, timepoint)
   and searches for any provided value of CONCEPT_NAME,CONCEPT_PUBLIC_ID or CONCEPT_CODE
   as it is shown below*/
  AND (UPPER(C.LONG_NAME)= UPPER(replace('Time Point',' '))or CON_ID>265661 or C.PREFERRED_NAME='C68568')
         
order by 1  ;
 

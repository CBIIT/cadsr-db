
          CREATE OR REPLACE TYPE          MDSR_FB_RD_ATTACH_XML_T      AS OBJECT --7
(   
  "name"      varchar2(355),
  "mimeType"    VARCHAR2(128 BYTE), 
  "size"     NUMBER);
  
CREATE OR REPLACE TYPE          MDSR_FB_RD_XML_T       AS OBJECT --8
(   
  "Name"      varchar2(255),
  "type"   varchar2(60), 
  "context"    VARCHAR2(40),
  "doctext"     VARCHAR2(4000),
  "languageName" VARCHAR2(40),
  "url"  varchar2(240),
  "attachments" MDSR_FB_RD_ATTACH_XML_T
);                                 
SELECT                      QQ.QUES_id,
                                        QQ.QUES_version,
                                        isDerived,
                                        QQ.DISPLAY_ORDER,
                                        qq.date_created,
                                        qq.date_Modified,
                                        qq.Q_LONG_NAME,
                                        REDCAP_INSTRUCTIONS_T (Q_instruction),
                                        qq.EDITABLE_IND,
                                        qq.MANDATORY_IND,
                                        qq.multiValue,
                                        MDSR_FB_DATA_EL_XML_T (
                                           qq.de_LONG_NAME,
                                           de_PREFERRED_NAME,
                                           qq.CDE_ID,
                                           qq.de_version,
                                           qq.DE_context,
                                           qq.DE_WORKFLOW,
                                           qq.D_PREFERRED_DEFINITION,
                                           CAST (
                                              MULTISET (
                                                 SELECT
                                                     rd.name,
                                                     rd.DCTL_NAME,
                                                     c2.name,
                                                     rd.doc_text,
                                                     rd.LAE_NAME,
                                                     rd.url,
                                                     MDSR_FB_RD_ATTACH_XML_T(
                                                     rb.name,
                                                     rb.MIME_TYPE,
                                                     rb.doc_size)
                                                FROM SBR.REFERENCE_DOCUMENTS rd,
                                                     SBR.contexts c2,
                                                     SBR.REFERENCE_BLOBS RB
                                                   
                                               WHERE   RD.RD_IDSEQ =RB.RD_IDSEQ (+)
                                                      AND  c2.CONTE_IDSEQ = rd.CONTE_IDSEQ
                                                     AND rd.ac_idseq =qq.de_idseq) as MDSR_FB_RD_XML_LIST_T)) as DE
                                                     FROM SBREXT.MDSR_FB_QUESTION_MVW QQ
                                                      WHERE qq.ques_idseq='430203EE-CCBE-6162-E053-F662850A2532'
                                                  
                                               
                                               
                                               
                                               
                                                --  select*
                                                      FROM SBREXT.MDSR_FB_QUESTION_MVW QQ
                                                      WHERE qq.ques_idseq='430203EE-CCBE-6162-E053-F662850A2532'
                                                      
                                                      
                                                      =5590327;
                                                      
                                            select       *    FROM SBR.REFERENCE_DOCUMENTS rd,
                                                     SBR.contexts c2,
                                                     SBR.REFERENCE_BLOBS RB,
                                                     SBREXT.MDSR_FB_QUESTION_MVW QQ
                                               WHERE   RD.RD_IDSEQ =RB.RD_IDSEQ (+)
                                                      AND  c2.CONTE_IDSEQ = rd.CONTE_IDSEQ
                                                     AND rd.ac_idseq=qq.de_idseq
                                                     and ISDERIVED='true'
                                                     and qq.ques_idseq='430203EE-CCBE-6162-E053-F662850A2532'
                                                     
                                          430203EE-CCBE-6162-E053-F662850A2532           
                                                     'DE329218-46CF-3E0C-E034-0003BA12F5E7';
                                                     272DB2A0-355C-2D49-E044-0003BA3F9857

                                                        select*from   SBR.REFERENCE_DOCUMENTS RD,
                                                             REFERENCE_BLOBS RB where  
                                                             RD.RD_IDSEQ =RB.RD_IDSEQ   
                                                            and  ac_idseq = 'DE329218-46CF-3E0C-E034-0003BA12F5E7''430203EE-CCBE-6162-E053-F662850A2532'-- 'DE329218-46CF-3E0C-E034-0003BA12F5E7';
                                                           
                                                            select*from SBREXT.MDSR_FB_QUESTION_MVW where ques_id=5590327--2263415
                                                            5590324 for question 5590327.( DE public id 2179689v4.0)
                                                            
                                             select*from   SBR.REFERENCE_DOCUMENTS 
                                                              where  
                                                              ac_idseq = '430203EE-CCBE-6162-E053-F662850A2532'               
                                                            
                                                            
                              'DE329218-46CF-3E0C-E034-0003BA12F5E7'                                  select       *    FROM SBR.REFERENCE_DOCUMENTS rd,
                                                     SBR.contexts c2,
                                                     SBR.REFERENCE_BLOBS RB,
                                                     SBREXT.MDSR_FB_QUESTION_MVW QQ
                                               WHERE   RD.RD_IDSEQ =RB.RD_IDSEQ 
                                                      AND  c2.CONTE_IDSEQ = rd.CONTE_IDSEQ
                                                     AND rd.ac_idseq=qq.de_idseq
                                                     
     select *                                               
        from COMPLEX_DE_RELATIONSHIPS cdv,--SBR.COMPLEX_DATA_ELEMENTS cdv,
       SBREXT.MDSR_FB_QUESTION_MVW DE,--SBR.DATA_ELEMENTS DE,
       SBR.REFERENCE_DOCUMENTS rd,
       SBR.REFERENCE_BLOBS RB     
       where  cdv.P_DE_IDSEQ = de.DE_IDSEQ 
       and RD.RD_IDSEQ =RB.RD_IDSEQ 
      -- AND  c2.CONTE_IDSEQ = rd.CONTE_IDSEQ   
       and cdv.P_DE_IDSEQ=rd.ac_idseq
       
       select*
       from COMPLEX_DE_RELATIONSHIPS cdr
       
       QUEST_CONTENT
       SELECT cde.P_DE_IDSEQ,
          cde.crtl_name,
          ctl.description,
          cde.methods,
          cde.rule,
          cde.concat_char,
          de.cde_id,
                       de.long_name,
                       de.preferred_name,
                       de.preferred_definition,
                       de.version,
                       de.asl_name,
                       conte.name,
                       cdr.display_order
                  FROM sbr.complex_de_relationships cdr,
                       sbr.data_elements de,
                       sbr.contexts conte
                 WHERE     cde.p_de_idseq = cdr.p_de_idseq(+)
                       AND cdr.c_de_idseq = de.de_idseq
                       AND de.conte_idseq = conte.conte_idseq
           
     FROM sbr.complex_data_elements cde, sbr.complex_rep_type_lov ctl
    WHERE cde.crtl_name = ctl.crtl_name;
    
  select*from  ADMINISTERED_COMPONENTS   where     preferred_name='434463943603054395695049310'  and actl_name  5590327

DATAELEMENT

QUEST_CONTENT
430203EE-CCBE-6162-E053-F662850A2532
430203EE-CCBE-6162-E053-F662850A2532
select*from  quest_CONTENTS_ext where qc_id=5590327--2263415
                                                            5590324 for question 5590327.( DE public id 2179689v4.0)
                                                            
                                                                select*from   SBR.REFERENCE_DOCUMENTS 
                                                              where  
                                                              ac_idseq = '272DB2A0-355C-2D49-E044-0003BA3F9857' 
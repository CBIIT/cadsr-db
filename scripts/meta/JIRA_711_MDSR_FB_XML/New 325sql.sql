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
                                                 SELECT           --1 data set
                                                       vd.long_name,
                                                        vd.vd_id,
                                                        vd.version,
                                                        vd.VD_TYPE_FLAG,
                                                        vd.ASL_NAME,
                                                        vd.DTL_NAME,
                                                        vd.MAX_LENGTH_NUM,
                                                        vd.MIN_LENGTH_NUM,
                                                        CAST (
                                                           MULTISET ( --2d data set
                                                              SELECT pv.VALUE,
                                                                     MDSR_FB_VM_XML_T (
                                                                        vm2.vm_id,
                                                                        vm2.version,
                                                                        vm2.long_name,
                                                                        CAST (
                                                                           MULTISET ( --3d data set MDSR_FB_DESIGN_XML_LIST_T
                                                                              SELECT d.created_by,
                                                                                     d.date_created,
                                                                                     d.LAE_NAME,
                                                                                     d.name,
                                                                                     DETL_NAME,
                                                                                     c.name,
                                                                                     CAST (
                                                                                        MULTISET ( --4th data set   MDSR_FB_FORM_CL_XML_LIST_T
                                                                                             SELECT class_long_name,
                                                                                                    CS_ID,
                                                                                                    class_version,
                                                                                                    preferred_definition,
                                                                                                    MDSR_FB_FORM_CLI_XML_T (
                                                                                                       clitem_long_name,
                                                                                                       CSI_ID,
                                                                                                       clitem_version,
                                                                                                       CSITL_NAME)
                                                                                               FROM MDSR_FB_VM_CLASSIFICATION CL
                                                                                              WHERE d.DESIG_IDSEQ =
                                                                                                       CL.ATT_IDSEQ(+)
                                                                                           ORDER BY CS_ID) AS MDSR_FB_FORM_CL_XML_LIST_T) --4th data set   MDSR_FB_FORM_CL_XML_LIST_T
                                                                                FROM SBR.DESIGNATIONS d,
                                                                                     SBR.contexts c
                                                                               WHERE     c.CONTE_IDSEQ =
                                                                                            d.CONTE_IDSEQ
                                                                                     AND d.ac_idseq =
                                                                                            vm2.vm_idseq) AS MDSR_FB_DESIGN_XML_LIST_T) --3d data set MDSR_FB_DESIGN_XML_LIST_T
                                                                                                                                       ,
                                                                        CAST (
                                                                           MULTISET ( --3d data set MDSR_FB_DEFIN_XML_LIST_T
                                                                              SELECT df.created_by,
                                                                                     df.date_created,
                                                                                     df.LAE_NAME,
                                                                                     df.DEFINITION,
                                                                                     SUBSTR (
                                                                                        DEFL_NAME,
                                                                                        1,
                                                                                        19),
                                                                                     -- c.name,
                                                                                     CAST (
                                                                                        MULTISET ( --4th data set   MDSR_FB_FORM_CL_XML_LIST_T
                                                                                             SELECT class_long_name,
                                                                                                    CS_ID,
                                                                                                    class_version,
                                                                                                    preferred_definition,
                                                                                                    MDSR_FB_FORM_CLI_XML_T (
                                                                                                       clitem_long_name,
                                                                                                       CSI_ID,
                                                                                                       clitem_version,
                                                                                                       CSITL_NAME)
                                                                                               FROM MDSR_FB_VM_CLASSIFICATION CL
                                                                                              WHERE df.DEFIN_IDSEQ =
                                                                                                       CL.ATT_IDSEQ(+)
                                                                                           ORDER BY CS_ID) AS MDSR_FB_FORM_CL_XML_LIST_T) --4th data set   MDSR_FB_FORM_CL_XML_LIST_T
                                                                                FROM SBR.DEFINITIONS df,
                                                                                     SBR.contexts c
                                                                               WHERE     c.CONTE_IDSEQ(+) =
                                                                                            df.CONTE_IDSEQ
                                                                                     AND df.ac_idseq =
                                                                                            vm2.vm_idseq) AS MDSR_FB_DEFIN_XML_LIST_T) --3d data set MDSR_FB_DEFIN_XML_LIST_T
                                                                                                                                      ,
                                                                        vm2.preferred_Definition)
                                                                FROM SBR.VALUE_MEANINGS vm2,
                                                                     SBR.PERMISSIBLE_VALUES pv,
                                                                     VD_PVS vp
                                                               WHERE     pv.pv_idseq =
                                                                            vp.pv_idseq --vm_id='3197154'
                                                                     AND vm2.vm_idseq =
                                                                            pv.VM_idseq
                                                                     AND vd.VD_IDSEQ =
                                                                            vp.VD_IDSEQ) AS MDSR_FB_PV_XML_LIST_T) ---2d list MDSR_FB_PV_XML_LIST_T
                                                   FROM value_domains vd
                                                  WHERE vd.vd_idseq = qq.vd_idseq) AS MDSR_FB_VD_XML_LIST_T) 
                                                  
                                                 ,
                                                CAST (
                                                MULTISET (select
                                                MDSR_FB_USECAT_XML('Mandatory','') ,
                                                '0' ,
                                                MDSR_FB_DE_DR_XML_T(
                                                '0',
                                                '0',
                                                MDSR_FB_VD_DR_XML_T(
                                                'PRSN_WT_VAL'  ,
                                                'NonEnumerated'   ,
                                                'RELEASED'       ,
                                                MDSR_FB_VDC_DR_XML_T('http://blankNode' ) ) ) 
                                                from SBR.COMPLEX_DATA_ELEMENTS cdv,
                                                SBR.DATA_ELEMENTS DE     
                                                where  cdv.P_DE_IDSEQ(+) = de.DE_IDSEQ    
                                                and de.DE_IDSEQ=qq.DE_IDSEQ) as MDSR_FB_COM_DE_DR_XML_LIST_T) 
                                                
                                                ,
                                                
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
                                                     AND rd.ac_idseq =qq.de_idseq) as MDSR_FB_RD_XML_LIST_T) 
                                                ,
                                                
                                              'https://cdebrowser.nci.nih.gov/CDEBrowser/search?elementDetails=9'
                                           || '&'
                                           || 'FirstTimer=0'
                                           || '&'
                                           || 'PageId=ElementDetailsGroup'
                                           || '&'
                                           || 'publicId='
                                           || QQ.CDE_ID
                                           || '&'
                                           || 'version='
                                           || QQ.de_version  )
                                           ------------
                                           
                                         
                                   from SBREXT.MDSR_FB_QUESTION_MVW QQ
                                  where QQ.QUES_IDSEQ= '430203EE-CCBE-6162-E053-F662850A2532';
                                  
                  /*   ,
                                            CAST (
                                           MULTISET (
                                                SELECT TRIM (DISPLAY_ORDER),
                                                       TRIM (long_name),
                                                       TRIM (MEANING_TEXT),
                                                       TRIM (DESCRIPTION_TEXT),
                                                       MDSR_FB_VV_VM_XML_T (
                                                          vm_id,
                                                          vm_version)
                                                  FROM SBREXT.MDSR_FB_VALID_VALUE_MVW MVV
                                                 WHERE MVV.QUEST_IDseq = qq.QUES_IDseq
                                                 ORDER BY DISPLAY_ORDER) AS MDSR_FB_VV_XML_LIST_T) AS FB_VV_list*/
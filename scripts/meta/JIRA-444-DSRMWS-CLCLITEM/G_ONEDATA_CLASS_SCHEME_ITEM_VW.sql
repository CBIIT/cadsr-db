CREATE OR REPLACE FORCE VIEW ONEDATA_WA.ONEDATA_CLASS_SCHEME_ITEM_VW
AS  SELECT    NODE.CNTXT_CS_ITEM_ID CS_ID,
            NODE.CNTXT_CS_VER_NR CS_VERSION, 
            CS.ITEM_LONG_NM PREFERRED_NAME,
            CS.ITEM_NM LONG_NAME,
            CSI.ITEM_DESC PREFERRED_DEFINITION,  
            cs.ADMIN_STUS_NM_DN  ASL_NAME,
            CS.CNTXT_NM_DN CS_CONTEXT_NAME,
            CS.CNTXT_VER_NR CS_CONTEXT_VERSION,
            -- CONTE_IDSEQ,
            NODE.NCI_PUB_ID,
            NODE.NCI_VER_NR,            
            NODE.C_ITEM_ID CSI_ID,
            NODE.C_item_ver_nr CSI_VERSION,           
            O.NCI_CD       CSITL_NAME,            
            -- CSI.ITEM_NM,
            CSI.ITEM_NM CSI_NAME,
            CSI.ITEM_DESC description,
            CSI.CNTXT_NM_DN CSI_CONTEXT_NAME,
            CSI.CNTXT_VER_NR CSI_CONTEXT_VERSION,
            CS.CREAT_DT  CS_DATE_CREATED,
            CSI.CREAT_DT  CSI_DATE_CREATED,
            NODE.P_ITEM_ID P_CSI_ID,
            NODE.p_item_ver_nr P_CSI_VERSION,             
            LEVEL,
            DECODE (CONNECT_BY_ISLEAF,  '1', 'FALSE',  '0', 'TRUE') "IsLeaf"
       
    FROM 
       NCI_ADMIN_ITEM_REL_ALT_KEY  NODE,
       admin_item                  CS,
       admin_item                  CSI,  
       NCI_CLSFCTN_SCHM_ITEM  NCSI,
       OBJ_KEY                     O      
    WHERE cs.ADMIN_ITEM_TYP_ID = 9
        AND cs.ADMIN_STUS_NM_DN ='RELEASED'
        AND csi.ADMIN_ITEM_TYP_ID = 51
        AND node.c_item_id = csi.item_id
        AND node.c_item_ver_nr = csi.ver_nr
        AND csi.item_id = ncsi.item_id
        AND csi.ver_nr = ncsi.ver_nr
        AND ncsi.CSI_TYP_ID = o.obj_key_id
        AND node.cntxt_cs_item_id = cs.item_id
        AND node.cntxt_cs_Ver_nr = cs.ver_nr
        AND node.rel_typ_id = 64
        AND INSTR (O.NCI_CD, 'testCaseMix') = 0  
        -- AND C_ITEM_ID=3070841
        AND CS.CNTXT_NM_DN  NOT IN ('TEST', 'Training')
        AND CSI.CNTXT_NM_DN  NOT IN ('TEST', 'Training')
        --   and ITEM_ID=5635383 --  CONNECT BY  NOCYCLE

        CONNECT BY PRIOR C_ITEM_ID = P_ITEM_ID
            AND PRIOR C_ITEM_VER_NR = C_ITEM_VER_NR
            AND PRIOR CNTXT_CS_ITEM_ID = CNTXT_CS_ITEM_ID
            AND PRIOR CNTXT_CS_VER_NR= CNTXT_CS_VER_NR
            AND PRIOR NCI_PUB_ID(+)< > NCI_PUB_ID
        START WITH P_ITEM_ID IS NULL
        ORDER BY P_ITEM_ID,LEVEL ,CNTXT_CS_ITEM_ID;
      
    /*  
      
      select 15991321	1	3070841	1	3070841	1	3134868	1	3	TRUE
      3134870

select NODE.NCI_PUB_ID,
            NODE.NCI_VER_NR,            
            NODE.C_ITEM_ID,
            NODE.C_item_ver_nr,
            NODE.P_ITEM_ID,
            NODE.p_item_ver_nr,
            NODE.CNTXT_CS_ITEM_ID,
            NODE.CNTXT_CS_VER_NR
            from NCI_ADMIN_ITEM_REL_ALT_KEY NODE where NODE.C_ITEM_ID=3134870 and NODE.CNTXT_CS_ITEM_ID =3134868
            
            select*from ADMIN_ITEM where  ITEM_ID =3134868
               cs_conte.name
                    cs_context_name,
                cs_conte.version
                    cs_context_version,*/
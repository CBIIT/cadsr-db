select DE.*--.cdv.* 
from SBR.COMPLEX_DATA_ELEMENTS cdv,
       SBR.DATA_ELEMENTS DE,
       COMPLEX_DE_RELATIONSHIPS CDR
       where  cdv.P_DE_IDSEQ = de.DE_IDSEQ
       --and cdv.P_DE_IDSEQ=CDR.P_DE_IDSEQ
       and C_DE_IDSEQ=DE_IDSEQ
       and de.DE_IDSEQ='272DB2A0-355C-2D49-E044-0003BA3F9857'
       and cde_id=2179689
  
select*from quest_contents_ext where qc_id=5590327  

select * from DATA_ELEMENT_CONCEPTS where dec_idseq='232C2334-25F1-017F-E044-0003BA3F9857'
COMPLEX_DE_RELATIONSHIPS
(
  CDR_IDSEQ      CHAR(36 BYTE)                  NOT NULL,
  C_DE_IDSEQ     CHAR(36 BYTE)                  NOT NULL,
  P_DE_IDSEQ     CHAR(36 BYTE)                  NOT NULL,
  DISPLAY_ORDER  NUMBER(4),
  DATE_MODIFIED  DATE,
  DATE_CREATED   DATE                           NOT NULL,
  MODIFIED_BY    VARCHAR2(30 BYTE),
  CREATED_BY     VARCHAR2(30 BYTE)              NOT NULL,
  RF_IDSEQ       CHAR(36 BYTE),
  LEFT_STRING    VARCHAR2(50 BYTE),
  RIGHT_STRING 


     
   select*from  SBR.DATA_ELEMENTS DE
       where  
        de.DE_IDSEQ='272DB2A0-355C-2D49-E044-0003BA3F9857'
       
          430203EE-CCBE-6162-E053-F662850A2532
       WHEN MOD.long_NAME LIKE 'Mandatory%' THEN 'Mandatory'
          WHEN MOD.long_NAME LIKE 'Conditional%' THEN 'Conditional'
          WHEN MOD.long_NAME LIKE 'Optional%' THEN 'Optional'
          ELSE 'None'
       
       select*from quest_contents_ext where qc_id=5590327
       DE='272DB2A0-355C-2D49-E044-0003BA3F9857'
       qc_idseq='430203EE-CCBE-6162-E053-F662850A2532'
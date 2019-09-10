CREATE OR REPLACE TYPE MDSR759_XML_CSI_T1 as object(
"item Level" number,
 "name" VARCHAR2(255),
 "publicID"        NUMBER,
 "version"          VARCHAR2(7),
 "type"   VARCHAR2(20),
"preferredDefinition"  VARCHAR2(2000),
 "Item id" VARCHAR2(60),
  "Parent id" VARCHAR2(60), 
 "Parent publicID"        NUMBER,
 "Parent version"          VARCHAR2(7),
 "Children" VARCHAR2(10))
/
CREATE OR REPLACE TYPE MDSR759_XML_CSI_LIST_T1  as table of MDSR759_XML_CSI_T1
/
CREATE OR REPLACE TYPE MDSR759_XML_CS_T1 as object(
"name" VARCHAR2(255),
"publicID"        NUMBER,
"version"          VARCHAR2(7),
"preferredDefinition"  VARCHAR2(2000),
"ClassificationItem_LIST"  MDSR759_XML_CSI_LIST_T1)
/
CREATE OR REPLACE TYPE MDSR759_XML_CS_LIST_T1  as table of MDSR759_XML_CS_T1
/
CREATE OR REPLACE TYPE MDSR759_XML_Context_T1 as object(
"PreferredName" VARCHAR(60),
"version"          VARCHAR2(7),
"ContextID" VARCHAR(60),
"ClassificationScheme" MDSR759_XML_CSI_LIST_T1)
/
select *--distinct version
 from contexts;
 
 
 SELECT CS_IDSEQ,
    PREFERRED_NAME,
    LONG_NAME,
    PREFERRED_DEFINITION,
    VERSION,
    ASL_NAME,
    CS_CONTEXT_NAME,
    CS_CONTEXT_VERSION,
                          CAST (
                             MULTISET (
                                SELECT CSI_LEVEL,
                                       CSI_NAME,
                                       CSI_ID,    
                                       CSI_VERSION,    
                                       CSITL_NAME,    
                                       DESCRIPTION,   
                                       CSI_IDSEQ,
                                       PARENT_CSI_IDSEQ,
                                       '',
                                       '',    
                                        LEAF
                                  FROM SBREXT.MDSR_CLASS_SCHEME_ITEM_VW csi
                                 WHERE csi.CS_IDSEQ=cl.CS_IDSEQ
                              --   group by csi.CSI_LEVEL,   csi.CSI_ID                                     
                              order by  csi.CSI_LEVEL,   csi.CSI_ID       ) AS MDSR759_XML_CSI_LIST_T1)      "ClassificationItemList"
                     FROM  (select distinct CS_IDSEQ,CS_ID,
    PREFERRED_NAME,
    LONG_NAME,
    PREFERRED_DEFINITION,
    VERSION,
    ASL_NAME,
    CS_CONTEXT_NAME,
    CS_CONTEXT_VERSION
    from SBREXT.MDSR_CLASS_SCHEME_ITEM_VW 
    where cs_idseq='E92962A2-9978-1F46-E034-0003BA3F9857' )cl
                   
order by  CS_ID


select* from  SBREXT.MDSR_CLASS_SCHEME_ITEM_VW where --csi_level>4
cs_idseq='E92962A2-9978-1F46-E034-0003BA3F9857'--'99BA9DC8-84A1-4E69-E034-080020C9C0E0'
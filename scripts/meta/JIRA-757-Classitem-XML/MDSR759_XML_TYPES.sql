CREATE OR REPLACE TYPE MDSR759_XML_CSI_T1 as object(
"item Level" number,
 "name" VARCHAR2(255),
 "publicID"        NUMBER,
 "version"          VARCHAR2(7),
 "type"   VARCHAR2(20),
"preferredDefinition"  VARCHAR2(2000),
 "Item id" VARCHAR2(60),
  "Parent id" VARCHAR2(60), 
  sc_csi_id VARCHAR2(60),
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
"ClassificationScheme" MDSR759_XML_CS_LIST_T1)
/

drop TYPE MDSR759_XML_Context_T1;
drop type MDSR759_XML_CS_LIST_T1;
drop type MDSR759_XML_CS_T1;
drop type MDSR759_XML_CSI_LIST_T1;
select *--distinct version
 from contexts;
  
 select CS_CONTEXT_NAME,
      CS_CONTEXT_VERSION,
 CAST (
                             MULTISET (SELECT CS_IDSEQ,
    PREFERRED_NAME,
    LONG_NAME,
    PREFERRED_DEFINITION,
    VERSION,
    ASL_NAME,
    CS_CONTEXT_NAME,
    CS_CONTEXT_VERSION,
                          CAST (
                             MULTISET (
                                SELECT vw.CSI_LEVEL,
                                       vw.CSI_NAME,
                                       vw.CSI_ID,    
                                       CSI_VERSION,    
                                       vw.CSITL_NAME,    
                                       vw.DESCRIPTION,   
                                       vw.CSI_IDSEQ,
                                       vw.PARENT_CSI_IDSEQ,
                                       csi.CS_CSI_IDSEQ,
                                       CSI.CSI_ID,    
                                       CSI.VERSION,  
                                        vw.LEAF
                                  FROM SBREXT.MDSR_CLASS_SCHEME_ITEM_VW vw,
                                      ( select csi.CSI_IDSEQ,csi.csi_id ,p_cs_csi_idseq,csi.version,CS_CSI_IDSEQ from
                                       sbr.cs_items   csi,
                                       sbr.cs_csi   csc 
                                       WHERE    csc.csi_idseq = csi.csi_idseq)csi
                                 WHERE vw.CS_IDSEQ=--'E92962A2-9978-1F46-E034-0003BA3F9857'
                                 cl.CS_IDSEQ
                                 and PARENT_CSI_IDSEQ=csi.CS_CSI_IDSEQ(+)
                              --   group by csi.CSI_LEVEL,   csi.CSI_ID                                     
                              order by  vw.CSI_LEVEL,   csi.CSI_ID       ) AS MDSR759_XML_CSI_LIST_T1)      "ClassificationItemList"
                     FROM  (select distinct CS_IDSEQ,CS_ID,
    PREFERRED_NAME,
    LONG_NAME,
    PREFERRED_DEFINITION,
    VERSION,
    ASL_NAME,
    CS_CONTEXT_NAME,
    CS_CONTEXT_VERSION
    from SBREXT.MDSR_CLASS_SCHEME_ITEM_VW 
    --where cs_idseq='E92962A2-9978-1F46-E034-0003BA3F9857' 
    )cl
                   
order by  CS_ID;
 
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
                                SELECT vw.CSI_LEVEL,
                                       vw.CSI_NAME,
                                       vw.CSI_ID,    
                                       CSI_VERSION,    
                                       vw.CSITL_NAME,    
                                       vw.DESCRIPTION,   
                                       vw.CSI_IDSEQ,
                                       vw.PARENT_CSI_IDSEQ,
                                        vw.CS_CSI_IDSEQ,
                                       CSI.CSI_ID,    
                                       CSI.VERSION,  
                                        vw.LEAF
                                  FROM SBREXT.MDSR_CLASS_SCHEME_ITEM_VW vw,
                                      ( select csi.CSI_IDSEQ,csi.csi_id ,p_cs_csi_idseq,csi.version ,CS_CSI_IDSEQ from
                                       sbr.cs_items   csi,
                                       sbr.cs_csi   csc 
                                       WHERE    csc.csi_idseq = csi.csi_idseq)csi
                                 WHERE vw.CS_IDSEQ='E92962A2-9978-1F46-E034-0003BA3F9857'--cl.CS_IDSEQ
                                 and PARENT_CSI_IDSEQ=csi.p_cs_csi_idseq(+)
                                 and vw.CS_CSI_IDSEQ=csi.CS_CSI_IDSEQ(+)
                                -- and  CSI.CSI_ID=
                              --   group by csi.CSI_LEVEL,   csi.CSI_ID                                     
                              order by  vw.CSI_LEVEL,   csi.CSI_ID       ) AS MDSR759_XML_CSI_LIST_T1)      "ClassificationItemList"
                     FROM  (select distinct CS_IDSEQ,CS_ID,
    PREFERRED_NAME,
    LONG_NAME,
    PREFERRED_DEFINITION,
    VERSION,
    ASL_NAME,
    CS_CONTEXT_NAME,
    CS_CONTEXT_VERSION
    from SBREXT.MDSR_CLASS_SCHEME_ITEM_VW cl
    where con.CS_CONTEXT_NAME=cl.CS_CONTEXT_NAME
   -- cs_idseq='E92962A2-9978-1F46-E034-0003BA3F9857' 
    )cl
                   
order by  CS_ID) AS MDSR759_XML_CS_LIST_T1)      "Classification List"
 FROM 
 (select distinct 
    CS_CONTEXT_NAME,
    CS_CONTEXT_VERSION
    from SBREXT.MDSR_CLASS_SCHEME_ITEM_VW 
    where cs_idseq='E92962A2-9978-1F46-E034-0003BA3F9857' )con
 
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
                                SELECT vw.CSI_LEVEL,
                                       vw.CSI_NAME,
                                       vw.CSI_ID,    
                                       CSI_VERSION,    
                                       vw.CSITL_NAME,    
                                       vw.DESCRIPTION,   
                                       vw.CSI_IDSEQ,
                                       vw.PARENT_CSI_IDSEQ,
                                       csi.CS_CSI_IDSEQ,
                                       CSI.CSI_ID,    
                                       CSI.VERSION,  
                                        vw.LEAF
                                  FROM SBREXT.MDSR_CLASS_SCHEME_ITEM_VW vw,
                                      ( select csi.CSI_IDSEQ,csi.csi_id ,p_cs_csi_idseq,csi.version,CS_CSI_IDSEQ from
                                       sbr.cs_items   csi,
                                       sbr.cs_csi   csc 
                                       WHERE    csc.csi_idseq = csi.csi_idseq)csi
                                 WHERE vw.CS_IDSEQ='E92962A2-9978-1F46-E034-0003BA3F9857'--cl.CS_IDSEQ
                                 and PARENT_CSI_IDSEQ=csi.CS_CSI_IDSEQ(+)
                              --   group by csi.CSI_LEVEL,   csi.CSI_ID                                     
                              order by  vw.CSI_LEVEL,   csi.CSI_ID       ) AS MDSR759_XML_CSI_LIST_T1)      "ClassificationItemList"
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

select* from sbr.cs_items  where csi_idseq='66A69346-781B-F3F8-E040-BB89AD430145'
 ( select csi.CSI_IDSEQ,csi.csi_id ,p_cs_csi_idseq,csi.version, CS_CSI_IDSEQ
 --select* 
 from
                                       sbr.cs_items   csi,
                                       sbr.cs_csi   csc 
                                       WHERE    csc.csi_idseq = csi.csi_idseq
                                       and csi_id=2812358
                                       and p_cs_csi_idseq='66A69346-781B-F3F8-E040-BB89AD430145')
                                       66A6EB0A-5447-16B2-E040-BB89AD4373A5
                                       
                                       
                                       66A6EB0A-5447-16B2-E040-BB89AD4373A5	2859963		1	66A69346-781B-F3F8-E040-BB89AD430145
66A6EB0A-5447-16B2-E040-BB89AD4373A5

select* from  SBREXT.MDSR_CLASS_SCHEME_ITEM_VW where PARENT_CSI_IDSEQ='EAC02A7D-CA3C-0786-E034-0003BA3F9857'
or CS_CSI_IDSEQ='EAC02A7D-CA3D-0786-E034-0003BA3F9857'


CREATE OR REPLACE TYPE MDSR759_XML_CSI_L5_T as object(
"item Level" number,
 "name" VARCHAR2(255),
 "publicID"        NUMBER,
 "version"          VARCHAR2(7),
 "type"   VARCHAR2(20),
"preferredDefinition"  VARCHAR2(2000),
 "Item id" VARCHAR2(60),
  "Parent id" VARCHAR2(60), 
  sc_csi_id VARCHAR2(60),
 "Parent publicID"        NUMBER,
 "Parent version"          VARCHAR2(7),
 "AnyChildren" VARCHAR2(10))
/
CREATE OR REPLACE TYPE MDSR759_XML_CSI_LIST5_T as table of MDSR759_XML_CSI_L5_T;
CREATE OR REPLACE TYPE MDSR759_XML_CSI_L4_T as object(
"item Level" number,
 "name" VARCHAR2(255),
 "publicID"        NUMBER,
 "version"          VARCHAR2(7),
 "type"   VARCHAR2(20),
"preferredDefinition"  VARCHAR2(2000),
 "Item id" VARCHAR2(60),
  "Parent id" VARCHAR2(60), 
  sc_csi_id VARCHAR2(60),
 "Parent publicID"        NUMBER,
 "Parent version"          VARCHAR2(7),
 "AnyChildren" VARCHAR2(10),
 "Children" MDSR759_XML_CSI_LIST5_T)
 
/
CREATE OR REPLACE TYPE MDSR759_XML_CSI_LIST4_T as table of MDSR759_XML_CSI_L4_T;
CREATE OR REPLACE TYPE MDSR759_XML_CSI_L3_T as object(
"item Level" number,
 "name" VARCHAR2(255),
 "publicID"        NUMBER,
 "version"          VARCHAR2(7),
 "type"   VARCHAR2(20),
"preferredDefinition"  VARCHAR2(2000),
 "Item id" VARCHAR2(60),
  "Parent id" VARCHAR2(60), 
  sc_csi_id VARCHAR2(60),
 "Parent publicID"        NUMBER,
 "Parent version"          VARCHAR2(7),
 "AnyChildren" VARCHAR2(10),
 "Children" MDSR759_XML_CSI_LIST4_T)
 
/
CREATE OR REPLACE TYPE MDSR759_XML_CSI_LIST3_T as table of MDSR759_XML_CSI_L3_T;

CREATE OR REPLACE TYPE MDSR759_XML_CSI_L2_T as object(
"item Level" number,
 "name" VARCHAR2(255),
 "publicID"        NUMBER,
 "version"          VARCHAR2(7),
 "type"   VARCHAR2(20),
"preferredDefinition"  VARCHAR2(2000),
 "Item id" VARCHAR2(60),
  "Parent id" VARCHAR2(60), 
  sc_csi_id VARCHAR2(60),
 "Parent publicID"        NUMBER,
 "Parent version"          VARCHAR2(7),
 "AnyChildren" VARCHAR2(10),
 "Children" MDSR759_XML_CSI_LIST3_T)
 
/
CREATE OR REPLACE TYPE MDSR759_XML_CSI_LIST2_T as table of MDSR759_XML_CSI_L2_T;

CREATE OR REPLACE TYPE MDSR759_XML_CSI_L1_T as object(
"item Level" number,
 "name" VARCHAR2(255),
 "publicID"        NUMBER,
 "version"          VARCHAR2(7),
 "type"   VARCHAR2(20),
"preferredDefinition"  VARCHAR2(2000),
 "Item id" VARCHAR2(60),
  "Parent id" VARCHAR2(60), 
  sc_csi_id VARCHAR2(60),
 "AnyChildren" VARCHAR2(10))
 
/
CREATE OR REPLACE TYPE MDSR759_XML_CSI_LIST1_T as table of MDSR759_XML_CSI_L1_T;


drop TYPE MDSR759_XML_CSI_LIST1_T ;
drop TYPE MDSR759_XML_CSI_L1_T;
drop TYPE MDSR759_XML_CSI_LIST2_T ;
drop TYPE MDSR759_XML_CSI_L2_T;
drop TYPE MDSR759_XML_CSI_LIST3_T ;
drop TYPE MDSR759_XML_CSI_L3_T;
drop TYPE MDSR759_XML_CSI_LIST4_T ;
drop TYPE MDSR759_XML_CSI_L4_T;
drop TYPE MDSR759_XML_CSI_LIST5_T ;
drop TYPE MDSR759_XML_CSI_L5_T;

drop TYPE MDSR759_XML_CSI_LIST1_T ;
drop TYPE MDSR759_XML_CSI_L5_T;
drop TYPE MDSR759_XML_CS_L5_LIST_T;
 drop TYPE MDSR759_XML_CS_L5_T;
CREATE OR REPLACE TYPE MDSR759_XML_CS_L5_T as object(
"name" VARCHAR2(255),
"publicID"        NUMBER,
"version"          VARCHAR2(7),
"preferredDefinition"  VARCHAR2(2000),
"ClassificationItem_LIST"  MDSR759_XML_CSI_LIST1_T)
/
CREATE OR REPLACE TYPE MDSR759_XML_CS_L5_LIST_T  as table of MDSR759_XML_CS_L5_T
/
CREATE OR REPLACE TYPE MDSR759_XML_Context_T1 as object(
"PreferredName" VARCHAR(60),
"version"          VARCHAR2(7),
"ContextID" VARCHAR(60),
"ClassificationScheme" MDSR759_XML_CS_L5_LIST_T)
/

v1.CSI_LEVEL,
                                       v1.CSI_NAME,
                                       v1.CSI_ID,    
                                       v1.CSI_VERSION,    
                                       v1.CSITL_NAME,    
                                       v1.DESCRIPTION,   
                                       v1.CSI_IDSEQ,
                                       v1.PARENT_CSI_IDSEQ,
                                       v1.CS_CSI_IDSEQ,                                      
                                       v1.LEAF,
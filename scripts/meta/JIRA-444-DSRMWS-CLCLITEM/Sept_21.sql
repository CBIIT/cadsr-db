select count(*) from ONEDATA_CLASS_SCHEME_ITEM_VW;
select count(*) from SBREXT_MDSR_CLASS_SCHEME_ITEM_VW where CS_ID = 2192345;
select count(*) from VW_CLASS_SCHEME_ITEM_MDSR;

select count(*) from  sbr.cs_csi;

select count(*) from ONEDATA_WA.VW_CSI_NODE;

select*from NCI_ADMIN_ITEM_REL_ALT_KEY where NCI_PUB_ID=15987181;
select *from VW_CLASS_SCHEME_ITEM_MDSR;
select * from SBREXT_MDSR_CLASS_SCHEME_ITEM_VW;
select*from NCI_ADMIN_ITEM_REL_ALT_KEY   where C_ITEM_ID=3070841
and CNTXT_CS_ITEM_ID=3134868;

select*from NCI_ADMIN_ITEM_REL_ALT_KEY  where P_ITEM_ID=3070841;
select count(*) from ONEDATA_CLASS_SCHEME_ITEM_VW;
select count(*) from (select distinct CS_ITEM_ID,--CS_LONG_NM, 
ITEM_ID,--ITEM_NM,CNTXT_NM_DN,CSI_LEVEL,
NVL(pcsi_item_id,0) from ONEDATA_CLASS_SCHEME_ITEM_VW);

select count(*) cnt, CS_ITEM_ID,CS_VER_NR,--CS_LONG_NM, 
ITEM_ID,VER_NR,--ITEM_NM,CNTXT_NM_DN,
CSI_LEVEL,
NVL(pcsi_item_id,0) from ONEDATA_CLASS_SCHEME_ITEM_VW
group by CS_ITEM_ID,CS_VER_NR,--CS_LONG_NM, 
ITEM_ID,VER_NR,--ITEM_NM,CNTXT_NM_DN,
CSI_LEVEL,
NVL(pcsi_item_id,0)
having count(*)>1;

create table temp_test1 as 
select  CS_ITEM_ID,CS_VER_NR,--CS_LONG_NM, 
ITEM_ID,VER_NR,--ITEM_NM,CNTXT_NM_DN,
CSI_LEVEL,
NVL(pcsi_item_id,0) p_csi_item from ONEDATA_CLASS_SCHEME_ITEM_VW;
--;
--select count(*) from temp_test2

select  CS_id ,CS_VERSION  ,
CSI_id ,CSI_VERSION ,CSI_LEVEL 
,NVL(P_CSI_id,0),nvl(P_CSI_VERSION,0),NCI_IDSEQ, P_CS_CSI_IDSEQ from REL_CLASS_SCHEME_ITEM_VW
minus
--create table temp_test2 as 
select c.CS_id ,c.VERSION  ,
c.CSI_id ITEM_ID,c.CSI_VERSION ,c.CSI_LEVEL 
,NVL(p.CSI_id,0),NVL(p.csi_version,0) , c.CS_CSI_IDSEQ,  c.PARENT_CSI_IDSEQ
from SBREXT_MDSR_CLASS_SCHEME_ITEM_VW c,
SBREXT_MDSR_CLASS_SCHEME_ITEM_VW p
where p.CS_CSI_IDSEQ(+)=c.PARENT_CSI_IDSEQ;

3134868	1	3135099	1	4	2812730
3134868	1	3180984	1	4	3070841
select* from NCI_ADMIN_ITEM_REL_ALT_KEY where CNTXT_CS_ITEM_ID =3134868
and CNTXT_CS_VER_NR=1 and C_ITEM_ID=3135099 --2--812730

select* from NCI_ADMIN_ITEM_REL_ALT_KEY where CNTXT_CS_ITEM_ID =3134868 --3
and CNTXT_CS_VER_NR=1 and C_ITEM_ID=2812730 --2
select* from NCI_ADMIN_ITEM_REL_ALT_KEY where CNTXT_CS_ITEM_ID =3134868
and CNTXT_CS_VER_NR=1 and C_ITEM_ID=	3135097	1

select*from sbr.SC_CSI


minus
--select count(*) from(
select c.CS_id, c.version cs_version,
c.CSI_id,c.csi_version,--c.CSI_NAME,c.CSI_CONTEXT_NAME,c.CSI_LEVEL 
NVL(p.CSI_id,0),NVL(p.csi_version,0)--,p.CSI_NAME,p.CSI_CONTEXT_NAME--,p.CSI_LEVEL 
from SBREXT_MDSR_CLASS_SCHEME_ITEM_VW c,
SBREXT_MDSR_CLASS_SCHEME_ITEM_VW p
where p.CS_CSI_IDSEQ(+)=c.PARENT_CSI_IDSEQ;
--);


select*from
SBREXT_MDSR_CLASS_SCHEME_ITEM;
select count(*)--c.CS_id,--c.PREFERRED_NAME,
--c.CSI_id--,--c.CSI_NAME,c.CSI_CONTEXT_NAME,c.CSI_LEVEL 
--,NVL(p.CSI_id,0)--,p.CSI_NAME,p.CSI_CONTEXT_NAME--,p.CSI_LEVEL 
from SBREXT_MDSR_CLASS_SCHEME_ITEM_VW c,
SBREXT_MDSR_CLASS_SCHEME_ITEM_VW p
where p.CS_CSI_IDSEQ(+)=c.PARENT_CSI_IDSEQ
minus
select CS_ITEM_ID,--CS_LONG_NM, 
ITEM_ID,--ITEM_NM,CNTXT_NM_DN,CSI_LEVEL,
NVL(pcsi_item_id,0) from ONEDATA_CLASS_SCHEME_ITEM_VW
;

select *from ONEDATA_CLASS_SCHEME_ITEM_VW where CS_Item_ID=3134868 and 
item_ID in (3135099,3180984)


4272096	4272129	0

select*from ONEDATA_WA.SBREXT_MDSR_CLASS_SCHEME_ITEM_VW 
 where PARENT_CSI_IDSEQ='8FB28EEE-49AF-FE18-E040-BB89AD4350B9'--c.CS_id=3134868 and 
c.CSI_id in (3135099,3180984)

select*from sbr.cs_csi where CS_CSI_IDSEQ='8FB28EEE-49AF-FE18-E040-BB89AD4350B9'




3134868	1	3135099	1	4	2812730
3134868	1	3180984	1	4	3070841

 SELECT 
                cs.preferred_name,
                cs.long_name,
                cs.preferred_definition,
                cs.version,
                cs.asl_name,               
                
                cs.conte_idseq
                    conte_idseq,
                csi.long_name
                    csi_name,
                csi.csitl_name,
                csi.preferred_definition
                    description,
                csi.csi_id,
                csi.version
                    csi_version,
                csi.CSI_IDSEQ,
               
                cs.cs_id,
                cs.date_created
                    cs_date_created,
                csi.date_created
                    csi_date_created,
                pcsi.version                    pcsi_version,
                pcsi.CSI_ID  PCSI_ID,
              csc.CS_CSI_IDSEQ,
              csc.p_cs_csi_idseq
           FROM sbr.classification_schemes cs,
                sbr.cs_items            csi,
                sbr.cs_csi              csc,
                sbr.cs_csi              pcsc,
                sbr.cs_items            pcsi
          WHERE     csc.cs_idseq = cs.cs_idseq
                AND csc.csi_idseq = csi.csi_idseq
                and pcsc.csi_idseq = pcsi.csi_idseq
               and pcsc.CS_CSI_IDSEQ=csc.p_cs_csi_idseq
                AND INSTR (csi.CSITL_NAME, 'testCaseMix') = 0
            --    AND csi_conte.name NOT IN ('TEST', 'Training')
               -- AND cs_conte.name NOT IN ('TEST', 'Training')
                AND cs.ASL_NAME = 'RELEASED'
                
                and cs.cs_id=3134868 and csi.csi_id=2812730--3135099
                
                create table PC_CS_CSI as select CS_CSI_IDSEQ,P_CS_CSI_IDSEQ from  sbr.cs_csi 
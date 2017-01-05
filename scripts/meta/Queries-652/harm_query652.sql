select c.name,de.version,de.cde_id ,de.long_name,de.PREFERRED_NAME,de.Asl_name,de.begin_date,
de.End_date,de.CHANGE_NOTE,de.date_created, de.created_by, de.date_modified, de.modified_by ,
dv.Asl_name,dv.long_name,dv.PREFERRED_NAME,dv.vd_id,dv.version,dv.begin_date,dv.End_date,
dv.CHANGE_NOTE,dv.LATEST_VERSION_IND,dv.date_created,dv.created_by, dv.date_modified, dv.modified_by
from  SBR.DATA_ELEMENTS de ,SBR.CONTEXTS c,VALUE_DOMAINS_VIEW dv
where de.CONTE_IDSEQ=c.CONTE_IDSEQ
and de.VD_IDSEQ=dv.VD_IDSEQ
and de.ASL_NAME='RELEASED' 
and UPPER(dv.ASL_NAME)  like'RETIRED%'
and de.cde_id=2552696-- in(2223860,2552647)
order by c.name,de.long_name;

select c.name,de.version,de.cde_id ,de.long_name,de.PREFERRED_NAME,de.Asl_name,de.begin_date,
de.End_date,de.CHANGE_NOTE,de.date_created, de.created_by, de.date_modified, de.modified_by ,
dv.Asl_name,dv.long_name,dv.PREFERRED_NAME,dv.vd_id,dv.version,dv.begin_date,dv.End_date,
dv.CHANGE_NOTE,dv.LATEST_VERSION_IND,dv.date_created,dv.created_by, dv.date_modified, dv.modified_by
from  SBR.DATA_ELEMENTS de ,SBR.CONTEXTS c,VALUE_DOMAINS_VIEW dv
where de.CONTE_IDSEQ=c.CONTE_IDSEQ
and de.VD_IDSEQ=dv.VD_IDSEQ
and de.ASL_NAME='RELEASED' 
and UPPER(dv.ASL_NAME)  like 'DRAFT%'
and de.cde_id=5143352
order by c.name,de.long_name;
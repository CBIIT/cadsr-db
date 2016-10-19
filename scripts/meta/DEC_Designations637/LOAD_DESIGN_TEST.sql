--clean MDSR_DESIGNATIONS_load_err;
--DESIGNATIONS
delete from MDSR_DESIGNATIONS_load_err;
delete from DESIGNATIONS where DESIG_IDSEQ in(
select d.DESIG_IDSEQ
from DATA_ELEMENT_CONCEPTS c,
MDSR_DES_UPLOAD_VW t,
designations  d,
contexts_view w  
where c.DEC_id=t.PUBLICID
and c.version=t.version
and c.DEC_IDSEQ=d.AC_IDSEQ
and t.name=d.name 
and d.CONTE_IDSEQ =W.conte_idseq
and w.name = t.context
and d.date_created>sysdate-1);
--set MDSR_DESIGNATIONS_UPLOAD before  SP exec SBR.META_INS_DEC_DESIGNATIONS;
update MDSR_DESIGNATIONS_UPLOAD set AC_IDSEQ=null,CONTE_IDSEQ=null;


--Check existed DEC designations before  execution SP SBR.MDSR_INS_DEC_DESIGNATIONS
select distinct d.*
from DATA_ELEMENT_CONCEPTS c,
MDSR_DESIGNATIONS_UPLOAD t,
DESIGNATIONS  d,
contexts_view w  
where c.DEC_id=t.PUBLICID
and c.version=t.version
and c.DEC_IDSEQ=d.AC_IDSEQ
and t.name=d.name 
and d.CONTE_IDSEQ =W.conte_idseq
and w.name = t.context
and  d.date_created>sysdate-1

--Check inserted DEC designations after execution SP SBR.MDSR_INS_DEC_DESIGNATIONS
---create view MDSR_DES_UPLOAD_VW as select distinct *MDSR_DESIGNATIONS_UPLOAD t
select distinct d.* from DESIGNATIONS d
inner join MDSR_DES_UPLOAD_VW t
on d.AC_IDSEQ=t.AC_IDSEQ
and d.conte_IDSEQ=t.conte_IDSEQ
and d.name=t.NAME
and d.date_created>sysdate-1


--check error table 
select*from MDSR_DESIGNATIONS_load_err



/*
select distinct d.* from designations d
inner join temp_designations t
on d.AC_IDSEQ=t.AC_IDSEQ
and d.conte_IDSEQ=t.conte_IDSEQ
and d.name=t.NAME
and d.date_created<sysdate-1

select distinct t.* from temp_designations t
left outer join designations d
on d.AC_IDSEQ=t.AC_IDSEQ
and d.conte_IDSEQ=t.conte_IDSEQ
and d.name=t.NAME
where  DESIG_IDSEQ is null

select distinct d.* from designations d
inner join temp_designations t
on d.AC_IDSEQ=t.AC_IDSEQ
and d.conte_IDSEQ=t.conte_IDSEQ
and d.name=t.NAME*/
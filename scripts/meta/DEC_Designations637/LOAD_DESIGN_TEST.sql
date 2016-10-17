--Check existed DEC designations before  execution SP SBR.MDSR_INS_DEC_DESIGNATIONS

select distinct d.*
from DATA_ELEMENT_CONCEPTS c,
temp_designations t,
designations  d,
contexts_view w  
where c.DEC_id=t.PUBLICID
and c.version=t.version
and c.DEC_IDSEQ=d.AC_IDSEQ
and t.name=d.name 
and d.CONTE_IDSEQ =W.conte_idseq
and w.name = t.context

--Check inserted DEC designations after execution SP SBR.MDSR_INS_DEC_DESIGNATIONS

select distinct d.* from designations d
inner join temp_designations t
on d.AC_IDSEQ=t.AC_IDSEQ
and d.conte_IDSEQ=t.conte_IDSEQ
and d.name=t.NAME
and d.date_created>sysdate-1

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
select  FIN_VM,version,VM_IDSEQ,long_name,PREFERRED_DEFINITION,ASL_NAME,created_By, Modified_By
from (
select max(VM_ID) over (partition by trim(upper(long_name)) ,trim(upper(PREFERRED_DEFINITION))  order by trim(upper(long_name)) ,trim(upper(PREFERRED_DEFINITION)) ) as FIN_VM,
VM_ID,VM_IDSEQ,upper(long_name) long_name,upper(PREFERRED_DEFINITION) PREFERRED_DEFINITION,ASL_NAME,created_By, Modified_By,version
from 
SBR.VALUE_MEANINGS 
where   UPPER(ASL_NAME) not like '%RETIRED%' and CONDR_IDSEQ is null and trim(upper(long_name))||','||trim(upper(PREFERRED_DEFINITION))
in (select distinct a.long_name||','||b.PREFERRED_DEFINITION  from
(select count(*),long_name from 
(
select distinct trim(upper(long_name)) long_name,trim(upper(PREFERRED_DEFINITION)) 
from SBR.VALUE_MEANINGS 
where   UPPER(ASL_NAME) not like '%RETIRED%'and CONDR_IDSEQ is null
--order by trim(upper(long_name)) ,trim(upper(PREFERRED_DEFINITION))
)
group by long_name 
having count(*)>1)a,
(select distinct trim(upper(long_name)) long_name,trim(upper(PREFERRED_DEFINITION))  PREFERRED_DEFINITION
from SBR.VALUE_MEANINGS 
where   UPPER(ASL_NAME) not like '%RETIRED%'and CONDR_IDSEQ is null) b
where a.long_name=b.long_name)
--and upper(long_name)='COMPLETE RESPONSE'

)where FIN_VM=VM_ID 
order by upper(long_name) ,upper(PREFERRED_DEFINITION),FIN_VM desc;
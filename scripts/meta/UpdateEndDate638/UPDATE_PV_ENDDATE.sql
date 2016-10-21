set serveroutput on size 1000000
SPOOL cadsrmeta-638.log
update PERMISSIBLE_VALUES set end_date=to_date('10/06/2016','mm/dd/yyyy') 
where PV_IDSEQ in(
select p.PV_IDSEQ from VD_PVS v,
value_domains d,
PERMISSIBLE_VALUES p
where d.VD_ID=2181490 
and v.VD_IDSEQ = d.VD_IDSEQ
 and v.conte_idseq=d.conte_idseq 
 and p.PV_IDSEQ=v.PV_IDSEQ
 and p.value in ('progression/relapse','Toxicities','Unknown')
 and d.version=1); 
update VD_PVS set end_date=to_date('10/06/2016','mm/dd/yyyy') 
where VP_IDSEQ in(
select v.VP_IDSEQ from VD_PVS v,
value_domains d,
PERMISSIBLE_VALUES p
where d.VD_ID=2181490 
and v.VD_IDSEQ = d.VD_IDSEQ
 and v.conte_idseq=d.conte_idseq 
 and p.PV_IDSEQ=v.PV_IDSEQ
 and p.value in ('progression/relapse','Toxicities','Unknown')
 and d.version=1);
 SPOOL OFF
create or replace view MDSR_CONTEXT_GROUP_749_VW
as
select name,decode(NAME ,'NCIP','1','CTEP',2,'NCI Standards',3,
'NHLBI',3,'NIDCR',3,'CCR',4,'DCP',4,'COG',4,'caCORE',4,5
) GROUP_NUMBER
from sbr.contexts


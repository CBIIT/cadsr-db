set serveroutput on size 1000000
SPOOL cadsrmeta-708.log

CREATE OR REPLACE PROCEDURE SBR.META_FIX_SP_CHAR_PV IS
v_date  date  ;
V_sdate date:=sysdate;
errmsg VARCHAR2(2000):='Non';
/******************************************************************************
   NAME:       SBR.META_FIX_SP_CHAR_PV
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        8/11/2016   trushi2       1. Created this procedure.

   NOTES:
      Object Name:     META_FIX_SP_CHAR_PV
      Sysdate:         8/11/2016
      Date and Time:   8/11/2016, 12:31:43 PM, and 8/11/2016 12:31:43 PM
      Username:        trushi2 (set in TOAD Options, Procedure Editor)

******************************************************************************/
BEGIN


select to_date(to_char(sysdate,'mm/dd/yyyy')||'12:34:56','mm/dd/yyyyhh24:mi:ss')
into v_date from dual;

insert into SBR.CT_PERMISSIBLE_VALUES_BKUP
(
PV_IDSEQ            ,
VALUE               ,
SHORT_MEANING        ,
MEANING_DESCRIPTION  ,
DATE_MODIFIED       ,
DATE_INSERT,
MODIFIED_BY         ,
VM_IDSEQ
)

select PV_IDSEQ            ,
VALUE               ,
SHORT_MEANING        ,
MEANING_DESCRIPTION  ,
DATE_MODIFIED       ,
SYSDATE,
MODIFIED_BY         ,
VM_IDSEQ
from SBR.PERMISSIBLE_VALUES
WHERE SBREXT.meta_FIND_SP_CHAR(short_meaning)>0 or SBREXT.meta_FIND_SP_CHAR(MEANING_DESCRIPTION)>0
or instr(value, UTL_RAW.CAST_TO_VARCHAR2(hextoraw('C2A0')))>0 ;
commit;

UPDATE SBR.PERMISSIBLE_VALUES set
date_modified=v_date, modified_by='DWARZEL',
short_meaning=SBREXT.meta_CleanSP_CHAR(short_meaning)
where SBREXT.meta_FIND_SP_CHAR(short_meaning)>0;
commit;

UPDATE SBR.PERMISSIBLE_VALUES set
date_modified=v_date, modified_by='DWARZEL',
MEANING_DESCRIPTION=SBREXT.meta_CleanSP_CHAR(MEANING_DESCRIPTION)
where SBREXT.meta_FIND_SP_CHAR(MEANING_DESCRIPTION)>0 ;
commit;
update SBR.PERMISSIBLE_VALUES set value=Replace(value, UTL_RAW.CAST_TO_VARCHAR2(hextoraw('C2A0')),'') 
where instr(value, UTL_RAW.CAST_TO_VARCHAR2(hextoraw('C2A0')))>0;
commit;

 EXCEPTION
    WHEN OTHERS THEN
    errmsg := substr(SQLERRM,1,2000);
    insert into SBREXT.META_SPCHAR_ERROR_LOG VALUES('META_FIX_SP_CHAR_PV',   sysdate ,errmsg);

     commit;
END META_FIX_SP_CHAR_PV;
/
exec META_FIX_SP_CHAR_PV;
exec dbms_scheduler.enable('cleanSPCH_PV');
SPOOL OFF
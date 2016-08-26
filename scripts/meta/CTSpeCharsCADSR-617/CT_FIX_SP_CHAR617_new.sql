CREATE OR REPLACE PROCEDURE SBREXT.CT_FIX_PROPERTIES_EXT_old IS
v_date  date  ;
V_sdate date:=sysdate;
errmsg VARCHAR2(2000):='Non';
/******************************************************************************
   NAME:       CT_fix_CD_VMS
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        8/11/2016   trushi2       1. Created this procedure.

   NOTES:
      Object Name:     CT_FIX_CD_VMS
      Sysdate:         8/11/2016
      Date and Time:   8/11/2016, 12:31:43 PM, and 8/11/2016 12:31:43 PM
      Username:        trushi2 (set in TOAD Options, Procedure Editor)

******************************************************************************/
BEGIN


select to_date(to_char(sysdate,'mm/dd/yyyy')||'12:34:56','mm/dd/yyyyhh24:mi:ss')
into v_date from dual;

insert into SBREXT.CT_PROPERTIES_EXT_BKUP
(PROP_IDSEQ              ,
  PREFERRED_NAME        ,
  LONG_NAME            ,
  PREFERRED_DEFINITION  ,
  CONTE_IDSEQ           ,
  VERSION               ,
  ASL_NAME              ,
  CHANGE_NOTE           ,
  DEFINITION_SOURCE     ,
  DATE_INSERT           ,
  DATE_MODIFIED        ,
  MODIFIED_BY          ,
  PROP_ID
)

select
PROP_IDSEQ              ,
  PREFERRED_NAME        ,
  LONG_NAME            ,
  PREFERRED_DEFINITION  ,
  CONTE_IDSEQ           ,
  VERSION               ,
  ASL_NAME              ,
  CHANGE_NOTE           ,
  DEFINITION_SOURCE     ,
  SYSDATE           ,
  DATE_MODIFIED        ,
  MODIFIED_BY          ,
  PROP_ID
from SBREXT.PROPERTIES_EXT
where 
from SBR.REFERENCE_DOCUMENTS

where ((instr(LONG_NAME ,'&'||'#')> 0
or INSTR(LONG_NAME,'&'||'gt;')>0 
or INSTR(LONG_NAME,'&'||'lt;')>0 
or  INSTR(LONG_NAME,'&'||'amp;')>0 )
and  UTL_I18N.UNESCAPE_REFERENCE(replace(replace(replace(replace(LONG_NAME,'&'||'#8804;','<='),'&'||'#8805;','>='),'&'||'#8800;','<>'),'&'||'#8304;','°')) not like'%¿%')
or 
((instr(DOC_TEXT ,'&'||'#')> 0
or INSTR(DOC_TEXT,'&'||'gt;')>0 
or INSTR(DOC_TEXT,'&'||'lt;')>0 
or  INSTR(DOC_TEXT,'&'||'amp;')>0 )
and   UTL_I18N.UNESCAPE_REFERENCE(replace(replace(replace(replace(DOC_TEXT,'&'||'#8804;','<='),'&'||'#8805;','>='),'&'||'#8800;','<>'),'&'||'#8304;','°')) not like'%¿%') ;



UPDATE SBR.REFERENCE_DOCUMENTS set 
date_modified=v_date, modified_by='DWARZEL',
LONG_NAME=UTL_I18N.UNESCAPE_REFERENCE(replace(replace(replace(replace(LONG_NAME,'&'||'#8804;','<='),'&'||'#8805;','>='),'&'||'#8800;','<>'),'&'||'#8304;','°')) 
where ((instr(LONG_NAME ,'&'||'#')> 0
or INSTR(LONG_NAME,'&'||'gt;')>0 
or INSTR(LONG_NAME,'&'||'lt;')>0 
or  INSTR(LONG_NAME,'&'||'amp;')>0 )
and UTL_I18N.UNESCAPE_REFERENCE(replace(replace(replace(replace(LONG_NAME,'&'||'#8804;','<='),'&'||'#8805;','>='),'&'||'#8800;','<>'),'&'||'#8304;','°')) not like'%¿%');

UPDATE SBR.REFERENCE_DOCUMENTS set 
date_modified=v_date, modified_by='DWARZEL',
DOC_TEXT=UTL_I18N.UNESCAPE_REFERENCE(replace(replace(replace(replace(DOC_TEXT,'&'||'#8804;','<='),'&'||'#8805;','>='),'&'||'#8800;','<>'),'&'||'#8304;','°'))
where((instr(DOC_TEXT ,'&'||'#')> 0
or INSTR(DOC_TEXT,'&'||'gt;')>0 
or INSTR(DOC_TEXT,'&'||'lt;')>0 
or  INSTR(DOC_TEXT,'&'||'amp;')>0 )
and UTL_I18N.UNESCAPE_REFERENCE(replace(replace(replace(replace(DOC_TEXT,'&'||'#8804;','<='),'&'||'#8805;','>='),'&'||'#8800;','<>'),'&'||'#8304;','°')) not like'%¿%') ;
 INSTR(LONG_NAME,'&'||'#x73;')>0 or
 INSTR(LONG_NAME,'&'||'#x74;')>0 or
 INSTR(LONG_NAME,'&'||'#x76;')>0 or
 INSTR(LONG_NAME,'&'||'#x3a;')>0 or
 INSTR(LONG_NAME,'&'||'#x28;')>0 or
 INSTR(LONG_NAME,'&'||'#x29;')>0 or
 INSTR(LONG_NAME,'&'||'#8322;')>0 or
 
 INSTR(PREFERRED_DEFINITION,'&'||'#x3a;')>0 or
 INSTR(PREFERRED_DEFINITION,'&'||'#x28;')>0 or
 INSTR(PREFERRED_DEFINITION,'&'||'#x29;')>0 or
 INSTR(PREFERRED_DEFINITION,'&'||'#8322;')>0;
--1  replace '&gt;' by '>'
UPDATE SBREXT.PROPERTIES_EXT set LONG_NAME=replace(LONG_NAME,'&'||'gt;','>') ,
PREFERRED_DEFINITION=replace(PREFERRED_DEFINITION,'&'||'gt;','>'),
date_modified=v_date, modified_by='DWARZEL'
where INSTR(LONG_NAME,'&'||'gt;')>0 or
INSTR(PREFERRED_DEFINITION,'&'||'gt;')>0 ;

UPDATE SBREXT.PROPERTIES_EXT set LONG_NAME=replace(LONG_NAME,'&'||'#62;','>') ,
PREFERRED_DEFINITION=replace(PREFERRED_DEFINITION,'&'||'#62;','>'),
date_modified=v_date, modified_by='DWARZEL'
where INSTR(LONG_NAME,'&'||'#62;')>0 or
INSTR(PREFERRED_DEFINITION,'&'||'#62;')>0 ;
--2  replace '&lt;' by '<'


 commit;

 EXCEPTION

    WHEN OTHERS THEN

    errmsg := substr(SQLERRM,1,2000);
         dbms_output.put_line('errmsg  - '||errmsg);
        insert into SBREXT.CT_FB_SPCHAR_ERROR_LOG VALUES('CT_FIX_PROPERTIES_EXT',   sysdate ,errmsg);

     commit;
END CT_FIX_PROPERTIES_EXT_old;
/

CREATE OR REPLACE PROCEDURE SBR.CT_FIX_REF_DOC IS
v_date  date  ;
V_sdate date:=sysdate;
errmsg VARCHAR2(2000):='Non';
/******************************************************************************
   NAME:       CT_FIX_REF_DOC
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        8/11/2016   trushi2       1. Created this procedure.

   NOTES:
      Object Name:     CT_FIX_REF_DOC
      Sysdate:         8/11/2016
      Date and Time:   8/11/2016, 12:31:43 PM, and 8/11/2016 12:31:43 PM
      Username:        trushi2 (set in TOAD Options, Procedure Editor)

******************************************************************************/
BEGIN


insert into SBR.CT_REF_DOC_BKUP
(
RD_IDSEQ,
ORG_IDSEQ    ,
AC_IDSEQ   ,
ACH_IDSEQ   ,
AR_IDSEQ      ,
NAME         ,
DOC_TEXT ,
DATE_MODIFIED       ,
DATE_INSERT,
MODIFIED_BY,
COMMENTS
)

select
r.RD_IDSEQ,
r.ORG_IDSEQ    ,
r.AC_IDSEQ   ,
r.ACH_IDSEQ   ,
r.AR_IDSEQ      ,
r.NAME         ,
r.DOC_TEXT ,
r.DATE_MODIFIED       ,
SYSDATE,
R.MODIFIED_BY,
'Mark for delition'
from SBR.REFERENCE_DOCUMENTS r,
SBR.REFERENCE_DOCUMENTS g
where 
r.DCTL_NAME=g.DCTL_NAME
and r.AC_IDSEQ=g.AC_IDSEQ
and  UTL_I18N.UNESCAPE_REFERENCE(replace(replace(replace(replace(r.name,'&'||'#8804;','<='),'&'||'#8805;','>='),'&'||'#8800;','<>'),'&'||'#8304;','°'))=g.name--replace(replace(replace(g.name,'&'||'#8804','<='),'&'||'#8805','>='),'&'||'#8800','>=')
and r.RD_IDSEQ<>g.RD_IDSEQ
and (instr(r.NAME ,'&'||'#')> 0
or INSTR(r.NAME,'&'||'gt;')>0 
or INSTR(r.NAME,'&'||'lt;')>0 
or  INSTR(r.NAME,'&'||'amp;')>0 )
and  UTL_I18N.UNESCAPE_REFERENCE(replace(replace(replace(replace(r.name,'&'||'#8804;','<='),'&'||'#8805;','>='),'&'||'#8800;','<>'),'&'||'#8304;','°')) not like'%¿%'
and g.NAME not like '%&#%';

commit;
delete from  SBR.REFERENCE_DOCUMENTS where RD_IDSEQ in(select distinct RD_IDSEQ from SBR.CT_REF_DOC_BKUP where comments='Mark for delition');
commit;



select to_date(to_char(sysdate,'mm/dd/yyyy')||'12:34:56','mm/dd/yyyyhh24:mi:ss')
into v_date from dual;



insert into SBR.CT_REF_DOC_BKUP
(
RD_IDSEQ,
ORG_IDSEQ    ,
AC_IDSEQ   ,
ACH_IDSEQ   ,
AR_IDSEQ      ,
NAME         ,
DOC_TEXT ,
DATE_MODIFIED       ,
DATE_INSERT,
MODIFIED_BY
)

select
RD_IDSEQ,
ORG_IDSEQ    ,
AC_IDSEQ   ,
ACH_IDSEQ   ,
AR_IDSEQ      ,
NAME         ,
DOC_TEXT ,
DATE_MODIFIED       ,
SYSDATE,
MODIFIED_BY
from SBR.REFERENCE_DOCUMENTS

where ((instr(NAME ,'&'||'#')> 0
or INSTR(NAME,'&'||'gt;')>0 
or INSTR(NAME,'&'||'lt;')>0 
or  INSTR(NAME,'&'||'amp;')>0 )
and  UTL_I18N.UNESCAPE_REFERENCE(replace(replace(replace(replace(name,'&'||'#8804;','<='),'&'||'#8805;','>='),'&'||'#8800;','<>'),'&'||'#8304;','°')) not like'%¿%')
or 
((instr(DOC_TEXT ,'&'||'#')> 0
or INSTR(DOC_TEXT,'&'||'gt;')>0 
or INSTR(DOC_TEXT,'&'||'lt;')>0 
or  INSTR(DOC_TEXT,'&'||'amp;')>0 )
and   UTL_I18N.UNESCAPE_REFERENCE(replace(replace(replace(replace(DOC_TEXT,'&'||'#8804;','<='),'&'||'#8805;','>='),'&'||'#8800;','<>'),'&'||'#8304;','°')) not like'%¿%') ;



UPDATE SBR.REFERENCE_DOCUMENTS set 
date_modified=v_date, modified_by='DWARZEL',
NAME=UTL_I18N.UNESCAPE_REFERENCE(replace(replace(replace(replace(name,'&'||'#8804;','<='),'&'||'#8805;','>='),'&'||'#8800;','<>'),'&'||'#8304;','°')) 
where ((instr(NAME ,'&'||'#')> 0
or INSTR(NAME,'&'||'gt;')>0 
or INSTR(NAME,'&'||'lt;')>0 
or  INSTR(NAME,'&'||'amp;')>0 )
and UTL_I18N.UNESCAPE_REFERENCE(replace(replace(replace(replace(name,'&'||'#8804;','<='),'&'||'#8805;','>='),'&'||'#8800;','<>'),'&'||'#8304;','°')) not like'%¿%');

UPDATE SBR.REFERENCE_DOCUMENTS set 
date_modified=v_date, modified_by='DWARZEL',
DOC_TEXT=UTL_I18N.UNESCAPE_REFERENCE(replace(replace(replace(replace(DOC_TEXT,'&'||'#8804;','<='),'&'||'#8805;','>='),'&'||'#8800;','<>'),'&'||'#8304;','°'))
where((instr(DOC_TEXT ,'&'||'#')> 0
or INSTR(DOC_TEXT,'&'||'gt;')>0 
or INSTR(DOC_TEXT,'&'||'lt;')>0 
or  INSTR(DOC_TEXT,'&'||'amp;')>0 )
and UTL_I18N.UNESCAPE_REFERENCE(replace(replace(replace(replace(DOC_TEXT,'&'||'#8804;','<='),'&'||'#8805;','>='),'&'||'#8800;','<>'),'&'||'#8304;','°')) not like'%¿%') ;



 commit;

 EXCEPTION

    WHEN OTHERS THEN

    errmsg := substr(SQLERRM,1,2000);
         dbms_output.put_line('errmsg  - '||errmsg);
        insert into SBREXT.CT_FB_SPCHAR_ERROR_LOG VALUES('CT_FIX_REF_DOC',   sysdate ,errmsg);

     commit;
END CT_FIX_REF_DOC;
/
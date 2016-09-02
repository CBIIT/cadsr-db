
CREATE OR REPLACE PROCEDURE SBR.CT_FIX_CD_VMS11G IS
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
      Object Name:     CT_FIX_SP_CHAR_PV
      Sysdate:         8/11/2016
      Date and Time:   8/11/2016, 12:31:43 PM, and 8/11/2016 12:31:43 PM
      Username:        trushi2 (set in TOAD Options, Procedure Editor)
     
******************************************************************************/
BEGIN   


select to_date(to_char(sysdate,'mm/dd/yyyy')||'12:34:56','mm/dd/yyyyhh24:mi:ss')
into v_date from dual;

insert into SBR.CT_CD_VMS_BKUP
(CV_IDSEQ,
CD_IDSEQ            ,
SHORT_MEANING        ,
DESCRIPTION  ,
DATE_MODIFIED       ,
DATE_INSERT,
MODIFIED_BY         ,
VM_IDSEQ             
)

select CV_IDSEQ,
CD_IDSEQ            ,
SHORT_MEANING        ,
DESCRIPTION  ,
DATE_MODIFIED       ,
SYSDATE,
MODIFIED_BY         ,
VM_IDSEQ   
from SBR.CD_VMS 
where ((((instr(short_meaning ,'&'||'#')> 0  and instr(short_meaning ,';')> 0)
or INSTR(short_meaning,'&'||'gt;')>0 
or INSTR(short_meaning,'&'||'lt;')>0 
or  INSTR(short_meaning,'&'||'amp;')>0)
and  UTL_I18N.UNESCAPE_REFERENCE(short_meaning) not like'%¿%')
or
(((instr(DESCRIPTION ,'&'||'#')> 0  and instr(DESCRIPTION ,';')> 0)
or INSTR(DESCRIPTION,'&'||'gt;')>0 
or INSTR(DESCRIPTION,'&'||'lt;')>0 
or  INSTR(DESCRIPTION,'&'||'amp;')>0)
and  UTL_I18N.UNESCAPE_REFERENCE(DESCRIPTION) not like'%¿%'));




UPDATE SBR.CD_VMS set 
date_modified=v_date, modified_by='DWARZEL',
short_meaning=UTL_I18N.UNESCAPE_REFERENCE(short_meaning) 
where ((instr(short_meaning ,'&'||'#')> 0  and instr(short_meaning ,';')> 0)
or INSTR(short_meaning,'&'||'gt;')>0 
or INSTR(short_meaning,'&'||'lt;')>0 
or  INSTR(short_meaning,'&'||'amp;')>0 )
and UTL_I18N.UNESCAPE_REFERENCE(short_meaning) not like'%¿%';


UPDATE SBR.CD_VMS set 
date_modified=v_date, modified_by='DWARZEL',
DESCRIPTION=UTL_I18N.UNESCAPE_REFERENCE(DESCRIPTION)
where((instr(DESCRIPTION ,'&'||'#')> 0 and instr(DESCRIPTION ,';')> 0)
or INSTR(DESCRIPTION,'&'||'gt;')>0 
or INSTR(DESCRIPTION,'&'||'lt;')>0 
or  INSTR(DESCRIPTION,'&'||'amp;')>0 )
and UTL_I18N.UNESCAPE_REFERENCE(DESCRIPTION) not like'%¿%'  ;

                                                                        
 commit;

 EXCEPTION
 
    WHEN OTHERS THEN   
    
    errmsg := substr(SQLERRM,1,2000);
         dbms_output.put_line('errmsg  - '||errmsg);
        insert into SBREXT.META_SPCHAR_ERROR_LOG VALUES('CT_FIX_CD_VMS',   sysdate ,errmsg);
        
     commit; 
END CT_FIX_CD_VMS11G;
/
CREATE OR REPLACE PROCEDURE SBR.CT_FIX_REF_DOC11G IS
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
'Duplicate'
from SBR.REFERENCE_DOCUMENTS r,
SBR.REFERENCE_DOCUMENTS g
where 
r.DCTL_NAME=g.DCTL_NAME
and r.AC_IDSEQ=g.AC_IDSEQ
and  UTL_I18N.UNESCAPE_REFERENCE(r.name)=g.name--replace(replace(replace(g.name,'&'||'#8804','<='),'&'||'#8805','>='),'&'||'#8800','>=')
and r.RD_IDSEQ<>g.RD_IDSEQ
and ((instr(r.NAME ,'&'||'#')> 0 and instr(r.NAME ,';')> 0)
or INSTR(r.NAME,'&'||'gt;')>0 
or INSTR(r.NAME,'&'||'lt;')>0 
or  INSTR(r.NAME,'&'||'amp;')>0 )
and  UTL_I18N.UNESCAPE_REFERENCE(r.name) not like'%¿%'
and g.NAME not like '%&#%'
and r.RD_IDSEQ not in (select distinct RD_IDSEQ from SBR.CT_REF_DOC_BKUP where comments='Duplicate') ;

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

where ((((instr(NAME ,'&'||'#')> 0  and instr(NAME ,';')> 0)
or INSTR(NAME,'&'||'gt;')>0 
or INSTR(NAME,'&'||'lt;')>0 
or  INSTR(NAME,'&'||'amp;')>0)
and  UTL_I18N.UNESCAPE_REFERENCE(name) not like'%¿%')
or
(((instr(DOC_TEXT ,'&'||'#')> 0  and instr(NAME ,';')> 0)
or INSTR(DOC_TEXT,'&'||'gt;')>0 
or INSTR(DOC_TEXT,'&'||'lt;')>0 
or  INSTR(NAME,'&'||'amp;')>0)
and  UTL_I18N.UNESCAPE_REFERENCE(DOC_TEXT) not like'%¿%'))
and RD_IDSEQ not in (select distinct RD_IDSEQ from SBR.CT_REF_DOC_BKUP where comments='Duplicate') ;


UPDATE SBR.REFERENCE_DOCUMENTS set 
date_modified=v_date, modified_by='DWARZEL',
NAME=UTL_I18N.UNESCAPE_REFERENCE(name) 
where ((instr(NAME ,'&'||'#')> 0  and instr(NAME ,';')> 0)
or INSTR(NAME,'&'||'gt;')>0 
or INSTR(NAME,'&'||'lt;')>0 
or  INSTR(NAME,'&'||'amp;')>0 )
and UTL_I18N.UNESCAPE_REFERENCE(name) not like'%¿%'
and RD_IDSEQ not in (select distinct RD_IDSEQ from SBR.CT_REF_DOC_BKUP where comments='Duplicate') ;


UPDATE SBR.REFERENCE_DOCUMENTS set 
date_modified=v_date, modified_by='DWARZEL',
DOC_TEXT=UTL_I18N.UNESCAPE_REFERENCE(DOC_TEXT)
where((instr(DOC_TEXT ,'&'||'#')> 0 and instr(DOC_TEXT ,';')> 0)
or INSTR(DOC_TEXT,'&'||'gt;')>0 
or INSTR(DOC_TEXT,'&'||'lt;')>0 
or  INSTR(DOC_TEXT,'&'||'amp;')>0 )
and UTL_I18N.UNESCAPE_REFERENCE(DOC_TEXT) not like'%¿%' 
and RD_IDSEQ not in (select distinct RD_IDSEQ from SBR.CT_REF_DOC_BKUP where comments='Duplicate') ;

 commit;

 EXCEPTION

    WHEN OTHERS THEN

    errmsg := substr(SQLERRM,1,2000);
         dbms_output.put_line('errmsg  - '||errmsg);
        insert into SBREXT.META_SPCHAR_ERROR_LOG VALUES('CT_FIX_REF_DOC',   sysdate ,errmsg);

     commit;
END CT_FIX_REF_DOC11G;


CREATE OR REPLACE PROCEDURE SBR.CT_FIX_SP_CHAR_PV11G IS
v_date  date  ;
V_sdate date:=sysdate;
errmsg VARCHAR2(2000):='Non';
/******************************************************************************
   NAME:       CT_fix_sp_char_VM
   PURPOSE:    

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        8/11/2016   trushi2       1. Created this procedure.

   NOTES:
      Object Name:     CT_FIX_SP_CHAR_PV
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
where ((((instr(short_meaning ,'&'||'#')> 0  and instr(short_meaning ,';')> 0)
or INSTR(short_meaning,'&'||'gt;')>0 
or INSTR(short_meaning,'&'||'lt;')>0 
or  INSTR(short_meaning,'&'||'amp;')>0)
and  UTL_I18N.UNESCAPE_REFERENCE(short_meaning) not like'%¿%')
or
(((instr(MEANING_DESCRIPTION ,'&'||'#')> 0  and instr(MEANING_DESCRIPTION ,';')> 0)
or INSTR(MEANING_DESCRIPTION,'&'||'gt;')>0 
or INSTR(MEANING_DESCRIPTION,'&'||'lt;')>0 
or  INSTR(MEANING_DESCRIPTION,'&'||'amp;')>0)
and  UTL_I18N.UNESCAPE_REFERENCE(MEANING_DESCRIPTION) not like'%¿%'));


UPDATE SBR.PERMISSIBLE_VALUES set 
date_modified=v_date, modified_by='DWARZEL',
short_meaning=UTL_I18N.UNESCAPE_REFERENCE(short_meaning) 
where ((instr(short_meaning ,'&'||'#')> 0  and instr(short_meaning ,';')> 0)
or INSTR(short_meaning,'&'||'gt;')>0 
or INSTR(short_meaning,'&'||'lt;')>0 
or  INSTR(short_meaning,'&'||'amp;')>0 )
and UTL_I18N.UNESCAPE_REFERENCE(short_meaning) not like'%¿%';


UPDATE SBR.PERMISSIBLE_VALUES set 
date_modified=v_date, modified_by='DWARZEL',
MEANING_DESCRIPTION=UTL_I18N.UNESCAPE_REFERENCE(MEANING_DESCRIPTION)
where((instr(MEANING_DESCRIPTION ,'&'||'#')> 0 and instr(MEANING_DESCRIPTION ,';')> 0)
or INSTR(MEANING_DESCRIPTION,'&'||'gt;')>0 
or INSTR(MEANING_DESCRIPTION,'&'||'lt;')>0 
or  INSTR(MEANING_DESCRIPTION,'&'||'amp;')>0 )
and UTL_I18N.UNESCAPE_REFERENCE(MEANING_DESCRIPTION) not like'%¿%'  ;
 commit;

 EXCEPTION
 
    WHEN OTHERS THEN   
    
    errmsg := substr(SQLERRM,1,2000);
         dbms_output.put_line('errmsg  - '||errmsg);
        insert into SBREXT.META_SPCHAR_ERROR_LOG VALUES('CT_FIX_SP_CHAR_PV',   sysdate ,errmsg);
        
     commit; 
END CT_FIX_SP_CHAR_PV11G;
/
CREATE OR REPLACE PROCEDURE SBR.CT_FIX_SP_CHAR_VM11G IS
tmpVar NUMBER;
V_date date:=sysdate;
errmsg VARCHAR2(2000):='Non';
/******************************************************************************
   NAME:       CT_fix_sp_char_VM
   PURPOSE:    

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        8/11/2016   trushi2       1. Created this procedure.

   NOTES:
      Object Name:     CT_fix_sp_char_VM
      Sysdate:         8/11/2016
      Date and Time:   8/11/2016, 12:31:43 PM, and 8/11/2016 12:31:43 PM
      Username:        trushi2 (set in TOAD Options, Procedure Editor)
     
******************************************************************************/
BEGIN   

select to_date(to_char(sysdate,'mm/dd/yyyy')||'12:34:56','mm/dd/yyyyhh24:mi:ss')
into v_date from dual;

insert into  SBR.CT_VALUE_MEANINGS_BKUP
(
  SHORT_MEANING        ,
  DESCRIPTION         ,
  DATE_MODIFIED        ,
  DATE_INSERT,
  MODIFIED_BY          ,  
  VM_IDSEQ              ,
  PREFERRED_NAME        ,
  PREFERRED_DEFINITION  ,
  LONG_NAME             ,
  VERSION              ,
  VM_ID                 ,
  CHANGE_NOTE           
)
select SHORT_MEANING        ,
  DESCRIPTION         ,
  DATE_MODIFIED        ,
  SYSDATE        ,
  MODIFIED_BY          ,  
  VM_IDSEQ              ,
  PREFERRED_NAME        ,
  PREFERRED_DEFINITION  ,
  LONG_NAME             ,
  VERSION              ,
  VM_ID                , 
  CHANGE_NOTE             
from SBR.VALUE_MEANINGS
where ((((instr(short_meaning ,'&'||'#')> 0  and instr(short_meaning ,';')> 0)
or INSTR(short_meaning,'&'||'gt;')>0 
or INSTR(short_meaning,'&'||'lt;')>0 
or  INSTR(short_meaning,'&'||'amp;')>0)
and  UTL_I18N.UNESCAPE_REFERENCE(short_meaning) not like'%¿%')
or
(((instr(DESCRIPTION ,'&'||'#')> 0  and instr(DESCRIPTION ,';')> 0)
or INSTR(DESCRIPTION,'&'||'gt;')>0 
or INSTR(DESCRIPTION,'&'||'lt;')>0 
or  INSTR(DESCRIPTION,'&'||'amp;')>0)
and  UTL_I18N.UNESCAPE_REFERENCE(DESCRIPTION) not like'%¿%'))
or((((instr(LONG_NAME ,'&'||'#')> 0  and instr(LONG_NAME ,';')> 0)
or INSTR(LONG_NAME,'&'||'gt;')>0 
or INSTR(LONG_NAME,'&'||'lt;')>0 
or  INSTR(LONG_NAME,'&'||'amp;')>0)
and  UTL_I18N.UNESCAPE_REFERENCE(LONG_NAME) not like'%¿%')
or
(((instr(preferred_definition ,'&'||'#')> 0  and instr(preferred_definition ,';')> 0)
or INSTR(preferred_definition,'&'||'gt;')>0 
or INSTR(preferred_definition,'&'||'lt;')>0 
or  INSTR(preferred_definition,'&'||'amp;')>0)
and  UTL_I18N.UNESCAPE_REFERENCE(preferred_definition) not like'%¿%'));




UPDATE SBR.VALUE_MEANINGS set 
date_modified=v_date, modified_by='DWARZEL',
short_meaning=UTL_I18N.UNESCAPE_REFERENCE(short_meaning) 
where ((instr(short_meaning ,'&'||'#')> 0  and instr(short_meaning ,';')> 0)
or INSTR(short_meaning,'&'||'gt;')>0 
or INSTR(short_meaning,'&'||'lt;')>0 
or  INSTR(short_meaning,'&'||'amp;')>0 )
and UTL_I18N.UNESCAPE_REFERENCE(short_meaning) not like'%¿%';


UPDATE SBR.VALUE_MEANINGS set 
date_modified=v_date, modified_by='DWARZEL',
DESCRIPTION=UTL_I18N.UNESCAPE_REFERENCE(DESCRIPTION)
where((instr(DESCRIPTION ,'&'||'#')> 0 and instr(DESCRIPTION ,';')> 0)
or INSTR(DESCRIPTION,'&'||'gt;')>0 
or INSTR(DESCRIPTION,'&'||'lt;')>0 
or  INSTR(DESCRIPTION,'&'||'amp;')>0 )
and UTL_I18N.UNESCAPE_REFERENCE(DESCRIPTION) not like'%¿%'  ;
 

UPDATE SBR.VALUE_MEANINGS set 
date_modified=v_date, modified_by='DWARZEL',
LONG_NAME=UTL_I18N.UNESCAPE_REFERENCE(LONG_NAME) 
where ((instr(LONG_NAME ,'&'||'#')> 0  and instr(LONG_NAME ,';')> 0)
or INSTR(LONG_NAME,'&'||'gt;')>0 
or INSTR(LONG_NAME,'&'||'lt;')>0 
or  INSTR(LONG_NAME,'&'||'amp;')>0 )
and UTL_I18N.UNESCAPE_REFERENCE(LONG_NAME) not like'%¿%';


UPDATE SBR.VALUE_MEANINGS set 
date_modified=v_date, modified_by='DWARZEL',
preferred_definition=UTL_I18N.UNESCAPE_REFERENCE(preferred_definition)
where((instr(preferred_definition ,'&'||'#')> 0 and instr(preferred_definition ,';')> 0)
or INSTR(preferred_definition,'&'||'gt;')>0 
or INSTR(preferred_definition,'&'||'lt;')>0 
or  INSTR(preferred_definition,'&'||'amp;')>0 )
and UTL_I18N.UNESCAPE_REFERENCE(preferred_definition) not like'%¿%'  ;

commit;
  EXCEPTION                      
   WHEN OTHERS THEN   
    rollback;
    errmsg := substr(SQLERRM,1,2000);
         dbms_output.put_line('errmsg  - '||errmsg);
        insert into SBREXT.META_SPCHAR_ERROR_LOG VALUES('CT_FIX_SP_CHAR_VM',   sysdate ,errmsg);
        
     commit; 
END CT_FIX_SP_CHAR_VM11G;
/

CREATE OR REPLACE PROCEDURE SBR.CT_FIX_VALUE_DOMAINS11G IS
v_date  date  ;
V_sdate date:=sysdate;
errmsg VARCHAR2(2000):='Non';
/******************************************************************************
   NAME:       CT_FIX_QUEST_CONTENTS_EXT
   PURPOSE:    

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        8/11/2016   trushi2       1. Created this procedure.

   NOTES:
      Object Name:     CT_fix_sp_char_VM
      Sysdate:         8/11/2016
      Date and Time:   8/11/2016, 12:31:43 PM, and 8/11/2016 12:31:43 PM
      Username:        trushi2 (set in TOAD Options, Procedure Editor)
     
******************************************************************************/
BEGIN   


select to_date(to_char(sysdate,'mm/dd/yyyy')||'12:34:56','mm/dd/yyyyhh24:mi:ss')
into v_date from dual;

insert into  SBR.CT_VALUE_DOMAINS_BKUP
(
            VD_IDSEQ   , 
            VD_ID , 
            VERSION ,                 
           PREFERRED_NAME,
           PREFERRED_DEFINITION,
           LONG_NAME,         
           DATE_MODIFIED, 
           DATE_INSERT,           
           MODIFIED_BY          
)

select     VD_IDSEQ   ,
           VD_ID ,
           VERSION ,                   
           PREFERRED_NAME,
           PREFERRED_DEFINITION,
           LONG_NAME,         
           DATE_MODIFIED, 
           SYSDATE    ,       
           MODIFIED_BY
from SBR.VALUE_DOMAINS
where ((((instr(LONG_NAME ,'&'||'#')> 0  and instr(LONG_NAME ,';')> 0)
or INSTR(LONG_NAME,'&'||'gt;')>0 
or INSTR(LONG_NAME,'&'||'lt;')>0 
or  INSTR(LONG_NAME,'&'||'amp;')>0)
and  UTL_I18N.UNESCAPE_REFERENCE(LONG_NAME) not like'%¿%')
or
(((instr(preferred_definition ,'&'||'#')> 0  and instr(preferred_definition ,';')> 0)
or INSTR(preferred_definition,'&'||'gt;')>0 
or INSTR(preferred_definition,'&'||'lt;')>0 
or  INSTR(preferred_definition,'&'||'amp;')>0)
and  UTL_I18N.UNESCAPE_REFERENCE(preferred_definition) not like'%¿%'));


 UPDATE SBR.VALUE_DOMAINS set 
date_modified=v_date, modified_by='DWARZEL',
LONG_NAME=UTL_I18N.UNESCAPE_REFERENCE(LONG_NAME) 
where ((instr(LONG_NAME ,'&'||'#')> 0  and instr(LONG_NAME ,';')> 0)
or INSTR(LONG_NAME,'&'||'gt;')>0 
or INSTR(LONG_NAME,'&'||'lt;')>0 
or  INSTR(LONG_NAME,'&'||'amp;')>0 )
and UTL_I18N.UNESCAPE_REFERENCE(LONG_NAME) not like'%¿%';


UPDATE SBR.VALUE_DOMAINS set 
date_modified=v_date, modified_by='DWARZEL',
preferred_definition=UTL_I18N.UNESCAPE_REFERENCE(preferred_definition)
where((instr(preferred_definition ,'&'||'#')> 0 and instr(preferred_definition ,';')> 0)
or INSTR(preferred_definition,'&'||'gt;')>0 
or INSTR(preferred_definition,'&'||'lt;')>0 
or  INSTR(preferred_definition,'&'||'amp;')>0 )
and UTL_I18N.UNESCAPE_REFERENCE(preferred_definition) not like'%¿%'  ;
                                                                             
 commit;  
    EXCEPTION
 
    WHEN OTHERS THEN   
       errmsg := substr(SQLERRM,1,2000);
         dbms_output.put_line('errmsg  - '||errmsg);
        insert into SBREXT.META_SPCHAR_ERROR_LOG VALUES('CT_FIX_VALUE_DOMAINS',   sysdate ,errmsg);
        
     commit; 
END CT_FIX_VALUE_DOMAINS11G;
/
/*******************SBREXT******************/
CREATE OR REPLACE PROCEDURE SBREXT.CT_FIX_QUEST_CONTENTS_EXT11G IS
v_date  date  ;
V_sdate date:=sysdate;
errmsg VARCHAR2(2000):='Non';
/******************************************************************************
   NAME:       CT_FIX_QUEST_CONTENTS_EXT
   PURPOSE:    

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        8/11/2016   trushi2       1. Created this procedure.

   NOTES:
      Object Name:     CT_fix_sp_char_VM
      Sysdate:         8/11/2016
      Date and Time:   8/11/2016, 12:31:43 PM, and 8/11/2016 12:31:43 PM
      Username:        trushi2 (set in TOAD Options, Procedure Editor)
     
******************************************************************************/
BEGIN   

update SBREXT.QUEST_CONTENTS_EXT SET LONG_NAME =SUBSTR (LONG_NAME, 1, 250)||'...'
where LENGTH (LONG_NAME) > 255
and (
INSTR(LONG_NAME,'&'||'gt;')>0 or
INSTR(LONG_NAME,'&'||'lt;')>0 or
INSTR(LONG_NAME,'&'||'amp;')>0 or
INSTR(LONG_NAME,'&'||'#')>0);

commit;
select to_date(to_char(sysdate,'mm/dd/yyyy')||'12:34:56','mm/dd/yyyyhh24:mi:ss')
into v_date from dual;

insert into  SBREXT.CT_QUEST_CONTENTS_EXT_BKUP
(
           QC_IDSEQ,                   
           PREFERRED_NAME,
           PREFERRED_DEFINITION,
           LONG_NAME,         
           DATE_MODIFIED, 
           DATE_INSERT,           
           MODIFIED_BY          
)

select     QC_IDSEQ,                   
           PREFERRED_NAME,
           PREFERRED_DEFINITION,
           LONG_NAME,         
           DATE_MODIFIED, 
           SYSDATE	,	   
           MODIFIED_BY
from SBREXT.QUEST_CONTENTS_EXT
where ((((instr(LONG_NAME ,'&'||'#')> 0  and instr(LONG_NAME ,';')> 0)
or INSTR(LONG_NAME,'&'||'gt;')>0 
or INSTR(LONG_NAME,'&'||'lt;')>0 
or  INSTR(LONG_NAME,'&'||'amp;')>0)
and  UTL_I18N.UNESCAPE_REFERENCE(LONG_NAME) not like'%¿%')
or
(((instr(PREFERRED_DEFINITION ,'&'||'#')> 0  and instr(PREFERRED_DEFINITION ,';')> 0)
or INSTR(PREFERRED_DEFINITION,'&'||'gt;')>0 
or INSTR(PREFERRED_DEFINITION,'&'||'lt;')>0 
or  INSTR(PREFERRED_DEFINITION,'&'||'amp;')>0)
and  UTL_I18N.UNESCAPE_REFERENCE(PREFERRED_DEFINITION) not like'%¿%'));

UPDATE SBREXT.QUEST_CONTENTS_EXT set 
date_modified=v_date, modified_by='DWARZEL',
LONG_NAME=UTL_I18N.UNESCAPE_REFERENCE(LONG_NAME) 
where ((instr(LONG_NAME ,'&'||'#')> 0  and instr(LONG_NAME ,';')> 0)
or INSTR(LONG_NAME,'&'||'gt;')>0 
or INSTR(LONG_NAME,'&'||'lt;')>0 
or  INSTR(LONG_NAME,'&'||'amp;')>0 )
and UTL_I18N.UNESCAPE_REFERENCE(LONG_NAME) not like'%¿%';


UPDATE SBREXT.QUEST_CONTENTS_EXT set 
date_modified=v_date, modified_by='DWARZEL',
PREFERRED_DEFINITION=UTL_I18N.UNESCAPE_REFERENCE(PREFERRED_DEFINITION)
where((instr(PREFERRED_DEFINITION ,'&'||'#')> 0 and instr(PREFERRED_DEFINITION ,';')> 0)
or INSTR(PREFERRED_DEFINITION,'&'||'gt;')>0 
or INSTR(PREFERRED_DEFINITION,'&'||'lt;')>0 
or  INSTR(PREFERRED_DEFINITION,'&'||'amp;')>0 )
and UTL_I18N.UNESCAPE_REFERENCE(PREFERRED_DEFINITION) not like'%¿%'  ;
                                                                             
 commit;  
    EXCEPTION
 
    WHEN OTHERS THEN   
       errmsg := substr(SQLERRM,1,2000);
         dbms_output.put_line('errmsg  - '||errmsg);
        insert into SBREXT.META_SPCHAR_ERROR_LOG VALUES('CT_FIX_QUEST_CONTENTS_EXT',   sysdate ,errmsg);
        
     commit; 
END CT_FIX_QUEST_CONTENTS_EXT11G;
/
CREATE OR REPLACE PROCEDURE SBREXT.CT_FIX_PROPERTIES_EXT11G IS
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
where ((((instr(LONG_NAME ,'&'||'#')> 0  and instr(LONG_NAME ,';')> 0)
or INSTR(LONG_NAME,'&'||'gt;')>0 
or INSTR(LONG_NAME,'&'||'lt;')>0 
or  INSTR(LONG_NAME,'&'||'amp;')>0)
and  UTL_I18N.UNESCAPE_REFERENCE(LONG_NAME) not like'%¿%')
or
(((instr(PREFERRED_DEFINITION ,'&'||'#')> 0  and instr(PREFERRED_DEFINITION ,';')> 0)
or INSTR(PREFERRED_DEFINITION,'&'||'gt;')>0 
or INSTR(PREFERRED_DEFINITION,'&'||'lt;')>0 
or  INSTR(PREFERRED_DEFINITION,'&'||'amp;')>0)
and  UTL_I18N.UNESCAPE_REFERENCE(PREFERRED_DEFINITION) not like'%¿%'));


UPDATE SBREXT.PROPERTIES_EXT  set 
date_modified=v_date, modified_by='DWARZEL',
LONG_NAME=UTL_I18N.UNESCAPE_REFERENCE(LONG_NAME) 
where ((instr(LONG_NAME ,'&'||'#')> 0  and instr(LONG_NAME ,';')> 0)
or INSTR(LONG_NAME,'&'||'gt;')>0 
or INSTR(LONG_NAME,'&'||'lt;')>0 
or  INSTR(LONG_NAME,'&'||'amp;')>0 )
and UTL_I18N.UNESCAPE_REFERENCE(LONG_NAME) not like'%¿%';


UPDATE SBREXT.PROPERTIES_EXT  set 
date_modified=v_date, modified_by='DWARZEL',
PREFERRED_DEFINITION=UTL_I18N.UNESCAPE_REFERENCE(PREFERRED_DEFINITION)
where((instr(PREFERRED_DEFINITION ,'&'||'#')> 0 and instr(PREFERRED_DEFINITION ,';')> 0)
or INSTR(PREFERRED_DEFINITION,'&'||'gt;')>0 
or INSTR(PREFERRED_DEFINITION,'&'||'lt;')>0 
or  INSTR(PREFERRED_DEFINITION,'&'||'amp;')>0 )
and UTL_I18N.UNESCAPE_REFERENCE(PREFERRED_DEFINITION) not like'%¿%'  ;                                                                            
 commit;

 EXCEPTION
 
    WHEN OTHERS THEN   
    
    errmsg := substr(SQLERRM,1,2000);
         dbms_output.put_line('errmsg  - '||errmsg);
        insert into SBREXT.META_SPCHAR_ERROR_LOG VALUES('CT_FIX_PROPERTIES_EXT',   sysdate ,errmsg);
        
     commit; 
END CT_FIX_PROPERTIES_EXT11G;
/
CREATE OR REPLACE PROCEDURE SBREXT.CT_FIX_SPCHAR_VV_ATT_EXT11G IS
v_date  date  ;
V_sdate date:=sysdate;
errmsg VARCHAR2(2000):='Non';
/******************************************************************************
   NAME:       CT_FIX_SPCHAR_VV_ATT_EXT
   PURPOSE:    

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        8/11/2016   trushi2       1. Created this procedure.

   NOTES:
      Object Name:     CT_FIX_SPCHAR_VV_ATT_EXT
      Sysdate:         8/11/2016
      Date and Time:   8/11/2016, 12:31:43 PM, and 8/11/2016 12:31:43 PM
      Username:        trushi2 (set in TOAD Options, Procedure Editor)
     
******************************************************************************/
BEGIN   


select to_date(to_char(sysdate,'mm/dd/yyyy')||'12:34:56','mm/dd/yyyyhh24:mi:ss')
into v_date from dual;

insert into  SBREXT.CT_VALID_VALUES_ATT_EXT_BKUP
(
  QC_IDSEQ          ,
  MEANING_TEXT      ,  
  DATE_MODIFIED     ,
  DATE_INSERT,
  MODIFIED_BY       ,
  DESCRIPTION_TEXT           
)

select QC_IDSEQ          ,
  MEANING_TEXT      ,  
  DATE_MODIFIED     ,
  SYSDATE,
  MODIFIED_BY       ,
  DESCRIPTION_TEXT
from SBREXT.VALID_VALUES_ATT_EXT 
where ((((instr(MEANING_TEXT ,'&'||'#')> 0  and instr(MEANING_TEXT ,';')> 0)
or INSTR(MEANING_TEXT,'&'||'gt;')>0 
or INSTR(MEANING_TEXT,'&'||'lt;')>0 
or  INSTR(MEANING_TEXT,'&'||'amp;')>0)
and  UTL_I18N.UNESCAPE_REFERENCE(MEANING_TEXT) not like'%¿%')
or
(((instr(DESCRIPTION_TEXT ,'&'||'#')> 0  and instr(DESCRIPTION_TEXT ,';')> 0)
or INSTR(DESCRIPTION_TEXT,'&'||'gt;')>0 
or INSTR(DESCRIPTION_TEXT,'&'||'lt;')>0 
or  INSTR(DESCRIPTION_TEXT,'&'||'amp;')>0)
and  UTL_I18N.UNESCAPE_REFERENCE(DESCRIPTION_TEXT) not like'%¿%'));




UPDATE SBREXT.VALID_VALUES_ATT_EXT set 
date_modified=v_date, modified_by='DWARZEL',
MEANING_TEXT=UTL_I18N.UNESCAPE_REFERENCE(MEANING_TEXT) 
where ((instr(MEANING_TEXT ,'&'||'#')> 0  and instr(MEANING_TEXT ,';')> 0)
or INSTR(MEANING_TEXT,'&'||'gt;')>0 
or INSTR(MEANING_TEXT,'&'||'lt;')>0 
or  INSTR(MEANING_TEXT,'&'||'amp;')>0 )
and UTL_I18N.UNESCAPE_REFERENCE(MEANING_TEXT) not like'%¿%';


UPDATE SBREXT.VALID_VALUES_ATT_EXT set 
date_modified=v_date, modified_by='DWARZEL',
DESCRIPTION_TEXT=UTL_I18N.UNESCAPE_REFERENCE(DESCRIPTION_TEXT)
where((instr(DESCRIPTION_TEXT ,'&'||'#')> 0 and instr(DESCRIPTION_TEXT ,';')> 0)
or INSTR(DESCRIPTION_TEXT,'&'||'gt;')>0 
or INSTR(DESCRIPTION_TEXT,'&'||'lt;')>0 
or  INSTR(DESCRIPTION_TEXT,'&'||'amp;')>0 )
and UTL_I18N.UNESCAPE_REFERENCE(DESCRIPTION_TEXT) not like'%¿%'  ;
 commit;                                                                               
 EXCEPTION
 
    WHEN OTHERS THEN   
       errmsg := substr(SQLERRM,1,2000);
         dbms_output.put_line('errmsg  - '||errmsg);
        insert into SBREXT.META_SPCHAR_ERROR_LOG VALUES('CT_FIX_SPCHAR_VV_ATT_EXT',   sysdate ,errmsg);
        
     commit; 
END CT_FIX_SPCHAR_VV_ATT_EXT11G;
/
exec SBREXT.CT_FIX_SPCHAR_VV_ATT_EXT11G;
exec SBREXT.CT_FIX_QUEST_CONTENTS_EXT11G;
exec SBR.CT_FIX_SP_CHAR_PV11G;
exec SBR.CT_FIX_SP_CHAR_VM11G;
exec SBR.CT_FIX_VALUE_DOMAINS11G;
exec SBR.CT_FIX_CD_VMS11G;
exec SBR.CT_FIX_REF_DOC11G;
exec SBREXT.CT_FIX_PROPERTIES_EXT11G;
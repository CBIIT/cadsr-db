CREATE OR REPLACE FUNCTION SBREXT.meta_FIND_SP_CHAR(p_text in VARCHAR2 )
RETURN VARCHAR2
IS
V_text VARCHAR2(3900);
V_find number;
BEGIN
V_text:=p_text;

IF (INSTR(p_text ,'&'||'gt;')>0 or
 INSTR(p_text ,'&'||'lt;')>0 or
 INSTR(p_text ,'&'||'amp;')>0 or
 INSTR(p_text ,'&'||'#32;')>0 or
 INSTR(p_text ,'&'||'#33;')>0 or
 INSTR(p_text ,'&'||'#34;')>0 or
 INSTR(p_text ,'&'||'#35;')>0 or
 INSTR(p_text ,'&'||'#36;')>0 or
 INSTR(p_text ,'&'||'#37;')>0 or
 INSTR(p_text ,'&'||'#38;')>0 or
 INSTR(p_text ,'&'||'#39;')>0 or
 INSTR(p_text ,'&'||'#40;')>0 or
 INSTR(p_text ,'&'||'#41;')>0 or
 INSTR(p_text ,'&'||'#42;')>0 or
 INSTR(p_text ,'&'||'#43;')>0 or
 INSTR(p_text ,'&'||'#44;')>0 or
 INSTR(p_text ,'&'||'#45;')>0 or
 INSTR(p_text ,'&'||'#46;')>0 or
 INSTR(p_text ,'&'||'#47;')>0 or
 INSTR(p_text ,'&'||'#58;')>0 or
 INSTR(p_text ,'&'||'#59;')>0 or
 INSTR(p_text ,'&'||'#60;')>0 or
 INSTR(p_text ,'&'||'#61;')>0 or
 INSTR(p_text ,'&'||'#62;')>0 or
 INSTR(p_text ,'&'||'#63;')>0 or
 INSTR(p_text ,'&'||'#64;')>0 or
 INSTR(p_text ,'&'||'#91;')>0 or
 INSTR(p_text ,'&'||'#92;')>0 or
 INSTR(p_text ,'&'||'#93;')>0 or
 INSTR(p_text ,'&'||'#94;')>0 or
 INSTR(p_text ,'&'||'#95;')>0 or
 INSTR(p_text ,'&'||'#123;')>0 or
 INSTR(p_text ,'&'||'#124;')>0 or
 INSTR(p_text ,'&'||'#125;')>0 or
 INSTR(p_text ,'&'||'#126;')>0 or
 INSTR(p_text ,'&'||'#176;')>0 or
 INSTR(p_text ,'&'||'#177;')>0 or
 INSTR(p_text ,'&'||'#178;')>0 or
 INSTR(p_text ,'&'||'#179;')>0 or
 INSTR(p_text ,'&'||'#181;')>0 or
 INSTR(p_text ,'&'||'#191;')>0 or
 INSTR(p_text ,'&'||'#247;')>0 or
 INSTR(p_text ,'&'||'#8804;')>0 or
 INSTR(p_text ,'&'||'#8805;')>0 or 
 INSTR(p_text ,'&'||'#8800;')>0 or 
 INSTR(p_text ,'&'||'#8223;')>0 or
 INSTR(p_text ,'&'||'#8322;')>0 )
THEN
V_find:=1;
ELSE
V_find:=0;
END if;
RETURN V_find;
END;
/
CREATE OR REPLACE FUNCTION SBREXT.meta_CleanSP_CHAR(p_text VARCHAR2 )
RETURN VARCHAR2
IS
V_text VARCHAR2(3900);
BEGIN
V_text:=p_text;

IF instr(V_text,'&'||'amp;')>0 
THEN
V_text:=replace(V_text,'&'||'amp;','&');
END if;

IF instr(V_text,'&'||'gt;')>0 or INSTR(V_text,'&'||'#62;')>0
THEN
V_text:=replace(replace(V_text,'&'||'gt;','>'),'&'||'#62;','>');
END if;

IF instr(V_text,'&'||'lt;')>0 or INSTR(V_text,'&'||'#60;')>0
THEN
V_text:=replace(replace(V_text,'&'||'lt;','<'),'&'||'#60;','<');
END if;

IF  INSTR(V_text,'&'||'#32;')>0
THEN
V_text:=replace(V_text,'&'||'#32;',' ');
END if;

IF  INSTR(V_text,'&'||'#33;')>0
THEN
V_text:=replace(V_text,'&'||'#33;','!');
END if;

IF  INSTR(V_text,'&'||'#34;')>0
THEN
V_text:=replace(V_text,'&'||'#34;','"');
END if;  
         
IF  INSTR(V_text,'&'||'#35;')>0
THEN
V_text:=replace(V_text,'&'||'#35;','#');
END if;  

IF  INSTR(V_text,'&'||'#36;')>0
THEN
V_text:=replace(V_text,'&'||'#36;','$');
END if;

IF  INSTR(V_text,'&'||'#37;')>0
THEN
V_text:=replace(V_text,'&'||'#37;','%');
END if;
IF INSTR(V_text,'&'||'#38;')>0
THEN
V_text:=replace(V_text,'&'||'#38;','&');
END if;
--#39 single quote
IF  INSTR(V_text,'&'||'#39;')>0
THEN
V_text:=replace(V_text,'&'||'#39;','''');
END if;
IF  INSTR(V_text,'&'||'#40;')>0
THEN
V_text:=replace(V_text,'&'||'#40;','(');
END if;
IF  INSTR(V_text,'&'||'#41;')>0
THEN
V_text:=replace(V_text,'&'||'#41;',')');
END if;
--    *   &#42; 
IF  INSTR(V_text,'&'||'#42;')>0
THEN
V_text:=replace(V_text,'&'||'#42;','*');
END if;
--    + &#43; 
IF  INSTR(V_text,'&'||'#43;')>0
THEN
V_text:=replace(V_text,'&'||'#43;','+');
END if;           

--    - &#45; 
IF  INSTR(V_text,'&'||'#45;')>0
THEN
V_text:=replace(V_text,'&'||'#45;','-');
END if;   

--    period &#46; 
IF  INSTR(V_text,'&'||'#46;')>0
THEN
V_text:=replace(V_text,'&'||'#46;','.');
END if;   

--    / &#47; 
IF  INSTR(V_text,'&'||'#47;')>0
THEN
V_text:=replace(V_text,'&'||'#47;','/');
END if;   

--    : &#58; 
IF  INSTR(V_text,'&'||'#58;')>0
THEN
V_text:=replace(V_text,'&'||'#58;',':');
END if;   

--    ; &#59; 
IF  INSTR(V_text,'&'||'#59;')>0
THEN
V_text:=replace(V_text,'&'||'#59;',';');
END if;

--   = ; &#61; 
IF  INSTR(V_text,'&'||'#61;')>0
THEN
V_text:=replace(V_text,'&'||'#61;','=');
END if;

--   ? &#63; 
IF  INSTR(V_text,'&'||'#63;')>0
THEN
V_text:=replace(V_text,'&'||'#63;','?');
END if;

--   @ &#64; 
IF  INSTR(V_text,'&'||'#64;')>0
THEN
V_text:=replace(V_text,'&'||'#64;','@');

END if;

--   [ &#91; opening bracket
IF  INSTR(V_text,'&'||'#91;')>0
THEN
V_text:=replace(V_text,'&'||'#91;','[');

END if;
--   \ &#92; backslash
IF  INSTR(V_text,'&'||'#92;')>0
THEN
V_text:=replace(V_text,'&'||'#92;','\');
END if;
--   ] &#93; closing bracket
IF  INSTR(V_text,'&'||'#93;')>0
THEN
V_text:=replace(V_text,'&'||'#93;',']');
END if;
--   ^ &#94; caret - circumflex
IF  INSTR(V_text,'&'||'#94;')>0
THEN
V_text:=replace(V_text,'&'||'#94;','^');
END if;

--  _ &#95; underscore
IF  INSTR(V_text,'&'||'#95;')>0
THEN
V_text:=replace(V_text,'&'||'#95;','_');
END if;

--  {&#123; opening brace
IF  INSTR(V_text,'&'||'#123;')>0
THEN
V_text:=replace(V_text,'&'||'#123;','{');
END if;

--  |&#124; vertical bar
IF  INSTR(V_text,'&'||'#124;')>0
THEN
V_text:=replace(V_text,'&'||'#124;','|');
END if;
--  }&#125; closing brace
IF  INSTR(V_text,'&'||'#125;')>0
THEN
V_text:=replace(V_text,'&'||'#125;','}');

END if;
--  ~&#126; equivalency sign - tilde
IF  INSTR(V_text,'&'||'#126;')>0
THEN
V_text:=replace(V_text,'&'||'#126;','~');
END if;


--   ° &#176; degree sign
IF  INSTR(V_text,'&'||'#176;')>0
THEN
V_text:=replace(V_text,'&'||'#176;',UTL_I18N.UNESCAPE_REFERENCE('&#176;') );
END if;

--   ± &#177; plus-or-minus sign
IF  INSTR(V_text,'&'||'#177;')>0
THEN
V_text:=replace(V_text,'&'||'#177;',UTL_I18N.UNESCAPE_REFERENCE('&#177;') );
END if;
--   ² &#178; superscript two - squared
IF  INSTR(V_text,'&'||'#178;')>0
THEN
V_text:=replace(V_text,'&'||'#178;',UTL_I18N.UNESCAPE_REFERENCE('&#178;') );
END if;

--   ³ &#179; superscript three - cubed
IF  INSTR(V_text,'&'||'#179;')>0
THEN
V_text:=replace(V_text,'&'||'#179;',UTL_I18N.UNESCAPE_REFERENCE('&#179;') );
END if;

--   µ &#181; 
IF  INSTR(V_text,'&'||'#181;')>0
THEN
V_text:=replace(V_text,'&'||'#181;',UTL_I18N.UNESCAPE_REFERENCE('&#181;') );
END if;
--   ¿&#191; inverted question mark
IF  INSTR(V_text,'&'||'#191;')>0
THEN
V_text:=replace(V_text,'&'||'#191;',UTL_I18N.UNESCAPE_REFERENCE('&#191;') );
END if;

--   ÷ &#247; division sign
IF  INSTR(V_text,'&'||'#247;')>0
THEN
V_text:=replace(V_text,'&'||'#247;',UTL_I18N.UNESCAPE_REFERENCE('&#247;') );
END if;

IF  INSTR(V_text,'&'||'#8804;')>0
THEN
V_text:=replace(V_text,'&'||'#8804;','<=');
END if;

IF  INSTR(V_text,'&'||'#8805;')>0
THEN
V_text:=replace(V_text,'&'||'#8805;','>=');
END if;

 IF  INSTR(V_text,'&'||'#8800;')>0
THEN
V_text:=replace(V_text,'&'||'#8800;','<>');
END if;

 IF  INSTR(V_text,'&'||'#8223;')>0
THEN
V_text:=replace(V_text,'&'||'#8223;','"');
END if;

 IF  INSTR(V_text,'&'||'#8322;')>0
THEN
V_text:=replace(V_text,'&'||'#8322;',UTL_I18N.UNESCAPE_REFERENCE('&#8322;') );
END if;

RETURN V_text;
END;
/
GRANT EXECUTE ON meta_CleanSP_CHAR TO SBR
/
GRANT EXECUTE ON SBREXT.meta_FIND_SP_CHAR TO SBR
/

CREATE OR REPLACE PROCEDURE SBR.META_FIX_CD_VMS IS
v_date  date  ;
V_sdate date:=sysdate;
errmsg VARCHAR2(2000):='Non';
/******************************************************************************where
   NAME:       META_FIX_CD_VMS
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
WHERE SBREXT.meta_FIND_SP_CHAR(short_meaning)>0 or SBREXT.meta_FIND_SP_CHAR(DESCRIPTION)>0 ; 

commit;

UPDATE SBR.CD_VMS set 
date_modified=v_date, modified_by='DWARZEL',
short_meaning=SBREXT.meta_CleanSP_CHAR(short_meaning) 
where SBREXT.meta_FIND_SP_CHAR(short_meaning)>0;

UPDATE SBR.CD_VMS set 
date_modified=v_date, modified_by='DWARZEL',
DESCRIPTION=SBREXT.meta_CleanSP_CHAR(DESCRIPTION)
where SBREXT.meta_FIND_SP_CHAR(DESCRIPTION)>0 ; 
                                                                        
 commit;

 EXCEPTION 
    WHEN OTHERS THEN       
    errmsg := substr(SQLERRM,1,2000);
     dbms_output.put_line('errmsg  - '||errmsg);
     insert into SBREXT.META_SPCHAR_ERROR_LOG VALUES('META_FIX_CD_VMS',   sysdate ,errmsg);
        
     commit; 
END META_FIX_CD_VMS;
/
CREATE OR REPLACE PROCEDURE SBR.META_FIX_REF_DOC IS
v_date  date  ;
V_sdate date:=sysdate;
errmsg VARCHAR2(2000):='Non';
/******************************************************************************
   NAME:       META_FIX_REF_DOC
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        8/11/2016   trushi2       1. Created this procedure.

   NOTES:
      Object Name:     META_FIX_REF_DOC
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
and  SBREXT.meta_CleanSP_CHAR(r.NAME )=SBREXT.meta_CleanSP_CHAR(g.NAME) --replace(replace(replace(g.name,'&'||'#8804','<='),'&'||'#8805','>='),'&'||'#8800','>=')
and r.RD_IDSEQ<>g.RD_IDSEQ
and SBREXT.meta_FIND_SP_CHAR(r.NAME )>0 
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
where (SBREXT.meta_FIND_SP_CHAR(NAME)>0 or SBREXT.meta_FIND_SP_CHAR(DOC_TEXT)>0 )
and RD_IDSEQ not in (select distinct RD_IDSEQ from SBR.CT_REF_DOC_BKUP where comments='Duplicate') ;
commit;

UPDATE SBR.REFERENCE_DOCUMENTS set
date_modified=v_date, modified_by='DWARZEL',
NAME=SBREXT.meta_CleanSP_CHAR(name)
where SBREXT.meta_FIND_SP_CHAR(NAME)>0
and RD_IDSEQ not in (select distinct RD_IDSEQ from SBR.CT_REF_DOC_BKUP where comments='Duplicate') ;


UPDATE SBR.REFERENCE_DOCUMENTS set
date_modified=v_date, modified_by='DWARZEL',
DOC_TEXT=SBREXT.meta_CleanSP_CHAR(DOC_TEXT)
where SBREXT.meta_FIND_SP_CHAR(DOC_TEXT)>0 
and RD_IDSEQ not in (select distinct RD_IDSEQ from SBR.CT_REF_DOC_BKUP where comments='Duplicate') ;

 commit;

 EXCEPTION
    WHEN OTHERS THEN
    errmsg := substr(SQLERRM,1,2000);
    insert into SBREXT.META_SPCHAR_ERROR_LOG VALUES('META_FIX_REF_DOC',   sysdate ,errmsg);

     commit;
END META_FIX_REF_DOC;
/
CREATE OR REPLACE PROCEDURE SBR.META_FIX_SP_CHAR_PV IS
v_date  date  ;
V_sdate date:=sysdate;
errmsg VARCHAR2(2000):='Non';
/******************************************************************************
   NAME:       META_FIX_sp_char_PV
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
WHERE SBREXT.meta_FIND_SP_CHAR(short_meaning)>0 or SBREXT.meta_FIND_SP_CHAR(MEANING_DESCRIPTION)>0 ;
commit;

UPDATE SBR.PERMISSIBLE_VALUES set 
date_modified=v_date, modified_by='DWARZEL',
short_meaning=SBREXT.meta_CleanSP_CHAR(short_meaning) 
where SBREXT.meta_FIND_SP_CHAR(short_meaning)>0;


UPDATE SBR.PERMISSIBLE_VALUES set 
date_modified=v_date, modified_by='DWARZEL',
MEANING_DESCRIPTION=SBREXT.meta_CleanSP_CHAR(MEANING_DESCRIPTION)
where SBREXT.meta_FIND_SP_CHAR(MEANING_DESCRIPTION)>0 ;
 commit;

 EXCEPTION 
    WHEN OTHERS THEN       
    errmsg := substr(SQLERRM,1,2000);
    insert into SBREXT.META_SPCHAR_ERROR_LOG VALUES('META_FIX_SP_CHAR_PV',   sysdate ,errmsg);
        
     commit; 
END META_FIX_SP_CHAR_PV;
/
CREATE OR REPLACE PROCEDURE SBR.META_FIX_SP_CHAR_VM IS
tmpVar NUMBER;
V_date date:=sysdate;
errmsg VARCHAR2(2000):='Non';
/******************************************************************************
   NAME:       META_FIX_sp_char_VM
   PURPOSE:    

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        8/11/2016   trushi2       1. Created this procedure.

   NOTES:
      Object Name:     META_FIX_sp_char_VM
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
where SBREXT.meta_FIND_SP_CHAR(short_meaning)>0
or SBREXT.meta_FIND_SP_CHAR(LONG_NAME)>0 
or SBREXT.meta_FIND_SP_CHAR(PREFERRED_DEFINITION)>0 
or SBREXT.meta_FIND_SP_CHAR(DESCRIPTION)>0 ;
commit;


UPDATE SBR.VALUE_MEANINGS set 
date_modified=v_date, modified_by='DWARZEL',
short_meaning=SBREXT.meta_CleanSP_CHAR(short_meaning) 
where  SBREXT.meta_FIND_SP_CHAR(short_meaning)>0;

UPDATE SBR.VALUE_MEANINGS set 
date_modified=v_date, modified_by='DWARZEL',
DESCRIPTION=SBREXT.meta_CleanSP_CHAR(DESCRIPTION)
where SBREXT.meta_FIND_SP_CHAR(DESCRIPTION)>0 ;

UPDATE SBR.VALUE_MEANINGS set 
date_modified=v_date, modified_by='DWARZEL',
LONG_NAME=SBREXT.meta_CleanSP_CHAR(LONG_NAME) 
where SBREXT.meta_FIND_SP_CHAR(LONG_NAME)>0 ;


UPDATE SBR.VALUE_MEANINGS set 
date_modified=v_date, modified_by='DWARZEL',
preferred_definition=SBREXT.meta_CleanSP_CHAR(preferred_definition)
where SBREXT.meta_FIND_SP_CHAR(PREFERRED_DEFINITION)>0 ;

commit;
  EXCEPTION                      
   WHEN OTHERS THEN   
    rollback;
    errmsg := substr(SQLERRM,1,2000);
         dbms_output.put_line('errmsg  - '||errmsg);
        insert into SBREXT.META_SPCHAR_ERROR_LOG VALUES('META_FIX_SP_CHAR_VM',   sysdate ,errmsg);
        
     commit; 
END META_FIX_SP_CHAR_VM;
/

CREATE OR REPLACE PROCEDURE SBR.META_FIX_VALUE_DOMAINS IS
v_date  date  ;
V_sdate date:=sysdate;
errmsg VARCHAR2(2000):='Non';
/******************************************************************************
   NAME:       META_FIX_VALUE_DOMAINS
   PURPOSE:    

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        8/11/2016   trushi2       1. Created this procedure.

   NOTES:
      Object Name:     META_FIX_sp_char_VM
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
where SBREXT.meta_FIND_SP_CHAR(LONG_NAME)>0 
or SBREXT.meta_FIND_SP_CHAR(PREFERRED_DEFINITION)>0 ;
commit;

 UPDATE SBR.VALUE_DOMAINS set 
date_modified=v_date, modified_by='DWARZEL',
LONG_NAME=SBREXT.meta_CleanSP_CHAR(LONG_NAME) 
where SBREXT.meta_FIND_SP_CHAR(LONG_NAME)>0 ;


UPDATE SBR.VALUE_DOMAINS set 
date_modified=v_date, modified_by='DWARZEL',
preferred_definition=SBREXT.meta_CleanSP_CHAR(preferred_definition)
where SBREXT.meta_FIND_SP_CHAR(PREFERRED_DEFINITION)>0 ;
                                                                             
 commit;  
    EXCEPTION
 
    WHEN OTHERS THEN   
       errmsg := substr(SQLERRM,1,2000);
         dbms_output.put_line('errmsg  - '||errmsg);
        insert into SBREXT.META_SPCHAR_ERROR_LOG VALUES('META_FIX_VALUE_DOMAINS',   sysdate ,errmsg);
        
     commit; 
END META_FIX_VALUE_DOMAINS;
/
/*******************SBREXT******************/

CREATE OR REPLACE PROCEDURE SBREXT.META_FIX_PROPERTIES_EXT IS
v_date  date  ;
V_sdate date:=sysdate;
errmsg VARCHAR2(2000):='Non';
/******************************************************************************
   NAME:       META_FIX_CD_VMS
   PURPOSE:    

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        8/11/2016   trushi2       1. Created this procedure.

   NOTES:
      Object Name:     META_FIX_CD_VMS
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
where SBREXT.meta_FIND_SP_CHAR(LONG_NAME)>0 
or SBREXT.meta_FIND_SP_CHAR(PREFERRED_DEFINITION)>0 ;

commit;
UPDATE SBREXT.PROPERTIES_EXT  set 
date_modified=v_date, modified_by='DWARZEL',
LONG_NAME=SBREXT.meta_CleanSP_CHAR(LONG_NAME) 
where SBREXT.meta_FIND_SP_CHAR(LONG_NAME)>0 ;


UPDATE SBREXT.PROPERTIES_EXT  set 
date_modified=v_date, modified_by='DWARZEL',
PREFERRED_DEFINITION=SBREXT.meta_CleanSP_CHAR(PREFERRED_DEFINITION)
where SBREXT.meta_FIND_SP_CHAR(PREFERRED_DEFINITION)>0 ;
                                                                   
 commit;

 EXCEPTION
 
    WHEN OTHERS THEN   
    
    errmsg := substr(SQLERRM,1,2000);
         dbms_output.put_line('errmsg  - '||errmsg);
        insert into SBREXT.META_SPCHAR_ERROR_LOG VALUES('META_FIX_PROPERTIES_EXT',   sysdate ,errmsg);
        
     commit; 
END META_FIX_PROPERTIES_EXT;
/
CREATE OR REPLACE PROCEDURE SBREXT.META_FIX_SPCHAR_VV_ATT_EXT IS
v_date  date  ;
V_sdate date:=sysdate;
errmsg VARCHAR2(2000):='Non';
/******************************************************************************
   NAME:       META_FIX_SPCHAR_VV_ATT_EXT
   PURPOSE:    

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        8/11/2016   trushi2       1. Created this procedure.

   NOTES:
      Object Name:     META_FIX_SPCHAR_VV_ATT_EXT
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
WHERE SBREXT.meta_FIND_SP_CHAR(MEANING_TEXT)>0 or
 SBREXT.meta_FIND_SP_CHAR(DESCRIPTION_TEXT)>0; 

commit;


UPDATE SBREXT.VALID_VALUES_ATT_EXT set 
date_modified=v_date, modified_by='DWARZEL',
MEANING_TEXT=SBREXT.meta_CleanSP_CHAR(MEANING_TEXT) 
where SBREXT.meta_FIND_SP_CHAR(MEANING_TEXT)>0;


UPDATE SBREXT.VALID_VALUES_ATT_EXT set 
date_modified=v_date, modified_by='DWARZEL',
DESCRIPTION_TEXT=SBREXT.meta_CleanSP_CHAR(DESCRIPTION_TEXT)
where SBREXT.meta_FIND_SP_CHAR(DESCRIPTION_TEXT)>0; 

 commit;                                                                               
 EXCEPTION
 
    WHEN OTHERS THEN   
       errmsg := substr(SQLERRM,1,2000);
         dbms_output.put_line('errmsg  - '||errmsg);
        insert into SBREXT.META_SPCHAR_ERROR_LOG VALUES('META_FIX_SPCHAR_VV_ATT_EXT',   sysdate ,errmsg);
        
     commit; 
END META_FIX_SPCHAR_VV_ATT_EXT;
/
CREATE OR REPLACE PROCEDURE SBR.META_FIX_DATA_ELEMENT_CONC IS
v_date  date  ;
V_sdate date:=sysdate;
errmsg VARCHAR2(2000):='Non';
/******************************************************************************
   NAME:       META_FIX_DATA_ELEMENT_CONCEPTS11G 
   PURPOSE:    

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        8/11/2016   trushi2       1. Created this procedure.

   NOTES:
      Object Name:     META_FIX_sp_char_VM
      Sysdate:         8/11/2016
      Date and Time:   8/11/2016, 12:31:43 PM, and 8/11/2016 12:31:43 PM
      Username:        trushi2 (set in TOAD Options, Procedure Editor)
     
******************************************************************************/
BEGIN   


select to_date(to_char(sysdate,'mm/dd/yyyy')||'12:34:56','mm/dd/yyyyhh24:mi:ss')
into v_date from dual;

insert into  SBR.CT_DATA_ELEMENT_CONCEPTS_BKUP
(
           DEC_IDSEQ ,
           PREFERRED_DEFINITION,
           LONG_NAME,         
           DATE_MODIFIED, 
           DATE_INSERT,           
           MODIFIED_BY          
)

select     DEC_IDSEQ ,
           PREFERRED_DEFINITION,
           LONG_NAME,    
           DATE_MODIFIED, 
           SYSDATE    ,       
           MODIFIED_BY
from SBR.DATA_ELEMENT_CONCEPTS
where SBREXT.meta_FIND_SP_CHAR(LONG_NAME)>0 
or SBREXT.meta_FIND_SP_CHAR(PREFERRED_DEFINITION)>0 ;
commit;

 UPDATE SBR.DATA_ELEMENT_CONCEPTS set 
date_modified=v_date, modified_by='DWARZEL',
LONG_NAME=SBREXT.meta_CleanSP_CHAR(LONG_NAME) 
where SBREXT.meta_FIND_SP_CHAR(LONG_NAME)>0 ;


UPDATE SBR.DATA_ELEMENT_CONCEPTS set 
date_modified=v_date, modified_by='DWARZEL',
PREFERRED_DEFINITION=SBREXT.meta_CleanSP_CHAR(PREFERRED_DEFINITION)
where SBREXT.meta_FIND_SP_CHAR(PREFERRED_DEFINITION)>0 ;
                                                                             
 commit;  
    EXCEPTION 
    WHEN OTHERS THEN   
       errmsg := substr(SQLERRM,1,2000);
        insert into SBREXT.META_SPCHAR_ERROR_LOG VALUES('META_FIX_DATA_ELEMENT_CONC',   sysdate ,errmsg);
        
     commit; 
END META_FIX_DATA_ELEMENT_CONC;
/
CREATE OR REPLACE PROCEDURE SBR.META_FIX_DATA_ELEMENTS IS
v_date  date  ;
V_sdate date:=sysdate;
errmsg VARCHAR2(2000):='Non';
/******************************************************************************
   NAME:       META_FIX_QUEST_CONTENTS_EXT
   PURPOSE:    

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        8/11/2016   trushi2       1. Created this procedure.

   NOTES:
      Object Name:     META_FIX_sp_char_VM
      Sysdate:         8/11/2016
      Date and Time:   8/11/2016, 12:31:43 PM, and 8/11/2016 12:31:43 PM
      Username:        trushi2 (set in TOAD Options, Procedure Editor)
     
******************************************************************************/
BEGIN   


select to_date(to_char(sysdate,'mm/dd/yyyy')||'12:34:56','mm/dd/yyyyhh24:mi:ss')
into v_date from dual;

insert into  SBR.CT_DATA_ELEMENTS_BKUP
(
           DE_IDSEQ ,
           PREFERRED_DEFINITION,
           LONG_NAME,         
           DATE_MODIFIED, 
           DATE_INSERT,           
           MODIFIED_BY          
)

select     DE_IDSEQ ,
           PREFERRED_DEFINITION,
           LONG_NAME,    
           DATE_MODIFIED, 
           SYSDATE    ,       
           MODIFIED_BY
from SBR.DATA_ELEMENTS
where SBREXT.meta_FIND_SP_CHAR(PREFERRED_DEFINITION)>0 ;
commit;

 UPDATE SBR.DATA_ELEMENTS set 
date_modified=v_date, modified_by='DWARZEL',
LONG_NAME=SBREXT.meta_CleanSP_CHAR(LONG_NAME) 
where SBREXT.meta_FIND_SP_CHAR(LONG_NAME)>0 ;


UPDATE SBR.DATA_ELEMENTS set 
date_modified=v_date, modified_by='DWARZEL',
PREFERRED_DEFINITION=SBREXT.meta_CleanSP_CHAR(PREFERRED_DEFINITION)
where SBREXT.meta_FIND_SP_CHAR(PREFERRED_DEFINITION)>0 ;
                                                                             
 commit;  
    EXCEPTION
 
    WHEN OTHERS THEN   
       errmsg := substr(SQLERRM,1,2000);
         dbms_output.put_line('errmsg  - '||errmsg);
        insert into SBREXT.META_SPCHAR_ERROR_LOG VALUES('META_FIX_DATA_ELEMENTS',   sysdate ,errmsg);
        
     commit; 
END META_FIX_DATA_ELEMENTS;
/
CREATE OR REPLACE PROCEDURE SBREXT.META_FIX_OBJECT_CLASSES_EXT IS
v_date  date  ;
V_sdate date:=sysdate;
errmsg VARCHAR2(2000):='Non';
/******************************************************************************
   NAME:       META_FIX_OBJECT_CLASSES_EXT
   PURPOSE:    

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        8/11/2016   trushi2       1. Created this procedure.

   NOTES:
      Object Name:     META_FIX_sp_char_VM
      Sysdate:         8/11/2016
      Date and Time:   8/11/2016, 12:31:43 PM, and 8/11/2016 12:31:43 PM
      Username:        trushi2 (set in TOAD Options, Procedure Editor)
     
******************************************************************************/
BEGIN   


select to_date(to_char(sysdate,'mm/dd/yyyy')||'12:34:56','mm/dd/yyyyhh24:mi:ss')
into v_date from dual;

insert into  SBREXT.CT_OBJECT_CLASSES_EXT_BKUP
(
           OC_IDSEQ ,
           PREFERRED_DEFINITION,
           LONG_NAME,         
           DATE_MODIFIED, 
           DATE_INSERT,           
           MODIFIED_BY          
)

select     OC_IDSEQ ,
           PREFERRED_DEFINITION,
           LONG_NAME,    
           DATE_MODIFIED, 
           SYSDATE    ,       
           MODIFIED_BY
from SBREXT.OBJECT_CLASSES_EXT
where SBREXT.meta_FIND_SP_CHAR(LONG_NAME)>0 
or SBREXT.meta_FIND_SP_CHAR(PREFERRED_DEFINITION)>0 ;

commit;
 UPDATE SBREXT.OBJECT_CLASSES_EXT set 
date_modified=v_date, modified_by='DWARZEL',
LONG_NAME=SBREXT.meta_CleanSP_CHAR(LONG_NAME) 
where SBREXT.meta_FIND_SP_CHAR(LONG_NAME)>0 ;


UPDATE SBREXT.OBJECT_CLASSES_EXT set 
date_modified=v_date, modified_by='DWARZEL',
PREFERRED_DEFINITION=SBREXT.meta_CleanSP_CHAR(PREFERRED_DEFINITION)
where SBREXT.meta_FIND_SP_CHAR(PREFERRED_DEFINITION)>0 ;
                                                                             
 commit;  
    EXCEPTION 
    WHEN OTHERS THEN   
       errmsg := substr(SQLERRM,1,2000);
       insert into SBREXT.META_SPCHAR_ERROR_LOG VALUES('META_FIX_OBJECT_CLASSES_EXT',   sysdate ,errmsg);
        
     commit; 
END META_FIX_OBJECT_CLASSES_EXT;
/
CREATE OR REPLACE PROCEDURE SBREXT.META_FIX_REPRESENTATIONS_EXT IS
v_date  date  ;
V_sdate date:=sysdate;
errmsg VARCHAR2(2000):='Non';
/******************************************************************************
   NAME:       META_FIX_REPRESENTATIONS_EXT
   PURPOSE:    

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        8/11/2016   trushi2       1. Created this procedure.

   NOTES:
      Object Name:     META_FIX_sp_char_VM
      Sysdate:         8/11/2016
      Date and Time:   8/11/2016, 12:31:43 PM, and 8/11/2016 12:31:43 PM
      Username:        trushi2 (set in TOAD Options, Procedure Editor)
     
******************************************************************************/
BEGIN   


select to_date(to_char(sysdate,'mm/dd/yyyy')||'12:34:56','mm/dd/yyyyhh24:mi:ss')
into v_date from dual;

insert into  SBREXT.CT_REPRESENTATIONS_EXT_BKUP
(
             REP_IDSEQ  ,
           PREFERRED_DEFINITION,
           LONG_NAME,         
           DATE_MODIFIED, 
           DATE_INSERT,           
           MODIFIED_BY          
)

select     REP_IDSEQ ,
           PREFERRED_DEFINITION,
           LONG_NAME,    
           DATE_MODIFIED, 
           SYSDATE    ,       
           MODIFIED_BY
from SBREXT.REPRESENTATIONS_EXT
where SBREXT.meta_FIND_SP_CHAR(LONG_NAME)>0 
or SBREXT.meta_FIND_SP_CHAR(PREFERRED_DEFINITION)>0 ;
commit;

 UPDATE SBREXT.REPRESENTATIONS_EXT set 
date_modified=v_date, modified_by='DWARZEL',
LONG_NAME=SBREXT.meta_CleanSP_CHAR(LONG_NAME) 
where SBREXT.meta_FIND_SP_CHAR(LONG_NAME)>0 ;


UPDATE SBREXT.REPRESENTATIONS_EXT set 
date_modified=v_date, modified_by='DWARZEL',
PREFERRED_DEFINITION=SBREXT.meta_CleanSP_CHAR(PREFERRED_DEFINITION)
where SBREXT.meta_FIND_SP_CHAR(PREFERRED_DEFINITION)>0 ;                                                                    
 commit;  
    EXCEPTION 
    WHEN OTHERS THEN   
       errmsg := substr(SQLERRM,1,2000);
       insert into SBREXT.META_SPCHAR_ERROR_LOG VALUES('META_FIX_REPRESENTATIONS_EXT',   sysdate ,errmsg);
      
     commit; 
END META_FIX_REPRESENTATIONS_EXT;
/
exec SBREXT.META_FIX_REPRESENTATIONS_EXT;
exec SBREXT.META_FIX_OBJECT_CLASSES_EXT;
exec SBR.META_FIX_DATA_ELEMENT_CONC;
exec SBR.META_FIX_DATA_ELEMENTS;
exec SBREXT.META_FIX_SPCHAR_VV_ATT_EXT;
exec SBR.META_FIX_SP_CHAR_PV;
exec SBR.META_FIX_SP_CHAR_VM;
exec SBR.META_FIX_VALUE_DOMAINS;
exec SBR.META_FIX_CD_VMS;
exec SBR.META_FIX_REF_DOC;
exec SBREXT.META_FIX_PROPERTIES_EXT;
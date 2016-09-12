CREATE OR REPLACE FUNCTION  meta_CleanSP_CHAR(p_text VARCHAR2 )
RETURN VARCHAR2
IS
V_text VARCHAR2(3000);
BEGIN


IF instr(p_text,'&'||'gt;')>0 or INSTR(p_text,'&'||'#62;')>0
THEN
V_text:=replace(replace(p_text,'&'||'gt;','>'),'&'||'#62;','>');
ELSE
V_text:=p_text;
END if;
/**/
IF instr(V_text,'&'||'lt;')>0 or INSTR(V_text,'&'||'#60;')>0
THEN
V_text:=replace(replace(V_text,'&'||'lt;','<'),'&'||'#60;','<');
ELSE
V_text:=V_text;
END if;

IF instr(V_text,'&'||'amp;')>0 or INSTR(V_text,'&'||'#38;')>0
THEN
V_text:=replace(replace(V_text,'&'||'amp;','&'),'&'||'#38;','&');

ELSE
V_text:=V_text;
END if;

IF  INSTR(V_text,'&'||'#32;')>0
THEN
V_text:=replace(V_text,'&'||'#32;',' ');
ELSE
V_text:=V_text;
END if;


IF  INSTR(V_text,'&'||'#33;')>0
THEN
V_text:=replace(V_text,'&'||'#33;','!');
ELSE
V_text:=V_text;
END if;

IF  INSTR(V_text,'&'||'#34;')>0
THEN
V_text:=replace(V_text,'&'||'#34;','"');
ELSE
V_text:=V_text;
END if;  
         
IF  INSTR(V_text,'&'||'#35;')>0
THEN
V_text:=replace(V_text,'&'||'#35;','#');
ELSE
V_text:=V_text;
END if;  

IF  INSTR(V_text,'&'||'#36;')>0
THEN
V_text:=replace(V_text,'&'||'#36;','$');
ELSE
V_text:=V_text;
END if;

IF  INSTR(V_text,'&'||'#37;')>0
THEN
V_text:=replace(V_text,'&'||'#37;','%');
ELSE
V_text:=V_text;
END if;

--#39 single quote
IF  INSTR(V_text,'&'||'#39;')>0
THEN
V_text:=replace(V_text,'&'||'#39;','''');
ELSE
V_text:=V_text;
END if;
IF  INSTR(V_text,'&'||'#40;')>0
THEN
V_text:=replace(V_text,'&'||'#40;','(');
ELSE
V_text:=V_text;
END if;
IF  INSTR(V_text,'&'||'#41;')>0
THEN
V_text:=replace(V_text,'&'||'#41;',')');
ELSE
V_text:=V_text;
END if;
--    *   &#42; 
IF  INSTR(V_text,'&'||'#42;')>0
THEN
V_text:=replace(V_text,'&'||'#42;','*');
ELSE
V_text:=V_text;
END if;
--    + &#43; 
IF  INSTR(V_text,'&'||'#43;')>0
THEN
V_text:=replace(V_text,'&'||'#43;','+');
ELSE
V_text:=V_text;
END if;           

--    - &#45; 
IF  INSTR(V_text,'&'||'#45;')>0
THEN
V_text:=replace(V_text,'&'||'#45;','-');
ELSE
V_text:=V_text;
END if;   

--    period &#46; 
IF  INSTR(V_text,'&'||'#46;')>0
THEN
V_text:=replace(V_text,'&'||'#46;','.');
ELSE
V_text:=V_text;
END if;   

--    / &#47; 
IF  INSTR(V_text,'&'||'#47;')>0
THEN
V_text:=replace(V_text,'&'||'#47;','/');
ELSE
V_text:=V_text;
END if;   

--    : &#58; 
IF  INSTR(V_text,'&'||'#58;')>0
THEN
V_text:=replace(V_text,'&'||'#58;',':');
ELSE
V_text:=V_text;
END if;   


--    ; &#59; 
IF  INSTR(V_text,'&'||'#59;')>0
THEN
V_text:=replace(V_text,'&'||'#59;',';');
ELSE
V_text:=V_text;
END if;

--   = ; &#61; 
IF  INSTR(V_text,'&'||'#61;')>0
THEN
V_text:=replace(V_text,'&'||'#61;','=');
ELSE
V_text:=V_text;
END if;

--   ? &#63; 
IF  INSTR(V_text,'&'||'#63;')>0
THEN
V_text:=replace(V_text,'&'||'#63;','?');
ELSE
V_text:=V_text;
END if;

--   @ &#64; 
IF  INSTR(V_text,'&'||'#64;')>0
THEN
V_text:=replace(V_text,'&'||'#64;','@');
ELSE
V_text:=V_text;
END if;

--   [ &#91; opening bracket
IF  INSTR(V_text,'&'||'#91;')>0
THEN
V_text:=replace(V_text,'&'||'#91;','[');
ELSE
V_text:=V_text;
END if;
--   \ &#92; backslash
IF  INSTR(V_text,'&'||'#92;')>0
THEN
V_text:=replace(V_text,'&'||'#92;','\');
ELSE
V_text:=V_text;
END if;
--   ] &#93; closing bracket
IF  INSTR(V_text,'&'||'#93;')>0
THEN
V_text:=replace(V_text,'&'||'#93;',']');
ELSE
V_text:=V_text;
END if;
--   ^ &#94; caret - circumflex
IF  INSTR(V_text,'&'||'#94;')>0
THEN
V_text:=replace(V_text,'&'||'#94;','^');
ELSE
V_text:=V_text;
END if;

--  _ &#95; underscore
IF  INSTR(V_text,'&'||'#95;')>0
THEN
V_text:=replace(V_text,'&'||'#95;','_');
ELSE
V_text:=V_text;
END if;

--  {&#123; opening brace
IF  INSTR(V_text,'&'||'#123;')>0
THEN
V_text:=replace(V_text,'&'||'#123;','{');
ELSE
V_text:=V_text;
END if;

--  |&#124; vertical bar
IF  INSTR(V_text,'&'||'#124;')>0
THEN
V_text:=replace(V_text,'&'||'#124;','|');
ELSE
V_text:=V_text;
END if;
--  }&#125; closing brace
IF  INSTR(V_text,'&'||'#125;')>0
THEN
V_text:=replace(V_text,'&'||'#125;','}');
ELSE
V_text:=V_text;
END if;
--  ~&#126; equivalency sign - tilde
IF  INSTR(V_text,'&'||'#126;')>0
THEN
V_text:=replace(V_text,'&'||'#126;','~');
ELSE
V_text:=V_text;
END if;


--   ° &#176; degree sign
IF  INSTR(V_text,'&'||'#176;')>0
THEN
V_text:=replace(V_text,'&'||'#176;','°');
ELSE
V_text:=V_text;
END if;


--   ± &#177; plus-or-minus sign
IF  INSTR(V_text,'&'||'#177;')>0
THEN
V_text:=replace(V_text,'&'||'#177;','±');
ELSE
V_text:=V_text;
END if;
--   ² &#178; superscript two - squared
IF  INSTR(V_text,'&'||'#178;')>0
THEN
V_text:=replace(V_text,'&'||'#178;','²');
ELSE
V_text:=V_text;
END if;

--   ³ &#179; superscript three - cubed
IF  INSTR(V_text,'&'||'#179;')>0
THEN
V_text:=replace(V_text,'&'||'#179;','³');
ELSE
V_text:=V_text;
END if;

--   µ &#181; 
IF  INSTR(V_text,'&'||'#181;')>0
THEN
V_text:=replace(V_text,'&'||'#181;','µ');
ELSE
V_text:=V_text;
END if;
--   ¿&#191; inverted question mark
IF  INSTR(V_text,'&'||'#191;')>0
THEN
V_text:=replace(V_text,'&'||'#191;','¿');
ELSE
V_text:=V_text;
END if;

--   ÷ &#247; division sign
IF  INSTR(V_text,'&'||'#247;')>0
THEN
V_text:=replace(V_text,'&'||'#247;','÷');
ELSE
V_text:=V_text;
END if;




IF  INSTR(V_text,'&'||'#8804;')>0
THEN
V_text:=replace(V_text,'&'||'#8804;','<=');
ELSE
V_text:=V_text;
END if;

IF  INSTR(V_text,'&'||'#8805;')>0
THEN
V_text:=replace(V_text,'&'||'#8805;','>=');
ELSE
V_text:=V_text;
END if;

 IF  INSTR(V_text,'&'||'#8800;')>0
THEN
V_text:=replace(V_text,'&'||'#8800;','<>');
ELSE
V_text:=V_text;
END if;

 IF  INSTR(V_text,'&'||'#8223;')>0
THEN
V_text:=replace(V_text,'&'||'#8223;','''');
ELSE
V_text:=V_text;
END if;

 IF  INSTR(V_text,'&'||'#8322;')>0
THEN
V_text:=replace(V_text,'&'||'#8322;','²');
ELSE
V_text:=V_text;
END if;

RETURN V_text;
END;
/
GRANT EXECUTE ON meta_CleanSP_CHAR TO SBR;


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
WHERE INSTR(short_meaning ,'&'||'gt;')>0 or
 INSTR(short_meaning ,'&'||'lt;')>0 or
 INSTR(short_meaning ,'&'||'amp;')>0 or
 INSTR(short_meaning ,'&'||'#32;')>0 or
 INSTR(short_meaning ,'&'||'#33;')>0 or
 INSTR(short_meaning ,'&'||'#34;')>0 or
 INSTR(short_meaning ,'&'||'#35;')>0 or
 INSTR(short_meaning ,'&'||'#36;')>0 or
 INSTR(short_meaning ,'&'||'#37;')>0 or
 INSTR(short_meaning ,'&'||'#38;')>0 or
 INSTR(short_meaning ,'&'||'#39;')>0 or
 INSTR(short_meaning ,'&'||'#40;')>0 or
 INSTR(short_meaning ,'&'||'#41;')>0 or
 INSTR(short_meaning ,'&'||'#42;')>0 or
 INSTR(short_meaning ,'&'||'#43;')>0 or
 INSTR(short_meaning ,'&'||'#44;')>0 or
 INSTR(short_meaning ,'&'||'#45;')>0 or
 INSTR(short_meaning ,'&'||'#46;')>0 or
 INSTR(short_meaning ,'&'||'#47;')>0 or
 INSTR(short_meaning ,'&'||'#58;')>0 or
 INSTR(short_meaning ,'&'||'#59;')>0 or
 INSTR(short_meaning ,'&'||'#60;')>0 or
 INSTR(short_meaning ,'&'||'#61;')>0 or
 INSTR(short_meaning ,'&'||'#62;')>0 or
 INSTR(short_meaning ,'&'||'#63;')>0 or
 INSTR(short_meaning ,'&'||'#64;')>0 or
 INSTR(short_meaning ,'&'||'#91;')>0 or
 INSTR(short_meaning ,'&'||'#92;')>0 or
 INSTR(short_meaning ,'&'||'#93;')>0 or
 INSTR(short_meaning ,'&'||'#94;')>0 or
 INSTR(short_meaning ,'&'||'#95;')>0 or
 INSTR(short_meaning ,'&'||'#123;')>0 or
 INSTR(short_meaning ,'&'||'#124;')>0 or
 INSTR(short_meaning ,'&'||'#125;')>0 or
 INSTR(short_meaning ,'&'||'#126;')>0 or
 INSTR(short_meaning ,'&'||'#176;')>0 or
 INSTR(short_meaning ,'&'||'#177;')>0 or
 INSTR(short_meaning ,'&'||'#178;')>0 or
 INSTR(short_meaning ,'&'||'#179;')>0 or
 INSTR(short_meaning ,'&'||'#181;')>0 or
 INSTR(short_meaning ,'&'||'#191;')>0 or
 INSTR(short_meaning ,'&'||'#247;')>0 or
 INSTR(short_meaning ,'&'||'#8804;')>0 or
 INSTR(short_meaning ,'&'||'#8805;')>0 or 
 INSTR(short_meaning ,'&'||'#8800;')>0 or 
 INSTR(short_meaning ,'&'||'#8223;')>0 or
 INSTR(short_meaning ,'&'||'#8322;')>0 or
 INSTR(DESCRIPTION  ,'&'||'gt;')>0 or
 INSTR(DESCRIPTION  ,'&'||'lt;')>0 or
 INSTR(DESCRIPTION  ,'&'||'amp;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#32;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#33;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#34;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#35;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#36;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#37;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#38;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#39;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#40;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#41;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#42;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#43;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#44;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#45;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#46;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#47;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#58;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#59;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#60;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#61;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#62;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#63;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#64;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#91;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#92;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#93;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#94;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#95;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#123;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#124;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#125;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#126;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#176;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#177;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#178;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#179;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#181;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#191;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#247;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#8804;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#8805;')>0 or 
 INSTR(DESCRIPTION  ,'&'||'#8800;')>0 or 
 INSTR(DESCRIPTION  ,'&'||'#8223;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#8322;')>0; 

commit;

UPDATE SBR.CD_VMS set 
date_modified=v_date, modified_by='DWARZEL',
short_meaning=SBREXT.meta_CleanSP_CHAR(short_meaning) 
where ((instr(short_meaning ,'&'||'#')> 0  and instr(short_meaning ,';')> 0)
or INSTR(short_meaning,'&'||'gt;')>0 
or INSTR(short_meaning,'&'||'lt;')>0 
or  INSTR(short_meaning,'&'||'amp;')>0 )
;


UPDATE SBR.CD_VMS set 
date_modified=v_date, modified_by='DWARZEL',
DESCRIPTION=SBREXT.meta_CleanSP_CHAR(DESCRIPTION)
where((instr(DESCRIPTION ,'&'||'#')> 0 and instr(DESCRIPTION ,';')> 0)
or INSTR(DESCRIPTION,'&'||'gt;')>0 
or INSTR(DESCRIPTION,'&'||'lt;')>0 
or  INSTR(DESCRIPTION,'&'||'amp;')>0 )
 ;

                                                                        
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
and(INSTR(r.NAME ,'&'||'gt;')>0 or
 INSTR(r.NAME ,'&'||'lt;')>0 or
 INSTR(r.NAME ,'&'||'amp;')>0 or
 INSTR(r.NAME ,'&'||'#32;')>0 or
 INSTR(r.NAME ,'&'||'#33;')>0 or
 INSTR(r.NAME ,'&'||'#34;')>0 or
 INSTR(r.NAME ,'&'||'#35;')>0 or
 INSTR(r.NAME ,'&'||'#36;')>0 or
 INSTR(r.NAME ,'&'||'#37;')>0 or
 INSTR(r.NAME ,'&'||'#38;')>0 or
 INSTR(r.NAME ,'&'||'#39;')>0 or
 INSTR(r.NAME ,'&'||'#40;')>0 or
 INSTR(r.NAME ,'&'||'#41;')>0 or
 INSTR(r.NAME ,'&'||'#42;')>0 or
 INSTR(r.NAME ,'&'||'#43;')>0 or
 INSTR(r.NAME ,'&'||'#44;')>0 or
 INSTR(r.NAME ,'&'||'#45;')>0 or
 INSTR(r.NAME ,'&'||'#46;')>0 or
 INSTR(r.NAME ,'&'||'#47;')>0 or
 INSTR(r.NAME ,'&'||'#58;')>0 or
 INSTR(r.NAME ,'&'||'#59;')>0 or
 INSTR(r.NAME ,'&'||'#60;')>0 or
 INSTR(r.NAME ,'&'||'#61;')>0 or
 INSTR(r.NAME ,'&'||'#62;')>0 or
 INSTR(r.NAME ,'&'||'#63;')>0 or
 INSTR(r.NAME ,'&'||'#64;')>0 or
 INSTR(r.NAME ,'&'||'#91;')>0 or
 INSTR(r.NAME ,'&'||'#92;')>0 or
 INSTR(r.NAME ,'&'||'#93;')>0 or
 INSTR(r.NAME ,'&'||'#94;')>0 or
 INSTR(r.NAME ,'&'||'#95;')>0 or
 INSTR(r.NAME ,'&'||'#123;')>0 or
 INSTR(r.NAME ,'&'||'#124;')>0 or
 INSTR(r.NAME ,'&'||'#125;')>0 or
 INSTR(r.NAME ,'&'||'#126;')>0 or
 INSTR(r.NAME ,'&'||'#176;')>0 or
 INSTR(r.NAME ,'&'||'#177;')>0 or
 INSTR(r.NAME ,'&'||'#178;')>0 or
 INSTR(r.NAME ,'&'||'#179;')>0 or
 INSTR(r.NAME ,'&'||'#181;')>0 or
 INSTR(r.NAME ,'&'||'#191;')>0 or
 INSTR(r.NAME ,'&'||'#247;')>0 or
 INSTR(r.NAME ,'&'||'#8804;')>0 or
 INSTR(r.NAME ,'&'||'#8805;')>0 or 
 INSTR(r.NAME ,'&'||'#8800;')>0 or 
 INSTR(r.NAME ,'&'||'#8223;')>0 or
 INSTR(r.NAME ,'&'||'#8322;')>0 )
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
where (INSTR(NAME ,'&'||'gt;')>0 or
 INSTR(NAME ,'&'||'lt;')>0 or
 INSTR(NAME ,'&'||'amp;')>0 or
 INSTR(NAME ,'&'||'#32;')>0 or
 INSTR(NAME ,'&'||'#33;')>0 or
 INSTR(NAME ,'&'||'#34;')>0 or
 INSTR(NAME ,'&'||'#35;')>0 or
 INSTR(NAME ,'&'||'#36;')>0 or
 INSTR(NAME ,'&'||'#37;')>0 or
 INSTR(NAME ,'&'||'#38;')>0 or
 INSTR(NAME ,'&'||'#39;')>0 or
 INSTR(NAME ,'&'||'#40;')>0 or
 INSTR(NAME ,'&'||'#41;')>0 or
 INSTR(NAME ,'&'||'#42;')>0 or
 INSTR(NAME ,'&'||'#43;')>0 or
 INSTR(NAME ,'&'||'#44;')>0 or
 INSTR(NAME ,'&'||'#45;')>0 or
 INSTR(NAME ,'&'||'#46;')>0 or
 INSTR(NAME ,'&'||'#47;')>0 or
 INSTR(NAME ,'&'||'#58;')>0 or
 INSTR(NAME ,'&'||'#59;')>0 or
 INSTR(NAME ,'&'||'#60;')>0 or
 INSTR(NAME ,'&'||'#61;')>0 or
 INSTR(NAME ,'&'||'#62;')>0 or
 INSTR(NAME ,'&'||'#63;')>0 or
 INSTR(NAME ,'&'||'#64;')>0 or
 INSTR(NAME ,'&'||'#91;')>0 or
 INSTR(NAME ,'&'||'#92;')>0 or
 INSTR(NAME ,'&'||'#93;')>0 or
 INSTR(NAME ,'&'||'#94;')>0 or
 INSTR(NAME ,'&'||'#95;')>0 or
 INSTR(NAME ,'&'||'#123;')>0 or
 INSTR(NAME ,'&'||'#124;')>0 or
 INSTR(NAME ,'&'||'#125;')>0 or
 INSTR(NAME ,'&'||'#126;')>0 or
 INSTR(NAME ,'&'||'#176;')>0 or
 INSTR(NAME ,'&'||'#177;')>0 or
 INSTR(NAME ,'&'||'#178;')>0 or
 INSTR(NAME ,'&'||'#179;')>0 or
 INSTR(NAME ,'&'||'#181;')>0 or
 INSTR(NAME ,'&'||'#191;')>0 or
 INSTR(NAME ,'&'||'#247;')>0 or
 INSTR(NAME ,'&'||'#8804;')>0 or
 INSTR(NAME ,'&'||'#8805;')>0 or 
 INSTR(NAME ,'&'||'#8800;')>0 or 
 INSTR(NAME ,'&'||'#8223;')>0 or
 INSTR(NAME ,'&'||'#8322;')>0 or
INSTR(DOC_TEXT ,'&'||'gt;')>0 or
 INSTR(DOC_TEXT ,'&'||'lt;')>0 or
 INSTR(DOC_TEXT ,'&'||'amp;')>0 or
 INSTR(DOC_TEXT ,'&'||'#32;')>0 or
 INSTR(DOC_TEXT ,'&'||'#33;')>0 or
 INSTR(DOC_TEXT ,'&'||'#34;')>0 or
 INSTR(DOC_TEXT ,'&'||'#35;')>0 or
 INSTR(DOC_TEXT ,'&'||'#36;')>0 or
 INSTR(DOC_TEXT ,'&'||'#37;')>0 or
 INSTR(DOC_TEXT ,'&'||'#38;')>0 or
 INSTR(DOC_TEXT ,'&'||'#39;')>0 or
 INSTR(DOC_TEXT ,'&'||'#40;')>0 or
 INSTR(DOC_TEXT ,'&'||'#41;')>0 or
 INSTR(DOC_TEXT ,'&'||'#42;')>0 or
 INSTR(DOC_TEXT ,'&'||'#43;')>0 or
 INSTR(DOC_TEXT ,'&'||'#44;')>0 or
 INSTR(DOC_TEXT ,'&'||'#45;')>0 or
 INSTR(DOC_TEXT ,'&'||'#46;')>0 or
 INSTR(DOC_TEXT ,'&'||'#47;')>0 or
 INSTR(DOC_TEXT ,'&'||'#58;')>0 or
 INSTR(DOC_TEXT ,'&'||'#59;')>0 or
 INSTR(DOC_TEXT ,'&'||'#60;')>0 or
 INSTR(DOC_TEXT ,'&'||'#61;')>0 or
 INSTR(DOC_TEXT ,'&'||'#62;')>0 or
 INSTR(DOC_TEXT ,'&'||'#63;')>0 or
 INSTR(DOC_TEXT ,'&'||'#64;')>0 or
 INSTR(DOC_TEXT ,'&'||'#91;')>0 or
 INSTR(DOC_TEXT ,'&'||'#92;')>0 or
 INSTR(DOC_TEXT ,'&'||'#93;')>0 or
 INSTR(DOC_TEXT ,'&'||'#94;')>0 or
 INSTR(DOC_TEXT ,'&'||'#95;')>0 or
 INSTR(DOC_TEXT ,'&'||'#123;')>0 or
 INSTR(DOC_TEXT ,'&'||'#124;')>0 or
 INSTR(DOC_TEXT ,'&'||'#125;')>0 or
 INSTR(DOC_TEXT ,'&'||'#126;')>0 or
 INSTR(DOC_TEXT ,'&'||'#176;')>0 or
 INSTR(DOC_TEXT ,'&'||'#177;')>0 or
 INSTR(DOC_TEXT ,'&'||'#178;')>0 or
 INSTR(DOC_TEXT ,'&'||'#179;')>0 or
 INSTR(DOC_TEXT ,'&'||'#181;')>0 or
 INSTR(DOC_TEXT ,'&'||'#191;')>0 or
 INSTR(DOC_TEXT ,'&'||'#247;')>0 or
 INSTR(DOC_TEXT ,'&'||'#8804;')>0 or
 INSTR(DOC_TEXT ,'&'||'#8805;')>0 or 
 INSTR(DOC_TEXT ,'&'||'#8800;')>0 or 
 INSTR(DOC_TEXT ,'&'||'#8223;')>0 or
 INSTR(DOC_TEXT ,'&'||'#8322;')>0)
and RD_IDSEQ not in (select distinct RD_IDSEQ from SBR.CT_REF_DOC_BKUP where comments='Duplicate') ;
commit;

UPDATE SBR.REFERENCE_DOCUMENTS set
date_modified=v_date, modified_by='DWARZEL',
NAME=SBREXT.meta_CleanSP_CHAR(name)
where ((instr(NAME ,'&'||'#')> 0  and instr(NAME ,';')> 0)
or INSTR(NAME,'&'||'gt;')>0
or INSTR(NAME,'&'||'lt;')>0
or  INSTR(NAME,'&'||'amp;')>0 )
and RD_IDSEQ not in (select distinct RD_IDSEQ from SBR.CT_REF_DOC_BKUP where comments='Duplicate') ;


UPDATE SBR.REFERENCE_DOCUMENTS set
date_modified=v_date, modified_by='DWARZEL',
DOC_TEXT=SBREXT.meta_CleanSP_CHAR(DOC_TEXT)
where((instr(DOC_TEXT ,'&'||'#')> 0 and instr(DOC_TEXT ,';')> 0)
or INSTR(DOC_TEXT,'&'||'gt;')>0
or INSTR(DOC_TEXT,'&'||'lt;')>0
or  INSTR(DOC_TEXT,'&'||'amp;')>0 )
and RD_IDSEQ not in (select distinct RD_IDSEQ from SBR.CT_REF_DOC_BKUP where comments='Duplicate') ;

 commit;

 EXCEPTION

    WHEN OTHERS THEN

    errmsg := substr(SQLERRM,1,2000);
         dbms_output.put_line('errmsg  - '||errmsg);
        insert into SBREXT.META_SPCHAR_ERROR_LOG VALUES('META_FIX_REF_DOC',   sysdate ,errmsg);

     commit;
END META_FIX_REF_DOC;
/
CREATE OR REPLACE PROCEDURE SBR.META_FIX_SP_CHAR_PV IS
v_date  date  ;
V_sdate date:=sysdate;
errmsg VARCHAR2(2000):='Non';
/******************************************************************************
   NAME:       META_FIX_sp_char_VM
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
WHERE INSTR(short_meaning ,'&'||'gt;')>0 or
 INSTR(short_meaning ,'&'||'lt;')>0 or
 INSTR(short_meaning ,'&'||'amp;')>0 or
 INSTR(short_meaning ,'&'||'#32;')>0 or
 INSTR(short_meaning ,'&'||'#33;')>0 or
 INSTR(short_meaning ,'&'||'#34;')>0 or
 INSTR(short_meaning ,'&'||'#35;')>0 or
 INSTR(short_meaning ,'&'||'#36;')>0 or
 INSTR(short_meaning ,'&'||'#37;')>0 or
 INSTR(short_meaning ,'&'||'#38;')>0 or
 INSTR(short_meaning ,'&'||'#39;')>0 or
 INSTR(short_meaning ,'&'||'#40;')>0 or
 INSTR(short_meaning ,'&'||'#41;')>0 or
 INSTR(short_meaning ,'&'||'#42;')>0 or
 INSTR(short_meaning ,'&'||'#43;')>0 or
 INSTR(short_meaning ,'&'||'#44;')>0 or
 INSTR(short_meaning ,'&'||'#45;')>0 or
 INSTR(short_meaning ,'&'||'#46;')>0 or
 INSTR(short_meaning ,'&'||'#47;')>0 or
 INSTR(short_meaning ,'&'||'#58;')>0 or
 INSTR(short_meaning ,'&'||'#59;')>0 or
 INSTR(short_meaning ,'&'||'#60;')>0 or
 INSTR(short_meaning ,'&'||'#61;')>0 or
 INSTR(short_meaning ,'&'||'#62;')>0 or
 INSTR(short_meaning ,'&'||'#63;')>0 or
 INSTR(short_meaning ,'&'||'#64;')>0 or
 INSTR(short_meaning ,'&'||'#91;')>0 or
 INSTR(short_meaning ,'&'||'#92;')>0 or
 INSTR(short_meaning ,'&'||'#93;')>0 or
 INSTR(short_meaning ,'&'||'#94;')>0 or
 INSTR(short_meaning ,'&'||'#95;')>0 or
 INSTR(short_meaning ,'&'||'#123;')>0 or
 INSTR(short_meaning ,'&'||'#124;')>0 or
 INSTR(short_meaning ,'&'||'#125;')>0 or
 INSTR(short_meaning ,'&'||'#126;')>0 or
 INSTR(short_meaning ,'&'||'#176;')>0 or
 INSTR(short_meaning ,'&'||'#177;')>0 or
 INSTR(short_meaning ,'&'||'#178;')>0 or
 INSTR(short_meaning ,'&'||'#179;')>0 or
 INSTR(short_meaning ,'&'||'#181;')>0 or
 INSTR(short_meaning ,'&'||'#191;')>0 or
 INSTR(short_meaning ,'&'||'#247;')>0 or
 INSTR(short_meaning ,'&'||'#8804;')>0 or
 INSTR(short_meaning ,'&'||'#8805;')>0 or 
 INSTR(short_meaning ,'&'||'#8800;')>0 or 
 INSTR(short_meaning ,'&'||'#8223;')>0 or
 INSTR(short_meaning ,'&'||'#8322;')>0 or
 INSTR(MEANING_DESCRIPTION  ,'&'||'gt;')>0 or
 INSTR(MEANING_DESCRIPTION  ,'&'||'lt;')>0 or
 INSTR(MEANING_DESCRIPTION  ,'&'||'amp;')>0 or
 INSTR(MEANING_DESCRIPTION  ,'&'||'#32;')>0 or
 INSTR(MEANING_DESCRIPTION  ,'&'||'#33;')>0 or
 INSTR(MEANING_DESCRIPTION  ,'&'||'#34;')>0 or
 INSTR(MEANING_DESCRIPTION  ,'&'||'#35;')>0 or
 INSTR(MEANING_DESCRIPTION  ,'&'||'#36;')>0 or
 INSTR(MEANING_DESCRIPTION  ,'&'||'#37;')>0 or
 INSTR(MEANING_DESCRIPTION  ,'&'||'#38;')>0 or
 INSTR(MEANING_DESCRIPTION  ,'&'||'#39;')>0 or
 INSTR(MEANING_DESCRIPTION  ,'&'||'#40;')>0 or
 INSTR(MEANING_DESCRIPTION  ,'&'||'#41;')>0 or
 INSTR(MEANING_DESCRIPTION  ,'&'||'#42;')>0 or
 INSTR(MEANING_DESCRIPTION  ,'&'||'#43;')>0 or
 INSTR(MEANING_DESCRIPTION  ,'&'||'#44;')>0 or
 INSTR(MEANING_DESCRIPTION  ,'&'||'#45;')>0 or
 INSTR(MEANING_DESCRIPTION  ,'&'||'#46;')>0 or
 INSTR(MEANING_DESCRIPTION  ,'&'||'#47;')>0 or
 INSTR(MEANING_DESCRIPTION  ,'&'||'#58;')>0 or
 INSTR(MEANING_DESCRIPTION  ,'&'||'#59;')>0 or
 INSTR(MEANING_DESCRIPTION  ,'&'||'#60;')>0 or
 INSTR(MEANING_DESCRIPTION  ,'&'||'#61;')>0 or
 INSTR(MEANING_DESCRIPTION  ,'&'||'#62;')>0 or
 INSTR(MEANING_DESCRIPTION  ,'&'||'#63;')>0 or
 INSTR(MEANING_DESCRIPTION  ,'&'||'#64;')>0 or
 INSTR(MEANING_DESCRIPTION  ,'&'||'#91;')>0 or
 INSTR(MEANING_DESCRIPTION  ,'&'||'#92;')>0 or
 INSTR(MEANING_DESCRIPTION  ,'&'||'#93;')>0 or
 INSTR(MEANING_DESCRIPTION  ,'&'||'#94;')>0 or
 INSTR(MEANING_DESCRIPTION  ,'&'||'#95;')>0 or
 INSTR(MEANING_DESCRIPTION  ,'&'||'#123;')>0 or
 INSTR(MEANING_DESCRIPTION  ,'&'||'#124;')>0 or
 INSTR(MEANING_DESCRIPTION  ,'&'||'#125;')>0 or
 INSTR(MEANING_DESCRIPTION  ,'&'||'#126;')>0 or
 INSTR(MEANING_DESCRIPTION  ,'&'||'#176;')>0 or
 INSTR(MEANING_DESCRIPTION  ,'&'||'#177;')>0 or
 INSTR(MEANING_DESCRIPTION  ,'&'||'#178;')>0 or
 INSTR(MEANING_DESCRIPTION  ,'&'||'#179;')>0 or
 INSTR(MEANING_DESCRIPTION  ,'&'||'#181;')>0 or
 INSTR(MEANING_DESCRIPTION  ,'&'||'#191;')>0 or
 INSTR(MEANING_DESCRIPTION  ,'&'||'#247;')>0 or
 INSTR(MEANING_DESCRIPTION  ,'&'||'#8804;')>0 or
 INSTR(MEANING_DESCRIPTION  ,'&'||'#8805;')>0 or 
 INSTR(MEANING_DESCRIPTION  ,'&'||'#8800;')>0 or 
 INSTR(MEANING_DESCRIPTION  ,'&'||'#8223;')>0 or
 INSTR(MEANING_DESCRIPTION  ,'&'||'#8322;')>0;
commit;

UPDATE SBR.PERMISSIBLE_VALUES set 
date_modified=v_date, modified_by='DWARZEL',
short_meaning=SBREXT.meta_CleanSP_CHAR(short_meaning) 
where ((instr(short_meaning ,'&'||'#')> 0  and instr(short_meaning ,';')> 0)
or INSTR(short_meaning,'&'||'gt;')>0 
or INSTR(short_meaning,'&'||'lt;')>0 
or  INSTR(short_meaning,'&'||'amp;')>0 )
;


UPDATE SBR.PERMISSIBLE_VALUES set 
date_modified=v_date, modified_by='DWARZEL',
MEANING_DESCRIPTION=SBREXT.meta_CleanSP_CHAR(MEANING_DESCRIPTION)
where((instr(MEANING_DESCRIPTION ,'&'||'#')> 0 and instr(MEANING_DESCRIPTION ,';')> 0)
or INSTR(MEANING_DESCRIPTION,'&'||'gt;')>0 
or INSTR(MEANING_DESCRIPTION,'&'||'lt;')>0 
or  INSTR(MEANING_DESCRIPTION,'&'||'amp;')>0 )
and SBREXT.meta_CleanSP_CHAR(MEANING_DESCRIPTION) not like'%¿%'  ;
 commit;

 EXCEPTION
 
    WHEN OTHERS THEN   
    
    errmsg := substr(SQLERRM,1,2000);
         dbms_output.put_line('errmsg  - '||errmsg);
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
where INSTR(LONG_NAME,'&'||'gt;')>0 or
 INSTR(LONG_NAME,'&'||'lt;')>0 or
 INSTR(LONG_NAME,'&'||'amp;')>0 or
 INSTR(LONG_NAME,'&'||'#32;')>0 or
 INSTR(LONG_NAME,'&'||'#33;')>0 or
 INSTR(LONG_NAME,'&'||'#34;')>0 or
 INSTR(LONG_NAME,'&'||'#35;')>0 or
 INSTR(LONG_NAME,'&'||'#36;')>0 or
 INSTR(LONG_NAME,'&'||'#37;')>0 or
 INSTR(LONG_NAME,'&'||'#38;')>0 or
 INSTR(LONG_NAME,'&'||'#39;')>0 or
 INSTR(LONG_NAME,'&'||'#40;')>0 or
 INSTR(LONG_NAME,'&'||'#41;')>0 or
 INSTR(LONG_NAME,'&'||'#42;')>0 or
 INSTR(LONG_NAME,'&'||'#43;')>0 or
 INSTR(LONG_NAME,'&'||'#44;')>0 or
 INSTR(LONG_NAME,'&'||'#45;')>0 or
 INSTR(LONG_NAME,'&'||'#46;')>0 or
 INSTR(LONG_NAME,'&'||'#47;')>0 or
 INSTR(LONG_NAME,'&'||'#58;')>0 or
 INSTR(LONG_NAME,'&'||'#59;')>0 or
 INSTR(LONG_NAME,'&'||'#60;')>0 or
 INSTR(LONG_NAME,'&'||'#61;')>0 or
 INSTR(LONG_NAME,'&'||'#62;')>0 or
 INSTR(LONG_NAME,'&'||'#63;')>0 or
 INSTR(LONG_NAME,'&'||'#64;')>0 or
 INSTR(LONG_NAME,'&'||'#91;')>0 or
 INSTR(LONG_NAME,'&'||'#92;')>0 or
 INSTR(LONG_NAME,'&'||'#93;')>0 or
 INSTR(LONG_NAME,'&'||'#94;')>0 or
 INSTR(LONG_NAME,'&'||'#95;')>0 or
 INSTR(LONG_NAME,'&'||'#123;')>0 or
 INSTR(LONG_NAME,'&'||'#124;')>0 or
 INSTR(LONG_NAME,'&'||'#125;')>0 or
 INSTR(LONG_NAME,'&'||'#126;')>0 or
 INSTR(LONG_NAME,'&'||'#176;')>0 or
 INSTR(LONG_NAME,'&'||'#177;')>0 or
 INSTR(LONG_NAME,'&'||'#178;')>0 or
 INSTR(LONG_NAME,'&'||'#179;')>0 or
 INSTR(LONG_NAME,'&'||'#181;')>0 or
 INSTR(LONG_NAME,'&'||'#191;')>0 or
 INSTR(LONG_NAME,'&'||'#247;')>0 or
 INSTR(LONG_NAME,'&'||'#8804;')>0 or
 INSTR(LONG_NAME,'&'||'#8805;')>0 or 
 INSTR(LONG_NAME,'&'||'#8800;')>0 or 
 INSTR(LONG_NAME,'&'||'#8223;')>0 or
 INSTR(LONG_NAME,'&'||'#8322;')>0 or
INSTR(PREFERRED_DEFINITION ,'&'||'gt;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'lt;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'amp;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#32;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#33;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#34;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#35;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#36;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#37;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#38;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#39;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#40;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#41;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#42;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#43;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#44;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#45;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#46;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#47;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#58;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#59;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#60;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#61;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#62;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#63;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#64;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#91;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#92;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#93;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#94;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#95;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#123;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#124;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#125;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#126;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#176;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#177;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#178;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#179;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#181;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#191;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#247;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#8804;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#8805;')>0 or 
 INSTR(PREFERRED_DEFINITION ,'&'||'#8800;')>0 or 
 INSTR(PREFERRED_DEFINITION ,'&'||'#8223;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#8322;')>0 or
 INSTR(short_meaning ,'&'||'gt;')>0 or
 INSTR(short_meaning ,'&'||'lt;')>0 or
 INSTR(short_meaning ,'&'||'amp;')>0 or
 INSTR(short_meaning ,'&'||'#32;')>0 or
 INSTR(short_meaning ,'&'||'#33;')>0 or
 INSTR(short_meaning ,'&'||'#34;')>0 or
 INSTR(short_meaning ,'&'||'#35;')>0 or
 INSTR(short_meaning ,'&'||'#36;')>0 or
 INSTR(short_meaning ,'&'||'#37;')>0 or
 INSTR(short_meaning ,'&'||'#38;')>0 or
 INSTR(short_meaning ,'&'||'#39;')>0 or
 INSTR(short_meaning ,'&'||'#40;')>0 or
 INSTR(short_meaning ,'&'||'#41;')>0 or
 INSTR(short_meaning ,'&'||'#42;')>0 or
 INSTR(short_meaning ,'&'||'#43;')>0 or
 INSTR(short_meaning ,'&'||'#44;')>0 or
 INSTR(short_meaning ,'&'||'#45;')>0 or
 INSTR(short_meaning ,'&'||'#46;')>0 or
 INSTR(short_meaning ,'&'||'#47;')>0 or
 INSTR(short_meaning ,'&'||'#58;')>0 or
 INSTR(short_meaning ,'&'||'#59;')>0 or
 INSTR(short_meaning ,'&'||'#60;')>0 or
 INSTR(short_meaning ,'&'||'#61;')>0 or
 INSTR(short_meaning ,'&'||'#62;')>0 or
 INSTR(short_meaning ,'&'||'#63;')>0 or
 INSTR(short_meaning ,'&'||'#64;')>0 or
 INSTR(short_meaning ,'&'||'#91;')>0 or
 INSTR(short_meaning ,'&'||'#92;')>0 or
 INSTR(short_meaning ,'&'||'#93;')>0 or
 INSTR(short_meaning ,'&'||'#94;')>0 or
 INSTR(short_meaning ,'&'||'#95;')>0 or
 INSTR(short_meaning ,'&'||'#123;')>0 or
 INSTR(short_meaning ,'&'||'#124;')>0 or
 INSTR(short_meaning ,'&'||'#125;')>0 or
 INSTR(short_meaning ,'&'||'#126;')>0 or
 INSTR(short_meaning ,'&'||'#176;')>0 or
 INSTR(short_meaning ,'&'||'#177;')>0 or
 INSTR(short_meaning ,'&'||'#178;')>0 or
 INSTR(short_meaning ,'&'||'#179;')>0 or
 INSTR(short_meaning ,'&'||'#181;')>0 or
 INSTR(short_meaning ,'&'||'#191;')>0 or
 INSTR(short_meaning ,'&'||'#247;')>0 or
 INSTR(short_meaning ,'&'||'#8804;')>0 or
 INSTR(short_meaning ,'&'||'#8805;')>0 or 
 INSTR(short_meaning ,'&'||'#8800;')>0 or 
 INSTR(short_meaning ,'&'||'#8223;')>0 or
 INSTR(short_meaning ,'&'||'#8322;')>0 or
 INSTR(DESCRIPTION  ,'&'||'gt;')>0 or
 INSTR(DESCRIPTION  ,'&'||'lt;')>0 or
 INSTR(DESCRIPTION  ,'&'||'amp;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#32;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#33;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#34;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#35;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#36;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#37;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#38;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#39;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#40;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#41;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#42;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#43;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#44;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#45;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#46;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#47;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#58;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#59;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#60;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#61;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#62;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#63;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#64;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#91;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#92;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#93;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#94;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#95;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#123;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#124;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#125;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#126;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#176;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#177;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#178;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#179;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#181;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#191;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#247;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#8804;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#8805;')>0 or 
 INSTR(DESCRIPTION  ,'&'||'#8800;')>0 or 
 INSTR(DESCRIPTION  ,'&'||'#8223;')>0 or
 INSTR(DESCRIPTION  ,'&'||'#8322;')>0;
commit;



UPDATE SBR.VALUE_MEANINGS set 
date_modified=v_date, modified_by='DWARZEL',
short_meaning=SBREXT.meta_CleanSP_CHAR(short_meaning) 
where ((instr(short_meaning ,'&'||'#')> 0  and instr(short_meaning ,';')> 0)
or INSTR(short_meaning,'&'||'gt;')>0 
or INSTR(short_meaning,'&'||'lt;')>0 
or  INSTR(short_meaning,'&'||'amp;')>0 )
;


UPDATE SBR.VALUE_MEANINGS set 
date_modified=v_date, modified_by='DWARZEL',
DESCRIPTION=SBREXT.meta_CleanSP_CHAR(DESCRIPTION)
where((instr(DESCRIPTION ,'&'||'#')> 0 and instr(DESCRIPTION ,';')> 0)
or INSTR(DESCRIPTION,'&'||'gt;')>0 
or INSTR(DESCRIPTION,'&'||'lt;')>0 
or  INSTR(DESCRIPTION,'&'||'amp;')>0 )
 ;
 

UPDATE SBR.VALUE_MEANINGS set 
date_modified=v_date, modified_by='DWARZEL',
LONG_NAME=SBREXT.meta_CleanSP_CHAR(LONG_NAME) 
where ((instr(LONG_NAME ,'&'||'#')> 0  and instr(LONG_NAME ,';')> 0)
or INSTR(LONG_NAME,'&'||'gt;')>0 
or INSTR(LONG_NAME,'&'||'lt;')>0 
or  INSTR(LONG_NAME,'&'||'amp;')>0 )
and SBREXT.meta_CleanSP_CHAR(LONG_NAME) not like'%¿%';


UPDATE SBR.VALUE_MEANINGS set 
date_modified=v_date, modified_by='DWARZEL',
preferred_definition=SBREXT.meta_CleanSP_CHAR(preferred_definition)
where((instr(preferred_definition ,'&'||'#')> 0 and instr(preferred_definition ,';')> 0)
or INSTR(preferred_definition,'&'||'gt;')>0 
or INSTR(preferred_definition,'&'||'lt;')>0 
or  INSTR(preferred_definition,'&'||'amp;')>0 )
;

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
where INSTR(LONG_NAME,'&'||'gt;')>0 or
 INSTR(LONG_NAME,'&'||'lt;')>0 or
 INSTR(LONG_NAME,'&'||'amp;')>0 or
 INSTR(LONG_NAME,'&'||'#32;')>0 or
 INSTR(LONG_NAME,'&'||'#33;')>0 or
 INSTR(LONG_NAME,'&'||'#34;')>0 or
 INSTR(LONG_NAME,'&'||'#35;')>0 or
 INSTR(LONG_NAME,'&'||'#36;')>0 or
 INSTR(LONG_NAME,'&'||'#37;')>0 or
 INSTR(LONG_NAME,'&'||'#38;')>0 or
 INSTR(LONG_NAME,'&'||'#39;')>0 or
 INSTR(LONG_NAME,'&'||'#40;')>0 or
 INSTR(LONG_NAME,'&'||'#41;')>0 or
 INSTR(LONG_NAME,'&'||'#42;')>0 or
 INSTR(LONG_NAME,'&'||'#43;')>0 or
 INSTR(LONG_NAME,'&'||'#44;')>0 or
 INSTR(LONG_NAME,'&'||'#45;')>0 or
 INSTR(LONG_NAME,'&'||'#46;')>0 or
 INSTR(LONG_NAME,'&'||'#47;')>0 or
 INSTR(LONG_NAME,'&'||'#58;')>0 or
 INSTR(LONG_NAME,'&'||'#59;')>0 or
 INSTR(LONG_NAME,'&'||'#60;')>0 or
 INSTR(LONG_NAME,'&'||'#61;')>0 or
 INSTR(LONG_NAME,'&'||'#62;')>0 or
 INSTR(LONG_NAME,'&'||'#63;')>0 or
 INSTR(LONG_NAME,'&'||'#64;')>0 or
 INSTR(LONG_NAME,'&'||'#91;')>0 or
 INSTR(LONG_NAME,'&'||'#92;')>0 or
 INSTR(LONG_NAME,'&'||'#93;')>0 or
 INSTR(LONG_NAME,'&'||'#94;')>0 or
 INSTR(LONG_NAME,'&'||'#95;')>0 or
 INSTR(LONG_NAME,'&'||'#123;')>0 or
 INSTR(LONG_NAME,'&'||'#124;')>0 or
 INSTR(LONG_NAME,'&'||'#125;')>0 or
 INSTR(LONG_NAME,'&'||'#126;')>0 or
 INSTR(LONG_NAME,'&'||'#176;')>0 or
 INSTR(LONG_NAME,'&'||'#177;')>0 or
 INSTR(LONG_NAME,'&'||'#178;')>0 or
 INSTR(LONG_NAME,'&'||'#179;')>0 or
 INSTR(LONG_NAME,'&'||'#181;')>0 or
 INSTR(LONG_NAME,'&'||'#191;')>0 or
 INSTR(LONG_NAME,'&'||'#247;')>0 or
 INSTR(LONG_NAME,'&'||'#8804;')>0 or
 INSTR(LONG_NAME,'&'||'#8805;')>0 or 
 INSTR(LONG_NAME,'&'||'#8800;')>0 or 
 INSTR(LONG_NAME,'&'||'#8223;')>0 or
 INSTR(LONG_NAME,'&'||'#8322;')>0 or
INSTR(PREFERRED_DEFINITION ,'&'||'gt;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'lt;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'amp;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#32;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#33;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#34;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#35;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#36;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#37;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#38;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#39;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#40;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#41;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#42;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#43;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#44;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#45;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#46;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#47;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#58;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#59;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#60;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#61;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#62;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#63;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#64;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#91;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#92;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#93;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#94;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#95;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#123;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#124;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#125;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#126;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#176;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#177;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#178;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#179;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#181;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#191;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#247;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#8804;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#8805;')>0 or 
 INSTR(PREFERRED_DEFINITION ,'&'||'#8800;')>0 or 
 INSTR(PREFERRED_DEFINITION ,'&'||'#8223;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#8322;')>0;
commit;

 UPDATE SBR.VALUE_DOMAINS set 
date_modified=v_date, modified_by='DWARZEL',
LONG_NAME=SBREXT.meta_CleanSP_CHAR(LONG_NAME) 
where ((instr(LONG_NAME ,'&'||'#')> 0  and instr(LONG_NAME ,';')> 0)
or INSTR(LONG_NAME,'&'||'gt;')>0 
or INSTR(LONG_NAME,'&'||'lt;')>0 
or  INSTR(LONG_NAME,'&'||'amp;')>0 )
;


UPDATE SBR.VALUE_DOMAINS set 
date_modified=v_date, modified_by='DWARZEL',
preferred_definition=SBREXT.meta_CleanSP_CHAR(preferred_definition)
where((instr(preferred_definition ,'&'||'#')> 0 and instr(preferred_definition ,';')> 0)
or INSTR(preferred_definition,'&'||'gt;')>0 
or INSTR(preferred_definition,'&'||'lt;')>0 
or  INSTR(preferred_definition,'&'||'amp;')>0 )
  ;
                                                                             
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
where INSTR(LONG_NAME,'&'||'gt;')>0 or
 INSTR(LONG_NAME,'&'||'lt;')>0 or
 INSTR(LONG_NAME,'&'||'amp;')>0 or
 INSTR(LONG_NAME,'&'||'#32;')>0 or
 INSTR(LONG_NAME,'&'||'#33;')>0 or
 INSTR(LONG_NAME,'&'||'#34;')>0 or
 INSTR(LONG_NAME,'&'||'#35;')>0 or
 INSTR(LONG_NAME,'&'||'#36;')>0 or
 INSTR(LONG_NAME,'&'||'#37;')>0 or
 INSTR(LONG_NAME,'&'||'#38;')>0 or
 INSTR(LONG_NAME,'&'||'#39;')>0 or
 INSTR(LONG_NAME,'&'||'#40;')>0 or
 INSTR(LONG_NAME,'&'||'#41;')>0 or
 INSTR(LONG_NAME,'&'||'#42;')>0 or
 INSTR(LONG_NAME,'&'||'#43;')>0 or
 INSTR(LONG_NAME,'&'||'#44;')>0 or
 INSTR(LONG_NAME,'&'||'#45;')>0 or
 INSTR(LONG_NAME,'&'||'#46;')>0 or
 INSTR(LONG_NAME,'&'||'#47;')>0 or
 INSTR(LONG_NAME,'&'||'#58;')>0 or
 INSTR(LONG_NAME,'&'||'#59;')>0 or
 INSTR(LONG_NAME,'&'||'#60;')>0 or
 INSTR(LONG_NAME,'&'||'#61;')>0 or
 INSTR(LONG_NAME,'&'||'#62;')>0 or
 INSTR(LONG_NAME,'&'||'#63;')>0 or
 INSTR(LONG_NAME,'&'||'#64;')>0 or
 INSTR(LONG_NAME,'&'||'#91;')>0 or
 INSTR(LONG_NAME,'&'||'#92;')>0 or
 INSTR(LONG_NAME,'&'||'#93;')>0 or
 INSTR(LONG_NAME,'&'||'#94;')>0 or
 INSTR(LONG_NAME,'&'||'#95;')>0 or
 INSTR(LONG_NAME,'&'||'#123;')>0 or
 INSTR(LONG_NAME,'&'||'#124;')>0 or
 INSTR(LONG_NAME,'&'||'#125;')>0 or
 INSTR(LONG_NAME,'&'||'#126;')>0 or
 INSTR(LONG_NAME,'&'||'#176;')>0 or
 INSTR(LONG_NAME,'&'||'#177;')>0 or
 INSTR(LONG_NAME,'&'||'#178;')>0 or
 INSTR(LONG_NAME,'&'||'#179;')>0 or
 INSTR(LONG_NAME,'&'||'#181;')>0 or
 INSTR(LONG_NAME,'&'||'#191;')>0 or
 INSTR(LONG_NAME,'&'||'#247;')>0 or
 INSTR(LONG_NAME,'&'||'#8804;')>0 or
 INSTR(LONG_NAME,'&'||'#8805;')>0 or 
 INSTR(LONG_NAME,'&'||'#8800;')>0 or 
 INSTR(LONG_NAME,'&'||'#8223;')>0 or
 INSTR(LONG_NAME,'&'||'#8322;')>0 or
INSTR(PREFERRED_DEFINITION ,'&'||'gt;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'lt;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'amp;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#32;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#33;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#34;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#35;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#36;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#37;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#38;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#39;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#40;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#41;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#42;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#43;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#44;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#45;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#46;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#47;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#58;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#59;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#60;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#61;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#62;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#63;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#64;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#91;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#92;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#93;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#94;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#95;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#123;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#124;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#125;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#126;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#176;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#177;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#178;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#179;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#181;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#191;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#247;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#8804;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#8805;')>0 or 
 INSTR(PREFERRED_DEFINITION ,'&'||'#8800;')>0 or 
 INSTR(PREFERRED_DEFINITION ,'&'||'#8223;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#8322;')>0;

commit;
UPDATE SBREXT.PROPERTIES_EXT  set 
date_modified=v_date, modified_by='DWARZEL',
LONG_NAME=SBREXT.meta_CleanSP_CHAR(LONG_NAME) 
where ((instr(LONG_NAME ,'&'||'#')> 0  and instr(LONG_NAME ,';')> 0)
or INSTR(LONG_NAME,'&'||'gt;')>0 
or INSTR(LONG_NAME,'&'||'lt;')>0 
or  INSTR(LONG_NAME,'&'||'amp;')>0 )
;


UPDATE SBREXT.PROPERTIES_EXT  set 
date_modified=v_date, modified_by='DWARZEL',
PREFERRED_DEFINITION=SBREXT.meta_CleanSP_CHAR(PREFERRED_DEFINITION)
where((instr(PREFERRED_DEFINITION ,'&'||'#')> 0 and instr(PREFERRED_DEFINITION ,';')> 0)
or INSTR(PREFERRED_DEFINITION,'&'||'gt;')>0 
or INSTR(PREFERRED_DEFINITION,'&'||'lt;')>0 
or  INSTR(PREFERRED_DEFINITION,'&'||'amp;')>0 )
  ;                                                                            
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
WHERE INSTR(MEANING_TEXT ,'&'||'gt;')>0 or
 INSTR(MEANING_TEXT ,'&'||'lt;')>0 or
 INSTR(MEANING_TEXT ,'&'||'amp;')>0 or
 INSTR(MEANING_TEXT ,'&'||'#32;')>0 or
 INSTR(MEANING_TEXT ,'&'||'#33;')>0 or
 INSTR(MEANING_TEXT ,'&'||'#34;')>0 or
 INSTR(MEANING_TEXT ,'&'||'#35;')>0 or
 INSTR(MEANING_TEXT ,'&'||'#36;')>0 or
 INSTR(MEANING_TEXT ,'&'||'#37;')>0 or
 INSTR(MEANING_TEXT ,'&'||'#38;')>0 or
 INSTR(MEANING_TEXT ,'&'||'#39;')>0 or
 INSTR(MEANING_TEXT ,'&'||'#40;')>0 or
 INSTR(MEANING_TEXT ,'&'||'#41;')>0 or
 INSTR(MEANING_TEXT ,'&'||'#42;')>0 or
 INSTR(MEANING_TEXT ,'&'||'#43;')>0 or
 INSTR(MEANING_TEXT ,'&'||'#44;')>0 or
 INSTR(MEANING_TEXT ,'&'||'#45;')>0 or
 INSTR(MEANING_TEXT ,'&'||'#46;')>0 or
 INSTR(MEANING_TEXT ,'&'||'#47;')>0 or
 INSTR(MEANING_TEXT ,'&'||'#58;')>0 or
 INSTR(MEANING_TEXT ,'&'||'#59;')>0 or
 INSTR(MEANING_TEXT ,'&'||'#60;')>0 or
 INSTR(MEANING_TEXT ,'&'||'#61;')>0 or
 INSTR(MEANING_TEXT ,'&'||'#62;')>0 or
 INSTR(MEANING_TEXT ,'&'||'#63;')>0 or
 INSTR(MEANING_TEXT ,'&'||'#64;')>0 or
 INSTR(MEANING_TEXT ,'&'||'#91;')>0 or
 INSTR(MEANING_TEXT ,'&'||'#92;')>0 or
 INSTR(MEANING_TEXT ,'&'||'#93;')>0 or
 INSTR(MEANING_TEXT ,'&'||'#94;')>0 or
 INSTR(MEANING_TEXT ,'&'||'#95;')>0 or
 INSTR(MEANING_TEXT ,'&'||'#123;')>0 or
 INSTR(MEANING_TEXT ,'&'||'#124;')>0 or
 INSTR(MEANING_TEXT ,'&'||'#125;')>0 or
 INSTR(MEANING_TEXT ,'&'||'#126;')>0 or
 INSTR(MEANING_TEXT ,'&'||'#176;')>0 or
 INSTR(MEANING_TEXT ,'&'||'#177;')>0 or
 INSTR(MEANING_TEXT ,'&'||'#178;')>0 or
 INSTR(MEANING_TEXT ,'&'||'#179;')>0 or
 INSTR(MEANING_TEXT ,'&'||'#181;')>0 or
 INSTR(MEANING_TEXT ,'&'||'#191;')>0 or
 INSTR(MEANING_TEXT ,'&'||'#247;')>0 or
 INSTR(MEANING_TEXT ,'&'||'#8804;')>0 or
 INSTR(MEANING_TEXT ,'&'||'#8805;')>0 or 
 INSTR(MEANING_TEXT ,'&'||'#8800;')>0 or 
 INSTR(MEANING_TEXT ,'&'||'#8223;')>0 or
 INSTR(MEANING_TEXT ,'&'||'#8322;')>0 or
 INSTR(DESCRIPTION_TEXT ,'&'||'gt;')>0 or
 INSTR(DESCRIPTION_TEXT ,'&'||'lt;')>0 or
 INSTR(DESCRIPTION_TEXT ,'&'||'amp;')>0 or
 INSTR(DESCRIPTION_TEXT ,'&'||'#32;')>0 or
 INSTR(DESCRIPTION_TEXT ,'&'||'#33;')>0 or
 INSTR(DESCRIPTION_TEXT ,'&'||'#34;')>0 or
 INSTR(DESCRIPTION_TEXT ,'&'||'#35;')>0 or
 INSTR(DESCRIPTION_TEXT ,'&'||'#36;')>0 or
 INSTR(DESCRIPTION_TEXT ,'&'||'#37;')>0 or
 INSTR(DESCRIPTION_TEXT ,'&'||'#38;')>0 or
 INSTR(DESCRIPTION_TEXT ,'&'||'#39;')>0 or
 INSTR(DESCRIPTION_TEXT ,'&'||'#40;')>0 or
 INSTR(DESCRIPTION_TEXT ,'&'||'#41;')>0 or
 INSTR(DESCRIPTION_TEXT ,'&'||'#42;')>0 or
 INSTR(DESCRIPTION_TEXT ,'&'||'#43;')>0 or
 INSTR(DESCRIPTION_TEXT ,'&'||'#44;')>0 or
 INSTR(DESCRIPTION_TEXT ,'&'||'#45;')>0 or
 INSTR(DESCRIPTION_TEXT ,'&'||'#46;')>0 or
 INSTR(DESCRIPTION_TEXT ,'&'||'#47;')>0 or
 INSTR(DESCRIPTION_TEXT ,'&'||'#58;')>0 or
 INSTR(DESCRIPTION_TEXT ,'&'||'#59;')>0 or
 INSTR(DESCRIPTION_TEXT ,'&'||'#60;')>0 or
 INSTR(DESCRIPTION_TEXT ,'&'||'#61;')>0 or
 INSTR(DESCRIPTION_TEXT ,'&'||'#62;')>0 or
 INSTR(DESCRIPTION_TEXT ,'&'||'#63;')>0 or
 INSTR(DESCRIPTION_TEXT ,'&'||'#64;')>0 or
 INSTR(DESCRIPTION_TEXT ,'&'||'#91;')>0 or
 INSTR(DESCRIPTION_TEXT ,'&'||'#92;')>0 or
 INSTR(DESCRIPTION_TEXT ,'&'||'#93;')>0 or
 INSTR(DESCRIPTION_TEXT ,'&'||'#94;')>0 or
 INSTR(DESCRIPTION_TEXT ,'&'||'#95;')>0 or
 INSTR(DESCRIPTION_TEXT ,'&'||'#123;')>0 or
 INSTR(DESCRIPTION_TEXT ,'&'||'#124;')>0 or
 INSTR(DESCRIPTION_TEXT ,'&'||'#125;')>0 or
 INSTR(DESCRIPTION_TEXT ,'&'||'#126;')>0 or
 INSTR(DESCRIPTION_TEXT ,'&'||'#176;')>0 or
 INSTR(DESCRIPTION_TEXT ,'&'||'#177;')>0 or
 INSTR(DESCRIPTION_TEXT ,'&'||'#178;')>0 or
 INSTR(DESCRIPTION_TEXT ,'&'||'#179;')>0 or
 INSTR(DESCRIPTION_TEXT ,'&'||'#181;')>0 or
 INSTR(DESCRIPTION_TEXT ,'&'||'#191;')>0 or
 INSTR(DESCRIPTION_TEXT ,'&'||'#247;')>0 or
 INSTR(DESCRIPTION_TEXT ,'&'||'#8804;')>0 or
 INSTR(DESCRIPTION_TEXT ,'&'||'#8805;')>0 or 
 INSTR(DESCRIPTION_TEXT ,'&'||'#8800;')>0 or 
 INSTR(DESCRIPTION_TEXT ,'&'||'#8223;')>0 or
 INSTR(DESCRIPTION_TEXT ,'&'||'#8322;')>0; 

commit;


UPDATE SBREXT.VALID_VALUES_ATT_EXT set 
date_modified=v_date, modified_by='DWARZEL',
MEANING_TEXT=SBREXT.meta_CleanSP_CHAR(MEANING_TEXT) 
where ((instr(MEANING_TEXT ,'&'||'#')> 0  and instr(MEANING_TEXT ,';')> 0)
or INSTR(MEANING_TEXT,'&'||'gt;')>0 
or INSTR(MEANING_TEXT,'&'||'lt;')>0 
or  INSTR(MEANING_TEXT,'&'||'amp;')>0 )
;


UPDATE SBREXT.VALID_VALUES_ATT_EXT set 
date_modified=v_date, modified_by='DWARZEL',
DESCRIPTION_TEXT=SBREXT.meta_CleanSP_CHAR(DESCRIPTION_TEXT)
where((instr(DESCRIPTION_TEXT ,'&'||'#')> 0 and instr(DESCRIPTION_TEXT ,';')> 0)
or INSTR(DESCRIPTION_TEXT,'&'||'gt;')>0 
or INSTR(DESCRIPTION_TEXT,'&'||'lt;')>0 
or  INSTR(DESCRIPTION_TEXT,'&'||'amp;')>0 )
 ;
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
where INSTR(LONG_NAME,'&'||'gt;')>0 or
 INSTR(LONG_NAME,'&'||'lt;')>0 or
 INSTR(LONG_NAME,'&'||'amp;')>0 or
 INSTR(LONG_NAME,'&'||'#32;')>0 or
 INSTR(LONG_NAME,'&'||'#33;')>0 or
 INSTR(LONG_NAME,'&'||'#34;')>0 or
 INSTR(LONG_NAME,'&'||'#35;')>0 or
 INSTR(LONG_NAME,'&'||'#36;')>0 or
 INSTR(LONG_NAME,'&'||'#37;')>0 or
 INSTR(LONG_NAME,'&'||'#38;')>0 or
 INSTR(LONG_NAME,'&'||'#39;')>0 or
 INSTR(LONG_NAME,'&'||'#40;')>0 or
 INSTR(LONG_NAME,'&'||'#41;')>0 or
 INSTR(LONG_NAME,'&'||'#42;')>0 or
 INSTR(LONG_NAME,'&'||'#43;')>0 or
 INSTR(LONG_NAME,'&'||'#44;')>0 or
 INSTR(LONG_NAME,'&'||'#45;')>0 or
 INSTR(LONG_NAME,'&'||'#46;')>0 or
 INSTR(LONG_NAME,'&'||'#47;')>0 or
 INSTR(LONG_NAME,'&'||'#58;')>0 or
 INSTR(LONG_NAME,'&'||'#59;')>0 or
 INSTR(LONG_NAME,'&'||'#60;')>0 or
 INSTR(LONG_NAME,'&'||'#61;')>0 or
 INSTR(LONG_NAME,'&'||'#62;')>0 or
 INSTR(LONG_NAME,'&'||'#63;')>0 or
 INSTR(LONG_NAME,'&'||'#64;')>0 or
 INSTR(LONG_NAME,'&'||'#91;')>0 or
 INSTR(LONG_NAME,'&'||'#92;')>0 or
 INSTR(LONG_NAME,'&'||'#93;')>0 or
 INSTR(LONG_NAME,'&'||'#94;')>0 or
 INSTR(LONG_NAME,'&'||'#95;')>0 or
 INSTR(LONG_NAME,'&'||'#123;')>0 or
 INSTR(LONG_NAME,'&'||'#124;')>0 or
 INSTR(LONG_NAME,'&'||'#125;')>0 or
 INSTR(LONG_NAME,'&'||'#126;')>0 or
 INSTR(LONG_NAME,'&'||'#176;')>0 or
 INSTR(LONG_NAME,'&'||'#177;')>0 or
 INSTR(LONG_NAME,'&'||'#178;')>0 or
 INSTR(LONG_NAME,'&'||'#179;')>0 or
 INSTR(LONG_NAME,'&'||'#181;')>0 or
 INSTR(LONG_NAME,'&'||'#191;')>0 or
 INSTR(LONG_NAME,'&'||'#247;')>0 or
 INSTR(LONG_NAME,'&'||'#8804;')>0 or
 INSTR(LONG_NAME,'&'||'#8805;')>0 or 
 INSTR(LONG_NAME,'&'||'#8800;')>0 or 
 INSTR(LONG_NAME,'&'||'#8223;')>0 or
 INSTR(LONG_NAME,'&'||'#8322;')>0 or
INSTR(PREFERRED_DEFINITION ,'&'||'gt;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'lt;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'amp;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#32;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#33;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#34;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#35;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#36;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#37;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#38;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#39;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#40;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#41;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#42;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#43;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#44;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#45;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#46;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#47;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#58;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#59;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#60;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#61;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#62;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#63;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#64;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#91;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#92;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#93;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#94;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#95;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#123;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#124;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#125;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#126;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#176;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#177;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#178;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#179;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#181;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#191;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#247;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#8804;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#8805;')>0 or 
 INSTR(PREFERRED_DEFINITION ,'&'||'#8800;')>0 or 
 INSTR(PREFERRED_DEFINITION ,'&'||'#8223;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#8322;')>0;
commit;

 UPDATE SBR.DATA_ELEMENT_CONCEPTS set 
date_modified=v_date, modified_by='DWARZEL',
LONG_NAME=SBREXT.meta_CleanSP_CHAR(LONG_NAME) 
where ((instr(LONG_NAME ,'&'||'#')> 0  and instr(LONG_NAME ,';')> 0)
or INSTR(LONG_NAME,'&'||'gt;')>0 
or INSTR(LONG_NAME,'&'||'lt;')>0 
or  INSTR(LONG_NAME,'&'||'amp;')>0 )
;


UPDATE SBR.DATA_ELEMENT_CONCEPTS set 
date_modified=v_date, modified_by='DWARZEL',
PREFERRED_DEFINITION=SBREXT.meta_CleanSP_CHAR(PREFERRED_DEFINITION)
where((instr(PREFERRED_DEFINITION ,'&'||'#')> 0 and instr(PREFERRED_DEFINITION ,';')> 0)
or INSTR(PREFERRED_DEFINITION,'&'||'gt;')>0 
or INSTR(PREFERRED_DEFINITION,'&'||'lt;')>0 
or  INSTR(PREFERRED_DEFINITION,'&'||'amp;')>0 )
  ;
                                                                             
 commit;  
    EXCEPTION
 
    WHEN OTHERS THEN   
       errmsg := substr(SQLERRM,1,2000);
         dbms_output.put_line('errmsg  - '||errmsg);
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
where INSTR(LONG_NAME,'&'||'gt;')>0 or
 INSTR(LONG_NAME,'&'||'lt;')>0 or
 INSTR(LONG_NAME,'&'||'amp;')>0 or
 INSTR(LONG_NAME,'&'||'#32;')>0 or
 INSTR(LONG_NAME,'&'||'#33;')>0 or
 INSTR(LONG_NAME,'&'||'#34;')>0 or
 INSTR(LONG_NAME,'&'||'#35;')>0 or
 INSTR(LONG_NAME,'&'||'#36;')>0 or
 INSTR(LONG_NAME,'&'||'#37;')>0 or
 INSTR(LONG_NAME,'&'||'#38;')>0 or
 INSTR(LONG_NAME,'&'||'#39;')>0 or
 INSTR(LONG_NAME,'&'||'#40;')>0 or
 INSTR(LONG_NAME,'&'||'#41;')>0 or
 INSTR(LONG_NAME,'&'||'#42;')>0 or
 INSTR(LONG_NAME,'&'||'#43;')>0 or
 INSTR(LONG_NAME,'&'||'#44;')>0 or
 INSTR(LONG_NAME,'&'||'#45;')>0 or
 INSTR(LONG_NAME,'&'||'#46;')>0 or
 INSTR(LONG_NAME,'&'||'#47;')>0 or
 INSTR(LONG_NAME,'&'||'#58;')>0 or
 INSTR(LONG_NAME,'&'||'#59;')>0 or
 INSTR(LONG_NAME,'&'||'#60;')>0 or
 INSTR(LONG_NAME,'&'||'#61;')>0 or
 INSTR(LONG_NAME,'&'||'#62;')>0 or
 INSTR(LONG_NAME,'&'||'#63;')>0 or
 INSTR(LONG_NAME,'&'||'#64;')>0 or
 INSTR(LONG_NAME,'&'||'#91;')>0 or
 INSTR(LONG_NAME,'&'||'#92;')>0 or
 INSTR(LONG_NAME,'&'||'#93;')>0 or
 INSTR(LONG_NAME,'&'||'#94;')>0 or
 INSTR(LONG_NAME,'&'||'#95;')>0 or
 INSTR(LONG_NAME,'&'||'#123;')>0 or
 INSTR(LONG_NAME,'&'||'#124;')>0 or
 INSTR(LONG_NAME,'&'||'#125;')>0 or
 INSTR(LONG_NAME,'&'||'#126;')>0 or
 INSTR(LONG_NAME,'&'||'#176;')>0 or
 INSTR(LONG_NAME,'&'||'#177;')>0 or
 INSTR(LONG_NAME,'&'||'#178;')>0 or
 INSTR(LONG_NAME,'&'||'#179;')>0 or
 INSTR(LONG_NAME,'&'||'#181;')>0 or
 INSTR(LONG_NAME,'&'||'#191;')>0 or
 INSTR(LONG_NAME,'&'||'#247;')>0 or
 INSTR(LONG_NAME,'&'||'#8804;')>0 or
 INSTR(LONG_NAME,'&'||'#8805;')>0 or 
 INSTR(LONG_NAME,'&'||'#8800;')>0 or 
 INSTR(LONG_NAME,'&'||'#8223;')>0 or
 INSTR(LONG_NAME,'&'||'#8322;')>0 or
INSTR(PREFERRED_DEFINITION ,'&'||'gt;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'lt;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'amp;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#32;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#33;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#34;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#35;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#36;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#37;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#38;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#39;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#40;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#41;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#42;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#43;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#44;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#45;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#46;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#47;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#58;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#59;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#60;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#61;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#62;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#63;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#64;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#91;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#92;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#93;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#94;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#95;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#123;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#124;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#125;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#126;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#176;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#177;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#178;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#179;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#181;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#191;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#247;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#8804;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#8805;')>0 or 
 INSTR(PREFERRED_DEFINITION ,'&'||'#8800;')>0 or 
 INSTR(PREFERRED_DEFINITION ,'&'||'#8223;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#8322;')>0;
commit;

 UPDATE SBR.DATA_ELEMENTS set 
date_modified=v_date, modified_by='DWARZEL',
LONG_NAME=SBREXT.meta_CleanSP_CHAR(LONG_NAME) 
where ((instr(LONG_NAME ,'&'||'#')> 0  and instr(LONG_NAME ,';')> 0)
or INSTR(LONG_NAME,'&'||'gt;')>0 
or INSTR(LONG_NAME,'&'||'lt;')>0 
or  INSTR(LONG_NAME,'&'||'amp;')>0 )
;


UPDATE SBR.DATA_ELEMENTS set 
date_modified=v_date, modified_by='DWARZEL',
PREFERRED_DEFINITION=SBREXT.meta_CleanSP_CHAR(PREFERRED_DEFINITION)
where((instr(PREFERRED_DEFINITION ,'&'||'#')> 0 and instr(PREFERRED_DEFINITION ,';')> 0)
or INSTR(PREFERRED_DEFINITION,'&'||'gt;')>0 
or INSTR(PREFERRED_DEFINITION,'&'||'lt;')>0 
or  INSTR(PREFERRED_DEFINITION,'&'||'amp;')>0 )
  ;
                                                                             
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
where INSTR(LONG_NAME,'&'||'gt;')>0 or
 INSTR(LONG_NAME,'&'||'lt;')>0 or
 INSTR(LONG_NAME,'&'||'amp;')>0 or
 INSTR(LONG_NAME,'&'||'#32;')>0 or
 INSTR(LONG_NAME,'&'||'#33;')>0 or
 INSTR(LONG_NAME,'&'||'#34;')>0 or
 INSTR(LONG_NAME,'&'||'#35;')>0 or
 INSTR(LONG_NAME,'&'||'#36;')>0 or
 INSTR(LONG_NAME,'&'||'#37;')>0 or
 INSTR(LONG_NAME,'&'||'#38;')>0 or
 INSTR(LONG_NAME,'&'||'#39;')>0 or
 INSTR(LONG_NAME,'&'||'#40;')>0 or
 INSTR(LONG_NAME,'&'||'#41;')>0 or
 INSTR(LONG_NAME,'&'||'#42;')>0 or
 INSTR(LONG_NAME,'&'||'#43;')>0 or
 INSTR(LONG_NAME,'&'||'#44;')>0 or
 INSTR(LONG_NAME,'&'||'#45;')>0 or
 INSTR(LONG_NAME,'&'||'#46;')>0 or
 INSTR(LONG_NAME,'&'||'#47;')>0 or
 INSTR(LONG_NAME,'&'||'#58;')>0 or
 INSTR(LONG_NAME,'&'||'#59;')>0 or
 INSTR(LONG_NAME,'&'||'#60;')>0 or
 INSTR(LONG_NAME,'&'||'#61;')>0 or
 INSTR(LONG_NAME,'&'||'#62;')>0 or
 INSTR(LONG_NAME,'&'||'#63;')>0 or
 INSTR(LONG_NAME,'&'||'#64;')>0 or
 INSTR(LONG_NAME,'&'||'#91;')>0 or
 INSTR(LONG_NAME,'&'||'#92;')>0 or
 INSTR(LONG_NAME,'&'||'#93;')>0 or
 INSTR(LONG_NAME,'&'||'#94;')>0 or
 INSTR(LONG_NAME,'&'||'#95;')>0 or
 INSTR(LONG_NAME,'&'||'#123;')>0 or
 INSTR(LONG_NAME,'&'||'#124;')>0 or
 INSTR(LONG_NAME,'&'||'#125;')>0 or
 INSTR(LONG_NAME,'&'||'#126;')>0 or
 INSTR(LONG_NAME,'&'||'#176;')>0 or
 INSTR(LONG_NAME,'&'||'#177;')>0 or
 INSTR(LONG_NAME,'&'||'#178;')>0 or
 INSTR(LONG_NAME,'&'||'#179;')>0 or
 INSTR(LONG_NAME,'&'||'#181;')>0 or
 INSTR(LONG_NAME,'&'||'#191;')>0 or
 INSTR(LONG_NAME,'&'||'#247;')>0 or
 INSTR(LONG_NAME,'&'||'#8804;')>0 or
 INSTR(LONG_NAME,'&'||'#8805;')>0 or 
 INSTR(LONG_NAME,'&'||'#8800;')>0 or 
 INSTR(LONG_NAME,'&'||'#8223;')>0 or
 INSTR(LONG_NAME,'&'||'#8322;')>0 or
INSTR(PREFERRED_DEFINITION ,'&'||'gt;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'lt;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'amp;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#32;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#33;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#34;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#35;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#36;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#37;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#38;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#39;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#40;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#41;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#42;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#43;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#44;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#45;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#46;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#47;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#58;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#59;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#60;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#61;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#62;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#63;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#64;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#91;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#92;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#93;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#94;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#95;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#123;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#124;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#125;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#126;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#176;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#177;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#178;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#179;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#181;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#191;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#247;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#8804;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#8805;')>0 or 
 INSTR(PREFERRED_DEFINITION ,'&'||'#8800;')>0 or 
 INSTR(PREFERRED_DEFINITION ,'&'||'#8223;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#8322;')>0;


commit;
 UPDATE SBREXT.OBJECT_CLASSES_EXT set 
date_modified=v_date, modified_by='DWARZEL',
LONG_NAME=SBREXT.meta_CleanSP_CHAR(LONG_NAME) 
where ((instr(LONG_NAME ,'&'||'#')> 0  and instr(LONG_NAME ,';')> 0)
or INSTR(LONG_NAME,'&'||'gt;')>0 
or INSTR(LONG_NAME,'&'||'lt;')>0 
or  INSTR(LONG_NAME,'&'||'amp;')>0 )
;


UPDATE SBREXT.OBJECT_CLASSES_EXT set 
date_modified=v_date, modified_by='DWARZEL',
PREFERRED_DEFINITION=SBREXT.meta_CleanSP_CHAR(PREFERRED_DEFINITION)
where((instr(PREFERRED_DEFINITION ,'&'||'#')> 0 and instr(PREFERRED_DEFINITION ,';')> 0)
or INSTR(PREFERRED_DEFINITION,'&'||'gt;')>0 
or INSTR(PREFERRED_DEFINITION,'&'||'lt;')>0 
or  INSTR(PREFERRED_DEFINITION,'&'||'amp;')>0 )
  ;
                                                                             
 commit;  
    EXCEPTION
 
    WHEN OTHERS THEN   
       errmsg := substr(SQLERRM,1,2000);
         dbms_output.put_line('errmsg  - '||errmsg);
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
where INSTR(LONG_NAME,'&'||'gt;')>0 or
 INSTR(LONG_NAME,'&'||'lt;')>0 or
 INSTR(LONG_NAME,'&'||'amp;')>0 or
 INSTR(LONG_NAME,'&'||'#32;')>0 or
 INSTR(LONG_NAME,'&'||'#33;')>0 or
 INSTR(LONG_NAME,'&'||'#34;')>0 or
 INSTR(LONG_NAME,'&'||'#35;')>0 or
 INSTR(LONG_NAME,'&'||'#36;')>0 or
 INSTR(LONG_NAME,'&'||'#37;')>0 or
 INSTR(LONG_NAME,'&'||'#38;')>0 or
 INSTR(LONG_NAME,'&'||'#39;')>0 or
 INSTR(LONG_NAME,'&'||'#40;')>0 or
 INSTR(LONG_NAME,'&'||'#41;')>0 or
 INSTR(LONG_NAME,'&'||'#42;')>0 or
 INSTR(LONG_NAME,'&'||'#43;')>0 or
 INSTR(LONG_NAME,'&'||'#44;')>0 or
 INSTR(LONG_NAME,'&'||'#45;')>0 or
 INSTR(LONG_NAME,'&'||'#46;')>0 or
 INSTR(LONG_NAME,'&'||'#47;')>0 or
 INSTR(LONG_NAME,'&'||'#58;')>0 or
 INSTR(LONG_NAME,'&'||'#59;')>0 or
 INSTR(LONG_NAME,'&'||'#60;')>0 or
 INSTR(LONG_NAME,'&'||'#61;')>0 or
 INSTR(LONG_NAME,'&'||'#62;')>0 or
 INSTR(LONG_NAME,'&'||'#63;')>0 or
 INSTR(LONG_NAME,'&'||'#64;')>0 or
 INSTR(LONG_NAME,'&'||'#91;')>0 or
 INSTR(LONG_NAME,'&'||'#92;')>0 or
 INSTR(LONG_NAME,'&'||'#93;')>0 or
 INSTR(LONG_NAME,'&'||'#94;')>0 or
 INSTR(LONG_NAME,'&'||'#95;')>0 or
 INSTR(LONG_NAME,'&'||'#123;')>0 or
 INSTR(LONG_NAME,'&'||'#124;')>0 or
 INSTR(LONG_NAME,'&'||'#125;')>0 or
 INSTR(LONG_NAME,'&'||'#126;')>0 or
 INSTR(LONG_NAME,'&'||'#176;')>0 or
 INSTR(LONG_NAME,'&'||'#177;')>0 or
 INSTR(LONG_NAME,'&'||'#178;')>0 or
 INSTR(LONG_NAME,'&'||'#179;')>0 or
 INSTR(LONG_NAME,'&'||'#181;')>0 or
 INSTR(LONG_NAME,'&'||'#191;')>0 or
 INSTR(LONG_NAME,'&'||'#247;')>0 or
 INSTR(LONG_NAME,'&'||'#8804;')>0 or
 INSTR(LONG_NAME,'&'||'#8805;')>0 or 
 INSTR(LONG_NAME,'&'||'#8800;')>0 or 
 INSTR(LONG_NAME,'&'||'#8223;')>0 or
 INSTR(LONG_NAME,'&'||'#8322;')>0 or
INSTR(PREFERRED_DEFINITION ,'&'||'gt;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'lt;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'amp;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#32;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#33;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#34;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#35;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#36;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#37;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#38;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#39;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#40;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#41;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#42;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#43;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#44;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#45;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#46;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#47;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#58;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#59;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#60;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#61;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#62;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#63;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#64;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#91;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#92;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#93;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#94;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#95;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#123;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#124;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#125;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#126;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#176;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#177;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#178;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#179;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#181;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#191;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#247;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#8804;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#8805;')>0 or 
 INSTR(PREFERRED_DEFINITION ,'&'||'#8800;')>0 or 
 INSTR(PREFERRED_DEFINITION ,'&'||'#8223;')>0 or
 INSTR(PREFERRED_DEFINITION ,'&'||'#8322;')>0;
commit;

 UPDATE SBREXT.REPRESENTATIONS_EXT set 
date_modified=v_date, modified_by='DWARZEL',
LONG_NAME=SBREXT.meta_CleanSP_CHAR(LONG_NAME) 
where ((instr(LONG_NAME ,'&'||'#')> 0  and instr(LONG_NAME ,';')> 0)
or INSTR(LONG_NAME,'&'||'gt;')>0 
or INSTR(LONG_NAME,'&'||'lt;')>0 
or  INSTR(LONG_NAME,'&'||'amp;')>0 )
;


UPDATE SBREXT.REPRESENTATIONS_EXT set 
date_modified=v_date, modified_by='DWARZEL',
PREFERRED_DEFINITION=SBREXT.meta_CleanSP_CHAR(PREFERRED_DEFINITION)
where((instr(PREFERRED_DEFINITION ,'&'||'#')> 0 and instr(PREFERRED_DEFINITION ,';')> 0)
or INSTR(PREFERRED_DEFINITION,'&'||'gt;')>0 
or INSTR(PREFERRED_DEFINITION,'&'||'lt;')>0 
or  INSTR(PREFERRED_DEFINITION,'&'||'amp;')>0 )
  ;
                                                                             
 commit;  
    EXCEPTION
 
    WHEN OTHERS THEN   
       errmsg := substr(SQLERRM,1,2000);
         dbms_output.put_line('errmsg  - '||errmsg);
        insert into SBREXT.META_SPCHAR_ERROR_LOG VALUES('META_FIX_REPRESENTATIONS_EXT',   sysdate ,errmsg);
        
     commit; 
END META_FIX_REPRESENTATIONS_EXT;
/
exec SBREXT.META_FIX_REPRESENTATIONS_EXT;
exec META_FIX_OBJECT_CLASSES_EXT;
exec SBR.META_FIX_DATA_ELEMENT_CONC;
exec SBR.META_FIX_DATA_ELEMENTS;
exec SBREXT.META_FIX_SPCHAR_VV_ATT_EXT;
exec SBR.META_FIX_SP_CHAR_PV;
exec SBR.META_FIX_SP_CHAR_VM;
exec SBR.META_FIX_VALUE_DOMAINS;
exec SBR.META_FIX_CD_VMS;
exec SBR.META_FIX_REF_DOC;
exec SBREXT.META_FIX_PROPERTIES_EXT;
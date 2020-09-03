set serveroutput on size 1000000
SPOOL cadsrmeta-819_t.log
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
 INSTR(p_text ,'&'||'apos;')>0 or
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
--apos
IF  INSTR(V_text,'&'||'apos;')>0
THEN
V_text:=replace(V_text,'&'||'apos;','''');
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
exec SBREXT.META_FIX_REPRESENTATIONS_EXT;
/
DECLARE
V_CNT NUMBER;
 errmsg VARCHAR2(200):=null;
BEGIN
select count(*) into V_CNT 
from SBR.ADMINISTERED_COMPONENTS a,representations_ext r where a.ac_idseq=rep_idseq
and (a.PREFERRED_DEFINITION<>r.PREFERRED_DEFINITION
or a.long_name<>r.long_name);
IF V_CNT=0 then
dbms_output.put_line('No records are found in SBR.ADMINISTERED_COMPONENTS which not matching to SBREXT.REPRESENTATIONS_EXT');
ELSE
dbms_output.put_line(v_CNT||' records are found in SBR.ADMINISTERED_COMPONENTS which not matching to SBREXT.REPRESENTATIONS_EXT');
declare
cursor C is select rep_idseq,rep_id,r.version,r.PREFERRED_DEFINITION PREFERRED_DEFINITION
,r.long_name long_name from SBR.ADMINISTERED_COMPONENTS a,sbrext.representations_ext r 
where  a.ac_idseq=r.rep_idseq
and (a.PREFERRED_DEFINITION<>r.PREFERRED_DEFINITION
or a.long_name<>r.long_name);
begin
for i in C  loop
begin
UPDATE SBR.ADMINISTERED_COMPONENTS set  PREFERRED_DEFINITION=i.PREFERRED_DEFINITION,
long_name=i.long_name where ac_idseq=i.rep_idseq;
commit;/**/ 
 EXCEPTION
    WHEN OTHERS THEN
    errmsg := i.rep_id||'v'||i.version||':'||substr(SQLERRM,1,100);
         dbms_output.put_line('errmsg insert - '||errmsg);
         rollback;
       INSERT INTO SBREXT.MDSR_PROC_ERR_LOG(SP_NAME, TABLE_NAME, TABLE_ID, ERROR_TEXT,  DATE_CREATED)
       values('SBREXT.MDSR_UPDATE_AC_PLSQL_BLOCK','SBR.ADMINISTERED_COMPONENTS',i.rep_id,errmsg,SYSDATE);
     commit;
      END;
  end loop;
END;
 END IF; 
end; 
/
SPOOL OFF

  

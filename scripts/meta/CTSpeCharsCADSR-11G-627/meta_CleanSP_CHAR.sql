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






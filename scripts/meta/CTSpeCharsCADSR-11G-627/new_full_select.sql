select count(*) --97
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
 INSTR(DOC_TEXT ,'&'||'#8322;')>0);
 
select count(*)--99
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



select count(*)from SBR.PERMISSIBLE_VALUES --47
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


select count(*)
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



select count(*)--66
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


select count(*)--9
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

select count(*)--94
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


select count(*)--117
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



select count(*)from SBREXT.REPRESENTATIONS_EXT
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
and  UTL_I18N.UNESCAPE_REFERENCE(preferred_definition) not like'%¿%'));--5


select count(*) --27
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








select count(*)--16
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


select count(*)--152
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



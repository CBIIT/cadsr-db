set serveroutput on size 1000000
SPOOL cadsrmeta-712.log
update SBREXT.CONCEPTS_EXT set PREFERRED_DEFINITION = REPLACE(REPLACE(PREFERRED_DEFINITION, CHR(13), ''), CHR(10), '')
where ((instr(PREFERRED_DEFINITION, chr(13))) > 0) or ((instr(PREFERRED_DEFINITION, chr(10))) > 0);
commit;
SPOOL OFF
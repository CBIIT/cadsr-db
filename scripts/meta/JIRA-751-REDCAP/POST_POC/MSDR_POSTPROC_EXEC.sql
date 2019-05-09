set serveroutput on size 1000000
SPOOL cadsrmeta-751ppexec.log  

exec SBREXT.MDSREDCAP_XML_POSTPOC.RUN_POSTPROC(1)
/
SPOOL OFF

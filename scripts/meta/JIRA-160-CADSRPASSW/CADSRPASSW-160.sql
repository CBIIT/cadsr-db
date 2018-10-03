 set serveroutput on size 1000000
SPOOL CADSRPASSW-160.log
UPDATE SBREXT.TOOL_OPTIONS_EXT 
 set value ='Your password for the caDSR account ${userid} is about to expire on ${expiryDate}. To change your password, you can either login to the Password 
 Change Station by visiting https://${webHost} or contact the NCI Helpdesk at NCIAppSupport@nih.gov.'
 where 
 TOOL_NAME='PasswordChangeStation' and PROPERTY = 'EMAIL.INTRO';
 commit;
 SPOOL  OFF
 



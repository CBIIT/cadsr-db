CREATE TABLE MSDRDEV.REPORTS_ERROR_LOG
(
  FILE_NAME         VARCHAR2(50 BYTE),
  REPORT_ERROR_TXT  VARCHAR2(1100 BYTE),
  DATE_PROCESSED    DATE
)
/
CREATE TABLE SBREXT.REDCAP_XML_GROUP_751
(
  QUEST_SUM     NUMBER,
  PROTOCOL      VARCHAR2(40 BYTE),
  GROUP_NUMBER  NUMBER
)
/
CREATE TABLE SBREXT.REDCAP_XML
(
  PROTOCOL      VARCHAR2(30 BYTE),
  TEXT          CLOB,
  FILE_NAME     VARCHAR2(200 BYTE),
  CREATED_DATE  DATE
)
/ 
CREATE OR REPLACE FORCE VIEW REDCOP_PR_GROUP_VW_751
(
    GROUP_NUMBER,
    PROTOCOLS
)
BEQUEATH DEFINER
AS
      SELECT group_number,
             LISTAGG (protocol, ',') WITHIN GROUP (ORDER BY protocol)    protocols
        FROM REDCAP_XML_GROUP_751
    GROUP BY group_number;
/
CREATE OR REPLACE PROCEDURE MSDRDEV.REDCAP_XML_GROUP_insert as

CURSOR c_protocol IS
SELECT distinct  r.protocol
FROM REDCAP_PROTOCOL_NEW r
order by 1;

   l_form_seq      number:='0';
   errmsg VARCHAR2(500):='Non';
   v_protocol VARCHAR2(50):='';
BEGIN
 FOR rec IN c_protocol LOOP
 BEGIN
        l_form_seq:=l_form_seq+1;
        insert into MSDRDEV.REDCAP_XML_GROUP VALUES (rec.protocol,l_form_seq, null);

    EXCEPTION
    WHEN OTHERS THEN
    errmsg := SQLERRM;
         dbms_output.put_line('errmsg  - '||errmsg);
        insert into REPORTS_ERROR_LOG VALUES (rec.protocol,  errmsg, sysdate);

     commit;
        END;
END LOOP;

END;
/  
exec SBREXT.xml_RedCop_insert751
/
CREATE OR REPLACE PROCEDURE SBREXT.REDCAP_XML_TRANSFORM IS

l_file_name VARCHAR2(500):='Phenx FORMS';
 errmsg VARCHAR2(500):='Non';
BEGIN

update redcap_xml set text=replace(text,'REDCAP_SECTION_T','module');
update redcap_xml set text=replace(text,'REDCAP_QUESTION_T','question');
update redcap_xml set text=replace(text,'</ROW>','</forms>');
update redcap_xml set text=replace(text,'<ROW>','<forms>');
UPDATE redcap_xml set text=replace(text,'REDCAP_VALIDVALUE_T','validValue');
UPDATE redcap_xml set text=replace(text,'REDCAP_FORM_S','form' ) ;
UPDATE redcap_xml set text=replace(text,'<group>'||chr(10) ) ;
UPDATE redcap_xml set text=replace(text,'</group>'||chr(10) ) ;
UPDATE redcap_xml set text=replace(text,'<ROWSET>'||chr(10) ) ;
UPDATE redcap_xml set text=replace(text,'</ROWSET>'||chr(10) );
update redcap_xml set text=replace(text,'</ROW>','</forms>');
update redcap_xml set text=replace(text,'<ROW>','<forms>');
update redcap_xml set text=replace(text,'REDCAP_SECTION_T','module');
update redcap_xml set text=replace(text,'REDCAP_QUESTION_T','question');
UPDATE redcap_xml set text=replace(text,'REDCAP_VALIDVALUE_T','validValue');
UPDATE redcap_xml set text=replace(text,'<validValues_x005F_xx>'||chr(10));
UPDATE redcap_xml set text=replace(text,'</validValues_x005F_xx>'||chr(10));
UPDATE redcap_xml set text=replace(text,'<validValues_x005F_xx/>'||chr(10));
UPDATE redcap_xml set text=replace(text,'CFR','CRF' ); 
UPDATE redcap_xml set text=replace(text,'<modules_x005F_xx>','' );
UPDATE redcap_xml set text=replace(text,'<modules_x005F_xx>'||chr(10));
UPDATE redcap_xml set text=replace(text,'</modules_x005F_xx>'||chr(10));
UPDATE redcap_xml set text=replace(text,'<questions_x005F_xx>'||chr(10));
UPDATE redcap_xml set text=replace(text,'</questions_x005F_xx>'||chr(10));
UPDATE redcap_xml set text=replace(text,'<questions_x005F_xx/>'||chr(10));
UPDATE redcap_xml set text=replace(text,'<?xml version="1.0"?>','<?xml version="1.0" encoding="UTF-8"?>');
--UPDATE redcap_xml set text=replace(text,'2016-08-01 16:20:20',TO_CHAR(SYSDATE,'YYYY-MM-DD')||'T00:00:00.0');
 commit;
 EXCEPTION
    WHEN OTHERS THEN
   errmsg := SQLERRM;
         dbms_output.put_line('errmsg  - '||errmsg);
        insert into REPORTS_ERROR_LOG VALUES (l_file_name,  errmsg, sysdate);
 commit;

END ;
/
exec   SBREXT.REDCAP_XML_TRANSFORM;

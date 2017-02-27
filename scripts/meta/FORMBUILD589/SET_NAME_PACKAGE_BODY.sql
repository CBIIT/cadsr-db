set serveroutput on size 1000000
SPOOL cadsrFORMBUILD589.log

create or replace PACKAGE BODY Set_Name IS
FUNCTION abbreviate_name(v_long_name IN VARCHAR2) RETURN VARCHAR2 IS
CURSOR abb_cur  IS
SELECT content,substitution
FROM sbrext.substitutions_view_ext
WHERE TYPE = 'Abbreviation';

v_name VARCHAR2(2000);
v_short_name VARCHAR2(30);
BEGIN
  v_name := v_long_name;
  FOR a_rec IN abb_cur LOOP
    v_name := REPLACE(UPPER(v_name),UPPER(a_Rec.content),UPPER(a_rec.substitution));
    IF(LENGTH(v_name) <=30) THEN
     EXIT;
    END IF;
  END LOOP;
 /* IF(LENGTH(v_name) > 30) THEN
   v_name := SUBSTR(v_name,1,29)||'*';
 END IF;*/
 v_name := REPLACE(REPLACE(v_name,' ','_'),',','_');
 v_name := REPLACE(v_name,'__','_');
 v_name := REPLACE(v_name,'.','');
 v_name := REPLACE(v_name,'/','_');
 v_name := REPLACE(v_name,'?','');
 v_name := REPLACE(v_name,')','');
 v_name := REPLACE(v_name,'(','');
 v_name := REPLACE(v_name,'-','');
 v_name := REPLACE(v_name,'''','');
 v_name := NVL(TRANSLATE (V_NAME,'1234567890qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM_()><+=%-,.*&$#@!?/\{}[]|~`;:" ''',
'1234567890qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM_'),'pref_name');
 v_short_name := SUBSTRB(v_name,1,30);
 RETURN(v_short_name);
END;

FUNCTION set_qc_name(name IN VARCHAR2) RETURN VARCHAR2 IS
v_name VARCHAR2(30);
v_count NUMBER;
v_num  NUMBER;
BEGIN
/* caDSR had started to use numeric SHORT_NAME since 2009; we do not need the call commented below */ 
/*v_name := abbreviate_name(name);*/

/*SELECT COUNT(*) INTO v_count
FROM QUEST_CONTENTS_EXT
WHERE preferred_name = v_name;

IF(v_count > 0) THEN*/
SELECT qc_seq.NEXTVAL INTO v_num
FROM dual;
v_name := /*SUBSTR(v_name,1,23)||*/v_num;
--END IF;
RETURN v_name;
END;

FUNCTION set_ac_name(name IN VARCHAR2,p_actl_name IN VARCHAR2) RETURN VARCHAR2 IS
v_name VARCHAR2(30);
v_count NUMBER;
v_num  NUMBER;
BEGIN
v_name := abbreviate_name(name);

SELECT COUNT(*) INTO v_count
FROM ADMINISTERED_COMPONENTS
WHERE preferred_name = v_name
AND actl_name = p_actl_name;

IF(v_count > 0) THEN
SELECT qc_seq.NEXTVAL INTO v_num
FROM dual;
v_name := SUBSTRB(v_name,1,23)||v_num;
END IF;
RETURN v_name;
END;
END;
/
SPOOL OFF
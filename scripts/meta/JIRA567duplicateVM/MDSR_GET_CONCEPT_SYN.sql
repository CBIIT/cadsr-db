CREATE OR REPLACE Function MDSR_GET_CONCEPT_SYN
     ( p_code IN varchar2 ,p_NAME IN varchar2)
   RETURN varchar2


IS 

 V_CNT number;
 V_NAME varchar2(255);

BEGIN


IF  V_CNT=0 THEN
V_NAME:= 'XXX';
ELSE
SELECT DISTINCT CONCEPT_NAME into V_NAME
FROM SBREXT.MDSR_CONCEPTS_SYNONYMS where CODE=P_code
and SYNONYM_NAME= p_NAME;
END IF;
RETURN V_NAME;

EXCEPTION
WHEN OTHERS THEN
   raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);

END MDSR_GET_CONCEPT_SYN;
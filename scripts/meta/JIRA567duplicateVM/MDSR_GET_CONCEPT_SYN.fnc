CREATE OR REPLACE Function SBREXT.MDSR_GET_CONCEPT_SYN
     ( p_code IN varchar2 ,p_NAME IN varchar2)
   RETURN NUMBER


IS 

 V_CNT number:=0;
 V_NAME NUMBER;

BEGIN
SELECT COUNT(*) into V_CNT
FROM SBREXT.MDSR_CONCEPTS_SYNONYMS where TRIM(upper(CODE))=TRIM(upper(P_code))
and TRIM(upper(SYNONYM_NAME))= TRIM(upper(p_NAME));

IF  V_CNT=0 THEN
V_NAME:= 0;
ELSE
V_NAME:= 1;
END IF;
RETURN V_NAME;

EXCEPTION
WHEN OTHERS THEN
   raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);

END MDSR_GET_CONCEPT_SYN;
/

CREATE OR REPLACE PACKAGE BODY SBREXT."SBREXT_COMMON_ROUTINES" AS


 FUNCTION GET_AC_VERSION(P_AC_PREFERRED_NAME IN VARCHAR2
                          ,P_AC_CONTE_IDSEQ IN CHAR
						  ,P_ACTL_NAME IN VARCHAR2
						  ,P_TYPE IN VARCHAR2 DEFAULT 'LATEST') RETURN  NUMBER IS
/******************************************************************************
   NAME:       GET_AC_VERSION
   PURPOSE:    Gets the version of a component of Admin_Components based on preferred name and context

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/18/2001  Prerna Aggarwal     1. Created this procedure.


******************************************************************************/
v_ac NUMBER;
v_public_id number;
BEGIN
v_public_id := get_public_id(p_ac_preferred_name,p_ac_Conte_idseq,p_actl_name);

if v_public_id > 0 then
v_ac := get_public_version(v_public_id,p_type,p_actl_name);
else
v_Ac := v_public_id;
end if;

/*IF(P_TYPE = 'LATEST') THEN
  SELECT NVL(MAX(version),0) INTO v_ac
  FROM admin_components_view
  WHERE preferred_name = P_AC_PREFERRED_NAME
  AND conte_idseq = P_AC_CONTE_IDSEQ
  AND latest_version_ind = 'Yes'
  AND actl_name = P_ACTL_NAME;
  IF(v_ac IS NOT NULL) THEN
    RETURN  v_ac;
  END IF;
END IF;
IF(v_ac = 0 OR P_TYPE = 'HIGHEST') THEN
    SELECT MAX(version) INTO v_ac
    FROM admin_components_view
    WHERE preferred_name = P_AC_PREFERRED_NAME
    AND conte_idseq = P_AC_CONTE_IDSEQ
    AND actl_name = P_ACTL_NAME;
    RETURN  v_ac;
END IF;*/
  RETURN  v_ac;
END GET_AC_VERSION;

FUNCTION GET_VERSION_AC(P_AC_PREFERRED_NAME IN VARCHAR2
                          ,P_AC_CONTE_IDSEQ IN CHAR
			,P_ACTL_NAME IN VARCHAR2) RETURN  CHAR IS
/******************************************************************************
   NAME:       GET_VERSION_AC
   PURPOSE:    Gets the AC with the version

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        11/16/2001  Prerna Aggarwal     1. Created this procedure.


******************************************************************************/
v_version admin_components_view.version%TYPE;
v_ac      CHAR(36);
v_public_id number;
BEGIN
v_public_id := get_public_id(P_AC_PREFERRED_NAME,P_AC_CONTE_IDSEQ,P_ACTL_NAME);
v_version := get_ac_version(P_AC_PREFERRED_NAME,P_AC_CONTE_IDSEQ,P_ACTL_NAME);
IF v_version > 0 THEN
  if p_actl_name = 'DATAELEMENT' then
   SELECT de_idseq
	  INTO v_ac
      FROM data_elements o
     WHERE version = v_Version
	 AND cde_id= v_public_id;
  elsif p_actl_name = 'DE_CONCEPT' then
   SELECT dec_idseq
	  INTO v_ac
      FROM data_element_Concepts o
     WHERE version = v_Version
	 AND dec_id= v_public_id;

  elsif p_actl_name = 'CONCEPTUALDOMAIN' then
   SELECT cd_idseq
	  INTO v_ac
      FROM conceptual_domains o
     WHERE version = v_Version
	 AND cd_id= v_public_id;
  elsif p_actl_name = 'VALUEDOMAIN' then
   SELECT vd_idseq
	  INTO v_ac
      FROM value_domains o
     WHERE version = v_Version
	 AND vd_id= v_public_id;

  elsif p_actl_name = 'CLASSIFICATION' then
   SELECT cs_idseq
	  INTO v_ac
      FROM classification_schemes o
     WHERE version = v_Version
	 AND cs_id= v_public_id;
  elsif p_actl_name = 'OBJECTCLASS' then
   SELECT oc_idseq
	  INTO v_ac
      FROM OBJECT_CLASSES_EXT o
     WHERE version = v_Version
	 AND oc_id= v_public_id;
  elsif p_actl_name = 'OBJECTRECS' then
   SELECT ocr_idseq
	  INTO v_ac
      FROM OC_RECS_EXT o
     WHERE version = v_Version
	 AND ocr_id= v_public_id;
  elsif p_actl_name = 'CONCEPT' then
   SELECT con_idseq
	  INTO v_ac
      FROM CONCEPTS_EXT o
     WHERE version = v_Version
	 AND con_id= v_public_id;
  elsif p_actl_name ='PROPERTY' then
   SELECT prop_idseq
	  INTO v_ac
      FROM PROPERTIES_EXT o
     WHERE version = v_Version
	 AND prop_id = v_public_id;
  elsif p_actl_name ='PROTOCOLS' then
   SELECT proto_idseq
	  INTO v_ac
      FROM protocols_EXT o
     WHERE version = v_Version
	 AND proto_id= v_public_id;
  elsif p_actl_name = 'QUEST_CONTENT' then
   SELECT qc_idseq
	  INTO v_ac
      FROM QUEST_CONTENTS_EXT o
     WHERE version = v_Version
	 AND qc_id= v_public_id;
  end if;

return v_ac;
 /* BEGIN
    SELECT ac_idseq INTO v_ac
    FROM admin_components_view
    WHERE preferred_name = P_AC_PREFERRED_NAME
    AND conte_idseq  = P_AC_CONTE_IDSEQ
    AND actl_name = P_ACTL_NAME
    AND version = v_Version;
    RETURN v_ac;
  EXCEPTION WHEN OTHERS THEN
    RETURN NULL;
  END;*/
ELSE
  RETURN NULL;
END IF;
END GET_VERSION_AC;



FUNCTION GET_CT_VERSION(P_CT_NAME IN VARCHAR2)RETURN  NUMBER IS
/******************************************************************************
   NAME:       GET_CT_VERSION
   PURPOSE:    Gets the version of the context based on preferred name and context

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/23/2001  Lisa Schick     1. Created function


******************************************************************************/
v_ct NUMBER;
BEGIN
  SELECT MAX(version)
  INTO v_ct
  FROM contexts_view
  WHERE name = P_CT_NAME;

  RETURN  v_ct;

EXCEPTION WHEN NO_DATA_FOUND THEN
    RETURN  0;
END GET_CT_VERSION;

FUNCTION CONTEXT_EXISTS(P_CONTE_IDSEQ IN CHAR )RETURN  BOOLEAN IS
/******************************************************************************
   NAME:       CONTEXT_EXISTS
   PURPOSE:    Check to see if context exists

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/22/2001  Prerna Aggarwal     1. Created this function


******************************************************************************/
v_count  NUMBER;
BEGIN

IF p_conte_idseq IS NULL THEN
  RETURN TRUE;
END IF;

SELECT COUNT(*) INTO v_count
FROM contexts_view
WHERE conte_idseq = p_conte_idseq;

IF(v_count = 1) THEN
 RETURN  TRUE;
ELSE
 RETURN  FALSE;
END IF;
END CONTEXT_EXISTS;

FUNCTION AC_EXISTS(P_PREFERRED_NAME IN VARCHAR2
                  ,P_CONTE_IDSEQ IN CHAR
                  ,P_VERSION IN NUMBER
                  ,P_ACTL_NAME IN VARCHAR2)RETURN  BOOLEAN IS
/******************************************************************************
   NAME:       AC_EXISTS
   PURPOSE:    Check to see if administered component exists based on preferred name context and version

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/30/2001  Prerna Aggarwal     1. Created this function


******************************************************************************/
v_count  NUMBER;
BEGIN
SELECT COUNT(*) INTO v_count
FROM ADMIN_COMPONENTS_VIEW
WHERE preferred_name = P_PREFERRED_NAME
AND conte_idseq= P_CONTE_IDSEQ
AND version = P_VERSION
AND actl_name = P_ACTL_NAME
AND deleted_ind = 'No';

IF(v_count = 1) THEN
  RETURN  TRUE;
ELSE
  RETURN  FALSE;
END IF;
END AC_EXISTS;



FUNCTION AC_VERSION_EXISTS(P_PREFERRED_NAME IN VARCHAR2
                  ,P_CONTE_IDSEQ IN CHAR
                  ,P_ACTL_NAME IN VARCHAR2)RETURN  BOOLEAN IS
/******************************************************************************
   NAME:       AC_EXISTS
   PURPOSE:    Check to see if version of administered component exists
               based on preferred name context

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        11/16/2001  Prerna Aggarwal     1. Created this function


******************************************************************************/
v_count  NUMBER;
BEGIN
SELECT COUNT(*) INTO v_count
FROM ADMIN_COMPONENTS_VIEW
WHERE preferred_name = P_PREFERRED_NAME
AND conte_idseq= P_CONTE_IDSEQ
AND actl_name = P_ACTL_NAME
AND deleted_ind = 'No';

IF(v_count>0) THEN
  RETURN  TRUE;
ELSE
  RETURN  FALSE;
END IF;
END AC_VERSION_EXISTS;

FUNCTION AC_EXISTS(P_AC_IDSEQ IN CHAR)RETURN  BOOLEAN IS
/******************************************************************************
   NAME:       AC_EXISTS
   PURPOSE:    Check to see IF AC exists based on AC_IDSEQ

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/22/2001  Prerna Aggarwal     1. Created this function


******************************************************************************/
v_count  NUMBER;
BEGIN
SELECT COUNT(*) INTO v_count
FROM ADMIN_COMPONENTS_VIEW
WHERE ac_idseq = P_AC_IDSEQ
AND deleted_ind = 'No';

IF(v_count = 1) THEN
   RETURN  TRUE;
ELSE
  RETURN  FALSE;
END IF;
END AC_EXISTS;


FUNCTION PV_EXISTS(P_VALUE IN VARCHAR2
                 ,P_SHORT_MEANING IN VARCHAR2)RETURN  BOOLEAN IS
/******************************************************************************
   NAME:       PV_EXISTS
   PURPOSE:    Check to see if PV exists based on value and short meaning

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/22/2001  Prerna Aggarwal     1. Created this function


******************************************************************************/
v_count  NUMBER;
BEGIN
SELECT COUNT(*) INTO v_count
FROM PERMISSIBLE_VALUES_VIEW
WHERE VALUE = P_VALUE
AND SHORT_MEANING = P_SHORT_MEANING;

IF(v_count = 1) THEN
  RETURN  TRUE;
ELSE
  RETURN  FALSE;
END IF;
END PV_EXISTS;

FUNCTION PV_EXISTS(P_VALUE IN VARCHAR2
                 ,P_VM_IDSEQ IN VARCHAR2)RETURN  BOOLEAN IS
/******************************************************************************
   NAME:       PV_EXISTS
   PURPOSE:    Check to see if PV exists based on value and short meaning

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/22/2001  Prerna Aggarwal     1. Created this function


******************************************************************************/
v_count  NUMBER;
BEGIN
SELECT COUNT(*) INTO v_count
FROM PERMISSIBLE_VALUES_VIEW
WHERE VALUE = P_VALUE
AND VM_IDSEQ = P_VM_IDSEQ;

IF(v_count = 1) THEN
  RETURN  TRUE;
ELSE
  RETURN  FALSE;
END IF;
END PV_EXISTS;

FUNCTION PV_EXISTS(P_PV_IDSEQ IN CHAR)RETURN  BOOLEAN IS
/******************************************************************************
   NAME:       PV_EXISTS
   PURPOSE:    Check to see if PV exists based on PV_IDSEQ

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/22/2001  Prerna Aggarwal     1. Created this function


******************************************************************************/
v_count  NUMBER;
BEGIN
SELECT COUNT(*) INTO v_count
FROM PERMISSIBLE_VALUES_VIEW
WHERE PV_IDSEQ = P_PV_IDSEQ;

IF(v_count = 1) THEN
  RETURN  TRUE;
ELSE
  RETURN  FALSE;
END IF;
END PV_EXISTS;

FUNCTION VD_PVS_EXISTS(P_VD_IDSEQ IN CHAR
                      ,P_PV_IDSEQ IN CHAR)RETURN  BOOLEAN IS
/******************************************************************************
   NAME:       VD_EXISTS_PVS
   PURPOSE:    Check to see if VD_PVS exists based on VD_IDSEQ and PV_IDSEQ

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/22/2001  Prerna Aggarwal     1. Created this function


******************************************************************************/
v_count  NUMBER;
BEGIN
SELECT COUNT(*) INTO v_count
FROM VD_PVS_VIEW
WHERE VD_IDSEQ = P_VD_IDSEQ
AND PV_IDSEQ = P_PV_IDSEQ;

IF(v_count = 1) THEN
  RETURN  TRUE;
ELSE
  RETURN  FALSE;
END IF;
END VD_PVS_EXISTS;

FUNCTION VD_PVS_EXISTS(P_VP_IDSEQ IN CHAR)RETURN  BOOLEAN IS
/******************************************************************************
   NAME:       VD_EXISTS_PVS
   PURPOSE:    Check to see if VD_PVS exists based on P_VP_IDSEQ

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/22/2001  Prerna Aggarwal     1. Created this function


******************************************************************************/
v_count  NUMBER;
BEGIN
SELECT COUNT(*) INTO v_count
FROM VD_PVS_VIEW
WHERE VP_IDSEQ = P_VP_IDSEQ;

IF(v_count = 1) THEN
  RETURN  TRUE;
ELSE
  RETURN  FALSE;
END IF;
END VD_PVS_EXISTS;


FUNCTION VD_PVS_QC_EXISTS(P_VDPVS_VP_IDSEQ IN CHAR,
                          P_VDPVS_VD_IDSEQ IN CHAR)
                      RETURN  CHAR IS
/******************************************************************************
   NAME:       VD_PVS_QC_EXISTS
   PURPOSE:    Check to see if VD_IDSEQ or VP_IDSEQ provided is linked to
               a QUEST_CONTENTS record.
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        07/06/2004  Daniel Ladino     1. Created this function


******************************************************************************/
v_flag  VARCHAR2(1000) := NULL;
BEGIN

  IF P_VDPVS_VD_IDSEQ IS NOT NULL THEN
     BEGIN
        SELECT D.QC_IDSEQ
        INTO   v_flag
        FROM
           SBREXT.QUEST_CONTENTS_EXT D
         , SBR.VALUE_DOMAINS B
         , SBR.VD_PVS C
        WHERE
            (C.VD_IDSEQ = B.VD_IDSEQ)
        AND (D.VP_IDSEQ = C.VP_IDSEQ)
        AND (C.VD_IDSEQ = P_VDPVS_VD_IDSEQ)
        AND  ROWNUM = 1;
     END;
  ELSIF P_VDPVS_VP_IDSEQ IS NOT NULL THEN
     BEGIN
        SELECT D.QC_IDSEQ
        INTO   v_flag
        FROM
           SBREXT.QUEST_CONTENTS_EXT D
         , SBR.VD_PVS C
        WHERE
            (D.VP_IDSEQ = C.VP_IDSEQ)
        AND (C.VP_IDSEQ = P_VDPVS_VP_IDSEQ)
        AND  ROWNUM = 1;
     END;
  END IF;

  IF (v_flag IS NOT NULL) THEN
    RETURN  'TRUE';
  ELSE
    RETURN  'FALSE';
  END IF;

  EXCEPTION
     WHEN OTHERS THEN
        RETURN 'FALSE';
END VD_PVS_QC_EXISTS;

FUNCTION CD_VM_EXISTS(P_CD_IDSEQ IN VARCHAR2, P_SHORT_MEANING IN VARCHAR2 )RETURN BOOLEAN
 IS
/******************************************************************************
   NAME:       VD_EXISTS_PVS
   PURPOSE:    Check to see if VD_PVS exists based on P_VP_IDSEQ

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        12/20/2002  Judy Pai         1. Created this function


******************************************************************************/
v_count  NUMBER := 0;
BEGIN
SELECT COUNT(*) INTO v_count
FROM CD_VMS
WHERE CD_IDSEQ = P_CD_IDSEQ
AND SHORT_MEANING = P_SHORT_MEANING;

IF v_count > 0 THEN
  RETURN  TRUE;
ELSE
  RETURN  FALSE;
END IF;
END;

FUNCTION CD_VM_EXISTS(P_CD_IDSEQ IN VARCHAR2
                     , P_VM_IDSEQ IN VARCHAR2 )RETURN BOOLEAN
 IS
/******************************************************************************
   NAME:       VD_EXISTS_PVS
   PURPOSE:    Check to see if VD_PVS exists based on P_VP_IDSEQ

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        12/20/2002  Judy Pai         1. Created this function


******************************************************************************/
v_count  NUMBER := 0;
BEGIN
SELECT COUNT(*) INTO v_count
FROM CD_VMS
WHERE CD_IDSEQ = P_CD_IDSEQ
AND VM_IDSEQ = P_VM_IDSEQ;

IF v_count > 0 THEN
  RETURN  TRUE;
ELSE
  RETURN  FALSE;
END IF;
END;


FUNCTION WORKFLOW_EXISTS(P_ASL_NAME IN VARCHAR2 )RETURN  BOOLEAN IS
/******************************************************************************
   NAME:       WORKFLOW_EXISTS
   PURPOSE:    Check to see if workflow exists

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/22/2001  Prerna Aggarwal     1. Created this function


******************************************************************************/
v_count  NUMBER;
BEGIN
SELECT COUNT(*) INTO v_count
FROM AC_STATUS_LOV_VIEW
WHERE asl_name = P_ASL_NAME;

IF(v_count = 1) THEN
  RETURN  TRUE;
ELSE
  RETURN  FALSE;
END IF;
END WORKFLOW_EXISTS;


FUNCTION DATA_TYPE_EXISTS(P_DTL_NAME IN VARCHAR2 )RETURN  BOOLEAN IS
/******************************************************************************
   NAME:       DATA_TYPE_EXISTS
   PURPOSE:    Check to see if data type exists

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/22/2001  Prerna Aggarwal     1. Created this function


******************************************************************************/
v_count  NUMBER;
BEGIN
SELECT COUNT(*) INTO v_count
FROM datatypes_lov_view
WHERE dtl_name = p_dtl_name;

IF(v_count = 1) THEN
  RETURN  TRUE;
ELSE
  RETURN  FALSE;
END IF;
END DATA_TYPE_EXISTS;


FUNCTION VM_EXISTS(P_SHORT_MEANING IN VARCHAR2 )RETURN  BOOLEAN IS
/******************************************************************************
   NAME:       VM_EXISTS
   PURPOSE:    Check to see if value meaning exists

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/22/2001  Prerna Aggarwal     1. Created this function


******************************************************************************/
v_count  NUMBER;
BEGIN
SELECT COUNT(*) INTO v_count
FROM value_meanings_lov_view
WHERE short_meaning = p_short_meaning;

IF(v_count = 1) THEN
  RETURN  TRUE;
ELSE
  RETURN  FALSE;
END IF;
END VM_EXISTS;

FUNCTION VM_EXISTS(P_VM_IDSEQ IN VARCHAR2 )RETURN  BOOLEAN IS
/******************************************************************************
   NAME:       VM_EXISTS
   PURPOSE:    Check to see if value meaning exists

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/22/2001  Prerna Aggarwal     1. Created this function


******************************************************************************/
v_count  NUMBER;
BEGIN
SELECT COUNT(*) INTO v_count
FROM value_meanings_view
WHERE vm_idseq = p_vm_idseq;

IF(v_count = 1) THEN
  RETURN  TRUE;
ELSE
  RETURN  FALSE;
END IF;
END VM_EXISTS;

FUNCTION CHAR_SET_EXISTS(P_CHAR_SET_NAME IN VARCHAR2 )RETURN  BOOLEAN IS
/******************************************************************************
   NAME:       CHAR_SET_EXISTS
   PURPOSE:    Check to see IF character set exists

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/22/2001  Prerna Aggarwal     1. Created this function


******************************************************************************/
v_count  NUMBER;
BEGIN
SELECT COUNT(*) INTO v_count
FROM CHARACTER_SET_LOV_VIEW
WHERE CHAR_SET_NAME = P_CHAR_SET_NAME;

IF(v_count = 1) THEN
  RETURN  TRUE;
ELSE
  RETURN  FALSE;
END IF;
END CHAR_SET_EXISTS;

FUNCTION VD_FORMAT_EXISTS(P_FORML_NAME IN VARCHAR2 )RETURN  BOOLEAN IS
/******************************************************************************
   NAME:       VD_FORMAT_EXISTS
   PURPOSE:    Check to see IF formatset exists

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/22/2001  Prerna Aggarwal     1. Created this function


******************************************************************************/
v_count  NUMBER;
BEGIN
SELECT COUNT(*) INTO v_count
FROM FORMATS_LOV_VIEW
WHERE forml_name = P_FORML_NAME;

IF(v_count = 1) THEN
  RETURN  TRUE;
ELSE
  RETURN  FALSE;
END IF;
END VD_FORMAT_EXISTS;

FUNCTION UOML_EXISTS(P_UOML_NAME IN VARCHAR2 )RETURN  BOOLEAN IS
/******************************************************************************
   NAME:       UOML_EXISTS
   PURPOSE:    Check to see IF unit of measure set exists

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/22/2001  Prerna Aggarwal     1. Created this function


******************************************************************************/
v_count  NUMBER;
BEGIN
SELECT COUNT(*) INTO v_count
FROM UNIT_OF_MEASURES_LOV_VIEW
WHERE uoml_name = P_UOML_NAME;

IF(v_count = 1) THEN
  RETURN  TRUE;
ELSE
  RETURN  FALSE;
END IF;
END UOML_EXISTS;

FUNCTION PROPL_EXISTS(P_PROPL_NAME IN VARCHAR2 )RETURN  BOOLEAN IS
/******************************************************************************
   NAME:       PROPL_EXISTS
   PURPOSE:    Check to see if property exists

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/22/2001  Prerna Aggarwal     1. Created this function


******************************************************************************/
v_count  NUMBER;
BEGIN
SELECT COUNT(*) INTO v_count
FROM PROPERTIES_LOV_VIEW
WHERE propl_name = P_PROPL_NAME;

IF(v_count = 1) THEN
  RETURN  TRUE;
ELSE
  RETURN  FALSE;
END IF;
END PROPL_EXISTS;

FUNCTION OCL_EXISTS(P_OCL_NAME IN VARCHAR2 )RETURN  BOOLEAN IS
/******************************************************************************
   NAME:       OCL_EXISTS
   PURPOSE:    Check to see if object classes exists

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/22/2001  Prerna Aggarwal     1. Created this function


******************************************************************************/
v_count  NUMBER;
BEGIN
SELECT COUNT(*) INTO v_count
FROM OBJECT_CLASSES_LOV_VIEW
WHERE ocl_name = P_OCL_NAME;

IF(v_count = 1) THEN
  RETURN  TRUE;
ELSE
  RETURN  FALSE;
END IF;
END OCL_EXISTS;

FUNCTION QCDL_EXISTS(P_QCDL_NAME IN VARCHAR2 )RETURN  BOOLEAN IS
/******************************************************************************
   NAME:       QCDL_EXISTS
   PURPOSE:    Check to see if QC Display exists

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        12/04/2001  Prerna Aggarwal  1. Created this function
   2.1        02/09/2004  W. Ver Hoef      1. added upper function on comparison


******************************************************************************/
v_count  NUMBER;
BEGIN
SELECT COUNT(*) INTO v_count
FROM QC_DISPLAY_LOV_VIEW_EXT
WHERE UPPER(qcdl_name) = UPPER(P_QCDL_NAME); -- 09-Feb-2004, W. Ver Hoef - added upper function

IF(v_count = 1) THEN
  RETURN  TRUE;
ELSE
  RETURN  FALSE;
END IF;
END QCDL_EXISTS;


PROCEDURE VALID_DATE(P_RETURN_CODE OUT VARCHAR2
                     ,P_DATE_IN IN  VARCHAR2
                     ,P_DATE_OUT OUT DATE) IS
BEGIN
NULL;
END VALID_date;

FUNCTION VALID_NAME(P_STRING IN VARCHAR2 )RETURN  BOOLEAN IS
/******************************************************************************
   NAME:       VALID_NAME
   PURPOSE:    Allows only alphabets, numbers and '_''.

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        03/04/2002  Harsh Marwaha     1. Created this function


******************************************************************************/
v_ascii  NUMBER;
BEGIN
 /*IF P_STRING IS NOT NULL THEN
 FOR i IN 1 .. LENGTH(P_STRING) LOOP
  v_ascii :=  ASCII(SUBSTR(P_STRING,i,1));
    IF  NOT ((v_ascii >= 48 AND v_ascii <=57)
             OR (v_ascii >= 65 AND v_ascii <=90)
	         OR (v_ascii >= 97 AND v_ascii <=122)
	         OR  v_ascii = 95 OR v_ascii = 32) THEN
      RETURN FALSE;
    END IF;
 END LOOP;
 END IF;*/
 RETURN TRUE;
END;


FUNCTION VALID_ALPHANUMERIC(P_STRING IN VARCHAR2 )RETURN  BOOLEAN IS
/******************************************************************************
   NAME:       VALID_ALPHANUMERIC
   PURPOSE:    Allows only alphabets, numbers and '_''.
               The first letter can be an alphabet only

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        11/13/2001  Prerna Aggarwal     1. Created this function
   2.0        ???         Prerna Aggarwal     2.  commented out code per SPRF_2.0_15

******************************************************************************/
v_ascii  NUMBER;
BEGIN
 /*IF P_STRING IS NOT NULL THEN
 FOR i IN 1 .. LENGTH(P_STRING) LOOP
  v_ascii :=  ASCII(SUBSTR(P_STRING,i,1));
  IF(i > 1) THEN
    IF  NOT ((v_ascii >= 48 AND v_ascii <=57)
             OR (v_ascii >= 65 AND v_ascii <=90)
	         OR (v_ascii >= 97 AND v_ascii <=122)
	         OR  v_ascii = 95 OR v_ascii = 32) THEN
      RETURN FALSE;
    END IF;
  ELSIF(i = 1) THEN
    IF  NOT ((v_ascii >= 65 AND v_ascii <=90)
	         OR (v_ascii >= 97 AND v_ascii <=122)) THEN
      RETURN FALSE;
    END IF;
  END IF;
 END LOOP;
 END IF;*/
 RETURN TRUE;
END;

FUNCTION VALID_CHAR(P_STRING IN VARCHAR2 )RETURN  BOOLEAN IS
/******************************************************************************
   NAME:       VALID_CHAR
   PURPOSE:    Allows only printable characters

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        11/13/2001  Prerna Aggarwal     1. Created this function
   2.0        ???         Prerna Aggarwal     2.  commented out code per SPRF_2.0_15

******************************************************************************/
v_ascii NUMBER;
BEGIN
/*IF P_STRING IS NOT NULL THEN
FOR i IN 1 .. LENGTH(P_STRING) LOOP
  v_ascii :=  ASCII(SUBSTR(P_STRING,i,1));
  IF (v_ascii <32  OR v_ascii > 127) and v_ascii <> 10 and v_ascii <> 13 THEN
      RETURN FALSE;
  END IF;
 END LOOP;
END IF;*/
 RETURN TRUE;
END;



FUNCTION RD_EXISTS(P_AC_IDSEQ IN CHAR
                 ,P_NAME IN VARCHAR2)RETURN  BOOLEAN IS
/******************************************************************************
   NAME:       RD_EXISTS
   PURPOSE:    Check to see if RD exists based on ac_idseq, name

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/22/2001  Prerna Aggarwal     1. Created this function


******************************************************************************/
v_count  NUMBER;
BEGIN
SELECT COUNT(*) INTO v_count
FROM REFERENCE_DOCUMENTS_VIEW
WHERE ac_idseq = P_AC_IDSEQ
AND name = P_NAME;

IF(v_count = 1) THEN
  RETURN  TRUE;
ELSE
  RETURN  FALSE;
END IF;
END RD_EXISTS;

FUNCTION RD_EXISTS(P_RD_IDSEQ IN CHAR)RETURN  BOOLEAN IS
/******************************************************************************
   NAME:       RD_EXISTS
   PURPOSE:    Check to see if RD exists based on RD_IDSEQ

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/30/2001  Prerna Aggarwal     1. Created this function


******************************************************************************/
v_count  NUMBER;
BEGIN
SELECT COUNT(*) INTO v_count
FROM REFERENCE_DOCUMENTS_VIEW
WHERE RD_IDSEQ = P_RD_IDSEQ;

IF(v_count = 1) THEN
  RETURN  TRUE;
ELSE
  RETURN  FALSE;
END IF;
END RD_EXISTS;

FUNCTION DCTL_EXISTS(P_DCTL_NAME IN VARCHAR2 )RETURN  BOOLEAN IS
/******************************************************************************
   NAME:       DCTL_EXISTS
   PURPOSE:    Check to see if document type exists

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/30/2001  Prerna Aggarwal     1. Created this function


******************************************************************************/
v_count  NUMBER;
BEGIN
SELECT COUNT(*) INTO v_count
FROM DOCUMENT_TYPES_LOV_VIEW
WHERE dctl_name = P_DCTL_NAME;

IF(v_count = 1) THEN
  RETURN  TRUE;
ELSE
  RETURN  FALSE;
END IF;
END DCTL_EXISTS;

FUNCTION ACH_EXISTS(P_ACH_IDSEQ IN CHAR )RETURN  BOOLEAN IS
/******************************************************************************
   IDSEQ:       ACH_EXISTS
   PURPOSE:    Check to see if history exist exists

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/30/2001  Prerna Aggarwal     1. Created this function


******************************************************************************/
v_count  NUMBER;
BEGIN
SELECT COUNT(*) INTO v_count
FROM AC_HISTORIES_VIEW
WHERE ach_idseq = P_ACH_IDSEQ;

IF(v_count = 1) THEN
  RETURN  TRUE;
ELSE
  RETURN  FALSE;
END IF;
END ACH_EXISTS;


FUNCTION AR_EXISTS(P_AR_IDSEQ IN CHAR )RETURN  BOOLEAN IS
/******************************************************************************
   IDSEQ:       AR_EXISTS
   PURPOSE:    Check to see if AR exist exists

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/30/2001  Prerna Aggarwal     1. Created this function


******************************************************************************/
v_count  NUMBER;
BEGIN
SELECT COUNT(*) INTO v_count
FROM AC_REGISTRATIONS_VIEW
WHERE ar_idseq = P_AR_IDSEQ;

IF(v_count = 1) THEN
  RETURN  TRUE;
ELSE
  RETURN  FALSE;
END IF;
END AR_EXISTS;

FUNCTION ORG_EXISTS(P_ORG_IDSEQ IN CHAR )RETURN  BOOLEAN IS
/******************************************************************************
   IDSEQ:       ORG_EXISTS
   PURPOSE:    Check to see if ORG exist
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/30/2001  Prerna Aggargwal     1. Created this function


******************************************************************************/
v_count  NUMBER;
BEGIN
SELECT COUNT(*) INTO v_count
FROM ORGANIZATIONS_VIEW
WHERE org_idseq = P_ORG_IDSEQ;

IF(v_count = 1) THEN
  RETURN  TRUE;
ELSE
  RETURN  FALSE;
END IF;
END ORG_EXISTS;

FUNCTION DES_EXISTS(P_DESIG_IDSEQ IN CHAR)RETURN  BOOLEAN IS
/******************************************************************************
   NAME:       DES_EXISTS
   PURPOSE:    Check to see if DES exists based on DESIG_IDSEQ

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/30/2001  Prerna Aggarwal     1. Created this function


******************************************************************************/
v_count  NUMBER;
BEGIN
SELECT COUNT(*) INTO v_count
FROM DESIGNATIONS_VIEW
WHERE DESIG_IDSEQ = P_DESIG_IDSEQ;

IF(v_count = 1) THEN
  RETURN  TRUE;
ELSE
  RETURN  FALSE;
END IF;
END DES_EXISTS;

FUNCTION DES_EXISTS(P_AC_IDSEQ IN CHAR
                 ,P_NAME IN VARCHAR2
                 ,P_DETL_NAME IN VARCHAR2
                 ,P_CONTE_IDSEQ IN CHAR)RETURN  BOOLEAN IS
/******************************************************************************
   NAME:       DES_EXISTS
   PURPOSE:    Check to see if DES exists based on ac_idseq, name, detl_name, conte_idseq

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/22/2001  Prerna Aggarwal     1. Created this function


******************************************************************************/
v_count  NUMBER;
BEGIN
SELECT COUNT(*) INTO v_count
FROM DESIGNATIONS_VIEW
WHERE ac_idseq = P_AC_IDSEQ
AND name = P_NAME
AND conte_idseq = P_CONTE_IDSEQ
AND detl_name = P_DETL_NAME;

IF(v_count = 1) THEN
  RETURN  TRUE;
ELSE
  RETURN  FALSE;
END IF;
END DES_EXISTS;

FUNCTION DETL_EXISTS(P_DETL_NAME IN VARCHAR2 )RETURN  BOOLEAN IS
/******************************************************************************
   NAME:       DETL_EXISTS
   PURPOSE:    Check to see if Designation Type exists

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/30/2001  Prerna Aggarwal     1. Created this function


******************************************************************************/
v_count  NUMBER;
BEGIN
SELECT COUNT(*) INTO v_count
FROM DESIGNATION_TYPES_LOV_VIEW
WHERE detl_name = P_DETL_NAME;

IF(v_count = 1) THEN
  RETURN  TRUE;
ELSE
  RETURN  FALSE;
END IF;
END DETL_EXISTS;

FUNCTION LAE_EXISTS(P_LAE_NAME IN VARCHAR2 )RETURN  BOOLEAN IS
/******************************************************************************
   NAME:       LAE_EXISTS
   PURPOSE:    Check to see if  LANGUAGE exists

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/22/2001  Prerna Aggarwal     1. Created this function


******************************************************************************/
v_count  NUMBER;
BEGIN
SELECT COUNT(*) INTO v_count
FROM LANGUAGES_LOV_VIEW
WHERE name = P_LAE_NAME;

IF(v_count = 1) THEN
  RETURN  TRUE;
ELSE
  RETURN  FALSE;
END IF;
END LAE_EXISTS;


FUNCTION CSI_EXISTS(P_CSI_IDSEQ IN CHAR)RETURN  BOOLEAN IS
/******************************************************************************
   NAME:       CSI_EXISTS
   PURPOSE:    Check to see if CSI exists based on CSI_IDSEQ

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/30/2001  Prerna Aggarwal     1. Created this function


******************************************************************************/
v_count  NUMBER;
BEGIN
SELECT COUNT(*) INTO v_count
FROM CLASS_SCHEME_ITEMS_VIEW
WHERE CSI_IDSEQ = P_CSI_IDSEQ;

IF(v_count = 1) THEN
  RETURN  TRUE;
ELSE
  RETURN  FALSE;
END IF;
END CSI_EXISTS;

FUNCTION CS_CSI_EXISTS(P_CS_IDSEQ IN CHAR
                      ,P_CSI_IDSEQ IN CHAR
                      ,P_P_CS_CSI_IDSEQ IN CHAR)RETURN  BOOLEAN IS
/******************************************************************************
   NAME:       CS_CSI_IDSEQ
   PURPOSE:    Check to see if CS_CSI exists based on CS_IDSEQ and CSI_IDSEQ, P_CS_CSI_IDSEQ

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/22/2001  Prerna Aggarwal     1. Created this function


******************************************************************************/
v_count  NUMBER;
BEGIN
SELECT COUNT(*) INTO v_count
FROM CS_CSI_VIEW
WHERE CS_IDSEQ = P_CS_IDSEQ
AND CSI_IDSEQ = P_CSI_IDSEQ
AND P_CS_CSI_IDSEQ = P_P_CS_CSI_IDSEQ;

IF(v_count = 1) THEN
  RETURN  TRUE;
ELSE
  RETURN  FALSE;
END IF;
END CS_CSI_EXISTS;

FUNCTION CS_CSI_EXISTS(PAR_CS_CSI_IDSEQ IN CHAR)RETURN  BOOLEAN IS
/******************************************************************************
   NAME:       VD_EXISTS_PVS
   PURPOSE:    Check to see if CS_CSI exists based on P_CS_CSI_IDSEQ

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/22/2001  Prerna Aggarwal     1. Created this function


******************************************************************************/
v_count  NUMBER:=0;
BEGIN

SELECT COUNT(*) INTO v_count
FROM CS_CSI_VIEW
WHERE CS_CSI_IDSEQ = PAR_CS_CSI_IDSEQ;

IF(v_count = 1) THEN
  RETURN  TRUE;
ELSE
  RETURN  FALSE;
END IF;
END CS_CSI_EXISTS;

FUNCTION AC_CSI_EXISTS(P_AC_IDSEQ IN CHAR
                      ,P_CS_CSI_IDSEQ IN CHAR)RETURN  BOOLEAN IS
/******************************************************************************
   NAME:       AC_CSI_EXISTS
   PURPOSE:    Check to see if AC_CSI exists based on AC_IDSEQ and CS_CSI_IDSEQ

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/30/2001  Prerna Aggarwal     1. Created this function


******************************************************************************/
v_count  NUMBER;
BEGIN
SELECT COUNT(*) INTO v_count
FROM AC_CSI_VIEW
WHERE AC_IDSEQ = P_AC_IDSEQ
AND CS_CSI_IDSEQ = P_CS_CSI_IDSEQ;

IF(v_count = 1) THEN
  RETURN  TRUE;
ELSE
  RETURN  FALSE;
END IF;
END AC_CSI_EXISTS;

FUNCTION AC_CSI_EXISTS(P_AC_CSI_IDSEQ IN CHAR)RETURN  BOOLEAN IS
/******************************************************************************
   NAME:       AC_EXISTS_CS_CSIS
   PURPOSE:    Check to see if AC_CS_CSI exists based on P_AC_CSI_IDSEQ

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/30/2001  Prerna Aggarwal     1. Created this function


******************************************************************************/
v_count  NUMBER;
BEGIN
SELECT COUNT(*) INTO v_count
FROM AC_CSI_VIEW
WHERE AC_CSI_IDSEQ = P_AC_CSI_IDSEQ;

IF(v_count = 1) THEN
  RETURN  TRUE;
ELSE
  RETURN  FALSE;
END IF;
END AC_CSI_EXISTS;


FUNCTION SRC_EXISTS(P_NAME IN VARCHAR2 )RETURN  BOOLEAN IS
/******************************************************************************
   NAME:       SRC_EXISTS
   PURPOSE:    Check to see if source exists

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/22/2001  Prerna Aggarwal     1. Created this function


******************************************************************************/
v_count  NUMBER;
BEGIN
SELECT COUNT(*) INTO v_count
FROM SOURCES_VIEW_EXT
WHERE src_name = P_NAME;

IF(v_count = 1) THEN
  RETURN  TRUE;
ELSE
  RETURN  FALSE;
END IF;
END SRC_EXISTS;


FUNCTION ACSRC_EXISTS(P_AC_IDSEQ IN CHAR
                     ,P_SRC_NAME IN VARCHAR2)RETURN  BOOLEAN IS
/******************************************************************************
   NAME:       ACSRC_EXISTS
   PURPOSE:    Check to see if AC SRC exists based on ac_idseq,  source name

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/31/2001  Prerna Aggarwal     1. Created this function


******************************************************************************/
v_count  NUMBER;
BEGIN
SELECT COUNT(*) INTO v_count
FROM AC_SOURCES_VIEW_EXT
WHERE ac_idseq = P_AC_IDSEQ
AND src_name = P_SRC_NAME;

IF(v_count = 1) THEN
  RETURN  TRUE;
ELSE
  RETURN  FALSE;
END IF;
END ACSRC_EXISTS;

FUNCTION ACSRC_EXISTS(P_ACS_IDSEQ IN CHAR)RETURN  BOOLEAN IS
/******************************************************************************
   NAME:       ACSRC_EXISTS
   PURPOSE:    Check to see if AC SRC exists based on acs_idseq

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/31/2001  Prerna Aggarwal     1. Created this function


******************************************************************************/
v_count  NUMBER;
BEGIN
SELECT COUNT(*) INTO v_count
FROM AC_SOURCES_VIEW_EXT
WHERE ACS_IDSEQ = P_ACS_IDSEQ;

IF(v_count = 1) THEN
  RETURN  TRUE;
ELSE
  RETURN  FALSE;
END IF;
END ACSRC_EXISTS;

FUNCTION TSTL_EXISTS(P_TSTL_NAME IN VARCHAR2)RETURN  BOOLEAN IS
/******************************************************************************
   NAME:       RD_EXISTS
   PURPOSE:    Check to see if TSTL exists based on tstl_name

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/31/2001  Prerna Aggarwal     1. Created this function


******************************************************************************/
v_count  NUMBER;
BEGIN
SELECT COUNT(*) INTO v_count
FROM TS_TYPE_LOV_VIEW_EXT
WHERE TSTL_NAME = P_TSTL_NAME;

IF(v_count = 1) THEN
  RETURN  TRUE;
ELSE
  RETURN  FALSE;
END IF;
END TSTL_EXISTS;

FUNCTION TS_EXISTS(P_TS_IDSEQ IN CHAR)RETURN  BOOLEAN IS
/******************************************************************************
   NAME:       RD_EXISTS
   PURPOSE:    Check to see if Text String exists based on ts_idseq
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/31/2001  Prerna Aggarwal     1. Created this function


******************************************************************************/
v_count  NUMBER;
BEGIN
SELECT COUNT(*) INTO v_count
FROM text_strings_view_ext
WHERE ts_idseq = P_TS_IDSEQ;

IF(v_count = 1) THEN
  RETURN  TRUE;
ELSE
  RETURN  FALSE;
END IF;
END TS_EXISTS;

FUNCTION VPSRC_EXISTS(P_VP_IDSEQ IN CHAR
                     ,P_SRC_NAME IN VARCHAR2)RETURN  BOOLEAN IS
/******************************************************************************
   NAME:       VPSRC_EXISTS
   PURPOSE:    Check to see if VP SRC exists based on vp_idseq,  source name

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/31/2001  Prerna Aggarwal     1. Created this function


******************************************************************************/
v_count  NUMBER;
BEGIN
SELECT COUNT(*) INTO v_count
FROM VD_PVS_SOURCES_VIEW_EXT
WHERE vp_idseq = P_VP_IDSEQ
AND src_name = P_SRC_NAME;

IF(v_count = 1) THEN
  RETURN  TRUE;
ELSE
  RETURN  FALSE;
END IF;
END VPSRC_EXISTS;


FUNCTION VPSRC_EXISTS(P_VPS_IDSEQ IN CHAR)RETURN  BOOLEAN IS
/******************************************************************************
   NAME:       VDPVS_EXISTS
   PURPOSE:    Check to see if VP SRC exists based on vps_idseq

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/30/2001  Prerna Aggarwal     1. Created this function


******************************************************************************/
v_count  NUMBER;
BEGIN
SELECT COUNT(*) INTO v_count
FROM VD_PVS_SOURCES_VIEW_EXT
WHERE VPS_IDSEQ = P_VPS_IDSEQ;

IF(v_count = 1) THEN
  RETURN  TRUE;
ELSE
  RETURN  FALSE;
END IF;
END VPSRC_EXISTS;

FUNCTION GET_CD(P_CONTE_IDSEQ IN CHAR)RETURN  CHAR IS
v_name  VARCHAR2(30);
v_cd    CHAR(36);
v_version NUMBER;
BEGIN
--get the name of the context
BEGIN
  SELECT name INTO v_name
  FROM contexts_view
  WHERE conte_idseq = p_conte_idseq;

  BEGIN
    v_version := get_ac_version(v_name
                          ,P_CONTE_IDSEQ
						  ,'CONCEPTUALDOMAIN');
    SELECT cd_idseq INTO v_cd
    FROM conceptual_domains_view
    WHERE conte_idseq = P_CONTE_IDSEQ
    AND preferred_name = v_name
    AND version = v_version;

	RETURN v_cd;
  EXCEPTION WHEN NO_DATA_FOUND THEN
    RETURN NULL;
  END;
EXCEPTION WHEN NO_DATA_FOUND THEN
  RETURN NULL;
END;
END GET_CD;

FUNCTION QTL_EXISTS(P_QTL_NAME IN VARCHAR2 )RETURN  BOOLEAN IS
/******************************************************************************
   NAME:       QTL_EXISTS
   PURPOSE:    Check to see if QTL exists

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        11/09/2001  Prerna Aggarwal     1. Created this function


******************************************************************************/
v_count  NUMBER;
BEGIN
SELECT COUNT(*) INTO v_count
FROM QC_TYPE_LOV_VIEW_EXT
WHERE qtl_name = P_QTL_NAME;

IF(v_count = 1) THEN
  RETURN  TRUE;
ELSE
  RETURN  FALSE;
END IF;
END QTL_EXISTS;

FUNCTION REL_EXISTS(P_TABLE IN VARCHAR2
                    ,P_REL_IDSEQ IN CHAR) RETURN BOOLEAN IS
/******************************************************************************
   NAME:       REL_EXISTS
   PURPOSE:    Check to see if RELATIOSHIP exist exists based on the table and
               primary key

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        11/13/2001  Prerna Aggarwal     1. Created this function


******************************************************************************/
v_found NUMBER := 0;
BEGIN
IF (P_TABLE = 'DE_RECS') THEN
  SELECT COUNT(*) INTO v_found
  FROM de_recs_view
  WHERE de_rec_idseq = P_REL_IDSEQ;
  IF v_found = 1 THEN
    RETURN TRUE;
  END IF;
ELSIF (P_TABLE = 'DEC_RECS') THEN
  SELECT COUNT(*) INTO v_found
  FROM dec_recs_view
  WHERE dec_rec_idseq = P_REL_IDSEQ;
  IF v_found = 1 THEN
    RETURN TRUE;
  END IF;
ELSIF (P_TABLE = 'VD_RECS') THEN
  SELECT COUNT(*) INTO v_found
  FROM vd_recs_view
  WHERE vd_rec_idseq = P_REL_IDSEQ;
  IF v_found = 1 THEN
    RETURN TRUE;
  END IF;
ELSIF (P_TABLE = 'CS_RECS') THEN
  SELECT COUNT(*) INTO v_found
  FROM cs_recs_view
  WHERE cs_rec_idseq = P_REL_IDSEQ;
  IF v_found = 1 THEN
    RETURN TRUE;
  END IF;
ELSIF (P_TABLE = 'CSI_RECS') THEN
  SELECT COUNT(*) INTO v_found
  FROM csi_recs_view
  WHERE csi_rec_idseq = P_REL_IDSEQ;
  IF v_found = 1 THEN
    RETURN TRUE;
  END IF;
ELSIF (P_TABLE = 'QC_RECS_EXT') THEN
  SELECT COUNT(*) INTO v_found
  FROM qc_recs_view_ext
  WHERE qr_idseq = P_REL_IDSEQ;
  IF v_found = 1 THEN
    RETURN TRUE;
  END IF;
END IF;
RETURN FALSE;
END REL_EXISTS;

FUNCTION	REL_EXISTS(P_REL_TABLE IN VARCHAR2
                      ,P_REL_P_IDSEQ IN CHAR,
					   P_REL_C_IDSEQ IN CHAR) RETURN BOOLEAN IS
/******************************************************************************
   NAME:       REL_EXISTS
   PURPOSE:    Check to see if RELATIOSHIP exist exists based on the table
               and uniquekey

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        11/13/2001  Prerna Aggarwal     1. Created this function


******************************************************************************/
v_found NUMBER := 0;
BEGIN
IF (P_REL_TABLE = 'DE_RECS') THEN
  SELECT COUNT(*) INTO v_found
  FROM de_recs_view
  WHERE p_de_idseq = P_REL_P_IDSEQ
  AND   c_de_idseq = P_REL_C_IDSEQ;
  IF v_found = 1 THEN
    RETURN TRUE;
  END IF;
ELSIF (P_REL_TABLE = 'DEC_RECS') THEN
  SELECT COUNT(*) INTO v_found
  FROM dec_recs_view
  WHERE p_dec_idseq = P_REL_P_IDSEQ
  AND   c_dec_idseq = P_REL_C_IDSEQ;
  IF v_found = 1 THEN
    RETURN TRUE;
  END IF;
ELSIF (P_REL_TABLE = 'VD_RECS') THEN
  SELECT COUNT(*) INTO v_found
  FROM vd_recs_view
  WHERE p_vd_idseq = P_REL_P_IDSEQ
  AND   c_vd_idseq = P_REL_C_IDSEQ;
  IF v_found = 1 THEN
    RETURN TRUE;
  END IF;
END IF;
RETURN FALSE;
END REL_EXISTS;

FUNCTION VALID_AC(P_TABLE IN VARCHAR2
                  ,P_AC_IDSEQ IN CHAR) RETURN BOOLEAN IS
/******************************************************************************
   NAME:       VALID AC
   PURPOSE:    Check to see IF AC exists and matches the table

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        111/13/2001  Prerna Aggarwal     1. Created this function


******************************************************************************/
v_actl  VARCHAR2(30);
BEGIN
--if actl name is found then the AC exists

SELECT actl_name INTO v_actl
FROM ADMIN_COMPONENTS_VIEW
WHERE ac_idseq = P_AC_IDSEQ
AND deleted_ind = 'No';


IF(P_TABLE = 'DE_RECS' AND v_actl = 'DATAELEMENT') THEN
  RETURN TRUE;
ELSIF(P_TABLE = 'DEC_RECS' AND v_actl = 'DE_CONCEPT') THEN
  RETURN TRUE;
ELSIF(P_TABLE = 'VD_RECS' AND v_actl = 'VALUEDOMAIN') THEN
  RETURN TRUE;
ELSIF(P_TABLE = 'CS_RECS' AND v_actl = 'CLASSIFICATION') THEN
  RETURN TRUE;
ELSIF(P_TABLE = 'QC_RECS_EXT' AND v_actl = 'QUEST_CONTENT') THEN
  RETURN TRUE;
ELSE
  RETURN FALSE;
END IF;
EXCEPTION WHEN OTHERS THEN
  RETURN  FALSE;
END VALID_AC;

FUNCTION RL_EXISTS(P_REL_RL_NAME IN VARCHAR2) RETURN BOOLEAN IS
/******************************************************************************
   NAME:       RL_EXISTS
   PURPOSE:    Check to see if Relationship name exists

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        11/13/2001  Prerna Aggarwal     1. Created this function


******************************************************************************/
v_count  NUMBER;
BEGIN
SELECT COUNT(*) INTO v_count
FROM RELATIONSHIPS_LOV_VIEW
WHERE rl_name = P_REL_RL_NAME;

IF(v_count = 1) THEN
  RETURN  TRUE;
ELSE
  RETURN  FALSE;
END IF;
END RL_EXISTS;


FUNCTION CONDR_EXISTS(P_CONDR_IDSEQ IN VARCHAR2) RETURN BOOLEAN IS
/******************************************************************************
   NAME:       CONDR_EXISTS
   PURPOSE:    Check to see if Relationship name exists

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   3.0        12/16/2004  Prerna Aggarwal     1. Created this function


******************************************************************************/
v_count  NUMBER;
BEGIN
SELECT COUNT(*) INTO v_count
FROM CON_DERIVATION_RULES_EXT
WHERE condr_idseq = P_CONDR_IDSEQ;

IF(v_count = 1) THEN
  RETURN  TRUE;
ELSE
  RETURN  FALSE;
END IF;
END CONDR_EXISTS;


PROCEDURE set_ac_lvi(P_RETURN_CODE OUT VARCHAR2
	             ,P_AC_IDSEQ IN CHAR
		     ,P_ACTL_NAME IN VARCHAR2) IS
/******************************************************************************
   NAME:       set_Ac_lvi
   PURPOSE:    sets the latest version indicator to 'Yes'

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        11/15/2001  Prerna Aggarwal     1. Created this procedure


******************************************************************************/

v_preferred_name admin_components_view.preferred_name%TYPE;
v_conte_idseq admin_components_view.conte_idseq%TYPE;
v_public_id number;
BEGIN


IF ac_exists(P_AC_IDSEQ) THEN
    SELECT preferred_name,conte_idseq INTO v_preferred_name,v_conte_idseq
    FROM admin_components_view
    WHERE ac_idseq = P_AC_IDSEQ;
	    v_public_id := get_public_id(v_preferred_name,v_conte_idseq,p_Actl_name);
    IF P_ACTL_NAME IN ('DATAELEMENT', 'DE_CONCEPT', 'VALUEDOMAIN') THEN
      META_CONFIG_MGMT.LATEST_VERSION_IND(p_ac_idseq => P_AC_IDSEQ,
                                          p_component_type=> P_ACTL_NAME,
                                          p_preferred_name => v_preferred_name ,
                                          p_conte_idseq =>v_conte_idseq);
    ELSIF(P_ACTL_NAME = 'QUEST_CONTENT') THEN
       BEGIN
         UPDATE QUEST_CONTENTS_EXT
         SET latest_version_ind = 'No'
         WHERE qc_idseq <> p_ac_idseq
         AND qc_id = v_public_id;
       EXCEPTION WHEN NO_DATA_FOUND THEN
         NULL;
       END;
    END IF;
END IF;
EXCEPTION WHEN OTHERS THEN
  P_RETURN_CODE := 'Error';
END set_ac_lvi;

FUNCTION valid_arc(P_ID1 IN CHAR,P_ID2 IN CHAR,P_ID3 IN CHAR) RETURN BOOLEAN IS
BEGIN
/******************************************************************************
   NAME:       valid arc
   PURPOSE:    checks the arc between 3 idseqs

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        11/16/2001  Prerna Aggarwal     1. Created this function


******************************************************************************/

IF((P_ID1 IS NOT NULL AND P_ID2 IS NOT NULL AND P_ID3 IS NOT NULL) OR
    (P_ID1 IS NOT NULL AND P_ID2 IS NOT NULL AND P_ID3 IS NULL) OR
    (P_ID1 IS NOT NULL AND P_ID2 IS NULL AND P_ID3 IS NOT NULL) OR
    (P_ID1 IS NULL AND P_ID2 IS NOT NULL AND P_ID3 IS NOT NULL))THEN
       RETURN FALSE;
ELSE
 RETURN TRUE;
END IF;

END valid_arc;


FUNCTION RF_EXISTS(P_FEEDBACK IN VARCHAR2,
                      P_TYPE IN VARCHAR2)RETURN  BOOLEAN IS
/******************************************************************************
   NAME:       RF_EXISTS
   PURPOSE:    Check to see if Feedback exists

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        12/19/2001  Prerna Aggarwal     1. Created this function


******************************************************************************/
v_count  NUMBER;
BEGIN
SELECT COUNT(*) INTO v_count
FROM REVIEWER_FEEDBACK_LOV_VIEW_EXT
WHERE reviewer_feedback = P_FEEDBACK
AND reviewer_feedback_type = P_TYPE;

IF(v_count = 1) THEN
  RETURN  TRUE;
ELSE
  RETURN  FALSE;
END IF;
END RF_EXISTS;

FUNCTION get_de_vd(P_DE_IDSEQ IN CHAR) RETURN CHAR IS
/******************************************************************************
   NAME:       get_de_vd
   PURPOSE:    Returns value Domain of a Data Element

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        04/09/2002  Prerna Aggarwal     1. Created this function


******************************************************************************/
v_vd_idseq CHAR(36);
BEGIN
SELECT vd_idseq INTO v_vd_idseq
FROM data_elements
WHERE de_idseq = p_de_idseq;
 RETURN v_vd_idseq;
EXCEPTION WHEN NO_DATA_FOUND THEN
 RETURN NULL;
END;



FUNCTION QUAL_EXISTS(P_QUALIFIER_NAME IN VARCHAR2 )RETURN  BOOLEAN IS
/******************************************************************************
   NAME:       UOML_EXISTS
   PURPOSE:    Check to see IF uqualifier exists

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        4/08/2003  Prerna Aggarwal     1. Created this function


******************************************************************************/
v_count  NUMBER;
BEGIN
SELECT COUNT(*) INTO v_count
FROM QUALIFIER_LOV_VIEW_EXT
WHERE qualifier_name = P_QUALIFIER_NAME;

IF(v_count = 1) THEN
  RETURN  TRUE;
ELSE
  RETURN  FALSE;
END IF;
END QUAL_EXISTS;



/******************************************************************************
   NAME:       get_public_id
   TYPE: 	   FUNCTION
   PURPOSE:    To find the public id of an administered component based on the
               idseq.

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        7/17/2003   W. Ver Hoef      1. Created this function.
   2.0	  7/22/2003	  W. Ver Hoef	   1. Moved it to sbrext_common_routines
   3.1	  1/19/2006	  S. Chandler	 Uses public_id in admin_components_view

******************************************************************************/
FUNCTION get_public_id ( p_idseq VARCHAR2 ) RETURN NUMBER IS
  v_idseq  VARCHAR2(36);
  v_actl   VARCHAR2(20);
  v_id     NUMBER := -1;
BEGIN
  v_idseq := p_idseq;
  SELECT public_id
  INTO   v_id
  FROM   admin_components_view
  WHERE  ac_idseq = v_idseq;
  RETURN v_id;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    dbms_output.put_line('No Data Found');
    dbms_output.put_line('SQLCODE = '||SQLCODE);
	dbms_output.put_line('SQLERRM = '||SQLERRM);
    RETURN 0;
  WHEN OTHERS THEN
    dbms_output.put_line('Other Error Occurred');
    dbms_output.put_line('SQLCODE = '||SQLCODE);
	dbms_output.put_line('SQLERRM = '||SQLERRM);
	RETURN -1;
END get_public_id;


-- 09-Sep-2003, Prerna Aggarwal
PROCEDURE get_rd_idseq(p_ac_idseq IN VARCHAR2,
                          p_dctl_name IN VARCHAR2,
						  p_rd_idseq OUT type_rd_Search
						    )
IS

  v_select       VARCHAR2(2000) := ' ';
  v_from         VARCHAR2(2000) := ' ';
  v_where        VARCHAR2(2000) := ' ';
  v_sql          VARCHAR2(4000) := NULL;

BEGIN

  IF p_rd_idseq%ISOPEN THEN
    CLOSE p_rd_idseq;
  END IF;


  -- define the basic query
  v_select := 'SELECT rd_idseq';

  v_from := '
	FROM       reference_documents_view ';
  v_where := ' WHERE       dctl_name = '||''''||p_dctl_name||''''||
             ' AND   ac_idseq = '||''''||p_ac_idseq||'''';


  v_sql := v_select||v_from||v_where;

  -- get the data
  OPEN p_rd_idseq FOR v_sql;

END;

-- 09-Sep-2003, Prerna Aggarwal
PROCEDURE get_desig_idseq(p_ac_idseq IN VARCHAR2,
                          p_detl_name IN VARCHAR2,
						  p_desig_idseq OUT type_desig_Search
						    )
IS

  v_select       VARCHAR2(2000) := ' ';
  v_from         VARCHAR2(2000) := ' ';
  v_where        VARCHAR2(2000) := ' ';
  v_sql          VARCHAR2(4000) := NULL;

BEGIN

  IF p_desig_idseq%ISOPEN THEN
    CLOSE p_desig_idseq;
  END IF;


  -- define the basic query
  v_select := 'SELECT desig_idseq';

  v_from := '
	FROM       designations_view ';
  v_where := ' WHERE       detl_name = '||''''||p_detl_name||''''||
             ' AND   ac_idseq = '||''''||p_ac_idseq||'''';


  v_sql := v_select||v_from||v_where;

  -- get the data
  OPEN p_desig_idseq FOR v_sql;

END;

--Function added on 11/21/2003 to get EVS code
  FUNCTION get_evs_codes(P_AC_IDSEQ IN VARCHAR2
                         ,P_DETL_NAME IN VARCHAR2) RETURN VARCHAR2 IS

v_name designations.name%TYPE;
BEGIN

--if p_detl_name not in ('NCI_CONCEPT_CODE','TEMP_CUI','UMLS_CUI') then
IF p_detl_name NOT IN ('NCI_CONCEPT_CODE','NCI_META_CUI','UMLS_CUI') THEN --changed from temp_cui to nci_meta_cui
  RETURN 'Invalid Designation Type';
ELSE
  SELECT name INTO v_name
  FROM designations
  WHERE ac_idseq = p_ac_idseq
  AND detl_name = p_detl_name;

  RETURN v_name;
END IF;
EXCEPTION WHEN NO_DATA_FOUND THEN
 RETURN 'EVS Code not found';
WHEN TOO_MANY_ROWS THEN
 RETURN 'More than one EVS code exists';
END;


FUNCTION cd_exists( p_preferred_name VARCHAR2,
                    p_version        NUMBER,
					p_conte_idseq    CHAR )
RETURN BOOLEAN IS
/******************************************************************************
   NAME:       cd_exists
   TYPE: 	   FUNCTION
   PURPOSE:    To find out if a Conceptual Domain exists based on preferred_name,
               version and conte idseq.

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   2.1		  3/08/2004	  W. Ver Hoef	   1. Created this function.

******************************************************************************/
  v_count  NUMBER;
BEGIN
  SELECT COUNT(1)
  INTO   v_count
  FROM   conceptual_domains
  WHERE  preferred_name = p_preferred_name
  AND    version        = p_version
  AND    conte_idseq    = p_conte_idseq;
  IF(v_count = 1) THEN
    RETURN TRUE;
  ELSE
    RETURN FALSE;
  END IF;
END cd_exists;


FUNCTION crtl_exists( p_crtl_name VARCHAR2 )
RETURN BOOLEAN IS
/******************************************************************************
   NAME:       crtl_exists
   TYPE: 	   FUNCTION
   PURPOSE:    To find out if a complex representation type exists based on
               crtl_name.

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   2.1		  3/16/2004	  W. Ver Hoef	   1. Created this function.

******************************************************************************/
  v_count  NUMBER;
BEGIN
  SELECT COUNT(1)
  INTO   v_count
  FROM   complex_rep_type_lov
  WHERE  crtl_name = p_crtl_name;
  IF(v_count = 1) THEN
    RETURN TRUE;
  ELSE
    RETURN FALSE;
  END IF;
END crtl_exists;


FUNCTION cdt_exists( p_p_de_idseq CHAR )
RETURN BOOLEAN IS
/******************************************************************************
   NAME:       cdt_exists
   TYPE: 	   FUNCTION
   PURPOSE:    To find out if a complex data element exists based on
               p_de_idseq (FK reference to Parent DE_IDSEQ).

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   2.1		  3/16/2004	  W. Ver Hoef	   1. Created this function.

******************************************************************************/
  v_count  NUMBER;
BEGIN
  SELECT COUNT(1)
  INTO   v_count
  FROM   complex_data_elements
  WHERE  p_de_idseq = p_p_de_idseq;
  IF(v_count = 1) THEN
    RETURN TRUE;
  ELSE
    RETURN FALSE;
  END IF;
END cdt_exists;


FUNCTION cdr_exists( p_cdr_idseq CHAR )
RETURN BOOLEAN IS
/******************************************************************************
   NAME:       cdr_exists
   TYPE: 	   FUNCTION
   PURPOSE:    To find out if a complex de relationship exists based on
               p_cdr_idseq

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   2.1		  3/17/2004	  W. Ver Hoef	   1. Created this function.

******************************************************************************/
  v_count  NUMBER;
BEGIN
  SELECT COUNT(1)
  INTO   v_count
  FROM   complex_de_relationships
  WHERE  cdr_idseq = p_cdr_idseq;
  IF(v_count = 1) THEN
    RETURN TRUE;
  ELSE
    RETURN FALSE;
  END IF;
END cdr_exists;



FUNCTION get_default_asl ( p_action VARCHAR2 ,p_actl_name varchar2)
RETURN VARCHAR IS
/******************************************************************************
   NAME:       get_default_asl
   TYPE: 	   FUNCTION
   PURPOSE:    Returns the default workflow status for creates and versions

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   2.1		  3/19/2004	  Prerna Aggarwal   1. Created this function.

******************************************************************************/
BEGIN
  IF p_action = 'VERSION' THEN
    RETURN 'DRAFT MOD';
  ELSE
    if p_actl_name in ('OBJECTCLASS','PROPERTY','REPRESENTATION','CONCEPT') then
	 RETURN 'RELEASED';
	ELSE
     RETURN 'DRAFT NEW';
	END IF;
  END IF;
END;



FUNCTION rsl_exists( p_registration_status VARCHAR2 )
RETURN BOOLEAN IS
/******************************************************************************
   NAME:       rsl_exists
   TYPE: 	   FUNCTION
   PURPOSE:    To find out if a registration status exists based on
               registration_status.

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   2.1		  3/19/2004	  W. Ver Hoef	   1. Created this function.

******************************************************************************/
  v_count  NUMBER;
BEGIN
  SELECT COUNT(1)
  INTO   v_count
  FROM   reg_status_lov
  WHERE  registration_status = p_registration_status;
  IF(v_count = 1) THEN
    RETURN TRUE;
  ELSE
    RETURN FALSE;
  END IF;
END rsl_exists;



FUNCTION GET_CSI_LEVEL(PRM_CS_CSI_IDSEQ IN VARCHAR2) RETURN NUMBER IS
/******************************************************************************
   NAME:       GET_CSI_LEVEL
   TYPE: 	   FUNCTION
   PURPOSE:    To find  the level of a classification_scheme item within a classificarion scheme

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   3.0	    11/18/2004	  Prerna Aggarwal   1. Created this function.

******************************************************************************/
v_level NUMBER;
BEGIN
	  SELECT LEVEL INTO v_level
			 FROM cs_csi_view
			 WHERE cs_csi_idseq = prm_cs_csi_idseq
			 CONNECT BY PRIOR cs_csi_idseq = p_cs_csi_idseq
			 START WITH  p_cs_csi_idseq IS NULL;
		RETURN v_level;
END;

FUNCTION GET_CS_CSI_DO(PRM_CS_IDSEQ IN VARCHAR2,prm_cs_csi_idseq in varchar2) RETURN NUMBER IS
v_do NUMBER := 0;
cursor cs is
SELECT cs_Csi_idseq,rownum
			 FROM cs_csi_view
			 WHERE cs_idseq = prm_cs_idseq
			 CONNECT BY PRIOR cs_csi_idseq = p_cs_csi_idseq
			 START WITH  p_cs_csi_idseq IS NULL;
BEGIN
 for r_Rec in cs loop
	if r_rec.cs_Csi_idseq = prm_cs_csi_idseq then
	  v_Do := r_Rec.rownum;
	 end if;
 end loop;

 return v_do;
END;

	  FUNCTION long_name_exists(p_con_idseq IN VARCHAR2,p_long_name IN VARCHAR2) RETURN BOOLEAN IS
	  v_exists BOOLEAN :=FALSE;
	  v_count NUMBER;
	  BEGIN
		  SELECT COUNT(*) INTO v_count
		  FROM CONCEPTS_EXT
		  WHERE long_name = p_long_name
		  AND con_idseq = p_con_idseq;
		   IF v_count > 0 THEN
		    v_exists := TRUE;
		   END IF;

		   RETURN v_exists;
	  END;

	  FUNCTION definition_exists(p_con_idseq IN VARCHAR2,p_definition IN VARCHAR2) RETURN BOOLEAN IS
	  v_exists BOOLEAN :=FALSE;
	  v_count NUMBER;
	  BEGIN
		  SELECT COUNT(*) INTO v_count
		  FROM CONCEPTS_EXT
		  WHERE preferred_definition = p_definition
		  AND con_idseq = p_con_idseq;
		   IF v_count > 0 THEN
		    v_exists := TRUE;
		   END IF;

		   RETURN v_exists;
	  END;


FUNCTION VALID_PARENT_CONCEPT(P_CON_IDSEQ IN VARCHAR2,P_VD_IDSEQ IN VARCHAR2 )RETURN BOOLEAN IS
v_count NUMBER;
BEGIN
SELECT COUNT(*) INTO v_count
FROM value_Domains d
,COMPONENT_CONCEPTS_EXT cc
WHERE d.condr_idseq = cc.condr_idseq
AND cc.con_idseq = p_con_idseq
AND d.vd_idseq = p_vd_idseq;

IF v_count = 0 THEN
  RETURN FALSE;
ELSE
  RETURN TRUE;
END IF;
END;

FUNCTION check_derivation_exists(p_con_array IN VARCHAR2) RETURN VARCHAR2 IS

/******************************************************************************
   NAME:       check_derivation_exists
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        11/6/2006          1. Created this function.
   1.1        11/7/2006          1. Changed declaration of v_array to omit REPLACE function that
                                    was removing blanks from p_con_array.

   NOTES:

   Automatically available Auto Replace Keywords:
      Object Name:     check_derivation_exists
      Sysdate:         11/6/2006
      Date and Time:   11/6/2006, 11:19:02 AM, and 11/6/2006 11:19:02 AM
      Username:         (set in TOAD Options, Procedure Editor)
      Table Name:       (set in the "New PL/SQL Object" dialog)

******************************************************************************/

CURSOR condr IS
SELECT condr_idseq
FROM CON_DERIVATION_RULES_EXT;

CURSOR comp(p_condr_idseq IN VARCHAR2) IS
SELECT con_idseq
,      concept_value
FROM COMPONENT_CONCEPTS_EXT
WHERE condr_idseq = p_condr_idseq
ORDER BY display_order desc;

v_condr_array VARCHAR2(2000);
rec_con_idseq VARCHAR2(2000);

v_array VARCHAR2(2000) := p_con_array;

v_condr_idseq VARCHAR2(36) NULL;


BEGIN


FOR n_rec IN condr  LOOP
 v_condr_array := ' ';

  FOR c_rec IN comp(n_rec.condr_idseq) LOOP
     -- also addec COMPONENT_CONCEPT to the SELECT clause of cursor COMP
	 rec_con_idseq := c_rec.con_idseq;
	IF c_rec.concept_value IS NOT NULL THEN
	   rec_con_idseq := c_rec.con_idseq||':'||c_rec.concept_value;
	END IF;

    IF v_condr_array =' ' THEN
	  v_condr_array := rec_con_idseq;
	ELSE
	  v_condr_array := v_condr_array||','||rec_con_idseq;
	END IF;
  END LOOP;
   IF v_condr_array = v_array THEN
     v_condr_idseq := n_rec.condr_idseq;
	 DBMS_OUTPUT.Put_Line(v_array || ' array ' || v_condr_array);
     RETURN v_condr_idseq;
  END IF;
--IF INSTR(v_condr_array,':') <> 0 THEN
--  DBMS_OUTPUT.Put_Line(n_rec.condr_idseq || ' array ' || v_condr_array);
--END IF;
END LOOP;

    RETURN v_condr_idseq;

END check_derivation_exists;

/* end of new function */

FUNCTION set_derivation_rule(p_con_array IN VARCHAR2)
  RETURN VARCHAR2 IS
  v_condr_idseq CHAR(36);
  v_con_idseq CHAR(36);
  v_con_idseq2 VARCHAR2(1000)   :=  NULL;
  cv_string VARCHAR2(30);
  cv_string VARCHAR2(100);
  cv NUMBER := 0;
  v_code VARCHAR2(30);
  v_name VARCHAR2(255);
  v_type VARCHAR2(20);
  i  NUMBER := 1;
  v_count NUMBER := 0;
  v_con_idseq_string VARCHAR2(4000) := p_con_array;
  v_flag VARCHAR2(3);
  v_concept_value     sbrext.component_concepts_ext.concept_value%TYPE;
BEGIN
  --check to see if derivation rule already exists
  -- dbms_output.put_line('Input: '||p_con_array);
  v_condr_idseq := sbrext_common_routines.check_derivation_exists(p_con_array);

  --if it does then send the existing condr_idseq
  IF v_condr_idseq IS NOT NULL THEN
    RETURN v_condr_idseq;
  END IF;

  -- otherwise create a new derivation rule
  v_condr_idseq := admincomponent_Crud.cmr_guid;

  IF INSTR(p_con_Array,',') = 0 THEN
     v_type := 'Simple Concept';
  ELSE
     v_type := 'CONCATENATION';
  END IF;


  INSERT INTO CON_DERIVATION_RULES_EXT(
     CONDR_IDSEQ
    ,CRTL_NAME
    ,NAME )
  VALUES (
     v_condr_idseq
    ,v_type
    ,'X');

  -- Create component_concepts
  WHILE (i != 0 AND v_con_idseq_string IS NOT NULL) LOOP
    i := INSTR(v_con_idseq_string ,',',-1,1);

        IF i = 0 THEN -- single fragment

            IF instr(v_con_idseq_string,':') > 0 THEN -- fragment has concatenated value

              v_con_idseq := TRIM(
                                  SUBSTR(v_con_idseq_string
                                         ,1
                                         ,INSTR(v_con_idseq_string,':')-1
                                         )
                                 );
             v_concept_value := TRIM(
                                   SUBSTR(v_con_idseq_string
                                         ,INSTR(v_con_idseq_string,':')+1
                                         )
                                      );

            ELSE -- fragment is simple value
              v_con_idseq := TRIM(v_con_idseq_string);

            END IF;

        ELSE    -- fragment contains multiple concepts
          -- extract a single fragment; position is from the *last* comma to the end
          v_con_idseq2 := substr(v_con_idseq_string
                                ,instr(v_con_idseq_string,',',-1,1)+1);
          -- check for a concatenated value
          IF instr(v_con_idseq2,':') > 0 THEN
              -- pull off the idseq
        	    v_con_idseq := TRIM(
    	                            SUBSTR(v_con_idseq2
    	                                  ,1
    	                                  ,INSTR(v_con_idseq2,':')-1)
    	                            );
              -- pull off the value
              v_concept_value := TRIM(
                                   SUBSTR(v_con_idseq2
                                         ,INSTR(v_con_idseq2,':') +1)
                                      );
    	     ELSE -- no catcatenated value, so use the fragment
    	       v_con_idseq := TRIM(v_con_idseq2);
    	     END IF;
    	   END IF;


  	  SELECT preferred_name INTO v_code
      FROM CONCEPTS_EXT
      WHERE deleted_ind = 'No'
      AND con_idseq = v_con_idseq;

  	   if v_name is null then
  	     v_name := v_code;
  	   else
          v_name := v_name||':'||v_code;
  	   end if;
  	  IF(v_count = 0) THEN
  	   v_flag := 'Yes';
         --v_name := v_code;
  	  ELSE
  	    v_flag := 'No';
  	  END IF;

  	  INSERT INTO COMPONENT_CONCEPTS_EXT(
  	     CC_IDSEQ
        ,CONDR_IDSEQ
        ,CON_IDSEQ
        ,DISPLAY_ORDER
  		  ,PRIMARY_FLAG_IND
  		  ,CONCEPT_VALUE)
  		VALUES(
  		   admincomponent_crud.cmr_guid
  		  ,v_condr_idseq
  			,v_con_idseq
  			,v_count
  			,v_flag
  		  ,v_concept_value);

    	   -- shorten string by removing fragements from right to left
      v_con_idseq_string := substr(v_con_idseq_string,1,instr(v_con_idseq_string,',',-1,1)-1);

         -- reset values and increment counter
         v_con_idseq2 := NULL;
         v_concept_value := NULL;
         v_count := v_count + 1;


      END LOOP;

    update component_Concepts_Ext
    set primary_flag_ind = 'Yes'
    where display_order = v_count
    and condr_idseq = v_condr_idseq;

    UPDATE CON_DERIVATION_RULES_EXT
    SET name = get_condr_preferred_name(v_condr_idseq)--nvl(v_name,'x')
    WHERE condr_idseq = v_condr_idseq;
  	RETURN v_condr_idseq;


   EXCEPTION WHEN NO_DATA_FOUND THEN
      DELETE FROM COMPONENT_CONCEPTS_EXT
  	  WHERE condr_idseq = v_condr_idseq;

  	  DELETE FROM CON_DERIVATION_RULES_EXT
  	  WHERE condr_idseq = v_condr_idseq;

  	  RETURN 'Concept Not Found';

END set_derivation_rule;


PROCEDURE set_oc_rep_prop(p_condr_idseq IN VARCHAR2
,p_return_code OUT VARCHAR2
,p_conte_idseq IN VARCHAR2
,p_actl_name IN VARCHAR2
,p_ac_idseq OUT VARCHAR2
)  IS

p_ua_name VARCHAR2(30);

BEGIN

p_ua_name := admin_security_util.effective_user;

set_oc_rep_prop(p_condr_idseq,
    p_return_code,
    p_conte_idseq,
    p_actl_name,
    p_ac_idseq,
    p_ua_name);

RETURN;
END;

PROCEDURE set_vm_condr(p_condr_idseq IN VARCHAR2
          ,p_return_code OUT VARCHAR2
          ,p_short_meaning IN OUT VARCHAR2
          )  IS
    v_comments VARCHAR2(2000);
    v_short_meaning VARCHAR2(2000);
    v_description VARCHAR2(4000);
    v_name VARCHAR2(255);
    v_crtl_name VARCHAR2(50);
    v_count number;

  CURSOR con(p_con_idseq IN VARCHAR2) IS
    SELECT * FROM CONCEPTS_EXT
    WHERE con_idseq = p_con_idseq;

  CURSOR comp_con IS
    SELECT * FROM COMPONENT_CONCEPTS_EXT
    WHERE condr_idseq = p_condr_idseq
    ORDER BY display_order desc;

BEGIN

 IF NOT sbrext.sbrext_common_routines.condr_Exists(p_condr_idseq) THEN
   p_return_code := 'Invalid Derivation Rule';
   RETURN;
 END IF;

  SELECT name
  ,      crtl_name
  INTO   v_name
  ,      v_crtl_name
  FROM CON_DERIVATION_RULES_EXT
  WHERE condr_idseq = p_condr_idseq;

  v_comments := v_name;

  FOR m_rec IN comp_con LOOP
      FOR c_rec IN con(m_rec.con_idseq) LOOP

/*  	    --add the concept_value to the long name -- commented out 12/4/2006; s. alred
  	    IF m_rec.concept_value is not null then
  	 	    c_rec.long_name := c_rec.long_name ||'::'||m_rec.concept_value;
  		    --not sure if definition is needed here
  	    END IF;
*/
        --add the concept_value to the long name
        IF m_rec.concept_value is not null then
          c_rec.long_name := c_rec.long_name ||'::'||m_rec.concept_value;
          c_rec.preferred_definition := c_rec.preferred_definition||'::'||m_rec.concept_value;
        END IF;

  	    IF v_short_meaning IS NULL THEN
  	      v_short_meaning := c_rec.long_name;
  	    ELSE
  	       v_short_meaning := v_short_meaning||' '||c_rec.long_name;
  	    END IF;

  	    IF v_description IS NULL THEN
  	        v_description := c_rec.preferred_definition;
  	  	ELSE
  	        v_description := v_description||': '||c_rec.preferred_definition;
  	    END IF;

       END LOOP;
  END LOOP;

  v_description := SUBSTR(v_description,1,2000);

  if(p_short_meaning is not null) then
    v_short_meaning := p_short_meaning;
  else
    v_short_meaning := SUBSTR(v_short_meaning,1,255);
  end if;

  select count(*) into v_count
  from value_meanings_lov
  where short_meaning = v_short_meaning;

  if v_count = 1 then
   update value_meanings_lov
   set condr_idseq = p_condr_idseq
   , description = v_description
   where short_meaning = v_short_meaning;
  else
    INSERT INTO value_meanings_lov(SHORT_MEANING
                                ,DESCRIPTION
                                ,COMMENTS
                                ,BEGIN_DATE
                                ,END_DATE
                                ,CONDR_IDSEQ    )
    VALUES
    (
      v_short_meaning
     ,v_description
     ,v_comments
     ,SYSDATE
     ,null
     ,p_condr_idseq);
  end if;

  p_short_meaning := v_short_meaning;

EXCEPTION WHEN OTHERS THEN
  p_return_code := 'Error Creating value meaning';
  RETURN;
END;


PROCEDURE set_vm_condr(p_condr_idseq IN VARCHAR2
          ,p_return_code OUT VARCHAR2
          ,p_vm_idseq IN OUT VARCHAR2
          )  IS
    v_change_note VARCHAR2(2000);
    v_long_name VARCHAR2(2000);
    v_preferred_definition VARCHAR2(4000);
    v_name VARCHAR2(255);
    v_crtl_name VARCHAR2(50);
    v_count number;
    v_vm_idseq value_meanings.vm_idseq%type;

  CURSOR con(p_con_idseq IN VARCHAR2) IS
    SELECT * FROM CONCEPTS_EXT
    WHERE con_idseq = p_con_idseq;

  CURSOR comp_con IS
    SELECT * FROM COMPONENT_CONCEPTS_EXT
    WHERE condr_idseq = p_condr_idseq
    ORDER BY display_order desc;

BEGIN

 IF NOT sbrext.sbrext_common_routines.condr_Exists(p_condr_idseq) THEN
   p_return_code := 'Invalid Derivation Rule';
   RETURN;
 END IF;

  SELECT name
  ,      crtl_name
  INTO   v_name
  ,      v_crtl_name
  FROM CON_DERIVATION_RULES_EXT
  WHERE condr_idseq = p_condr_idseq;


  FOR m_rec IN comp_con LOOP
      FOR c_rec IN con(m_rec.con_idseq) LOOP

/*  	    --add the concept_value to the long name -- commented out 12/4/2006; s. alred
  	    IF m_rec.concept_value is not null then
  	 	    c_rec.long_name := c_rec.long_name ||'::'||m_rec.concept_value;
  		    --not sure if definition is needed here
  	    END IF;
*/
        --add the concept_value to the long name
        IF m_rec.concept_value is not null then
          c_rec.long_name := c_rec.long_name ||'::'||m_rec.concept_value;
          c_rec.preferred_definition := c_rec.preferred_definition||'::'||m_rec.concept_value;
        END IF;

  	    IF v_long_name IS NULL THEN
  	      v_long_name := c_rec.long_name;
  	    ELSE
  	       v_long_name := v_long_name||' '||c_rec.long_name;
  	    END IF;

  	    IF v_preferred_definition IS NULL THEN
  	        v_preferred_definition := c_rec.preferred_definition;
  	  	ELSE
  	        v_preferred_definition := v_preferred_definition||': '||c_rec.preferred_definition;
  	    END IF;

       END LOOP;
  END LOOP;

  v_preferred_definition := SUBSTR(v_preferred_Definition,1,2000);

  if(p_vm_idseq is not null) then
    v_vm_idseq := p_vm_idseq;
  else
    v_vm_idseq := admincomponent_crud.cmr_guid;
  end if;

  select count(*) into v_count
  from value_meanings
  where vm_idseq = v_vm_idseq;

  if v_count = 1 then
   update value_meanings
   set condr_idseq = p_condr_idseq
   , preferred_Definition = v_preferred_definition
   ,long_name = v_long_name
   where vm_idseq = v_vm_idseq;
  else
    INSERT INTO value_meanings(VM_IDSEQ
                                 ,long_name
                                ,preferred_Definition
                                ,BEGIN_DATE
                                ,END_DATE
                                ,CONDR_IDSEQ    )
    VALUES
    (v_vm_idseq
     , v_long_name
     ,v_preferred_definition
     ,SYSDATE
     ,null
     ,p_condr_idseq);
  end if;

  p_vm_idseq := v_vm_idseq;

EXCEPTION WHEN OTHERS THEN
  p_return_code := 'Error Creating value meaning';
  RETURN;
END;
FUNCTION get_dec_list(p_oc_idseq in varchar2,p_prop_idseq in varchar2, p_dec_id in number) return varchar2
is
  cursor dec(p_oc_id in number, p_prop_id in number,p_dec_id in number,p_oc_version in number,p_prop_version in number)  is
	  select d.dec_id, d.version
	  from data_element_Concepts d,
	  object_classes_ext o,
	  properties_ext p
	  where d.oc_idseq = o.oc_idseq(+)
	  and d.prop_idseq = p.prop_idseq(+)
	  and nvl(o.oc_id,-1) = nvl(p_oc_id,-1)
	  and nvl(p.prop_id,-1) = nvl(p_prop_id, -1)
	  and d.dec_id <> nvl(p_dec_id,-1)
	  and nvl(o.version,-1) = nvl(p_oc_version,-1)
	  and nvl(p.version,-1) = nvl(p_prop_version, -1);

	  dec_list varchar2(4000);

	  v_oc_id  number;
	  v_prop_id  number;
	  v_oc_version number;
	  v_prop_version number;
begin


		 if (P_OC_IDSEQ is not null) then
	  select oc_id, version into v_oc_id, v_oc_version
	  from object_Classes_Ext
	  where oc_idseq =P_OC_IDSEQ;
	 end if;

	 if P_PROP_IDSEQ is not null then

	  select prop_id, version into v_prop_id, v_prop_version
	  from properties_Ext
	  where prop_idseq =P_PROP_IDSEQ;
	 end if;





	  for d_rec in dec(v_oc_id,v_prop_id,p_dec_id,v_oc_version,v_prop_version) loop
	    if dec_list is null then
		  dec_list := d_rec.dec_id||' v'||d_rec.version;
		else
		   dec_list := dec_list||','||d_rec.dec_id||' v'||d_rec.version;
		end if;

	  end loop;

 return dec_list;
 exception when others then
  return('Error in checking OC, PROP combination');
end;

FUNCTION get_dec_conte(p_oc_idseq in varchar2,p_prop_idseq in varchar2,p_conte_idseq in varchar2, p_dec_id in number) return varchar2
is
  cursor dec(p_oc_id in number, p_prop_id in number,p_dec_id in number,p_oc_version in number,p_prop_version in number) is
	  select d.dec_id, d.version
	  from data_element_Concepts d,
	  object_classes_ext o,
	  properties_ext p
	  where d.oc_idseq = o.oc_idseq(+)
	  and d.prop_idseq = p.prop_idseq(+)
	  and nvl(o.oc_id,-1) = nvl(p_oc_id,-1)
	  and nvl(p.prop_id,-1) = nvl(p_prop_id, -1)
	  and nvl(o.version,-1) = nvl(p_oc_version,-1)
	  and nvl(p.version,-1) = nvl(p_prop_version, -1)
	  and d.dec_id <> nvl(p_dec_id,-1)
	  and d.conte_idseq = p_conte_idseq;

	  dec_list varchar2(4000);

	  v_oc_id  number;
	  v_prop_id  number;
	  v_oc_version number;
	  v_prop_version number;
begin


	 if (P_OC_IDSEQ is not null) then
	  select oc_id, version into v_oc_id, v_oc_version
	  from object_Classes_Ext
	  where oc_idseq =P_OC_IDSEQ;
	 end if;

	 if P_PROP_IDSEQ is not null then

	  select prop_id, version into v_prop_id, v_prop_version
	  from properties_Ext
	  where prop_idseq =P_PROP_IDSEQ;
	 end if;




	  for d_rec in dec(v_oc_id,v_prop_id,p_dec_id,v_oc_version,v_prop_version) loop
	    if dec_list is null then
		  dec_list := d_rec.dec_id||' v'||d_rec.version;
		else
		   dec_list := dec_list||','||d_rec.dec_id||' v'||d_rec.version;
		end if;

	  end loop;

 return dec_list;
 exception when others then
  return('Error in checking OC, PROP combination');
end;


FUNCTION dec_vd_uk(p_dec_idseq in varchar2,p_vd_idseq in varchar2, p_cde_id in number,p_conte_idseq in varchar2) return boolean is

	  v_count number;

	  v_vd_id  number;
	  v_dec_id  number;
begin

	  select vd_id into v_vd_id
	  from value_domains
	  where vd_idseq =P_VD_IDSEQ;

	  select dec_id into v_dec_id
	  from data_element_Concepts
	  where dec_idseq =P_DEC_IDSEQ;

	  select count(*) into v_count
	  from data_element_Concepts dec,
	  data_elements d,
	  value_domains v
	  where d.dec_idseq = dec.dec_idseq
	  and d.vd_idseq = v.vd_idseq
	  and d.conte_idseq = p_conte_idseq
	  and dec_id = v_dec_id
	  and vd_id = v_vd_id
	  and d.cde_id <> nvl(p_cde_id,-1);

	  if v_count = 0 then
	   return true;
	  else
	   return false;
	  end if;
end;

FUNCTION get_concept(p_evs_code in varchar2
	                ,p_long_name in varchar2
					,p_preferred_definition in varchar2
					,p_conte_idseq in varchar2
					,p_definition_source in varchar2
					,p_origin in varchar2
					,p_evs_source in varchar2) return varchar2 is
v_Con_idseq varchar2(2000);
begin
 begin
   select con_idseq into v_Con_idseq
   from concepts_Ext
   where preferred_name = p_evs_code;
 exception when no_data_found then
   v_Con_idseq := admincomponent_Crud.cmr_guid;

   insert into concepts_ext(CON_IDSEQ
                             ,PREFERRED_NAME
                             ,LONG_NAME
                             ,PREFERRED_DEFINITION
                             ,CONTE_IDSEQ
                             ,VERSION
                             ,ASL_NAME
                             ,LATEST_VERSION_IND
                             ,BEGIN_DATE
                             ,DEFINITION_SOURCE
                             ,ORIGIN
                             ,DELETED_IND
                             ,EVS_SOURCE )
                   values (   v_con_idseq --CON_IDSEQ
                             ,p_evs_code --PREFERRED_NAME
                             ,p_long_name --LONG_NAME
                             ,p_preferred_definition --PREFERRED_DEFINITION
                             ,p_conte_idseq --CONTE_IDSEQ
                             ,1 --VERSION
                             ,'RELEASED' --ASL_NAME
                             ,'Yes' --LATEST_VERSION_IND
                             ,sysdate --BEGIN_DATE
                             ,p_definition_source --DEFINITION_SOURCE
                             ,p_origin --ORIGIN
                             ,'No' --DELETED_IND
                             ,p_evs_source );--EVS_SOURCE
end;

return v_con_idseq;

exception when others then
   htp.p(sqlerrm);
return null;
cg$errors.push(sqlerrm);
end;
FUNCTION get_public_id(p_preferred_name in varchar2
					,p_conte_idseq in varchar2
					,p_actl_name in varchar2) return number is

v_public_id number;
begin

if p_actl_name = 'DATAELEMENT' then
SELECT distinct(cde_id)
	  INTO v_public_id
      FROM data_elements o
     WHERE preferred_name = p_preferred_name
	 AND conte_idseq = p_conte_idseq;
elsif p_actl_name = 'DE_CONCEPT' then
SELECT distinct(dec_id)
	  INTO v_public_id
      FROM data_element_Concepts o
     WHERE preferred_name = p_preferred_name
	 AND conte_idseq = p_conte_idseq;

elsif p_actl_name = 'CONCEPTUALDOMAIN' then
SELECT distinct(cd_id)
	  INTO v_public_id
      FROM conceptual_domains o
     WHERE preferred_name = p_preferred_name
	 AND conte_idseq = p_conte_idseq;
elsif p_actl_name = 'VALUEDOMAIN' then
SELECT distinct(vd_id)
	  INTO v_public_id
      FROM value_domains o
     WHERE preferred_name = p_preferred_name
	 AND conte_idseq = p_conte_idseq;

elsif p_actl_name = 'CLASSIFICATION' then
SELECT distinct(cs_id)
	  INTO v_public_id
      FROM classification_schemes o
     WHERE preferred_name = p_preferred_name
	 AND conte_idseq = p_conte_idseq;
elsif p_actl_name = 'OBJECTCLASS' then
SELECT distinct(oc_id)
	  INTO v_public_id
      FROM OBJECT_CLASSES_EXT o
     WHERE preferred_name = p_preferred_name
	 AND conte_idseq = p_conte_idseq;
elsif p_actl_name = 'OBJECTRECS' then
SELECT distinct(ocr_id)
	  INTO v_public_id
      FROM OC_RECS_EXT o
     WHERE preferred_name = p_preferred_name
	 AND conte_idseq = p_conte_idseq;
elsif p_actl_name = 'CONCEPT' then
SELECT distinct(con_id)
	  INTO v_public_id
      FROM CONCEPTS_EXT o
     WHERE preferred_name = p_preferred_name
	 AND conte_idseq = p_conte_idseq;
elsif p_actl_name ='PROPERTY' then
SELECT distinct(prop_id)
	  INTO v_public_id
      FROM PROPERTIES_EXT o
     WHERE preferred_name = p_preferred_name
	 AND conte_idseq = p_conte_idseq;
elsif p_actl_name ='PROTOCOLS' then
SELECT distinct(proto_id)
	  INTO v_public_id
      FROM protocols_EXT o
     WHERE preferred_name = p_preferred_name
	 AND conte_idseq = p_conte_idseq;
elsif p_actl_name = 'QUEST_CONTENT' then
SELECT distinct(qc_id)
	  INTO v_public_id
      FROM QUEST_CONTENTS_EXT o
     WHERE preferred_name = p_preferred_name
	 AND conte_idseq = p_conte_idseq;
else
 return 0;
end if;


    RETURN v_public_id;
  EXCEPTION WHEN NO_DATA_FOUND THEN
    RETURN -1;
  WHEN OTHERS THEN

    RETURN -2;
  END;



FUNCTION get_public_version(p_public_id in number
					,p_type in varchar2
					,p_actl_name in varchar2) return number is


v_version number;
begin

if p_type = 'LATEST' then
if p_actl_name = 'DATAELEMENT' then
SELECT max(version)
	  INTO v_version
      FROM data_elements o
     WHERE cde_id = p_public_id
	 AND latest_version_ind = 'Yes';
elsif p_actl_name = 'DE_CONCEPT' then
SELECT max(version)
	  INTO v_version
      FROM data_element_Concepts o
     WHERE dec_id = p_public_id
	 AND latest_version_ind = 'Yes';

elsif p_actl_name = 'CONCEPTUALDOMAIN' then
SELECT max(version)
	  INTO v_version
      FROM conceptual_domains o
     WHERE cd_id = p_public_id
	 AND latest_version_ind = 'Yes';
elsif p_actl_name = 'VALUEDOMAIN' then
SELECT max(version)
	  INTO v_version
      FROM value_domains o
     WHERE vd_id = p_public_id
	 AND latest_version_ind = 'Yes';
elsif p_actl_name = 'CLASSIFICATION' then
SELECT max(version)
	  INTO v_version
      FROM classification_schemes o
     WHERE cs_id = p_public_id
	 AND latest_version_ind = 'Yes';
elsif p_actl_name = 'OBJECTCLASS' then
SELECT max(version)
	  INTO v_version
      FROM OBJECT_CLASSES_EXT o
     WHERE oc_id = p_public_id
	 AND latest_version_ind = 'Yes';
elsif p_actl_name = 'OBJECTRECS' then
SELECT max(version)
	  INTO v_version
      FROM OC_RECS_EXT o
     WHERE ocr_id = p_public_id
	 AND latest_version_ind = 'Yes';
elsif p_actl_name = 'CONCEPT' then
SELECT max(version)
	  INTO v_version
      FROM CONCEPTS_EXT o
     WHERE con_id = p_public_id
	 AND latest_version_ind = 'Yes';
elsif p_actl_name ='PROPERTY' then
SELECT max(version)
	  INTO v_version
      FROM PROPERTIES_EXT o
     WHERE prop_id = p_public_id
	 AND latest_version_ind = 'Yes';
elsif p_actl_name ='PROTOCOLS' then
SELECT max(version)
	  INTO v_version
      FROM protocols_EXT o
     WHERE proto_id = p_public_id
	 AND latest_version_ind = 'Yes';
elsif p_actl_name = 'QUEST_CONTENT' then
SELECT max(version)
	  INTO v_version
      FROM QUEST_CONTENTS_EXT o
     WHERE qc_id = p_public_id
	 AND latest_version_ind = 'Yes';
else
 v_Version := 0;
end if;
end if;
if p_type = 'HIGHEST' or v_version = 0 then
if p_actl_name = 'DATAELEMENT' then
SELECT max(version)
	  INTO v_version
      FROM data_elements o
     WHERE cde_id = p_public_id;
elsif p_actl_name = 'DE_CONCEPT' then
SELECT max(version)
	  INTO v_version
      FROM data_element_Concepts o
     WHERE dec_id = p_public_id;
elsif p_actl_name = 'CONCEPTUALDOMAIN' then
SELECT max(version)
	  INTO v_version
      FROM conceptual_domains o
     WHERE cd_id = p_public_id;
elsif p_actl_name = 'VALUEDOMAIN' then
SELECT max(version)
	  INTO v_version
      FROM value_domains o
     WHERE vd_id = p_public_id;
elsif p_actl_name = 'CLASSIFICATION' then
SELECT max(version)
	  INTO v_version
      FROM classification_schemes o
     WHERE cs_id = p_public_id;
elsif p_actl_name = 'OBJECTCLASS' then
SELECT max(version)
	  INTO v_version
      FROM OBJECT_CLASSES_EXT o
     WHERE oc_id = p_public_id;
elsif p_actl_name = 'OBJECTRECS' then
SELECT max(version)
	  INTO v_version
      FROM OC_RECS_EXT o
     WHERE ocr_id = p_public_id;
elsif p_actl_name = 'CONCEPT' then
SELECT max(version)
	  INTO v_version
      FROM CONCEPTS_EXT o
     WHERE con_id = p_public_id;
elsif p_actl_name ='PROPERTY' then
SELECT max(version)
	  INTO v_version
      FROM PROPERTIES_EXT o
     WHERE prop_id = p_public_id;
elsif p_actl_name ='PROTOCOLS' then
SELECT max(version)
	  INTO v_version
      FROM protocols_EXT o
     WHERE proto_id = p_public_id;
elsif p_actl_name = 'QUEST_CONTENT' then
SELECT max(version)
	  INTO v_version
      FROM QUEST_CONTENTS_EXT o
     WHERE qc_id = p_public_id;
else
 v_Version := 0;
end if;
end if;

    RETURN v_version;
  EXCEPTION WHEN NO_DATA_FOUND THEN
    RETURN -1;
  WHEN OTHERS THEN

    RETURN -2;
  END;

FUNCTION generate_dec_preferred_name(p_oc_idseq in varchar2
					,p_prop_idseq in varchar2) return varchar2 is
v_preferred_name administered_components.preferred_name%type;
v_oc_id number;
v_oc_version varchar2(10);
v_prop_id number;
v_prop_version varchar2(10);
begin

if(p_oc_idseq is null and p_prop_idseq is null) then
  return('OC and PROP are null');
end if;

if(p_oc_idseq is not null) then
  begin
    select oc_id, to_char(version,'9999.99')
    into v_oc_id,v_oc_version
    from object_Classes_ext
    where oc_idseq = p_oc_idseq;

v_oc_version := ltrim(v_oc_version);
IF substr(v_oc_version,-1,1) = '0' THEN
  v_oc_version := substr(v_oc_version,1,length(v_oc_version)-1);
END IF;


v_preferred_name := v_oc_id||'v'||ltrim(v_oc_version);
  exception when no_data_found then
    return('Invalid Object');
  end;
end if;

if(p_prop_idseq is not null) then
begin
select prop_id, to_char(version,'9999.99')
into v_prop_id,v_prop_version
from properties_ext
where prop_idseq = p_prop_idseq;
exception when no_data_found then
return('Invalid Property');
end;

v_prop_version := ltrim(v_prop_version);
IF substr(v_prop_version,-1,1) = '0' THEN
  v_prop_version := substr(v_prop_version,1,length(v_prop_version)-1);
END IF;

if v_preferred_name is not null then
  v_preferred_name := v_preferred_name||':'||v_prop_id||'v'||ltrim(v_prop_version);
else
  v_preferred_name := v_prop_id||'v'||ltrim(v_prop_version);
end if;
end if;


return v_preferred_name;

end;

FUNCTION generate_de_preferred_name(p_dec_idseq in varchar2
					,p_vd_idseq in varchar2) return varchar2 is
v_preferred_name administered_components.preferred_name%type;
v_dec_id number;
v_dec_version varchar2(10);
v_vd_id number;
v_vd_version varchar2(10);
begin

begin
select dec_id, to_char(version,'9999.99')
into v_dec_id,v_dec_version
from data_element_Concepts
where dec_idseq = p_dec_idseq;
exception when no_data_found then
return('Invalid Data Element Concept');
end;

v_dec_version := ltrim(v_dec_version);
IF substr(v_dec_version,-1,1) = '0' THEN -- remove trailing 0 (zero)
  v_dec_version := substr(v_dec_version,1,length(v_dec_version)-1);
END IF;

v_preferred_name := v_dec_id||'v'||v_dec_version;

if(p_vd_idseq is not null) then
begin
select vd_id, to_char(version,'9999.99')
into v_vd_id,v_vd_version
from value_Domains
where vd_idseq = p_vd_idseq;
exception when no_data_found then
return('Invalid Value Domain');
end;
v_preferred_name := v_preferred_name||':'||v_vd_id||'v'||ltrim(v_vd_version);
end if;


return v_preferred_name;

end;

FUNCTION generate_vd_preferred_name(p_vd_idseq in varchar2) return varchar2 is

cursor comp is
select c.preferred_name
from value_domains v
,component_concepts_ext cc
,concepts_Ext c
where v.condr_idseq = cc.condr_idseq
and cc.con_idseq = c.con_idseq
and vd_idseq = p_vd_idseq
order by display_order asc;

v_preferred_name varchar2(2000);
v_vd_id number;
v_vd_version varchar2(10);

begin

if(p_vd_idseq is not null) then
begin
select vd_id, to_char(version,'9999.99')
into v_vd_id,v_vd_version
from value_Domains
where vd_idseq = p_vd_idseq;
exception when no_data_found then
return('Invalid Value Domain');
end;

v_vd_version := ltrim(v_vd_version);
IF substr(v_vd_version,-1,1) = '0' THEN -- remove trailing 0 (zero)
  v_vd_version := substr(v_vd_version,1,length(v_vd_version)-1);
END IF;
v_preferred_name := v_vd_id||'v'||v_vd_version;
for c_rec in comp loop

 v_preferred_name := c_rec.preferred_name||':'||v_preferred_name;
end loop;

if (length(v_preferred_name) > 30) then
  v_preferred_name := substr(v_preferred_name,-1,30);
end if;
end if;

return v_preferred_name;

end;
--Function added 03/01/05
Function get_concept_count(p_array in varchar2) return number is
v_count number := 0;
i number := 1;
v_array varchar2(4000):= p_array;
begin
WHILE (i != 0 AND v_array IS NOT NULL) LOOP
      i := INSTR(v_array ,',');
	  v_array := substr(v_array,i+1);
	  v_count := v_count+1;
END LOOP;
return v_count;
end;


FUNCTION get_oc_dec_count(P_OC_IDSEQ IN VARCHAR2) RETURN NUMBER IS
v_dec_count number;
begin
select count(*) into v_dec_count
from data_element_concepts
where oc_idseq = p_oc_idseq;

return v_dec_count;

end;

FUNCTION get_prop_dec_count(P_PROP_IDSEQ IN VARCHAR2) RETURN NUMBER IS
v_dec_count number;
begin
select count(*) into v_dec_count
from data_element_concepts
where prop_idseq = p_prop_idseq;

return v_dec_count;

end;

function return_number(p_char in varchar2) return number is

begin
return to_number(p_char);
exception when others then
return null;
end;


function create_rule(p_par_de_idseq in varchar2) return varchar2 is

v_rule varchar2(4000):= null;

cursor rule_comp is
select r.symbol,r.name,c.left_String,c.right_String,d.long_name,display_order
from complex_de_relationships c, rule_functions_ext r, data_elements d
where p_de_idseq = p_par_de_idseq
and c.rf_idseq = r.rf_idseq
and c.c_de_idseq = d.de_idseq
order by display_order;

begin

for r_rec in rule_comp loop
 if v_rule is null then
   v_rule := nvl(nvl(r_rec.symbol,r_rec.name),'')||nvl(r_rec.left_string,'')||r_rec.long_name||nvl(r_rec.right_string,'');
 else
   v_rule := v_rule||nvl(nvl(r_rec.symbol,r_rec.name),'')||nvl(r_rec.left_string,'')||r_rec.long_name||nvl(r_rec.right_string,'');
 end if;
end loop;
return v_rule;
end;


FUNCTION PER_EXISTS(P_PER_IDSEQ IN CHAR )RETURN  BOOLEAN IS
/******************************************************************************
   IDSEQ:       PER_EXISTS
   PURPOSE:    Check to see if person exists
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        12/13/2005  S. Alred        1. Created this function


******************************************************************************/
v_count  NUMBER;
BEGIN
SELECT COUNT(*) INTO v_count
FROM PERSONS_VIEW
WHERE PER_idseq = P_PER_IDSEQ;

IF(v_count = 1) THEN
  RETURN  TRUE;
ELSE
  RETURN  FALSE;
END IF;
END PER_EXISTS;

FUNCTION COMM_TYPE_EXISTS(P_CTL_NAME IN COMm_TYPES_LOV_VIEW.CTL_NAME%TYPE )
  RETURN  BOOLEAN IS

/******************************************************************************
   IDSEQ:       COMM_TYPE_EXISTS
   PURPOSE:    Check to see if comm type exists
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        12/13/2005  S. Alred        1. Created this function


******************************************************************************/
v_count  NUMBER;
BEGIN
SELECT COUNT(*) INTO v_count
FROM COMM_TYPES_LOV_VIEW
WHERE CTL_NAME = P_CTL_NAME;

IF(v_count = 1) THEN
  RETURN  TRUE;
ELSE
  RETURN  FALSE;
END IF;
END COMM_TYPE_EXISTS;


FUNCTION ADDR_TYPE_EXISTS(P_ATL_NAME IN ADDR_TYPES_LOV_VIEW.ATL_NAME%TYPE )
  RETURN  BOOLEAN is
/******************************************************************************
   IDSEQ:       ATL_TYPE_EXISTS
   PURPOSE:    Check to see if address type exists
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        12/14/2005  S. Alred        1. Created this function


******************************************************************************/
v_count  NUMBER;
BEGIN
SELECT COUNT(*) INTO v_count
FROM ADDR_TYPES_LOV_VIEW
WHERE ATL_NAME = P_ATL_NAME;

IF(v_count = 1) THEN
  RETURN  TRUE;
ELSE
  RETURN  FALSE;
END IF;
END ADDR_TYPE_EXISTS;

FUNCTION CONTACT_ROLE_EXISTS(P_CONTACT_ROLE IN CONTACT_ROLES_EXT.CONTACT_ROLE%TYPE)
  RETURN BOOLEAN is
  /******************************************************************************
   IDSEQ:       CONTACT_ROLE_EXISTS
   PURPOSE:    Check to see if contact role exists
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        12/14/2005  S. Alred        1. Created this function


******************************************************************************/
v_count  NUMBER;
BEGIN
SELECT COUNT(*) INTO v_count
FROM CONTACT_ROLES_EXT
WHERE CONTACT_ROLE = P_CONTACT_ROLE;

IF(v_count = 1) THEN
  RETURN  TRUE;
ELSE
  RETURN  FALSE;
END IF;
END CONTACT_ROLE_EXISTS;

PROCEDURE SET_MULTI_PROTO(P_PROTO_IDSEQ in varchar2,
P_crf_idseq in varchar2) is

  v_proto_idseq varchar2(36);
  v_String varchar2(2000);
  i number := 1;
  begin
   v_string := p_proto_idseq;
	if v_string is not null then
	  while i <>0 loop
	   i := instr(v_string,',');
	   if i =0 then
	    v_proto_idseq := v_String;
	   else
	    v_proto_idseq := substr(v_string,1,i-1);
	   end if;
	  v_string := substr(v_string,i+1);
	  ins_proto_qc(p_crf_idseq,v_proto_idseq);
	   end loop;
	 end if;
  end;


PROCEDURE ins_proto_qc ( p_qc_idseq                   IN varchar2,
                       p_proto_idseq                   IN varchar2) is
begin
insert into protocol_qc_ext(qc_idseq,proto_idseq) values
(p_qc_idseq, p_proto_idseq);
end;




FUNCTION set_proto_array (  p_qc_idseq in varchar2) return varchar2 is
v_proto_array varchar2(2000);
cursor pq is
select * from protocol_Qc_ext
where qc_idseq = p_qc_idseq;
begin
  for p_rec in pq loop
    if v_proto_array is null then
      v_proto_array := p_rec.proto_idseq;
    else
      v_proto_array := v_proto_array||','||p_rec.proto_idseq;
    end if;
  end loop;

  return v_proto_array;

end;
FUNCTION encode_file_name(p_filename in varchar2) return varchar2 is
v_filename varchar2(350);
v_sequence number;
begin
select rb_seq.nextval into v_sequence from dual;
v_filename := 'C'||v_sequence||'/'||p_filename;
return v_filename;
end;

FUNCTION decode_file_name(p_filename in varchar2) return varchar2 is
v_filename varchar2(350);
i number;
begin
i:= instr(p_filename,'/');
v_filename := substr(p_filename,i+1);
return v_filename;
end;

FUNCTION get_condr_preferred_name(p_condr_idseq in varchar2) return varchar2 is
cursor con is
select preferred_name
from component_Concepts_ext m, concepts_ext c
where condr_idseq = p_condr_idseq
and m.con_idseq = c.con_idseq
order by display_order desc;

v_name varchar2(255);

begin

for c_rec in con loop

if v_name is null then
  v_name := c_rec.preferred_name;
else
  v_name := v_name||':'||c_rec.preferred_name;
end if;

end loop;

return v_name;

end;



FUNCTION get_condr_preferred_definition(p_condr_idseq in varchar2) return varchar2 is

cursor con is
select preferred_definition
from component_Concepts_ext m, concepts_ext c
where condr_idseq = p_condr_idseq
and m.con_idseq = c.con_idseq
order by display_order desc;

v_definition varchar2(2000);

begin

for c_rec in con loop

if v_definition is null then
  v_definition := c_rec.preferred_definition;
else
  v_definition := substr(v_definition||':'||c_rec.preferred_definition,1,2000);
end if;

end loop;

return v_definition;
end;


FUNCTION get_condr_long_name(p_condr_idseq in varchar2) return varchar2 is

cursor con is
select long_name
from component_Concepts_ext m, concepts_ext c
where condr_idseq = p_condr_idseq
and m.con_idseq = c.con_idseq
order by display_order desc;

v_name varchar2(255);

begin

for c_rec in con loop

if v_name is null then
  v_name := c_rec.long_name;
else
  v_name := v_name||' '||c_rec.long_name;
end if;

end loop;

return v_name;


end;



FUNCTION get_condr_def_source(p_condr_idseq in varchar2) return varchar2 is

cursor con is
select definition_source
from component_Concepts_ext m, concepts_ext c
where condr_idseq = p_condr_idseq
and m.con_idseq = c.con_idseq
order by display_order desc;

v_ds varchar2(2000);

begin

for c_rec in con loop

if v_ds is null then
  v_ds := c_rec.definition_source;
else
  v_ds := v_ds||':'||c_rec.definition_source;
end if;

end loop;

return v_ds;
end;



FUNCTION get_condr_origin(p_condr_idseq in varchar2) return varchar2 is
cursor con is
select origin
from component_Concepts_ext m, concepts_ext c
where condr_idseq = p_condr_idseq
and m.con_idseq = c.con_idseq
order by display_order desc;

v_origin varchar2(2000);

begin

for c_rec in con loop

if v_origin is null then
  v_origin := c_rec.origin;
else
  v_origin := v_origin||':'||c_rec.origin;
end if;

end loop;

return v_origin;
end;


FUNCTION get_fully_qualified_name(p_ac_idseq in varchar2,p_ac_csi_idseq in varchar2) return varchar2 is
cursor ac is
select name,csi_name
from designations d
,ac_att_cscsi_ext a
,cs_csi i
,class_scheme_items c
,ac_csi ac
where d.desig_idseq = a.att_idseq
and a.cs_csi_idseq = i.cs_csi_idseq
and i.csi_idseq = c.csi_idseq
and d.ac_idseq = p_ac_idseq
and a.cs_csi_idseq = ac.cs_csi_idseq
and ac.ac_csi_idseq = p_ac_csi_idseq
and detl_name = 'UML Class';

begin

for a_rec in ac loop
return a_rec.csi_name||'.'||a_rec.name;
end loop;

return null;

end;


FUNCTION get_concepts(p_condr_idseq in varchar2) return varchar2 is
cursor con is
select preferred_name, concept_value
from component_Concepts_ext m, concepts_ext c
where condr_idseq = p_condr_idseq
and m.con_idseq = c.con_idseq
order by display_order desc;

v_name varchar2(255);

begin

for c_rec in con loop

if v_name is null then
  v_name := c_rec.preferred_name;
  
  /* Check if Integer Concept */
    if c_rec.preferred_name = 'C45255' then      
        v_name := v_name||'::'||c_rec.concept_value;
    end if;
else
   v_name := v_name||':'||c_rec.preferred_name;
  
  /* Check if Integer Concept */
  if c_rec.preferred_name = 'C45255' then
    v_name := v_name||'::'||c_rec.concept_value;
  end if;
end if;

end loop;

return v_name;

end;


PROCEDURE set_oc_rep_prop(p_condr_idseq IN VARCHAR2
,p_return_code OUT VARCHAR2
,p_conte_idseq IN VARCHAR2
,p_actl_name IN VARCHAR2
,p_ac_idseq OUT VARCHAR2
,p_ua_name IN  VARCHAR2
)  IS
v_preferred_name VARCHAR2(2000);
v_long_name VARCHAR2(2000);
v_preferred_definition VARCHAR2(4000);
v_definition_source VARCHAR2(4000);
v_origin VARCHAR2(2000);
v_ac_idseq VARCHAR2(36);
v_name VARCHAR2(255);
v_crtl_name VARCHAR2(50);

CURSOR con(p_con_idseq IN VARCHAR2) IS
SELECT * FROM CONCEPTS_EXT
WHERE con_idseq = p_con_idseq;

CURSOR comp_con IS
SELECT * FROM COMPONENT_CONCEPTS_EXT
WHERE condr_idseq = p_condr_idseq
ORDER BY display_order desc;

BEGIN

IF P_Actl_name NOT IN ('OBJECTCLASS','PROPERTY','REPRESENTATION','VALUEMEANING') THEN
 p_return_code := 'Invalid AC Type';
 RETURN;
END IF;

IF NOT sbrext.sbrext_common_routines.condr_Exists(p_condr_idseq) THEN
 p_return_code := 'Invalid Derivation Rule';
 RETURN;
END IF;

IF NOT sbrext.sbrext_common_routines.context_Exists(p_conte_idseq) THEN
  p_return_code := 'Invalid Context';
 RETURN;
END IF;

SELECT name, crtl_name INTO v_name, v_crtl_name
FROM CON_DERIVATION_RULES_EXT
WHERE condr_idseq = p_condr_idseq;

dbms_output.put_line('v_preferred_name: '||v_preferred_name);
FOR m_rec IN comp_con LOOP
  FOR c_rec IN con(m_rec.con_idseq) LOOP

/*	  --add the concept_value to the long name -- commented out 12/4/06 ; s. alred
	  IF m_rec.concept_value is not null then
	 	  c_rec.long_name := c_rec.long_name ||'::'||m_rec.concept_value;
		  c_rec.preferred_name := c_rec.preferred_name ||'::'||m_rec.concept_value;
		  --not sure if definition is needed here
	  END IF;
*/
      --add the concept_value to the long name
      IF m_rec.concept_value is not null then
        c_rec.long_name := c_rec.long_name ||'::'||m_rec.concept_value;
        c_rec.preferred_name := c_rec.preferred_name ||'::'||m_rec.concept_value;
        c_rec.preferred_definition := c_rec.preferred_definition||'::'||m_rec.concept_value;
      END IF;

	  IF v_long_name IS NULL THEN
	    v_long_name := c_rec.long_name;
	  ELSE
	    v_long_name :=v_long_name||' '||c_rec.long_name;
	  END IF;

	  IF v_preferred_name IS NULL THEN
	    v_preferred_name := c_rec.preferred_name;
	  ELSE
	    v_preferred_name := v_preferred_name||':'||c_rec.preferred_name;
	  END IF;

	  IF v_preferred_definition IS NULL THEN
	    v_preferred_definition := c_rec.preferred_definition;
	  ELSE
	    v_preferred_definition := v_preferred_definition||':'||c_rec.preferred_definition;
	  END IF;


	  IF v_definition_source IS NULL THEN
	    v_definition_source := c_rec.definition_source;
	  ELSE
	    v_definition_source := v_definition_source||':'||c_rec.definition_source;
	  END IF;


	  IF v_origin IS NULL THEN
	    v_origin := c_rec.origin;
    ELSE
	    v_origin :=  v_origin||':'||c_rec.origin;
	  END IF;
  END LOOP;
END LOOP;

IF v_preferred_name IS NOT NULL AND LENGTH(v_preferred_name) > 30 THEN
    v_preferred_name := NULL;
END IF;

v_ac_idseq := admincomponent_crud.cmr_guid;
v_preferred_Definition := SUBSTR(v_preferred_Definition,1,2000);
v_long_name := SUBSTR(v_long_name,1,255);
v_definition_source := SUBSTR(v_definition_source,1,2000);
v_origin := SUBSTR(v_origin,1,240);


IF p_actl_name = 'OBJECTCLASS' THEN
begin
  select oc_idseq  into v_ac_idseq
  from object_classes_ext
  where condr_idseq = p_condr_idseq
  and conte_idseq = p_conte_idseq;
  exception when no_data_found then
    INSERT INTO OBJECT_CLASSES_EXT(oc_idseq
    ,preferred_name
    ,preferred_definition
    ,version
    ,long_name
    ,asl_name
    ,conte_idseq
    ,origin
    ,definition_source
    ,begin_date
    ,end_date
    ,latest_Version_ind
    ,deleted_ind
    ,condr_idseq
    ,created_by)
  VALUES
  (v_ac_idseq
  ,v_preferred_name
  ,v_preferred_definition
  ,1
  ,v_long_name
  ,'RELEASED'
  ,p_conte_idseq
  ,v_origin
  ,v_definition_source
  ,SYSDATE
  ,NULL
  ,'Yes'
  ,'No'
  ,p_condr_idseq
  ,p_ua_name);
end ;
ELSIF p_actl_name = 'PROPERTY' THEN
begin

  select prop_idseq  into v_ac_idseq
  from properties_ext
  where condr_idseq = p_condr_idseq
  and conte_idseq = p_conte_idseq;
  exception when no_data_found then
    INSERT INTO PROPERTIES_EXT(prop_idseq
    ,preferred_name
    ,preferred_definition
    ,version
    ,long_name
    ,asl_name
    ,conte_idseq
    ,origin
    ,definition_source
    ,begin_date
    ,end_date
    ,latest_Version_ind
    ,deleted_ind
    ,condr_idseq
    ,created_by)
     VALUES
     (v_ac_idseq
     ,v_preferred_name
     ,v_preferred_definition
     ,1
     ,v_long_name
     ,'RELEASED'
     ,p_conte_idseq
     ,v_origin
     ,v_definition_source
     ,SYSDATE
     ,NULL
     ,'Yes'
     ,'No'
     ,p_condr_idseq
     ,p_ua_name);
   end ;
ELSIF p_actl_name = 'REPRESENTATION' THEN
begin
  select rep_idseq  into v_ac_idseq
  from representations_ext
  where condr_idseq = p_condr_idseq
  and conte_idseq = p_conte_idseq;
  exception when no_data_found then
    INSERT INTO REPRESENTATIONS_EXT(rep_idseq
    ,preferred_name
    ,preferred_definition
    ,version
    ,long_name
    ,asl_name
    ,conte_idseq
    ,origin
    ,definition_source
    ,begin_date
    ,end_date
    ,latest_Version_ind
    ,deleted_ind
    ,condr_idseq
    ,created_by)
  VALUES
  (v_ac_idseq
  ,v_preferred_name
  ,v_preferred_definition
  ,1
  ,v_long_name
  ,'RELEASED'
  ,p_conte_idseq
  ,v_origin
  ,v_definition_source
  ,SYSDATE
  ,NULL
  ,'Yes'
  ,'No'
  ,p_condr_idseq
  ,p_ua_name);
end ;

ELSIF p_actl_name = 'VALUEMEANING' THEN
begin
  select vm_idseq  into v_ac_idseq
  from value_meanings
  where condr_idseq = p_condr_idseq
  and conte_idseq = p_conte_idseq;
  exception when no_data_found then
    INSERT INTO VALUE_MEANINGS(vm_idseq
    ,preferred_name
    ,preferred_definition
    ,version
    ,long_name
    ,asl_name
    ,conte_idseq
    ,origin
    ,definition_source
    ,begin_date
    ,end_date
    ,latest_Version_ind
    ,deleted_ind
    ,condr_idseq
    ,created_by)
  VALUES
  (v_ac_idseq
  ,v_preferred_name
  ,v_preferred_definition
  ,1
  ,v_long_name
  ,'RELEASED'
  ,p_conte_idseq
  ,v_origin
  ,v_definition_source
  ,SYSDATE
  ,NULL
  ,'Yes'
  ,'No'
  ,p_condr_idseq
  ,p_ua_name);
end ;
END IF;

p_ac_idseq := v_ac_idseq;

EXCEPTION WHEN OTHERS THEN
p_return_code := substr(sqlerrm,1,255);
RETURN;
END;


END Sbrext_Common_Routines;
/
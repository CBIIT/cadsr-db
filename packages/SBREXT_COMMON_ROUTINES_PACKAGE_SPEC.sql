CREATE OR REPLACE PACKAGE SBREXT."SBREXT_COMMON_ROUTINES" IS
/******************************************************************************
   NAME:       SBREXT_COMMON_ROUTINES
   PURPOSE:    Set of routines common to more than one procedure

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/18/2001  Prerna Aggarwal     1. Created this package.


******************************************************************************/

   FUNCTION VD_PVS_QC_EXISTS(P_VDPVS_VP_IDSEQ IN CHAR,
                             P_VDPVS_VD_IDSEQ IN CHAR)
                     RETURN  CHAR;

   FUNCTION AC_EXISTS(P_AC_IDSEQ IN CHAR)RETURN BOOLEAN;

   FUNCTION AC_EXISTS(P_PREFERRED_NAME IN VARCHAR2
                  ,P_CONTE_IDSEQ IN CHAR
                  ,P_VERSION IN NUMBER
                  ,P_ACTL_NAME IN VARCHAR2)RETURN BOOLEAN;

   FUNCTION AC_VERSION_EXISTS(P_PREFERRED_NAME IN VARCHAR2
                  ,P_CONTE_IDSEQ IN CHAR
                  ,P_ACTL_NAME IN VARCHAR2)RETURN BOOLEAN;


   PROCEDURE VALID_DATE(P_RETURN_CODE OUT VARCHAR2
   			 		   	,P_DATE_IN IN VARCHAR2
					   	,P_DATE_OUT OUT DATE);

   FUNCTION GET_CT_VERSION(P_CT_NAME IN VARCHAR2)RETURN NUMBER;

   FUNCTION CONTEXT_EXISTS(P_CONTE_IDSEQ IN CHAR )RETURN BOOLEAN;

   FUNCTION PV_EXISTS(P_VALUE IN VARCHAR2
                    ,P_SHORT_MEANING IN VARCHAR2)RETURN BOOLEAN;--to be depracted
   FUNCTION PV_EXISTS(P_VALUE IN VARCHAR2
                    ,P_VM_IDSEQ IN VARCHAR2)RETURN BOOLEAN;
   FUNCTION PV_EXISTS(P_PV_IDSEQ IN CHAR)RETURN BOOLEAN;

   FUNCTION WORKFLOW_EXISTS(P_ASL_NAME IN VARCHAR2 )RETURN BOOLEAN;

   FUNCTION DATA_TYPE_EXISTS(P_DTL_NAME IN VARCHAR2 )RETURN BOOLEAN;

   FUNCTION CHAR_SET_EXISTS(P_CHAR_SET_NAME IN VARCHAR2 )RETURN BOOLEAN;

   FUNCTION VD_FORMAT_EXISTS(P_FORML_NAME IN VARCHAR2 )RETURN BOOLEAN;

   FUNCTION VM_EXISTS(P_SHORT_MEANING IN VARCHAR2 )RETURN BOOLEAN;--to be depracted

   FUNCTION CD_VM_EXISTS(P_CD_IDSEQ IN VARCHAR2, P_SHORT_MEANING IN VARCHAR2 )RETURN BOOLEAN;

   FUNCTION VM_EXISTS(P_VM_IDSEQ IN VARCHAR2 )RETURN BOOLEAN;-- to be depracted

   FUNCTION CD_VM_EXISTS(P_CD_IDSEQ IN VARCHAR2, P_VM_IDSEQ IN VARCHAR2 )RETURN BOOLEAN;

   FUNCTION UOML_EXISTS(P_UOML_NAME IN VARCHAR2 )RETURN BOOLEAN;

   FUNCTION PROPL_EXISTS(P_PROPL_NAME IN VARCHAR2 )RETURN BOOLEAN;

   FUNCTION OCL_EXISTS(P_OCL_NAME IN VARCHAR2 )RETURN BOOLEAN;

   FUNCTION QCDL_EXISTS(P_QCDL_NAME IN VARCHAR2 )RETURN BOOLEAN;

   FUNCTION VALID_NAME(P_STRING IN VARCHAR2 )RETURN  BOOLEAN ;

   FUNCTION VALID_ALPHANUMERIC(P_STRING IN VARCHAR2 )RETURN BOOLEAN;

   FUNCTION VALID_CHAR(P_STRING IN VARCHAR2 )RETURN BOOLEAN;

   FUNCTION VALID_PARENT_CONCEPT(P_CON_IDSEQ IN VARCHAR2,P_VD_IDSEQ IN VARCHAR2 )RETURN BOOLEAN;

   FUNCTION VD_PVS_EXISTS(P_VP_IDSEQ IN CHAR)RETURN BOOLEAN ;

   FUNCTION VD_PVS_EXISTS(P_VD_IDSEQ IN CHAR
                        ,P_PV_IDSEQ IN CHAR)RETURN BOOLEAN;

   FUNCTION RD_EXISTS(P_RD_IDSEQ IN CHAR)RETURN  BOOLEAN ;

   FUNCTION RD_EXISTS(P_AC_IDSEQ IN CHAR
                     ,P_NAME IN VARCHAR2)RETURN  BOOLEAN;

   FUNCTION DCTL_EXISTS(P_DCTL_NAME IN VARCHAR2 )RETURN  BOOLEAN;

   FUNCTION ACH_EXISTS(P_ACH_IDSEQ IN CHAR )RETURN  BOOLEAN;

   FUNCTION AR_EXISTS(P_AR_IDSEQ IN CHAR )RETURN  BOOLEAN;

   FUNCTION ORG_EXISTS(P_ORG_IDSEQ IN CHAR )RETURN  BOOLEAN;

   FUNCTION DES_EXISTS(P_DESIG_IDSEQ IN CHAR)RETURN  BOOLEAN ;

   FUNCTION DES_EXISTS(P_AC_IDSEQ IN CHAR
                     ,P_NAME IN VARCHAR2
                     ,P_DETL_NAME IN VARCHAR2
                     ,P_CONTE_IDSEQ IN CHAR)RETURN  BOOLEAN;

   FUNCTION DETL_EXISTS(P_DETL_NAME IN VARCHAR2 )RETURN  BOOLEAN;

   FUNCTION LAE_EXISTS(P_LAE_NAME IN VARCHAR2 )RETURN  BOOLEAN;

   FUNCTION CSI_EXISTS(P_CSI_IDSEQ IN CHAR)RETURN  BOOLEAN;

   FUNCTION CS_CSI_EXISTS(P_CS_IDSEQ IN CHAR
                      ,P_CSI_IDSEQ IN CHAR
                      ,P_P_CS_CSI_IDSEQ IN CHAR)RETURN  BOOLEAN;

   FUNCTION CS_CSI_EXISTS(PAR_CS_CSI_IDSEQ IN CHAR)RETURN  BOOLEAN;

   FUNCTION AC_CSI_EXISTS(P_AC_IDSEQ IN CHAR

                      ,P_CS_CSI_IDSEQ IN CHAR)RETURN  BOOLEAN;
   FUNCTION AC_CSI_EXISTS(P_AC_CSI_IDSEQ IN CHAR)RETURN  BOOLEAN;


   FUNCTION GET_AC_VERSION(P_AC_PREFERRED_NAME IN VARCHAR2
                          ,P_AC_CONTE_IDSEQ IN CHAR
						  ,P_ACTL_NAME IN VARCHAR2
						  ,P_TYPE IN VARCHAR2 DEFAULT 'LATEST') RETURN NUMBER;

   FUNCTION SRC_EXISTS(P_NAME IN VARCHAR2 )RETURN  BOOLEAN;

   FUNCTION ACSRC_EXISTS(P_AC_IDSEQ IN CHAR
                     ,P_SRC_NAME IN VARCHAR2)RETURN  BOOLEAN;

   FUNCTION ACSRC_EXISTS(P_ACS_IDSEQ IN CHAR)RETURN  BOOLEAN;

   FUNCTION VPSRC_EXISTS(P_VPS_IDSEQ IN CHAR)RETURN  BOOLEAN;

   FUNCTION VPSRC_EXISTS(P_VP_IDSEQ IN CHAR
                     ,P_SRC_NAME IN VARCHAR2)RETURN  BOOLEAN;

   FUNCTION TSTL_EXISTS(P_TSTL_NAME IN VARCHAR2)RETURN  BOOLEAN;

   FUNCTION TS_EXISTS(P_TS_IDSEQ IN CHAR)RETURN  BOOLEAN;

   FUNCTION GET_CD(P_CONTE_IDSEQ IN CHAR)RETURN  CHAR;

   FUNCTION QTL_EXISTS(P_QTL_NAME IN VARCHAR2 )RETURN BOOLEAN;

   FUNCTION REL_EXISTS(P_TABLE IN VARCHAR2
                       ,P_REL_IDSEQ IN CHAR) RETURN BOOLEAN;

   FUNCTION	REL_EXISTS(P_REL_TABLE IN VARCHAR2
                      ,P_REL_P_IDSEQ IN CHAR,
					   P_REL_C_IDSEQ IN CHAR) RETURN BOOLEAN;

   FUNCTION	RF_EXISTS(P_FEEDBACK IN VARCHAR2,
                      P_TYPE IN VARCHAR2) RETURN BOOLEAN;

   FUNCTION VALID_AC(P_TABLE IN VARCHAR2
                     ,P_AC_IDSEQ IN CHAR) RETURN BOOLEAN;

   FUNCTION RL_EXISTS(P_REL_RL_NAME IN VARCHAR2) RETURN BOOLEAN;
   FUNCTION CONDR_EXISTS(P_CONDR_IDSEQ IN VARCHAR2) RETURN BOOLEAN;

   PROCEDURE set_ac_lvi(P_RETURN_CODE OUT VARCHAR2
	             ,P_AC_IDSEQ IN CHAR
		     ,P_ACTL_NAME IN VARCHAR2);

  FUNCTION GET_VERSION_AC(P_AC_PREFERRED_NAME IN VARCHAR2
                          ,P_AC_CONTE_IDSEQ IN CHAR
			,P_ACTL_NAME IN VARCHAR2) RETURN  CHAR;

  FUNCTION valid_arc(P_ID1 IN CHAR,P_ID2 IN CHAR,P_ID3 IN CHAR) RETURN BOOLEAN;

  FUNCTION get_de_vd(P_DE_IDSEQ IN CHAR) RETURN CHAR;

  FUNCTION get_evs_codes(P_AC_IDSEQ IN VARCHAR2
                         ,P_DETL_NAME IN VARCHAR2) RETURN VARCHAR2;

  FUNCTION get_oc_dec_count(P_OC_IDSEQ IN VARCHAR2) RETURN NUMBER;
  FUNCTION get_prop_dec_count(P_PROP_IDSEQ IN VARCHAR2) RETURN NUMBER;

  FUNCTION QUAL_EXISTS(P_QUALIFIER_NAME IN VARCHAR2 )RETURN BOOLEAN;

	  FUNCTION GET_CSI_LEVEL(PRM_CS_CSI_IDSEQ IN VARCHAR2) RETURN NUMBER;

	  FUNCTION GET_CS_CSI_DO(PRM_CS_IDSEQ IN VARCHAR2,prm_cs_csi_idseq in varchar2) RETURN NUMBER;

	  FUNCTION long_name_exists(p_con_idseq IN VARCHAR2,p_long_name IN VARCHAR2) RETURN BOOLEAN;
	  FUNCTION definition_exists(p_con_idseq IN VARCHAR2,p_definition IN VARCHAR2) RETURN BOOLEAN;

/******************************************************************************
   NAME:       get_public_id
   TYPE: 	   FUNCTION
   PURPOSE:    To find the public id of an administered component based on the
               idseq.

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        7/17/2003   W. Ver Hoef      1. Created this function.
   2.0		  7/22/2003	  W. Ver Hoef	   1. Moved it to sbrext_common_routines

******************************************************************************/
FUNCTION get_public_id ( p_idseq VARCHAR2 ) RETURN NUMBER DETERMINISTIC;

/******************************************************************************
   NAME:       get_rd_idseq
   TYPE: 	   PROCEDURE
   PURPOSE:    To find the rd_idseq of an administered component based on the
               document type.

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        9/09/2003   W. Ver Hoef      1. Created this function.

******************************************************************************/
TYPE type_rd_search IS REF CURSOR ;
PROCEDURE get_rd_idseq ( p_ac_idseq IN VARCHAR2,
                          p_dctl_name IN VARCHAR2,
						  p_rd_idseq OUT type_rd_search
						    );

TYPE type_desig_search IS REF CURSOR ;
PROCEDURE get_desig_idseq ( p_ac_idseq IN VARCHAR2,
                          p_detl_name IN VARCHAR2,
						  p_desig_idseq OUT type_desig_search
						    );

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
FUNCTION cd_exists ( p_preferred_name VARCHAR2,
                     p_version        NUMBER,
					 p_conte_idseq    CHAR )
RETURN BOOLEAN;


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
FUNCTION crtl_exists ( p_crtl_name VARCHAR2 )
RETURN BOOLEAN;


/******************************************************************************
   NAME:       cdt_exists
   TYPE: 	   FUNCTION
   PURPOSE:    To find out if a complex data element exists based on
               de_idseq.

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   2.1		  3/16/2004	  W. Ver Hoef	   1. Created this function.

******************************************************************************/
FUNCTION cdt_exists ( p_p_de_idseq CHAR )
RETURN BOOLEAN;


/******************************************************************************
   NAME:       cdr_exists
   TYPE: 	   FUNCTION
   PURPOSE:    To find out if a complex DE relationship exists based on
               cdr_idseq.

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   2.1		  3/17/2004	  W. Ver Hoef	   1. Created this function.

******************************************************************************/
FUNCTION cdr_exists ( p_cdr_idseq CHAR )
RETURN BOOLEAN;



/******************************************************************************
   NAME:       get_default_asl
   TYPE: 	   FUNCTION
   PURPOSE:    Returns the default workflow status for creates and versions

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   2.1		  3/19/2004	  Prerna Aggarwal   1. Created this function.

******************************************************************************/
FUNCTION get_default_asl ( p_action VARCHAR2 ,p_actl_name in varchar2 default null )
RETURN VARCHAR;



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
FUNCTION rsl_exists ( p_registration_status VARCHAR2 )
RETURN BOOLEAN;
FUNCTION check_derivation_exists(p_con_array IN VARCHAR2) RETURN VARCHAR2;
FUNCTION set_derivation_rule(p_con_array IN VARCHAR2) RETURN VARCHAR2;

PROCEDURE set_oc_rep_prop(p_condr_idseq IN VARCHAR2
,p_return_code OUT VARCHAR2
,p_conte_idseq IN VARCHAR2
,p_actl_name IN VARCHAR2
,p_ac_idseq OUT VARCHAR2
);

PROCEDURE set_oc_rep_prop(p_condr_idseq IN VARCHAR2
,p_return_code OUT VARCHAR2
,p_conte_idseq IN VARCHAR2
,p_actl_name IN VARCHAR2
,p_ac_idseq OUT VARCHAR2
,p_ua_name IN  VARCHAR2
);

PROCEDURE set_vm_condr(p_condr_idseq IN VARCHAR2
,p_return_code OUT VARCHAR2
,p_short_meaning IN OUT VARCHAR2
);--(To be removed in second phase)

PROCEDURE set_vm_condr(p_condr_idseq IN VARCHAR2
,p_return_code OUT VARCHAR2
,p_vm_idseq IN OUT VARCHAR2
);

FUNCTION get_dec_list(p_oc_idseq in varchar2,p_prop_idseq in varchar2, p_dec_id in number) return varchar2;

FUNCTION dec_vd_uk(p_dec_idseq in varchar2,p_vd_idseq in varchar2, p_cde_id in number, p_conte_idseq in varchar2) return boolean;
FUNCTION get_concept(p_evs_code in varchar2
	                ,p_long_name in varchar2
					,p_preferred_definition in varchar2
					,p_conte_idseq in varchar2
					,p_definition_source in varchar2
					,p_origin in varchar2
					,p_evs_source in varchar2) return varchar2;

FUNCTION get_public_id(p_preferred_name in varchar2
					,p_conte_idseq in varchar2
					,p_actl_name in varchar2) return number;

FUNCTION get_public_version(p_public_id in number
					,p_type in varchar2
					,p_actl_name in varchar2) return number;

FUNCTION generate_dec_preferred_name(p_oc_idseq in varchar2
					,p_prop_idseq in varchar2) return varchar2;


FUNCTION generate_de_preferred_name(p_dec_idseq in varchar2
					,p_vd_idseq in varchar2) return varchar2;
FUNCTION generate_vd_preferred_name(p_vd_idseq in varchar2) return varchar2;

--Function to count the number of concepts sent
Function get_concept_count(p_array in varchar2) return number ;
FUNCTION get_dec_conte(p_oc_idseq in varchar2,p_prop_idseq in varchar2,p_conte_idseq in varchar2, p_dec_id in number) return varchar2;
function return_number(p_char in varchar2) return number;


function create_rule(p_par_de_idseq in varchar2) return varchar2;

FUNCTION PER_EXISTS(P_PER_IDSEQ IN CHAR )RETURN  BOOLEAN;

FUNCTION COMM_TYPE_EXISTS(P_CTL_NAME IN COmM_TYPES_LOV_VIEW.CTL_NAME%TYPE )
  RETURN  BOOLEAN;

FUNCTION ADDR_TYPE_EXISTS(P_ATL_NAME IN ADDR_TYPES_LOV_VIEW.ATL_NAME%TYPE )
  RETURN  BOOLEAN;

FUNCTION CONTACT_ROLE_EXISTS(P_CONTACT_ROLE IN CONTACT_ROLES_EXT.CONTACT_ROLE%TYPE)
  RETURN BOOLEAN;

PROCEDURE SET_MULTI_PROTO(P_PROTO_IDSEQ in varchar2,
P_crf_idseq in varchar2);

PROCEDURE ins_proto_qc ( p_qc_idseq                   IN varchar2,
                        p_proto_idseq                   IN varchar2);

FUNCTION set_proto_array ( p_qc_idseq  IN varchar2) return varchar2;

FUNCTION encode_file_name(p_filename in varchar2) return varchar2;
FUNCTION decode_file_name(p_filename in varchar2) return varchar2;
FUNCTION get_condr_preferred_name(p_condr_idseq in varchar2) return varchar2;
FUNCTION get_condr_preferred_definition(p_condr_idseq in varchar2) return varchar2;
FUNCTION get_condr_long_name(p_condr_idseq in varchar2) return varchar2;
FUNCTION get_condr_def_source(p_condr_idseq in varchar2) return varchar2;
FUNCTION get_condr_origin(p_condr_idseq in varchar2) return varchar2;
FUNCTION get_fully_qualified_name(p_ac_idseq in varchar2,p_ac_csi_idseq in varchar2) return varchar2;
FUNCTION get_concepts(p_condr_idseq in varchar2) return varchar2;
END Sbrext_Common_Routines;
/
select  qc_id,  preferred_name,protocol,quest_sum,quest_sum_csv from

(SELECT COUNT (*) quest_sum_csv, PROTOCOL, form_name_new
                  FROM MDSR_REDCAP_PROTOCOL_CSV
                 WHERE protocol NOT LIKE 'Instr%'
              GROUP BY PROTOCOL, form_name_new) a,
              
              
              (SELECT COUNT (*) quest_sum, q.dn_crf_idseq,f.qc_id, p.preferred_name
                 FROM sbrext.quest_contents_ext f,
                 sbrext.quest_contents_ext q,
                 sbrext.PROTOCOL_QC_EXT pp,
                 sbrext.PROTOCOLS_EXT p
                 WHERE  f.QTL_NAME='CRF'
                 and  q.dn_crf_idseq =f.qc_idseq 
                 and q.QTL_NAME ='QUESTION' 
                and p.preferred_name like 'PX%'
                and f.QC_IDSEQ=pp.QC_IDSEQ
              and p.PROTO_IDSEQ=pp.PROTO_IDSEQ
              GROUP BY q.dn_crf_idseq,f.qc_id, p.preferred_name) b
              where protocol=preferred_name
              and quest_sum<>quest_sum_csv;
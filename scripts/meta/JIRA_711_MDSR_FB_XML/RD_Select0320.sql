
                                              SELECT rd.name,
                                                     rd.DCTL_NAME,
                                                     c2.name,
                                                     rd.doc_text,
                                                     rd.LAE_NAME,
                                                     rd.url,
                                                     rb.name,
                                                     rb.MIME_TYPE,
                                                     rb.doc_size
                                                FROM SBR.REFERENCE_DOCUMENTS rd,
                                                     SBR.contexts c2,
                                                     SBR.REFERENCE_BLOBS RB
                                                   
                                               WHERE   RD.RD_IDSEQ =RB.RD_IDSEQ 
                                                      AND  c2.CONTE_IDSEQ = rd.CONTE_IDSEQ
                                                     AND rd.ac_idseq ='DE329218-46CF-3E0C-E034-0003BA12F5E7';
                                         

                                                        select*from   SBR.REFERENCE_DOCUMENTS RD,
                                                             REFERENCE_BLOBS RB where  
                                                             RD.RD_IDSEQ =RB.RD_IDSEQ   
                                                            and  ac_idseq =  'DE329218-46CF-3E0C-E034-0003BA12F5E7';
                                                           
                                                            select*from quest_contents_ext where qc_id=2263415
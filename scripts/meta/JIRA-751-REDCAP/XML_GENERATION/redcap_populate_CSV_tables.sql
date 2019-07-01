/*when next time we get new CSV files execute SP below with N=max(LOAD_LOAD_SEQ )+1
select max(LOAD_LOAD_SEQ )+1 into N from MDSR_REDCAP_PROTOCOL_CSV 
and provide as parameter in SPS*/



exec MDSR_RECAP_INSERT_CSV(N);
exec MDSR_RECAP_UPDATE_CSV(N);
exec MDSR_RECAP_UPDATE_CSV2(N);
exec MDSRedCapSaction_populate(N) ;
exec MSDRedCapSact_Quest_populate(N);
exec MDSRedCapSaction_Insert(N);
exec MDSRedCapForm_Insert(N) ;
exec MDSRedCap_VALVAL_Insert(N);



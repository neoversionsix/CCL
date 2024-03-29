SELECT
    org.org_name
    ;,year = Year(ce.event_start_dt_tm)
    ;,month = month(ce.event_start_dt_tm)
    ;,day = day(ce.event_start_dt_tm)
    ;,hour(ce.event_start_dt_tm)
    ;,No_insert = count(*)
    ;,enc_id = listagg(ce.ENCNTR_ID,"  ") over (order by null)
    ,enct_code = uar_get_code_display(ecn.encntr_type_cd)
    ,ECN.encntr_type_cd
    ,ecn.organization_id
    ,org.org_name
    ,location_facility = uar_get_code_display(ecn.loc_facility_cd)
    ,ea.alias
    ,p.name_full_formatted
    ,ce.ENCNTR_ID
    ,startevent = format(ce.EVENT_START_DT_TM , "dd/mm/yy")
    ;, endevent = format(ce.EVENT_END_DT_TM , "dd/mm/yy")
    ,cdl.LABEL_NAME
    ,Event_resul2 = Concat	(
                            trim(uar_get_code_display(ce.EVENT_CD))," ",
                            if ( ce.RESULT_VAL = ce.EVENT_TAG) ce.EVENT_TAG else concat(trim(ce.EVENT_TAG,5)," ", ce.RESULT_VAL) endif
                            )
    
 from clinical_event CE
    ,(left join V500_EVENT_CODE ec on ce.EVENT_CD = ec.EVENT_CD)
    ,(left join CE_EVENT_ACTION cea on cea.event_id = ce.event_id)
    ,(left join CE_DYNAMIC_LABEL CDL ON CE.CE_DYNAMIC_LABEL_ID = CDL.CE_DYNAMIC_LABEL_ID)
    ,(left join DYNAMIC_LABEL_TEMPLATE DLT on DLT.LABEL_TEMPLATE_ID = CDL.LABEL_TEMPLATE_ID)
    ,(LEFT JOIN DOC_SET_REF DSR ON DSR.DOC_SET_REF_ID = DLT.DOC_SET_REF_ID )
    ,(left join encounter ecn on ce.encntr_id = ecn.encntr_id)
    ,(left join encntr_alias ea on ea.encntr_id = ecn.encntr_id)
    ,(left join organization org on ecn.organization_id = org.organization_id)
    ,(	inner join person p on p.person_id = ce.person_id ;and p.person_id = 12630809
 	and p.ACTIVE_IND = 1 and p.NAME_LAST_KEY != "TESTWHS"
   )
PLAN CE
JOIN EC
JOIN CEA
JOIN CDL
JOIN DLT
JOIN DSR
JOIN ECN
JOIN EA
JOIN ORG
JOIN P

where
;    1=1
    ecn.encntr_type_cd = 309310 ; filter cannula inserts in Emergency only
;    ecn.encntr_type_cd = 309308 ; filter cannula inserts in inpatient only

    and dsr.DOC_SET_NAME_KEY IN ("PERIPHERAL IV RG","CENTRAL LINE RG")
    and cnvtlower(ea.alias) like "emg*"
    and cnvtlower(cdl.LABEL_NAME) like "*cannula*"
    and ce.event_cd = 79847746
    and (	cnvtlower(ce.EVENT_TAG) like "*insert*"
		or cnvtlower(ce.RESULT_VAL) like "**insert*"
	)
    and ce.event_start_dt_tm >= CNVTDATETIME("01-OCT-2020")
    and ce.event_start_dt_tm <= CNVTDATETIME("01-APR-2021")
    ;and ce.ENCNTR_ID = 47281522
    ;----------------
    ;AND CE.RESULT_STATUS_CD != 31
    ;AND CE.authentic_flag = 1
    ;AND CE.CE_DYNAMIC_LABEL_ID > 0
    ;AND CE.PUBLISH_FLAG = 1
    ;group by org.org_name, year(ce.event_start_dt_tm), month(ce.event_start_dt_tm), day(ce.event_start_dt_tm)
order by org.org_name, year(ce.event_start_dt_tm), month(ce.event_start_dt_tm), day(ce.event_start_dt_tm)
with time = 600, maxrec = 100000
select	; WHS users	
	prsnl_last_update = format(p.updt_dt_tm, "dd/mm/yy hh:mm:ss")
    , p.name_full_formatted	
	, physician_ind = p.physician_ind	
	, p.username	
	, postion = uar_get_code_display(p.position_cd)	
	, prsnl_create_dt = format(p.create_dt_tm, "dd/mm/yyyy")	
	, prsnl_creator =
        if(p.person_id > 0 and p.create_prsnl_id = 0) "0"	
	    else p_p_create.name_full_formatted	
	    endif	
	, prsnl_active = p.active_ind	
	, prsnl_active_status_dt = format(p.active_status_dt_tm, "dd/mm/yyyy")	
	, prsnl_active_status_updater = 
        if(p.person_id > 0 and p.active_status_prsnl_id = 0) "0"	
	    else p_p_act_stat.name_full_formatted
	    endif	
	, prsnl_beg_dt = format(p.beg_effective_dt_tm, "dd/mm/yyyy")	
	, prsnl_end_dt = format(p.end_effective_dt_tm, "dd/mm/yyyy")	
		
	, prsnl_last_updater = 
        if(p.person_id > 0 and p.updt_id = 0) "0"	
	    else p_p.name_full_formatted	
	    endif	
	, p.person_id	
	, Demo1_org = 
        if(p_org_r_Demo.prsnl_org_reltn_id > 0) "x"	
	    else ""	
	    endif	
	, Footscray_org = 
        if(p_org_r_Foots.prsnl_org_reltn_id > 0) "x"	
	    else ""	
	    endif	
	, Sunbury_org = 
        if(p_org_r_Sunb.prsnl_org_reltn_id > 0) "x"	
	    else ""	
	    endif	
	, Sunshine_org = 
        if(p_org_r_Suns.prsnl_org_reltn_id > 0) "x"	
	    else ""	
	    endif	
	, Williamstown_org = 
        if(p_org_r_Will.prsnl_org_reltn_id > 0) "x"	
	    else ""	
	    endif	
	, wh_org_count = p_org_r_Foots.active_ind + p_org_r_Sunb.active_ind + p_org_r_Suns.active_ind + p_org_r_Will.active_ind 	
	, wh_org_group = 
        if(p_org_set_r_wh.org_set_prsnl_r_id > 0) "x"	
	    else ""	
	    endif	
	, mpages_org_group = 
        if(p_org_set_r_mpages.org_set_prsnl_r_id > 0) "x"	
	    else ""	
	    endif	
	, external_id_alias = p_a_ext_id.alias	
	, alias_pool = uar_get_code_display(p_a_ext_id.alias_pool_cd)	
	, alias_pool_cd = 
        if(p_a_ext_id.prsnl_alias_id > 0) cnvtstring(p_a_ext_id.alias_pool_cd)	
	    else ""	
	    endif	
	, alias_type = uar_get_code_display(p_a_ext_id.prsnl_alias_type_cd)	
;	, alias_type_cd = if(p_a_ext_id.prsnl_alias_id > 0) cnvtstring(p_a_ext_id.prsnl_alias_type_cd)	
;	else ""	
;	endif	
	, alias_active = 
        if(p_a_ext_id.prsnl_alias_id > 0) cnvtstring(p_a_ext_id.active_ind)	
	    else ""	
	    endif	
;	, alias_active_status = uar_get_code_display(p_a_ext_id.active_status_cd)	
;	, alias_active_status_cd = if(p_a_ext_id.prsnl_alias_id > 0) cnvtstring(p_a_ext_id.active_status_cd)	
;	else ""	
;	endif	
	, alias_beg_dt = format(p_a_ext_id.beg_effective_dt_tm, "dd/mm/yyyy")	
	, alias_end_dt = format(p_a_ext_id.end_effective_dt_tm, "dd/mm/yyyy")	
;	, alias_contributor_system_cd = if(p_a_ext_id.prsnl_alias_id > 0) cnvtstring(p_a_ext_id.contributor_system_cd)	
;	else ""	
;	endif	
;	, alias_count = count(p_a_ext_id.alias_pool_cd) over (partition by p.person_id)	
	, alias_last_update = format(p_a_ext_id.updt_dt_tm, "dd/mm/yy hh:mm:ss")	
	, alias_last_updater = 
        if(p_a_ext_id.prsnl_alias_id > 0 and p_a_ext_id.updt_id = 0) "0"	
	    else p_p_a_ext_id.name_full_formatted	
	    endif	
	, alias_id = 
        if(p_a_ext_id.prsnl_alias_id > 0) cnvtstring(p_a_ext_id.prsnl_alias_id)	
	    else ""	
	    endif	
	, credential = uar_get_code_display(cred.credential_cd)	
	, cred_active = 
        if(cred.credential_id > 0) cnvtstring(cred.active_ind)	
	    else ""	
	    endif	
	, cred_beg_dt = format(cred.beg_effective_dt_tm, "dd/mm/yyyy")	
	, cred_end_dt = format(cred.end_effective_dt_tm, "dd/mm/yyyy")	
	, cred_count = count(distinct cred.credential_id) over (partition by cred.prsnl_id)	
	, cred_last_update = format(cred.updt_dt_tm, "dd/mm/yy hh:mm:ss")	
	, cred_last_updater = 
        if(cred.credential_id > 0 and cred.updt_id = 0) "0"	
	    else p_cred.name_full_formatted	
	    endif	
	, cred_id = 
        if(cred.credential_id > 0) cnvtstring(cred.credential_id)	
	    else ""	
	    endif	
	, user_rank = dense_rank() over (partition by 0	; no logical database field partition
	order by 	
	p.active_status_dt_tm	
	, cnvtupper(p.name_full_formatted)	
	, p.person_id	
	)	
		
from		
	prsnl p	
	, (left join prsnl p_p on p_p.person_id = p.updt_id)	
	, (left join prsnl p_p_create on p_p_create.person_id = p.create_prsnl_id)	
	, (left join prsnl p_p_act_stat on p_p_act_stat.person_id = p.active_status_prsnl_id)	
	, (left join prsnl_org_reltn p_org_r_Demo on p_org_r_Demo.person_id = p.person_id	
	and p_org_r_Demo.active_ind = 1	
	and p_org_r_Demo.beg_effective_dt_tm < sysdate	
	and p_org_r_Demo.end_effective_dt_tm > sysdate	
	and p_org_r_Demo.organization_id = 617843	; 'Demonstration 1 Hospital' organisation
	)	
	, (left join prsnl_org_reltn p_org_r_Foots on p_org_r_Foots.person_id = p.person_id	
	and p_org_r_Foots.active_ind = 1	
	and p_org_r_Foots.beg_effective_dt_tm < sysdate	
	and p_org_r_Foots.end_effective_dt_tm > sysdate	
	and p_org_r_Foots.organization_id = 680563	; 'WHS Footscray Hospital' organisation
	)	
	, (left join prsnl_org_reltn p_org_r_Sunb on p_org_r_Sunb.person_id = p.person_id	
	and p_org_r_Sunb.active_ind = 1	
	and p_org_r_Sunb.beg_effective_dt_tm < sysdate	
	and p_org_r_Sunb.end_effective_dt_tm > sysdate	
	and p_org_r_Sunb.organization_id = 680566	; 'WHS Sunbury Day Hospital' organisation
	)	
	, (left join prsnl_org_reltn p_org_r_Suns on p_org_r_Suns.person_id = p.person_id	
	and p_org_r_Suns.active_ind = 1	
	and p_org_r_Suns.beg_effective_dt_tm < sysdate	
	and p_org_r_Suns.end_effective_dt_tm > sysdate	
	and p_org_r_Suns.organization_id = 680564	; 'WHS Sunshine Hospital' organisation
	)	
	, (left join prsnl_org_reltn p_org_r_Will on p_org_r_Will.person_id = p.person_id	
	and p_org_r_Will.active_ind = 1	
	and p_org_r_Will.beg_effective_dt_tm < sysdate	
	and p_org_r_Will.end_effective_dt_tm > sysdate	
	and p_org_r_Will.organization_id = 680566	; 'WHS Williamstown Hospital' organisation
	)	
	, (left join org_set_prsnl_r p_org_set_r_wh on p_org_set_r_wh.prsnl_id = p.person_id	
	and p_org_set_r_wh.active_ind = 1	
	and p_org_set_r_wh.beg_effective_dt_tm < sysdate	
	and p_org_set_r_wh.end_effective_dt_tm > sysdate	
	and p_org_set_r_wh.org_set_id = 620126	; 'Western Health' org group
	)	
	, (left join org_set_prsnl_r p_org_set_r_mpages on p_org_set_r_mpages.prsnl_id = p.person_id	
	and p_org_set_r_mpages.active_ind = 1	
	and p_org_set_r_mpages.beg_effective_dt_tm < sysdate
	and p_org_set_r_mpages.end_effective_dt_tm > sysdate
	and p_org_set_r_mpages.org_set_id = 680584	; 'MPages Mobile Review' org group
	)	
	, (left join prsnl_alias p_a_ext_id on p_a_ext_id.person_id = p.person_id	
;	and p_a_ext_id.active_ind = 1	
;	and p_a_ext_id.beg_effective_dt_tm < sysdate	
;	and p_a_ext_id.end_effective_dt_tm > sysdate	
	and p_a_ext_id.alias_pool_cd = 683991	; 'External Id' from code set 263
	)	
	, (left join prsnl p_p_a_ext_id on p_p_a_ext_id.person_id = p_a_ext_id.updt_id)	
	, (left join credential cred on cred.prsnl_id = p.person_id	
	and cred.active_ind = 1	
	and cred.beg_effective_dt_tm < sysdate	
	and cred.end_effective_dt_tm > sysdate	
	)	
	, (left join prsnl p_cred on p_cred.person_id = cred.updt_id)	
		
plan	p	
;where	p.active_ind = 1	
where	p.position_cd not in (	
	0	; ignore blank position (â€˜non-user' EMR accounts, usually GPs)
	, 6797458	; ignore 'Non System' position
	,  (select code_value from code_value	; ignore no-longer used positions that begin with 'zz'
	where code_set = 88	
	and display_key = "ZZ*"	
	)	
	)	
and	p.username > " "	; ignore '0' database row
and	p.username not in ("AHS*", "PEN*")	; ignore Austin and Peninsula Health username format
join	p_p where p_p.name_full_formatted = "Whittle, Jason"
join	p_p_create
join	p_p_act_stat	
join	p_org_r_Demo	
join	p_org_r_Foots	
join	p_org_r_Sunb	
join	p_org_r_Suns	
join	p_org_r_Will	
join	p_org_set_r_wh	
join	p_org_set_r_mpages	
join	p_a_ext_id	
join	p_p_a_ext_id	
join	cred	
join	 p_cred	

order by
	p.updt_dt_tm DESC
		
with		
	time = 120	
	, maxrec = 1000	

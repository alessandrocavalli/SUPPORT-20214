---- unopti
set statistics time on;
SELECT SUB.* 
FROM ( select RES.* , row_number() over (ORDER BY RES.PRIORITY_ desc) rnk 
FROM ( select distinct RES.* 
	from ( select RES.*, PI.BUSINESS_KEY_, PD.VERSION_TAG_ from ACT_RU_EXT_TASK RES left join ACT_RU_EXECUTION PI on RES.PROC_INST_ID_ = PI.ID_ inner join ACT_RE_PROCDEF PD on RES.PROC_DEF_ID_ = PD.ID_ 
left join ( SELECT A.* FROM ACT_RU_AUTHORIZATION A 
	WHERE A.TYPE_ < 2 AND ( A.USER_ID_ in ( 'demo', '*') OR A.GROUP_ID_ IN ( 'camunda-admin' , 'DK9995_ProcApp_Clients' ) ) ) AUTH 
		ON ( (AUTH.RESOURCE_TYPE_ = 8 AND (AUTH.RESOURCE_ID_ IN ( RES.PROC_INST_ID_ , '*' )) 
			AND AUTH.PERMS_ &2 = 2) OR (AUTH.RESOURCE_TYPE_ = 6 
			AND (AUTH.RESOURCE_ID_ IN ( RES.PROC_DEF_KEY_ , '*' )) 
			AND AUTH.PERMS_ &512 = 512) ) 
left join ( SELECT A.* FROM ACT_RU_AUTHORIZATION A 
	WHERE A.TYPE_ < 2 
	AND ( A.USER_ID_ in ( 'demo', '*') OR A.GROUP_ID_ IN ( 'camunda-admin' , 'DK9995_ProcApp_Clients'  ) ) ) AUTH1 
		ON ( (AUTH1.RESOURCE_TYPE_ = 8 
		AND (AUTH1.RESOURCE_ID_ IN ( RES.PROC_INST_ID_ , '*' )) 
		AND AUTH1.PERMS_ &4 = 4) OR (AUTH1.RESOURCE_TYPE_ = 6 
		AND (AUTH1.RESOURCE_ID_ IN ( RES.PROC_DEF_KEY_ , '*' )) 
		AND AUTH1.PERMS_ &1024 = 1024) ) 
		WHERE (RES.LOCK_EXP_TIME_ is null or RES.LOCK_EXP_TIME_ <= GETDATE()) 
		and (RES.SUSPENSION_STATE_ is null or RES.SUSPENSION_STATE_ = 1) 
		and (RES.RETRIES_ is null or RES.RETRIES_ > 0) 
		and ( RES.TOPIC_NAME_ = 'load' ) 
		AND AUTH.RESOURCE_ID_ IS NOT NULL 
		AND AUTH1.RESOURCE_ID_ IS NOT NULL 
		and (RES.TENANT_ID_ is null or RES.TENANT_ID_ in ( 'DK9961' ) )
		) RES )RES ) SUB 
		WHERE SUB.rnk >= 1 AND SUB.rnk < 2 ORDER BY SUB.rnk
set statistics time off;

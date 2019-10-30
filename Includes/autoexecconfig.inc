stock auto_exec_config(const szName[], bool:bAutoCreate=true)
{
	new szFileName[32]
	new iLen = copy(szFileName, charsmax(szFileName), szName)
	if( iLen <= 4 || !equal(szFileName[iLen-4], ".cfg") )
	{
		add(szFileName, charsmax(szFileName), ".cfg")
	}

	new szConfigPath[96]
	get_localinfo("amxx_configsdir", szConfigPath, charsmax(szConfigPath))
	format(szConfigPath, charsmax(szConfigPath), "%s/%s", szConfigPath, szFileName)

	if( file_exists(szConfigPath) )
	{
		server_cmd("exec %s", szConfigPath)
		server_exec()
		return 1
	}
	else if( bAutoCreate )
	{
		new fp = fopen(szConfigPath, "wt")
		if( !fp )
		{
			return -1
		}
		new szPluginFileName[96], szPluginName[64], szAuthor[32], szVersion[32], szStatus[2]
		new iPlugin = get_plugin(-1, 
					szPluginFileName, charsmax(szPluginFileName), 
					szPluginName, charsmax(szPluginName), 
					szVersion, charsmax(szVersion), 
					szAuthor, charsmax(szAuthor), 
					szStatus, charsmax(szStatus) )

		server_print("Plugin id is %d", iPlugin)
		fprintf(fp, "; ^"%s^" configuration file^n", szPluginName)
		fprintf(fp, "; Author : ^"%s^"^n", szAuthor)
		fprintf(fp, "; Version : ^"%s^"^n", szVersion)
		fprintf(fp, "; File : ^"%s^"^n", szPluginFileName)

		new iMax, i, szCommand[64], iCommandAccess, szCmdInfo[128], szFlags[32]
		iMax = get_concmdsnum(-1, -1)
		fprintf(fp, "^n; Console Commands :^n")
		for(i=0; i<iMax; i++)
		{
			if( get_concmd_plid(i, -1, -1) == iPlugin )
			{
				get_concmd(i, 
						szCommand, charsmax(szCommand), 
						iCommandAccess, 
						szCmdInfo, charsmax(szCmdInfo), 
						-1, -1)
				get_flags(iCommandAccess, szFlags, charsmax(szFlags))
				fprintf(fp, "; %s | Access:^"%s^" | ^"%s^"^n", szCommand, szFlags, szCmdInfo)
			}
		}

		iMax = get_plugins_cvarsnum()
		new iTempId, iPcvar, szCvarName[256], szCvarValue[128]
		fprintf(fp, "^n; Cvars :^n")
		for(new i; i<iMax; i++)
		{
			get_plugins_cvar(i, szCvarName, charsmax(szCvarName), _, iTempId, iPcvar)
			if( iTempId == iPlugin )
			{
				get_pcvar_string(iPcvar, szCvarValue, charsmax(szCvarValue))
				fprintf(fp, "%s ^"%s^"^n", szCvarName, szCvarValue)
			}
		}

		fclose(fp)
	}
	return 0
}
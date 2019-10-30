enum _:Colors 
{
	DONT_CHANGE,
	TERRORIST,
	CT,
	SPECTATOR
}

stock colorChat_FIX(id, COLOR=DONT_CHANGE, fmt[], any:...)
{
	new szMsg[192]
	szMsg[0] = 0x04
	vformat(szMsg[1], charsmax(szMsg)-1, fmt, 4)
	
	replace_all(szMsg, charsmax(szMsg), "!y" , "^1");
	replace_all(szMsg, charsmax(szMsg), "!t" , "^3");
	replace_all(szMsg, charsmax(szMsg), "!g" , "^4");
	
	new szTeam[11], MSG_DEST = id ? MSG_ONE : MSG_ALL
	
	static const szTeamNames[Colors][] = {"UNASSIGNED", "TERRORIST", "CT", "SPECTATOR"}
	
	if( COLOR )
	{
		Send_TeamInfo(id, szTeamNames[COLOR], MSG_DEST)
	}
	
	static iSayText
	
	if( iSayText || (iSayText = get_user_msgid("SayText")) )
	{
		message_begin(MSG_DEST, iSayText, _, id)
		{
			write_byte(id ? id : 1)
			write_string(szMsg)
		}
		message_end()
	}
	
	if( COLOR )
	{
		if( id || is_user_connected(1) )
		{
			get_user_team(id ? id : 1, szTeam, charsmax(szTeam))
			Send_TeamInfo(id, szTeam, MSG_DEST)
		}
		else
		{
			Send_TeamInfo(0, "UNASSIGNED", MSG_DEST)
		}
	}
}

Send_TeamInfo(const id, const szTeam[], MSG_DEST)
{
	static iTeamInfo
	if( iTeamInfo || (iTeamInfo = get_user_msgid("TeamInfo")) )
	{
		message_begin(MSG_DEST, iTeamInfo, _, id)
		{
			write_byte(id ? id : 1)
			write_string(szTeam)
		}
		message_end()
	}
}
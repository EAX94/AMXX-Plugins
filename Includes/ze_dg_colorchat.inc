#if defined _ng_colorchat_included
	#endinput
#endif
#define _ng_colorchat_included

enum _:structIdColor
{
	DONT_CHANGE,
	TERRORIST,
	CT,
	SPECTATOR
};

new const CS_TEAM_NAMES[structIdColor][] = {"UNASSIGNED", "TERRORIST", "CT", "SPECTATOR"};

stock colorChat(const id, color=DONT_CHANGE, const input[], any:...)
{
	static sMessage[192];
	sMessage[0] = 0x04;

	vformat(sMessage[1], charsmax(sMessage) - 1, input, 4);

	replace_all(sMessage[1], charsmax(sMessage) - 1, "!g", "^4");
	replace_all(sMessage[1], charsmax(sMessage) - 1, "!y", "^1");
	replace_all(sMessage[1], charsmax(sMessage) - 1, "!t", "^3");

	if(color)
		sendTeamInfo(id, CS_TEAM_NAMES[color]);

	sendSayText(id, sMessage);

	if(color)
	{
		if(id || is_user_connected(1))
		{
			static sTeam[12];
			get_user_team((id) ? id : 1, sTeam, 11);

			sendTeamInfo(id, sTeam);
		}
		else
			sendTeamInfo(0, CS_TEAM_NAMES[DONT_CHANGE]);
	}
}

public sendSayText(const id, const message[])
{
	static iSayText;
	if(iSayText || (iSayText = get_user_msgid("SayText")))
	{
		message_begin((id) ? MSG_ONE_UNRELIABLE : MSG_BROADCAST, iSayText, _, id);
		write_byte((id) ? id : 1);
		write_string(message);
		message_end();
	}
}

public sendTeamInfo(const id, const team[])
{
	static iTeamInfo;
	if(iTeamInfo || (iTeamInfo = get_user_msgid("TeamInfo")))
	{
		message_begin((id) ? MSG_ONE_UNRELIABLE : MSG_BROADCAST, iTeamInfo, _, id);
		write_byte((id) ? id : 1);
		write_string(team);
		message_end();
	}
}
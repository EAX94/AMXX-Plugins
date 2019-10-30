/*
* AMX mod X team functions for "Natural-Selection 3.2"
* by Mev-Rael (Tyrael@inbox.lv ; Tyrael_Greefien @ skype; Mevrael @ steam)
*
* 28.04.2010
*
* http://ns.boxg.lv - Baltic Natural-Selection Community
*
* Those functions provides a simple manipulation with NS (MvA) teams:
* 1) Check if player is in team
* 2) Change player team
* 3) Count players in team
* 4) Get players ID and count in team
*/

#if !defined NS_INC
    #include <ns>
#endif 

/*
* Check if player is in team
* return true or false
*/

// Check if player is in readyroom
stock nst_is_readyroom(id)
{
	new team[4]
	ns_get_user_team(id, team, 3)
	
	if (equal(team, "und") && is_user_connected(id))
	{
		return true
	}
	return false
}

// Check if player is in spectatorteam
stock nst_is_spectate(id)
{
	new team[2]
	ns_get_user_team(id, team, 1)
	
	if (team[0] == 's')
	{
		return true
	}
	return false
}

// Check if player is in marine team
stock nst_is_marine(id)
{
	new team[2]
	ns_get_user_team(id, team, 1)
	
	if (team[0] == 'm')
	{
		return true
	}
	return false
}

// Check if player is in alien team
stock nst_is_alien(id)
{
	new team[2]
	ns_get_user_team(id, team, 1)
	
	if (team[0] == 'a'))
	{
		return true
	}
	return false
}


/*
* Change player team
*/

// Send  a player to readyroom
stock nst_readyroom(id)
{
	new team[4]
	ns_get_user_team(id, team, 3)
	
	if (!equal(team, "und") && is_user_connected(id))
	{
		client_cmd(id, "readyroom; readyroom")
	}
}

// Readyroom all
stock nst_readyroomall()
{
	new players[32], num, i
	get_players(players, num)
	for (i=0; i<num; i++)
	{
		nst_readyroom(players[i])
	}
}

// Send a player to spectatorteam
stock nst_spectate(id)
{
	new team[2]
	ns_get_user_team(id, team, 1)
	
	if (team[0] != 's' && is_user_connected(id))
	{
		nst_readyroom(id)
		
		client_cmd(id, "spectate")
	}
}

// Send a player to marines
stock nst_marine(id)
{
	new team[2]
	ns_get_user_team(id, team, 1)
	
	if (team[0] != 'm' && is_user_connected(id))
	{
		if (team[0] != 's')
		{
			nst_readyroom(id)
		}
		
		client_cmd(id, "jointeamone")
	}
}

// Send a player to aliens
stock nst_alien(id)
{
	new team[2]
	ns_get_user_team(id, team, 1)
	
	if (team[0] != 'a' && is_user_connected(id))
	{
		if (team[0] != 's')
		{
			nst_readyroom(id)
		}
		
		client_cmd(id, "jointeamtwo")
	}
}


/*
* Count members in team
* Return a number
*/

// Count players in readyroom
stock nst_readyroom_count()
{
	new count = 0
	new players[32], num, i
	
	get_players(players, num)
	
	for (i=0; i<num; i++)
	{
		if (nst_is_readyroom(players[i]))
		{
			count++
		}
	}
	
	return count
}

// Count players in spectatorteam
stock nst_spectate_count()
{
	new count = 0
	new players[32], num, i
	
	get_players(players, num)
	
	for (i=0; i<num; i++)
	{
		if (nst_is_spectate(players[i]))
		{
			count++
		}
	}
	
	return count
}

// Count players in marine team
stock nst_marine_count()
{
	new count = 0
	new players[32], num, i
	
	get_players(players, num)
	
	for (i=0; i<num; i++)
	{
		if (nst_is_marine(players[i]))
		{
			count++
		}
	}
	
	return count
}

// Count players in alien team
stock nst_alien_count()
{
	new count = 0
	new players[32], num, i
	
	get_players(players, num)
	
	for (i=0; i<num; i++)
	{
		if (nst_is_alien(players[i]))
		{
			count++
		}
	}
	
	return count
}


/*
* Get players ID and count in team.
* Return an array with 33 elements. 1-32 are player indexes and 0 is players count
* Example: client_print to all marines
*
* new marines[33]
* marines = nst_get_marine()
* for (new i=1; i<=marines[0]; i++) {
*	client_print(marines[i], print_chat, "You are marine!")
* }
*/

// Get readyroom players
stock nst_get_readyroom()
{
	new teamplayers[33]
	new players[32], num, i
	new k=0
	
	get_players(players, num)
	
	for (i=0; i<num; i++)
	{
		if (nst_is_readyroom(players[i]))
		{
			k++
			teamplayers[k]=players[i]
		}
		
		teamplayers[0] = k
	}
	
	return teamplayers
}

// Get spectatorteam players
stock nst_get_spectate()
{
	new teamplayers[33]
	new players[32], num, i
	new k=0
	
	get_players(players, num)
	
	for (i=0; i<num; i++)
	{
		if (nst_is_spectate(players[i]))
		{
			k++
			teamplayers[k]=players[i]
		}
		
		teamplayers[0] = k
	}
	
	return teamplayers
}

// Get marine players
stock nst_get_marine()
{
	new teamplayers[33]
	new players[32], num, i
	new k=0
	
	get_players(players, num)
	
	for (i=0; i<num; i++)
	{
		if (nst_is_marine(players[i]))
		{
			k++
			teamplayers[k]=players[i]
		}
		
		teamplayers[0] = k
	}
	
	return teamplayers
}

// Get alien players
stock nst_get_alien()
{
	new teamplayers[33]
	new players[32], num, i
	new k=0
	
	get_players(players, num)
	
	for (i=0; i<num; i++)
	{
		if (nst_is_alien(players[i]))
		{
			k++
			teamplayers[k]=players[i]
		}
		
		teamplayers[0] = k
	}
	
	return teamplayers
}
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1049\\ f0\\ fs16 \n\\ par }
*/

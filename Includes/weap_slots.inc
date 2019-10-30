/*
   1.0a: set_slot now works with bots
 */

#define MAXSLOTS 5
#define MAXWEAPS 31

new numWeapons[33]
new numSlot[33][MAXSLOTS]
new inSlot[33][MAXSLOTS]

stock weap_slot[MAXWEAPS] = {
	0,
	2,	//CSW_P228
	0,
	1,	//CSW_SCOUT
	4,	//CSW_HEGRENADE
	1,	//CSW_XM1014
	5,	//CSW_C4
	1,	//CSW_MAC10
	1,	//CSW_AUG
	4,	//CSW_SMOKEGRENADE
	2,	//CSW_ELITE
	2,	//CSW_FIVESEVEN
	1,	//CSW_UMP45
	1,	//CSW_SG550
	1,	//CSW_GALIL
	1,	//CSW_FAMAS
	2,	//CSW_USP
	2,	//CSW_GLOCK18
	1,	//CSW_AWP
	1,	//CSW_MP5NAVY
	1,	//CSW_M249
	1,	//CSW_M3
	1,	//CSW_M4A1
	1,	//CSW_TMP
	1,	//CSW_G3SG1
	4,	//CSW_FLASHBANG
	2,	//CSW_DEAGLE
	1,	//CSW_SG552
	1,	//CSW_AK47
	3,	//CSW_KNIFE
	1	//CSW_P90
}

public num_slot(id, slot){
	get_weaps(id)
	return numSlot[id][slot]
}

public set_slot(id, slot){
	if(weap_slot[get_user_weapon(id)]==1 && num_slot(id, slot))
	{
		new weapon[33]
		get_weaponname(inSlot[id][slot], weapon, 32)
		
		engclient_cmd(id, weapon)
	}
}

get_weaps(id){
	reset_slots(id)
	
	new Weapons[32], weap
	get_user_weapons(id, Weapons, numWeapons[id])
	
	for(new x = 0; x < numWeapons[id]; x++)
	{
		weap = Weapons[x]
		
		new slot = weap_slot[weap]
		numSlot[id][slot]++
		inSlot[id][slot] = weap
	}
}

reset_slots(id){
	numWeapons[id] = 0
	
	for(new x=0; x<MAXSLOTS; x++)
	{
		numSlot[id][x]=0
		inSlot[id][x]=-1
	}
}

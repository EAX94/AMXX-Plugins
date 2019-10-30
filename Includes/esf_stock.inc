/*
Made by Hip_hop_x / GameBak for esf fans, more stocks will be added once I find them

			--	--//Credits://--       --
Zenith77, he recreated the esf_player_class and made it working, 
Zero demonstrated me how to get player class more easy
*/
#if defined _esf_stock_included
#endinput
#endif
#define _esf_stock_included

#include <amxmodx>
#include <fakemeta>
#include <engine>


//max ki is 1000!
stock esf_get_ki(id){
	if(!is_user_alive(id))
		return 0
	return floatround( entity_get_float(id, EV_FL_fuser4 ))
}
//if you set ki over 1000, the ki box will have a bigger width
stock esf_set_ki(id,value){
	entity_set_float(id, EV_FL_fuser4, float(value))
}
stock esf_get_powerlevel(id){
	return get_pdata_int(id,460)
}
stock esf_set_powerlevel(id,thp){
	set_pdata_int(id,460,thp)
}
stock esf_get_acpl(id){
	return get_pdata_int(id,463)
}
stock esf_set_acpl(id,acpl){
	set_pdata_int(id,463,acpl)
}
stock esf_get_maxhealth(id){
	return get_pdata_int(id, 142)
}
//health bar gets increased
stock esf_set_maxhealth(id,health){
	set_pdata_int(id, 142,health)
	message_begin( MSG_ONE, get_user_msgid("MaxHealth"),{ 0, 0, 0 },id)
	write_byte(health)
	message_end( )
}
/*Usage if(esf_player_class(id) == ESFC_TRUNKS) {  }
Notice: esf_player_class(id) will return the number of the class
*/
enum ESFClasses
{
	ESFC_NOCLASS = 0,
	ESFC_VEGETA,
	ESFC_CELL,
	ESFC_BUU,
	ESFC_FRIEZA,
	ESFC_GOHAN,
	ESFC_GOKU,
	ESFC_KRILLIN,
	ESFC_PICCOLO,
	ESFC_TRUNKS
}

new const gESFClassNames[ESFClasses][] =
{
	"N/A",
	"vegeta",
	"cell",
	"buu",
	"frieza",
	"gohan",
	"goku",
	"kirllin",
	"piccolo",
	"trunks"
}

stock ESFClasses:esf_player_modelclass(id){
	static sModel[32]
	get_user_model(id, sModel, charsmax(sModel))
	for (new i = 1; i < sizeof gESFClassNames; i++)
	{
		if (containi(sModel, gESFClassNames[ESFClasses:i]) != -1)
			return ESFClasses:i;
	}
	return ESFC_NOCLASS;
}
stock esf_player_class(id){
	switch(entity_get_int(id, EV_INT_playerclass )){
	case 1:
		return "buu"
	case 2:
		return "goku"
	case 3:
		return "gohan"
	case 4:
		return "krillin"
	case 5:
		return "frieza"
	case 6:	
		return "piccolo"
	case 7:
		return "trunks"
	case 8:
		return "vegeta"
	case 9:
		return "cell"
	}
}

/* Xen Gunshop Stocks
*
* This file is provided as is (no warranties).
*/

#if defined _xen_gunshop_included
  #endinput
#endif
#define _xen_gunshop_included

#define get_gunshop_array() get_xarray("gunshop")

stock load_gun(infostr[])
{
	new gunid[200], duration[200], clips[200], flags[200], origin[200]
	break_npc_line(infostr,gunid,duration,clips,flags,origin)

	new Float:Origin[3]
	string_to_vector(origin,Origin)

	new ent = spawn_weapon(gunid,duration,clips,flags)

	entity_set_origin(ent, Origin)
}


stock save_gun(infostr[])
{
	new gunshop_array = get_gunshop_array() 

	new slot = array_firstempty (gunshop_array, 0);
	array_set_string(gunshop_array, slot, infostr);

	return slot;
}

stock spawn_weapon(gunid[],duration[],clips[],flags[])
{
	new ent = create_entity("ts_groundweapon")
	if(!ent || !is_valid_ent(ent)) return 0;

	DispatchKeyValue(ent, "tsweaponid", gunid)
	DispatchKeyValue(ent, "wduration", duration)
	DispatchKeyValue(ent, "wextraclip", clips)
	DispatchKeyValue(ent, "spawnflags", flags)
	DispatchSpawn(ent)

	return ent;
}
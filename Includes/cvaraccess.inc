/* AMX Mod X
*   CVars Access System functions
*
* (c) Copyright 2007 by VEN
*
* This file is provided as is (no warranties)
*/

#if defined _cvaraccess_included
	#endinput
#endif

#define _cvaraccess_included


// returns access flag(s) to a CVar, returns access to a default amx_cvar command if CVar doesn't have a custom access, returns -1 on failure
native get_cvar_access(pointer);

// returns 1 on success and 0 on failure
native set_cvar_access(pointer, flags);

// the above natives shouldn't be called if a return result of the below function is false
stock bool:is_cvar_access_running() {
	static pid = -2;
	if (pid == -2)
		pid = find_plugin_byfile("cvars_access_system.amxx");

	if (pid == INVALID_PLUGIN_ID)
		return false;

	static status[2];
	get_plugin(pid, status, 0, status, 0, status, 0, status, 0, status, sizeof status - 1);
	if (status[0] == 'r' || status[0] == 'd')
		return true;

	return false;
}

// returns access to a default amx_cvar command, returns -1 if access can't be determined
stock get_default_cvar_access() {
	static flags, bool:retrieved = false;
	if (retrieved)
		return flags;

	static pid = -2;
	if (pid == -2)
		pid = find_plugin_byfile("admincmd.amxx");

	if (pid == INVALID_PLUGIN_ID) {
		retrieved = true;
		flags = -1;
		return flags;
	}

	static status[2];
	get_plugin(pid, status, 0, status, 0, status, 0, status, 0, status, sizeof status - 1);
	if (status[0] != 'r' && status[0] != 'd') {
		if (status[0] != 'p') {
			retrieved = true;
			flags = -1;
		}
		return -1;
	}

	static const amx_cvar[] = "amx_cvar";
	static command[sizeof amx_cvar + 1], dummy[1], i; i = 0;
	while (get_concmd(i, command, sizeof command - 1, flags, dummy, sizeof dummy - 1, -1)) {
		if (equal(command, amx_cvar) && get_concmd_plid(i, -1, -1) == pid) {
			retrieved = true;
			return flags;
		}
		i++;
	}

	return -1;
}

// similar to amxmisc's access(), takes in account an ADMIN_ALL access level, optimized
stock bool:has_access(id, flags) {
	if (flags == ADMIN_ALL)
		return true;

	static level;
	level = get_user_flags(id);
	if (flags == ADMIN_ADMIN && level > 0 && !(level & ADMIN_USER))
		return true;

	return !!(level & flags);
}

#if defined _text_included
	#endinput
#endif
#define _text_included

/*
	String functions by Zefir<zefir-cs@ukr.net>
		developed for Cerberus project
		http://cerberus.cstrike.in.ua/
	5 January 2010 (c) Zefir
*/

#include <fakemeta>



// Allocate memory for string
// Used for store parameters between call of set_task and other callbacks
#define get_ptr_to_str(%1) engfunc(EngFunc_AllocString, %1)
#define get_str_from_ptr(%1,%2,%3) global_get(glb_pStringBase, %1, %2, %3)
#define free_ptr_to_str(%1) %1 = 0

// simple copy with autodetected size of recive buffer
#define scopy(%1,%2) copy(%1, sizeof(%1) - 1, %2)

/*
	For create sub formatted string

Example:

#include <amxmodx>
#include <text>

public plugin_init() {
	register_plugin("Dinamic Hostname", "1.0", "Zefir")
	register_cvar("amx_hostname", "CS Server (next map: #m; timeleft: #t)")
	set_task(1.0, "set_hostname", 0, _, _, "b")
}

public set_hostname() {
	static hostname[64]

	get_cvar_string("amx_hostname", hostname, charsmax(hostname))

	static time_string[32], next_map[32]
	static h,m,s

	if (!get_cvar_float("mp_timelimit"))
		formatex(time_string, charsmax(time_string), "Never")
	else {
		s = get_timeleft()
		m = s/60
		h = m/60
		s = s-m*60
		m = m-h*60
		if(h)
			formatex(time_string, charsmax(time_string), "%d:%02d:%02d", h, m, s)
		else
			formatex(time_string, charsmax(time_string), "%d:%02d", m, s)
	}
	replace_all_format(hostname, charsmax(hostname), 't', time_string)

	get_cvar_string("amx_nextmap", next_map, charsmax(next_map))
	replace_all_format(hostname, charsmax(hostname), 'm', next_map)

	set_cvar_string("hostname", hostname)
}


*/
stock replace_all_format(string[], len, const format_char, const with[]) {

	static total, format_str[3]
	total = 0
	formatex(format_str, 2, "#%c", format_char)

	while (replace(string, len, format_str, "%s") != 0) {
		format(string, len, string, with)
		total++;
	}

	return total;
}


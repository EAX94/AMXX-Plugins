#if defined __INCLUDED_AnyMAL_MainMenu
	#endinput
#endif

#define __INCLUDED_AnyMAL_MainMenu

/*
----------------
@ about
----------------

AnyMAL (Any-Mod Abstraction Layer)
MM (Main Menu) subsystem

by Shadows In Rain (aka SiR)
shadowsinrain@ya.ru

This plugin shares main menu (assigned to M key) via AnyMAL MB.

----------------
@ notes
----------------

Injection item indexex starts from 1.
Zero indicates failed injection.

Menu items 8 and 9 reserved for admin menu and options.

After injected, watch when menu items shown and selected.

If you want show main menu, pass 9 as number of menu items.

----------------
@ depedencies
----------------

This plugin uses AnyMAL IPM
Initialization depends on Anymal MB.

----------------
*/

// IPM
#define IPM_ANYMAL_MM "anymal/mm"

// menus enumeration
const MMP:anymal_mm_c_main = MMP:0
const MMP:anymal_mm_c_admin = MMP:1
const MMP:anymal_mm_c_options = MMP:2

/*
Obtain menu handle.
*/
native MBH:anymal_mm_hook(MMP:menu = anymal_mm_c_main)

/*
Broadcasted before IPM. Can be used by main menu override plugins,
f.e. to make "change team" first option on options menu.
*/
forward anymal_mm_initialized()

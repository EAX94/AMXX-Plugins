#if defined __INCLUDED_AnyMAL_MenuBuilder
	#endinput
#endif

#define __INCLUDED_AnyMAL_MenuBuilder

/*
----------------
@ about
----------------

AnyMAL (Any-Mod Abstraction Layer)
MB (Menu Builder) subsystem

by Shadows In Rain (aka SiR)
shadowsinrain@ya.ru

This plugin helps manage big or shared menus.

----------------
@ notes
----------------

Handle count starts from 1.
Zero indicates unitialized cell or invalid handle.

Pages handled automatically for menus with multiple pages.
Pages and items count starts from 1.

Injection index can act as item index, as on-screen menu index, or even as page index.
Look for menu provider documentation before injection.

----------------
@ depedencies
----------------

This plugin uses AnyMAL IPM

----------------
*/

// IPM
#define IPM_ANYMAL_MB "anymal/mb"

// Max symbols can be shown for single menu item or predefined element.
const anymal_mb_text_len = 100

/*
Register new menu.
Menus with navigation will be present with "Back", "Next" and page counter.
Menus without navigation can show up to 9 items only.
*/
native MBH:anymal_mb_register(bool:navigation)

/*
Inject your item into menu.
You must be sure that menu is injectable.
*/
native anymal_mb_inject(MBH:handle)

/*
Get number of injections in menu.
*/
native anymal_mb_injections(MBH:handle)

/*
Launch menu building.
To show on previous page, pass zero.
*/
native anymal_mb_show(MBH:handle, player, page = 1)

/*
Menu requested to be shown.
*/
forward anymal_mb_requested(MBH:handle, player, page)

/*
Accept menu. Without this request will be ignored.
Callback to anymal_mb_requested.
*/
native anymal_mb_accept(const header[], const footer[], num_pages_or_items = 1, bool:specified_pages = false)

/*
Current item will be shown in menu.
Hook it and update.
*/
forward anymal_mb_item_shown(MBH:handle, player, item, menuitem, page)

/*
Update displayed item.
Callback to anymal_mb_item_shown.
*/
native anymal_mb_update_item(const text[])

/*
Item in menu was selected by user.
*/
forward anymal_mb_item_selected(MBH:handle, player, item, menuitem, page)

/*
User selected exit.
*/
forward anymal_mb_menu_closed(MBH:handle, player)
#if defined SAFE_MENU_INCLUDED
#endinput
#endif
#define SAFE_MENU_INCLUDED

stock __LocalMenus[33] = {INVALID_HANDLE, ...};

/*
 * Shows a menu which is supposed to be destroyed when another one is shown.
 * It does a certain check and then calls menu_display().
 * Use instead of menu_display().
 * 
 * @return - same as menu_display().
 */
stock ShowLocalMenu(client, menu, page = 0)
{
	if (__LocalMenus[client] != INVALID_HANDLE && menu != __LocalMenus[client])
		menu_destroy(__LocalMenus[client]);
	
	__LocalMenus[client] = menu;
	
	return menu_display(client, menu, page);
}

/*
 * Shows a menu which is NOT supposed to be destroyed when another one is shown.
 * It does a certain check and then calls menu_display().
 * Use instead of menu_display().
 * 
 * @return - same as menu_display().
 */
stock ShowGlobalMenu(client, menu, page = 0)
{
	if (__LocalMenus[client] != INVALID_HANDLE)
	{
		menu_destroy(__LocalMenus[client]);
		__LocalMenus[client] = INVALID_HANDLE;
	}
	
	return menu_display(client, menu, page);
}

/*
 * Destroys a menu which was previously shown with ShowLocalMenu() function.
 * Use instead of menu_destroy().
 * 
 * @return - same as menu_destroy().
 * 
 * Note - It requires the index of player as first parameter, unlike menu_destroy().
 * Note - For global menus, which were shown with ShowGlobalMenu() or menu_display(),
 *        use menu_destroy() instead.
 */
stock DestroyLocalMenu(client, menu)
{
	__LocalMenus[client] = INVALID_HANDLE;
	
	return menu_destroy(menu);
}
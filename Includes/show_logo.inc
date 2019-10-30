public showLogo(const id, const logo) {
	if(logo != LOGO_NONE) {
		g_Account_Logo[id] = logo;
		
		message_begin(MSG_ONE, g_Message_WeaponList, _, id);
		write_string(SPRITE_DIR[logo]);
		write_byte(-1);
		write_byte(-1);
		write_byte(-1);
		write_byte(-1);
		write_byte(3);
		write_byte(3);
		write_byte(CSW_VEST);
		write_byte((1<<0));
		message_end();
		
		message_begin(MSG_ONE, g_Message_Fov, _, id);
		write_byte(89);
		message_end();
		
		message_begin(MSG_ONE, g_Message_CurWeapon, _, id);
		write_byte(1);
		write_byte(CSW_VEST);
		write_byte(1);
		message_end();
		
		message_begin(MSG_ONE, g_Message_Fov, _, id);
		write_byte(90);
		message_end();
	} else if(g_Account_Logo[id]) {
		g_Account_Logo[id] = logo;
		
		message_begin(MSG_ONE, g_Message_CurWeapon, _, id);
		write_byte(2);
		write_byte(CSW_VEST);
		write_byte(1);
		message_end();
	}
}
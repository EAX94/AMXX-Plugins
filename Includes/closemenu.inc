stock closeMenus(const id) {
	message_begin(MSG_ONE, get_user_msgid("ShowMenu"), .player=id);
	{
		write_short(0);
		write_char(0);
		write_byte(0);
		write_string("");
	}
	message_end();
}
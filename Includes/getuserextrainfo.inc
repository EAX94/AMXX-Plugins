/*
	Include for:
	
	Native to get the 5th argument of a user entry in users.ini

	native bool:GetUserExtraInfo(const UserKey[], Output[], len)
	
	; New Format of admin account in users.ini (backwards compatible):
	; <name|ip|steamid> <password> <access flags> <account flags> [extra info]

*/
#if defined _getuserextrainfo_included
	#endinput
#endif
#define _getuserextrainfo_included

#pragma reqlib "getuserextrainfo"

/*
	@param UserKey		String: <name|ip|steamid>
	@param Output		String to output "ExtraInfo" (The 5th argument of a user entry in users.ini)
	@param len			Max length of output string
	
	@return				True if found any ExtraInfo.

*/
native bool:GetUserExtraInfo(const UserKey[], Output[], len)

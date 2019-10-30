#if defined _expmod_included
  #endinput
#endif
#define _expmod_included

#define get_playing(%1) (cs_get_user_team(%1) == CS_TEAM_T || cs_get_user_team(%1) == CS_TEAM_CT)

enum
{
	STATUS_UNREGISTERED = 0,
	STATUS_REGISTERED,
	STATUS_LOGED
}

forward fmod_status(index, status)

forward fmod_level(index, level, reset)

forward fmod_class_lasers(id, lasers)

native fmod_add_class(const name[], const privilegios[], level, reset, health, armor, lasers, hegrenade, flashbang, smokegrenade)

native fmod_get_user_class(index)

native fmod_is_carnage()

native fmod_frag_laser(id)

native fmod_frag_ronda(id)

native fmod_have_money(index, cantidad=0, sacar=0)

native fmod_get_user_congelacion(id)

native fmod_get_user_descongelacion(id)

native haveFrozen(id)

native mejoraPonerLaserMine(id)

native mejoraSacarLaserMine(id)
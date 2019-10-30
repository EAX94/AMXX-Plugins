#if defined _ts_stocks_included
	#endinput
#endif

#define _ts_stocks_included

#define TSPWUP_OFS_KUNGFU ( 1<<16 )
#define TSPWUP_OFS_SUPERJUMP ( 1<<24 )

#include <amxmodx>
#include <amxmisc>
#include <fakemeta>
#include <tsconst>

#define OFFSET_CURPWUP 452
#define OFFSET_PWUP1 453
#define OFFSET_EXTRA 454
#define OFFSET_AMT1 455
#define OFFSET_AMT2 456
#define OFFSET_PWUP2 457
#define OFFSET_KUNGFU 462

#define TSW_CONTENDER 38
#define TSW_BERETTA TSW_UNK1

#define OFFSET_PWUP 27
#define OFFSET_TIMESTAMP 28

#define OFFSET_CONSECUTIVE_KILLS 460

#define OFFSET_JUMPS 325

stock ts_setpwup( id, pwup, amt = 0 )
{
	if ( pwup & TSPWUP_SLOWPAUSE )
	{
		set_pdata_int_ex( id, OFFSET_PWUP1, TSPWUP_SLOWPAUSE )
		set_pdata_int_ex( id, OFFSET_EXTRA, TSPWUP_NONE )
		set_pdata_int_ex( id, OFFSET_AMT1, amt )
		set_pdata_int_ex( id, OFFSET_AMT2, amt )
		set_pdata_int_ex( id, OFFSET_PWUP2, TSPWUP_SLOWPAUSE )
		
		engclient_cmd( id, "usepowerup" )
	}
	
	if ( pwup & ( TSPWUP_KUNGFU | TSPWUP_SUPERJUMP ) )
	{
		new sum = ( pwup & TSPWUP_KUNGFU ) ? TSPWUP_OFS_KUNGFU : 0
		sum |= ( pwup & TSPWUP_SUPERJUMP ) ? TSPWUP_OFS_SUPERJUMP : 0
		set_pdata_int_ex( id, OFFSET_KUNGFU, sum )
		
		message_begin( MSG_ONE, get_user_msgid( "PwUp" ), _, id )
		write_short( pwup & ( TSPWUP_KUNGFU | TSPWUP_SUPERJUMP ) )
		write_byte( 0 )
		message_end()
	}
	
	/*
	if ( pwup & TSPWUP_KUNGFU )
	{
		new ent = ts_createpwup( TSPWUP_KUNGFU )
		set_pev( ent, pev_effects, EF_NODRAW )
		ts_givepwup( id, ent )
	}
	
	if ( pwup & TSPWUP_SUPERJUMP )
	{
		new ent = ts_createpwup( TSPWUP_SUPERJUMP )
		set_pev( ent, pev_effects, EF_NODRAW )
		ts_givepwup( id, ent )
	}
	*/
		
	if ( !( pwup & ( TSPWUP_KUNGFU | TSPWUP_SUPERJUMP ) ) && get_pdata_int_ex( id, OFFSET_KUNGFU ) & ( TSPWUP_OFS_KUNGFU | TSPWUP_OFS_SUPERJUMP ) )
	{
		set_pdata_int_ex( id, OFFSET_KUNGFU, 0 )
		
		message_begin( MSG_ONE, get_user_msgid( "PwUp" ), _, id )
		write_short( 0 )
		write_byte( 0 )
		message_end()
	}
	
	if ( get_pdata_int_ex( id, OFFSET_CURPWUP ) & ( TSPWUP_SLOWPAUSE | TSPWUP_SLOWMO ) && !( pwup & ( TSPWUP_SLOWPAUSE | TSPWUP_SLOWMO ) ) )
		set_pdata_int_ex( id, OFFSET_EXTRA, TSPWUP_NONE )
	//else
		//set_pdata_int( id, OFFSET_CURPWUP + is_linux_server() * OFFSET_LINUX, pwup & ( TSPWUP_INFAMMO | TSPWUP_DFIRERATE ) )
	
	return 1
}

stock ts_resetjumps( id )
{
	return set_pdata_int_ex( id, OFFSET_JUMPS, 0 )
}

stock ts_setconsecutivekills( id, amt )
{
	return set_pdata_int_ex( id, OFFSET_CONSECUTIVE_KILLS, amt )
}

stock ts_getconsecutivekills( id )
{
	return get_pdata_int_ex( id, OFFSET_CONSECUTIVE_KILLS )
}

stock ts_setscoremode( id, mode )
{
	message_begin( MSG_ALL, get_user_msgid( "TSPAward" ) )
	write_byte( id )
	write_byte( mode )
	message_end() 
}

stock get_pdata_int_ex( id, offset )
{
	return get_pdata_int( id, offset )
}

stock set_pdata_int_ex( id, offset, amt )
{
	return set_pdata_int( id, offset, amt )
}

stock ts_createpwup( pwup )
{	
	new temp[24]
	format( temp, 23, "%d", pwup )
	
	new ent = engfunc( EngFunc_CreateNamedEntity, engfunc( EngFunc_AllocString, "ts_powerup" ) )
	DispatchKeyValue( ent, "pwuptype", temp )
	DispatchKeyValue( ent, "pwupduration", "60" )
	engfunc( EngFunc_SetSize, ent, Float:{ -16.0, -16.0, 0.0 }, Float: { 16.0, 16.0, 64.0 } )
	set_pev( ent, pev_solid, SOLID_TRIGGER )
	set_pev( ent, pev_movetype, MOVETYPE_TOSS )
	set_pev( ent, pev_frame, 1 )
	set_pev( ent, pev_renderamt, 255.0 )
	set_pev( ent, pev_renderfx, kRenderFxNoDissipation )
	//set_pev( ent, pev_nextthink, get_gametime() + 0.5 )
	set_pev( ent, pev_body, 6 )
	set_pev( ent, pev_watertype, -1 )
	dllfunc( DLLFunc_Spawn, ent )
	dllfunc( DLLFunc_Think, ent )

	//set_pdata_int_ex( ent, OFFSET_PWUP, pwup )
	
	return ent
}

stock ts_givepwup( id, pwupent )
{
	new Float:origin[3]
	pev( id, pev_origin, origin )
	origin[2] -= 16.0
	
	engfunc( EngFunc_SetOrigin, pwupent, origin )
	
	dllfunc( DLLFunc_Touch, id, pwupent )
	
	//set_pev( pwupent, pev_nextthink, get_gametime() + 0.5 )
	//set_pev( pwupent, pev_flags, FL_KILLME )
	//dllfunc( DLLFunc_Use, id, pwupent )
	
	//engfunc( EngFunc_RemoveEntity, pwupent )
}
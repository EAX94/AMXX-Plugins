
#if defined _rage_const_included
	#endinput
#endif
#define _rage_const_included

#if AMXX_VERSION_NUM >= 175
 #pragma reqlib rage
 #if !defined AMXMODX_NOAUTOLOAD
  #pragma loadlib rage
 #endif
#else
 #pragma library rage
#endif

const RageFunc:RageFuncInvalid = RageFunc:-1

enum RageHookPhase
{
	RageHookPre,
	RageHookPost
}

enum RageHookReturn
{
	RageHookIgnored,
	RageHookHandled,
	RageHookOverride,
	RageHookSupercede
}

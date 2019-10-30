#if defined _TSDYNATIVE_INCLUDE
	#endinput
#endif
#define _TSDYNATIVE_INCLUDE

enum Stunts
{
    ST_DIVE = 95,
    ST_DIVE_LEFT = 96,
    ST_DIVE_RIGHT = 97,
    ST_BACKFLIP = 149,
    ST_FRONTFLIP = 152
};

// Forwards
forward TS_Stunt(id,Stunts:Type);

// VictimID returns 0 if they didn't hit anybody
forward TS_Attack(id,VictimID,Float:Damage,Attacks:Type);

// Called when there "KungFu Power Bar" changes
// return PLUGIN_HANDLED
forward TS_KFuPower(id,PowerLost);
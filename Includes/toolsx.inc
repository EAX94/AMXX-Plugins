/*
     Tools X v0.1
     Copyright (c) SAMURAI
     
*/


#if !defined _fakemeta_included
	#include <fakemeta>
#endif

#if defined toolsx_included
	#endinput
#endif
#define toolsx_included


#define FFADE_IN   	0x0000  
#define FFADE_OUT  	0x0001     
#define FFADE_MODULATE 	0x0002 
#define FFADE_STAYOUT 	0x0004 


stock bool:is_aiming_at_hostage(index)
{
	new target, temp, classname[32];
	
	get_user_aiming(index, target, temp);
	
	pev(target, pev_classname, classname, 31);
	
	if ( equal(classname, "hostage_entity") ) 
		return true;
		
	return false;
}

	
stock bool:is_aiming_at_sky(index)
{
	new target, temp;

	get_user_aiming(index,target,temp);
	
	if( engfunc(EngFunc_PointContents,target) == CONTENTS_SKY)
		return true;
		
	return false;
}


stock bool:is_aiming_at_water(index)
{
	new target, temp;

	get_user_aiming(index,target,temp);
	
	if( engfunc(EngFunc_PointContents,target) == CONTENTS_WATER)
		return true;
		
	return false;
}


stock bool:is_nothing_above_index(index)
{
	new Float:origin[1], Float:origin[2]
	origin2 = origin1;

	pev(index,pev_origin,origin1);
	
	
	new ptr;
	engfunc(EngFunc_TraceLine,origin1,origin2,IGNORE_MONSTERS,index,ptr);

	new Float:flFraction;
	get_tr2(ptr,TR_flFraction,flFraction);
	
	if(flFraction == 1.0)
		return true;
		
	return false;
	
}
	

stock bool:is_nothing_solid_abv_index(index)
{
	new Float:origin[1], Float:origin[2]
	pev(index,pev_origin,origin1);
	
	origin2 = origin1;
	
	new ptr;
	engfunc(EngFunc_TraceLine,origin1,origin2,IGNORE_MONSTERS,index,ptr);

	new hit = get_tr2(ptr,TR_pHit);
	
	if(hit > 0 && pev_valid(hit))
	{
		new classname[6];
		pev(hit,pev_classname,classname,5);

		
		if(!equal(classname,"func_"))
			return true;
	}
	
		
	return false;
	
}	

/* ==================================
tlx_distance_to_sky
is fm_distance_to_floor stock from 
fakemeta util with changed dest.z 
value
===================================*/
stock Float:tlx_distance_to_sky(id) 
{
	new Float:origin_start[3],  Float:origin_end[3];
	pev(id, pev_origin, origin_start);
	
	new Float:f_dest[3];
	
	f_dest[0] = origin_start[0];
	f_dest[1] = origin_start[1];
	f_dest[2] = 8191.0;

	engfunc(EngFunc_TraceLine, origin_start, f_dest, IGNORE_MONSTERS, id, 0);
	get_tr2(0, TR_vecEndPos, origin_end);

	pev(id, pev_absmin, origin_start);
	new Float:ret = origin_start[2] - origin_end[2];

	return ret > 0 ? ret : 0.0;
}


/*
//=====================================================================================================================
    tlx_create_explosion

 Example usage : tlx_create_explosion(origin, MSG_BROADCAST, SVC_TEMPENTITY, sprite index, 20, 40, 2)

      // for desType are available:
	MSG_BROADCAST // Unreliable to all
	MSG_ONE       // Reliable to one (msg_entity)
	MSG_ALL       // Reliable to all
	MSG_INIT     // Write to the init string
	MSG_PVS      // Ents in PVS of org
	MSG_PAS     // Ents in PAS of org
	MSG_PVS_R   // Reliable to PVS
	MSG_PAS_R    // Reliable to PAS
	MSG_ONE_UNRELIABLE // Send to one client, but don't put in reliable stream, put in unreliable datagram (could be dropped)
	MSG_SPEC    // Sends to all spectator proxies
 
      For msgType are available:
	 SVC_TEMPENTITY              23
	 SVC_INTERMISSION            30
	 SVC_CDTRACK                 32
	 SVC_WEAPONANIM              35
	 SVC_ROOMTYPE                37
	 SVC_ADDANGLE                38       // [vec3] add this angle to the view angle
	 SVC_NEWUSERMSG              39
	 SVC_HLTV                    50


========================================================================================================================*/
stock tlx_create_explosion(Float:origin[3], destType, msgType, sprite, scale, framerate, flags )
{
      
	
	message_begin(destType, msgType); 
	write_byte(TE_EXPLOSION); 
	write_coord(floatround(origin[0])); 
	write_coord(floatround(origin[1])); 
	write_coord(floatround(origin[2])); 
	write_short(sprite);
	write_byte(scale); 
	write_byte(framerate); 
	write_byte(flags); 
	message_end(); 

}



stock fade_units_to_seconds(num)
{
	return ((1<<12) * (num));
}



/*========================================================================================================================= 
	tlx_flash_player
	
	Ex to use:
	
	tlx_flash_player(id, MSG_ONE, 3, 5, FADE_OUT, 255, 0, 255, 200)

	// for desType are available:
	MSG_BROADCAST // Unreliable to all
	MSG_ONE       // Reliable to one (msg_entity)
	MSG_ALL       // Reliable to all
	MSG_INIT     // Write to the init string
	MSG_PVS      // Ents in PVS of org
	MSG_PAS     // Ents in PAS of org
	MSG_PVS_R   // Reliable to PVS
	MSG_PAS_R    // Reliable to PAS
	MSG_ONE_UNRELIABLE // Send to one client, but don't put in reliable stream, put in unreliable datagram (could be dropped)
	MSG_SPEC    // Sends to all spectator proxies
 
	
	 For flags you can use:	
	FFADE_IN   	Just here so we don't pass 0 into the function
	FFADE_OUT  	Fade out (not in)
	FFADE_MODULATE  Modulate (don't blend)
	FFADE_STAYOUT   Ignores the duration, stays faded out until new ScreenFade message received

===========================================================================================================================*/
stock tlx_flash_player(index, destType, iDuration, iHoldTime, iFlags, r, g, b, alpha)
{
	
	if(!is_user_alive(index))
		return 0;
		
	
	message_begin( destType,get_user_msgid("ScreenFade"), {0,0,0}, index );
	write_short(fade_units_to_seconds(iDuration));
	write_short(fade_units_to_seconds(iHoldTime));
	write_short(iFlags);
	write_short(r);
	write_short(g);
	write_short(b);
	write_byte(alpha);	
	message_end();
	
	return 1;
	

}


/*========================================================================================================================
	shake_player_screen


	 ex to use:
	shake_player_screen(id, MSG_ONE, 20, 5, 6)

	// for desType are available:
	MSG_BROADCAST // Unreliable to all
	MSG_ONE       // Reliable to one (msg_entity)
	MSG_ALL       // Reliable to all
	MSG_INIT     // Write to the init string
	MSG_PVS      // Ents in PVS of org
	MSG_PAS     // Ents in PAS of org
	MSG_PVS_R   // Reliable to PVS
	MSG_PAS_R    // Reliable to PAS
	MSG_ONE_UNRELIABLE // Send to one client, but don't put in reliable stream, put in unreliable datagram (could be dropped)
	MSG_SPEC    // Sends to all spectator proxies
	
===================================================================================================================*/
stock shake_player_screen(index, destType, iAmplitude, iDuration, iFrequency)
{

	
	if(!is_user_alive(index))
		return 0;
	
	message_begin( destType,get_user_msgid("ScreenShake"), {0,0,0}, index );
	
	write_short(fade_units_to_seconds(iAmplitude));
	write_short(fade_units_to_seconds(iDuration));
	write_short(fade_units_to_seconds(iFrequency));
	
	message_end();
	
	return 1;
	
}
	

	
stock tlx_VectorInverse(Float:vector[3])
{	
	vector[0] *= -1
	
	vector[1] *= -1
	
	vector[2] *= -1
}
	
	
stock tlx_VectorScale(const Float:in[3], Float:scale, Float:out[3])
{
	
	out[0] = in[0] * scale;
	
	out[1] = in[1] * scale;
	
	out[2] = in[2] * scale;
	
}



stock Float:tlx_VectorNormalize(Float:vector[3])
{
	
	new Float:length, Float:ilength;

	length = vector[0] * vector[0] + vector[1] * vector[1] + vector[2] * vector[2];
	length = floatsqroot(length);		

	if (length)
	{
		ilength = 1 / length;
		vector[0] *= ilength;
		vector[1] *= ilength;
		vector[2] *= ilength;
	}
		
	return length;

}


stock tlx_VectorMA(Float:vecA[3], Float:scale, Float:vecB[3], Float:vecC[3])
{
	
	vecC[0] = vecA[0] + scale * vecB[0];
	
	vecC[1] = vecA[1] + scale * vecB[1];
	
	vecC[2] = vecA[2] + scale * vecB[2];
	
}




/*======================================================================
HUD_GetHullBounds
 Engine calls this to enumerate player collision hulls, for prediction.  
Return 0 if the hullnumber doesn't exist.
==================================================================== */
stock tlx_GetHullBounds(hullnumber, Float:mins[3], Float:maxs[3] )
{
	new iret = 0;

	switch ( hullnumber )
	{
		case 0:		
		{
			// normal
			mins = Float:{-16.0, -16.0, -36.0 }	
			maxs = Float:{ 16.0,  16.0,  36.0 }
			iret = 1;
		}
					
		
		case 1:	
		{	
			// Crouched player
			mins = Float:{-16.0, -16.0, -18.0 }	
			maxs = Float:{ 16.0,  16.0,  18.0 }
			iret = 1;
		}
				
	
		case 2:	
		{
			// Point base hull
			mins = Float:{0.0, 0.0, 0.0 }	
			maxs = Float:{0.0, 0.0, 0.0 }
			iret = 1;
		}
				
		
	}
	
	return iret;
}


stock Float:tlx_fvectorProduct(Float:Vec1[3],Float:Vec2[3])
{
	return Vec1[0]*Vec2[0]+Vec1[1]*Vec2[1]+Vec1[2]*Vec2[2];
}
	
	
	
stock tlx_vectorProduct(Vec1[3], Vec2[3])
{
	return Vec1[0]*Vec2[0]+Vec1[1]*Vec2[1]+Vec1[2]*Vec2[2];
}



/*
=================
tlx_VectorAvg
stock by Emp`
=================
*/
stock tlx_VectorAvg( a[], num )
{
	new sum = 0;
	for(new i = 0; i<num; i++)
		sum += a[i]
		
	return ( sum / num );
} 


/*
=================
EV_IsPlayer

Is the entity's index in the player range?
=================
*/
stock bool:tlx_EV_IsPlayer(index)
{
	if( index >= 1 && index <= get_maxplayers() )
		return true;
		
	return false;
}
	
	

/*====================================
VectorCompare

====================================*/
stock tlx_VectorCompare(const Float:v1[3], const Float:v2[3])
{
	new i;
	
	for (i=0 ; i<3 ; i++)
		if (v1[i] != v2[i])
			return 0;
			
	return 1;
}



stock Float:tlx_VectorClear(Float:a[3])
{
	 a[0] = 0.0;
	 a[1] = 0.0;
	 a[2] = 0.0;
	 
	 return a;
}



/*
==============================
CrossProduct

==============================
*/
stock tlx_CrossProduct(const Float:v1[3], const Float:v2[3], Float:cross[3])
{
	cross[0] = v1[1] * v2[2] - v1[2] * v2[1];
	
	cross[1] = v1[2] * v2[0] - v1[0] * v2[2];
	
	cross[2] = v1[0] * v2[1] - v1[1] * v2[0];
}




/*
==================================
ConcatTransforms
 
==================================
*/
stock tlx_ConcatTransforms(Float:in1[3][4], Float:in2[3][4], Float:out[3][4])
{
	out[0][0] = in1[0][0] * in2[0][0] + in1[0][1] * in2[1][0] +
				in1[0][2] * in2[2][0];
				
	out[0][1] = in1[0][0] * in2[0][1] + in1[0][1] * in2[1][1] +
				in1[0][2] * in2[2][1];
				
	out[0][2] = in1[0][0] * in2[0][2] + in1[0][1] * in2[1][2] +
				in1[0][2] * in2[2][2];
				
	out[0][3] = in1[0][0] * in2[0][3] + in1[0][1] * in2[1][3] +
				in1[0][2] * in2[2][3] + in1[0][3];
				
	out[1][0] = in1[1][0] * in2[0][0] + in1[1][1] * in2[1][0] +
				in1[1][2] * in2[2][0];
				
	out[1][1] = in1[1][0] * in2[0][1] + in1[1][1] * in2[1][1] +
				in1[1][2] * in2[2][1];
				
	out[1][2] = in1[1][0] * in2[0][2] + in1[1][1] * in2[1][2] +
				in1[1][2] * in2[2][2];
				
	out[1][3] = in1[1][0] * in2[0][3] + in1[1][1] * in2[1][3] +
				in1[1][2] * in2[2][3] + in1[1][3];
				
	out[2][0] = in1[2][0] * in2[0][0] + in1[2][1] * in2[1][0] +
				in1[2][2] * in2[2][0];
				
	out[2][1] = in1[2][0] * in2[0][1] + in1[2][1] * in2[1][1] +
				in1[2][2] * in2[2][1];
				
	out[2][2] = in1[2][0] * in2[0][2] + in1[2][1] * in2[1][2] +
				in1[2][2] * in2[2][2];
				
	out[2][3] = in1[2][0] * in2[0][3] + in1[2][1] * in2[1][3] +
				in1[2][2] * in2[2][3] + in1[2][3];
}



stock tlx_AddVectors(Float:vec1[3] ,Float:vec2[3], Float:ret[3])
{
	ret = vec1;
	
	ret[0] += vec2[0];
	
	ret[1] += vec2[1];
	
	ret[2] += vec2[2];
}


stock tlx_SubtractVectors(Float:vec1[3], Float:vec2[3], Float:ret[3])
{ 
	ret = vec1;
	
	ret[0] -= vec2[0];
	
	ret[1] -= vec2[1];
	
	ret[2] -= vec2[2];
}


stock Float:tlx_AngleDiff(Float:destAngle, Float:srcAngle )
{
	new Float:delta;

	delta = destAngle - srcAngle;
	
	if ( destAngle > srcAngle )
	{
		if ( delta >= 180 )
			delta -= 360;
	}
	
	else
	{
		if ( delta <= -180 )
			delta += 360;
	}
	
	return delta;
}



//=========================================================
 // StudioFrameAdvance - advance the animation frame up to the current time
 // if an flInterval is passed in, only advance animation that number of seconds
// by Avalanche
 //=========================================================
stock Float:tlx_StudioFrameAdvance(ent,Float:flInterval)
{
	new Float:time = get_gametime(), Float:animtime;
	pev(ent,pev_animtime,animtime);

	if(flInterval == 0.0)
	{
		flInterval = (time - animtime);
		if(flInterval <= 0.001)
		{
			set_pev(ent,pev_animtime,time);
			return 0.0;
		}
	}
	if(!animtime)
		flInterval = 0.0;


	new Float:framerate, Float:frame;
	pev(ent,pev_framerate,framerate);
	pev(ent,pev_frame,frame);

	frame += flInterval * 15.0 * framerate; // *m_flFrameRate = 15.0
	set_pev(ent,pev_frame,frame);
	set_pev(ent,pev_animtime,time);

	if(frame < 0.0 || frame >= 256.0) 
	{
		new m_fSequenceLoops = 1; // HACK
		if(m_fSequenceLoops)
			set_pev(ent,pev_frame,frame - (float(floatround(frame / 256.0)) * 256.0));
		else
			set_pev(ent,pev_frame,(frame < 0.0) ? 0.0 : 255.0);
		set_pev(ent,pev_iuser3); // just in case it wasn't caught in GetEvents
	}

	return flInterval;
}



//  tlx_EntitiesInBox
//  collect entities in a box
//  by Avalanche
stock tlx_EntitiesInBox(pList[],listMax,Float:mins[3],Float:maxs[3],flagMask)
{
	new count = 0;
	new maxEntities = global_get(glb_maxEntities);

	static Float:absmax[3], Float:absmin[3];

	new i;
	for(i=1;i<maxEntities;i++)
	{
		if(!pev_valid(i)) // Not in use
			continue;
		
		if(flagMask && !(pev(i,pev_flags) & flagMask) ) // Does it meet the criteria?
			continue;

		pev(i,pev_absmax,absmax);
		pev(i,pev_absmin,absmin);

		if(mins[0] > absmax[0] ||
			 mins[1] > absmax[1] ||
			 mins[2] > absmax[2] ||
			 maxs[0] < absmin[0] ||
			 maxs[1] < absmin[1] ||
			 maxs[2] < absmin[2] )
			 continue;

		pList[count++] = i;

		if(count >= listMax)
			return count;
	}

	return count;
}



stock tlx_MonstersInSphere(pList[], listMax, Float:center[3], Float:radius)
{
	new maxEntities = global_get(glb_maxEntities);
	
	new count = 0;
	new i = 1;
	
	new Float:radiusSquared = radius * radius;
	new Float:distance, Float:delta;
	
	for(i = 1; i < maxEntities; i++)
	{
		if ( !pev_valid(i) )	// Not in use
			continue;
		
		if ( !(pev(i,pev_flags & (FL_CLIENT|FL_MONSTER))))	// Not a client/monster ?
			continue;

		// Use origin for X & Y since they are centered for all monsters
		// Now X
		new x_origin[3];
		pev(i,pev_origin,x_origin);
		
		delta = center[0] - x_origin[0]; 
		delta *= delta;

		if ( delta > radiusSquared )
			continue;
			
		distance = delta;
		
		// Now Y
		delta = center[1] - x_origin[1]; 
		delta *= delta;

		distance += delta;
		
		if ( distance > radiusSquared )
			continue;

		// Now Z
		new Float:absmin[3], Float:absmax[3];
		pev(i,pev_absmin,absmin);
		pev(i,pev_absmax,absmax);
		
		delta = center[2] - (absmin[2] + absmax[2]) * 0.5;
		delta *= delta;

		distance += delta;
		if ( distance > radiusSquared )
			continue;

		
		pList[count++] = i;
		
		if ( count >= listMax )
			return count;
	}


	return count;
}


stock Float:tlx_Approach(Float:target, Float:value, Float:speed)
{
	new Float:delta = target - value;

	if ( delta > speed )
		value += speed;
		
	else if ( delta < -speed )
		value -= speed;
		
	else 
		value = target;

	return value;
}



stock Float:tlx_AngleDistance(Float:next, Float:cur)
{
	new Float:delta = next - cur;

	if ( delta < -180 )
		delta += 360;
		
	else if ( delta > 180 )
		delta -= 360;

	return delta;
}



stock Float:tlx_SplineFraction(Float:value, Float:scale)
{
	value = scale * value;
	
	new Float:valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}


//=========================================================
// func_ladder - makes an area vertically negotiable
//=========================================================
stock tlx_CLadder(ent)
{
	if(!pev_valid(ent))
		return 0;
	
	set_pev(ent,pev_solid,SOLID_NOT);
	set_pev(ent,pev_skin,CONTENTS_LADDER);
	
	static tlx_pfloat_poin;
	
	if(!tlx_pfloat_poin)
		tlx_pfloat_poin = get_cvar_pointer("showtriggers");
	
	if(get_pcvar_float(tlx_pfloat_poin) == 0)
	{
		set_pev(ent,pev_rendermode,kRenderTransTexture);
		set_pev(ent,pev_renderamt,0);
	}
	
	
	// pev->effects &= ~EF_NODRAW;
	set_pev(ent,pev_effects, ~EF_NODRAW);
	
	return 1;
}



// =========================================================
// STOCK by Wilson 29 ID / P34nut
// returns 1 if the two vectors are equal
// it traces a line and returns 1 if it is a clear 
// returns 0 if there is something in the way
// =========================================================
stock tlx_clear_path( id, Float:fDist, Float:fZOffset ) 
{
    
	new Float:fStartOrigin[3], Float:fAngle[3], Float:fSize[3];
	pev(id, pev_origin, fStartOrigin);
	pev(id, pev_v_angle, fAngle);
	pev(id, pev_size, fSize);
	
	// Adjust for Z Offset
	fStartOrigin[2] += fZOffset;
    
	new Float:fEndOrigin[3];
	fEndOrigin[0] = fStartOrigin[0] + floatcos(fAngle[1], degrees) * (fDist + fSize[0]);
	fEndOrigin[1] = fStartOrigin[1] + floatsin(fAngle[1], degrees) * (fDist + fSize[1]);
	fEndOrigin[2] = (fStartOrigin[2] - floatsin(fAngle[0], degrees) * (fDist + fSize[2])) + 5;
	
	new Float:fStop[3];
    
	fm_trace_line( id, fStartOrigin, fEndOrigin, fStop );
    
	return tlx_VectorCompare(fEndOrigin, fStop);
} 



// fm_trace_line from Fakemeta Util by VEN
// required for tlx_clear_path
stock fm_trace_line(ignoreent, const Float:start[3], const Float:end[3], Float:ret[3]) 
{
	engfunc(EngFunc_TraceLine, start, end, ignoreent == -1 ? 1 : 0, ignoreent, 0)

	new ent = get_tr2(0, TR_pHit)
	get_tr2(0, TR_vecEndPos, ret)

	return pev_valid(ent) ? ent : 0
}





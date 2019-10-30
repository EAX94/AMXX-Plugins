/*-------------------------------------------------------------------------------------------------*

		[ Zombie Plague Plugin Addon: Counter-Strike Online In-Game Theme ]
			
				[ Main Plugin Natives Version 5.3 ]
					
					[ By jc980 ]
					
		Description:
		
			- Adds Countdown And Warning Sounds And Round Start Sounds
			And Ambience Sounds Kill Effects. And A New Respawn System,
			When You Kill A Zombie, You Have A Head Shot On Him To Stop
			Respawning. When Last Human, You Are ONE HIT. Also The Level
			System Can Help Humans And Zombies Become Invincible. Evolutions
			Adds Health And Armor. While Damage Fire Power Lesses Recoil And
			Adds More Damage Per Level.
		
		Changelog:
		
			- 0.1 - Countdown Added
			- 0.2 - Sounds Added
			- 0.3 - Warning Added
			- 0.4 - Infection Warning Added
			- 0.5 - Round Start Music Added
			- 0.6 - Ambience Sound Added
			- 0.7 - ZP Round Start Warning Added
			- 0.8 - Fixed Problem At zp_user_infected_post
			- 0.9 - Optimization
			- 1.0 - Tested Plugin
			- 1.1 - Countdown Fix
			- 1.2 - Sound Fix
			- 1.3 - Re-Optimization
			- 1.4 - Emit Sound Fix
			- 1.5 - Re-Optimization
			- 1.6 - Added NVault
			- 1.7 - Points And Kills
			- 1.8 - Countdown Sound Re-Fix
			- 1.9 - Kill Streaks
			- 2.0 - Fixed Kill Streak On Infect
			- 2.1 - Changed Nick To IP Save Method
			- 2.2 - Fixed Double Kill Sound
			- 2.3 - Added Limited Time Before Kill Streak Disappears
			- 2.4 - HUD Problem Fixed
			- 2.5 - Kill Type Problem Fixed
			- 2.6 - Changed Fix Emit_Sound With Speak
			- 2.7 - Re-Optimization
			- 2.8 - Countdown Runtime Error Fix
			- 2.9 - added Scoreboard
			- 3.0 - Re-Optimization
			- 3.1 - Changed All Emit_Sound To Speak
			- 3.2 - Added Respawn System
			- 3.3 - Added Respawn Sprite
			- 3.4 - Re-Optimization
			- 3.5 - Added Last Human Insta-Kill
			- 3.6 - Re-Made Respawn System
			- 3.7 - Fixed Messages
			- 3.8 - Fixed CZ Bot Problem
			- 3.9 - Fixed Attacker == Victim Problem
			- 4.0 - Re-Optimization
			- 4.1 - Added Human Level
			- 4.2 - Recoil Gets Lower Per Level
			- 4.3 - Added Evolution
			- 4.4 - ZB HP Gets Higher Per Level
			- 4.5 - ZB Armor Gets Higher Per Level
			- 4.6 - Added Effects
			- 4.7 - Fixed HUD Message
			- 4.8 - Changed Code Arrangement
			- 4.9 - HUD Bug Fixed
			- 5.0 - Re-Optimization
			- 5.1 - Added Natives
			- 5.2 - Change Funcs
			- 5.3 - Re-Optimization
			- 5.4 - Added Fowards
			- 5.5 - Re-Optimization
			
		Coming Updates:
		
			- Supply Box Drop
			- Speed Run Extra Item
			- x1.5 Ammo Extra Item
			- Hammer Extra Item
			- x30% Damage Recoil Level Extra Item
			- x5 Damage To Zombies Extra Item
			- Zombie Regeneration
			- Something Else Thats Cool

*-------------------------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------------------*
 [ ZP CSO Plugin If Included ]
*------------------------------------------------------------------------------------------*/

#if defined _zp_cso_theme_included
  #endinput
#endif
#define _zp_cso_theme_included

/*------------------------------------------------------------------------------------------*
 [ ZP CSO Plugin Natives ]
*------------------------------------------------------------------------------------------*/

/*---------------------------------------------*
 [ ZP CSO Plugin Natives: Get Evo Health ]
*---------------------------------------------*/ 

native zp_cso_theme_evohp(id)

/*---------------------------------------------*
 [ ZP CSO Plugin Natives: Get Evo Armor ]
*---------------------------------------------*/ 

native zp_cso_theme_evo_armor(id)

/*------------------------------------------------------------------------------------------*
 [ ZP CSO Plugin Fowards ]
*------------------------------------------------------------------------------------------*/

/*---------------------------------------------*
 [ ZP CSO Plugin Fowards: Evolution Health ]
*---------------------------------------------*/ 

forward zp_cso_theme_evohp_lvlup(iInfector, iEvoHp)

/*------------------------------------------------------------------------------------------*
 [ Parameter 1 - Infector | Parameter 2 - Infector's Additional Evolution Health ]
*------------------------------------------------------------------------------------------*/

/*---------------------------------------------*
 [ ZP CSO Plugin Fowards: Evolution Armor ]
*---------------------------------------------*/ 

forward zp_cso_theme_evo_armor_lvlup(iInfector, iEvoArmor)

/*------------------------------------------------------------------------------------------*
 [ Parameter 1 - Infector | Parameter 2 - Infector's Additional Evolution Armor ]
*------------------------------------------------------------------------------------------*/
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1034\\ f0\\ fs16 \n\\ par }
*/

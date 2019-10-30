#pragma reqlib "ffac_sys"
/**********************
Include file for FFAC 2.3

please visit http://82.232.102.55/FFAC 


***********************/

/*************************************************
Register a plugin in ffac
Now ... this do nothing ... but it'll be usefull for plugin autoupdate, ... :)
**************************************************/
native ffac_register_plugin(const plugin_name[], const version[], const author[])

/*************************************************
//return the ffac id of the server
**************************************************/
native ffac_get_server_id()

/*************************************************
//return is if the player is authentified on ffac server 
// 0 = no auth, 1 = auth, 2 = under auth
Banned player can't get an autentification
**************************************************/
native ffac_is_player_auth(id)

/*************************************************
//return a player skill
//please note the skill is retrieve about 1 second after the player connection !
**************************************************/
native ffac_get_skill(id)


/*************************************************************************
**************************************************************************
**************************************************************************
FFAC MSN BOT RULES ! PLEASE READ !
First, this is free, please don't abuse !

The bot may be slow ... It's normal and I've no enought time to check the problem ...

How to add a contact ?
-Send a message, the bot will drop the message and add the contact in the contact list

How ti remove a contact ?
-You can't

How to get the contact list ?
-You can't

How to send a message to several contact ?
-"contact@msn.com;tt@msn.com;dfsff@msn.com"
**************************************************************************
**************************************************************************
**************************************************************************/

/*************************************************
// Send a message to someone on msn throught the ffac bot !
Please note the msn contact is defined with the cvar "ffac_msn_contact" in ffac plugin.
**************************************************/
native ffac_msn_message2admin(msg[128])

/*************************************************
// Send a message to someone on msn throught the ffac bot !
Please note the msn contact is defined with the cvar "ffac_msn_contact" in ffac plugin.

This is the function of the ffac 1.x plugin which display the ident and a nickname
**************************************************/
native ffac_msn_message2admin2(msg[128],ident[32],nickname[32])

/*************************************************
Send a message to a specific contact ! Please send to only ONE CONTACT a the same time
Please don't abuse of this function ... 
**************************************************/
native ffac_msn_message(msg[128],msncontact[128])

/*************************************************************************
**************************************************************************
**************************************************************************
FFAC AIM BOT RULES ! PLEASE READ !
First, this is free, please don't abuse !

The bot may be slow ... It's normal and I've no enought time to check the problem ...

How to add a contact ?
-Send a message, the bot will drop the message and add the contact in the contact list

How ti remove a contact ?
-You can't

How to get the contact list ?
-You can't

How to send a message to several contact ?
-"buddyname;buddyname2"
**************************************************************************
**************************************************************************
**************************************************************************/

/*************************************************
// Send a message to someone on msn throught the ffac bot !
Please note the msn contact is defined with the cvar "ffac_msn_contact" in ffac plugin.
**************************************************/
native ffac_aim_message2admin(msg[128])

/*************************************************
// Send a message to someone on msn throught the ffac bot !
Please note the msn contact is defined with the cvar "ffac_msn_contact" in ffac plugin.

This is the function of the ffac 1.x plugin which display the ident and a nickname
**************************************************/
native ffac_aim_message2admin2(msg[128],ident[32],nickname[32])

/*************************************************
Send a message to a specific contact ! Please send to only ONE CONTACT a the same time
Please don't abuse of this function ... 
**************************************************/
native ffac_aim_message(msg[128],msncontact[64])


/*************************************************************************
**************************************************************************
**************************************************************************
FFAC ICQ BOT RULES ! PLEASE READ !
First, this is free, please don't abuse !

The bot may be slow ... It's normal and I've no enought time to check the problem ...

How to add a contact ?
-Send a message, the bot will drop the message and add the contact in the contact list

How ti remove a contact ?
-You can't

How to get the contact list ?
-You can't

How to send a message to several contact ?
-"buddyname;buddyname2"
**************************************************************************
**************************************************************************
**************************************************************************/

/*************************************************
// Send a message to someone on msn throught the ffac bot !
Please note the msn contact is defined with the cvar "ffac_msn_contact" in ffac plugin.
**************************************************/
native ffac_icq_message2admin(msg[128])

/*************************************************
// Send a message to someone on msn throught the ffac bot !
Please note the msn contact is defined with the cvar "ffac_msn_contact" in ffac plugin.

This is the function of the ffac 1.x plugin which display the ident and a nickname
**************************************************/
native ffac_icq_message2admin2(msg[128],ident[32],nickname[32])

/*************************************************
Send a message to a specific contact ! Please send to only ONE CONTACT a the same time
Please don't abuse of this function ... 
**************************************************/
native ffac_icq_message(msg[128],msncontact[64])


/*************************************************************************
**************************************************************************
**************************************************************************
FFAC PACKAGE MANAGER & MAP DOWNLOADER RULES ! PLEASE READ !
First, this is free, please don't abuse !

The speed of the transfer depends on my bandwith and the latency between me and you (pj) 

Map download :
Just allow to download maps from ffac server to your server ( no support for maps with .wad, ... )
If you want add maps to ffac map server, please go to http://82.232.102.55/FFAC and post on the forum

Package Manager :
Allow to make package like dpkg on linux ... 
To add a new package please post on the ffac forum ( http://82.232.102.55/FFAC )

A package is a plugin.hpt , remove_plugin.hpt file and other packages files

A package can be
************
[INFO] 
sanksound: SankSound plugin and sounds   //description for the package installer menu
[Version]
1.7	// required version of amxmodx ( here it's 1.7x )
[MkDir]
../../sound/misc	//create a directory, may don't work on certain servers ...
[Download]
configs/hpt/remove_sanksound.hpt	//download the remove package file
[Download]
../../sound/misc/godlike.wav	//download a new sound
...
[Download]
../../sound/misc/ultrakill.wav
[Install]		
plugins/ultimate_sounds.amxx	//download the plugin
ultimate_sounds.amxx	//add the plugin line in plugins.ini
*************

A package remover can be
**************
[Version]
1.7
[UnInstall]
plugins/ultimate_sounds.amxx
ultimate_sounds.amxx
***************

A package installer, for what ?
-Make plugin autoinstaller : for example, make maps installer menu for plugin like soccer jam.
-Autoupdate your plugin
-...



**************************************************************************
**************************************************************************
**************************************************************************/

/*************************************************
Download and install a package
**************************************************/
native ffac_install_package(mapname[32])
/*************************************************
Remove an installed package
**************************************************/
native ffac_remove_package(mapname[32])
/*************************************************
Download a map ( please note, that don't install other map ressources, like .wad or sounds ...)
If you have a map with some other thing, please use the package manager
**************************************************/
native ffac_download_map(packagename[16])



/*************************************************************************
**************************************************************************
**************************************************************************
Other misc functions

First, this is free, please don't abuse !
*************************************************************************
**************************************************************************
**************************************************************************/

/*************************************************
log a sentence. A player can see all his logged sentences on your account on the ffac website.
**************************************************/
native ffac_log_sentence(id,sentence[96])



/**************************************************************************
DBSYS Beta
***************************************************************************/

native ffac_register_gvar(gvarname[])
native ffac_get_gvar_int(gvarid,playerid)
native ffac_set_gvar_int(gvarid,playerid,gvarval)
/**************************************************************************
***************************************************************************/
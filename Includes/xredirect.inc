#if defined _xredirect
  #endinput
#endif
#define _xredirect

native redirect(id, nServer, bCanDrop);
/*
id = index of player to be redirected
 nServer = server number to redirect to - can be -1 for random/next server in list (depends on settings)
 bCanDrop = drop user if no valid target server was found?
*/

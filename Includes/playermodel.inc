#if defined _playermodel_included
  #endinput
#endif
#define _playermodel_included

#pragma reqlib playermodel

#if !defined AMXMODX_NOAUTOLOAD
	#pragma loadlib playermodel
#endif

native fm_set_user_model(index, model[])
native fm_reset_user_model(index)
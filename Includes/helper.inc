#if defined HELPER_INC
  #endinput
#endif
#define HELPER_INC

/*
Every plugin the helper is supposed to show something for has to implement this
forward. This forward is called when the client chose the appropriate plugin via the
menu. The client's ID is passed for better customization.
Return PLUGIN_HANDLED if you don't want to show any help at all
*/
forward client_help(id);

/*
This forward will be called with a little delay after roundstart to inform
clients about plugin that alter the gameplay. Only its presence is required to
add the plugin's name to the list. If you return PLUGIN_HANDLED inside this
forward it'll act as if it didn't exist. (For example: This allows advertising only for clients
in the marine team.)
*/
forward client_advertise(id);

/*
Add multiple help_add's (ONLY!) in the client_help forward to extend the help
caption:string (32 chars)
content:string (255 chars)
*/
stock bool:help_add(caption[],content[]){
  new plugin = is_plugin_loaded("Helper")
  if(plugin == -1){
    return false
  }
  new func = get_func_id("help_add",plugin)
  if(func == -1){
    return false
  }
  if(callfunc_begin_i(func,plugin) != 1){
    return false
  }
  callfunc_push_str(caption)
  callfunc_push_str(content)
  return callfunc_end()?true:false
}

/*
Use this stock to check if the helper plugin is actually loaded
*/
stock bool:helper_loaded(){
  return is_plugin_loaded("Helper")==-1?false:true
}

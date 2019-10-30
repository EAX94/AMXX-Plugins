#if defined _chatcolor_included
  #endinput
#endif
#define _chatcolor_included

#pragma reqlib chatcolor

/* ColorChat Support */
/* Replace in .sma line #include <colorchat> with #include <chatcolor> */
#define NORMAL DontChange
#define GREEN DontChange
#define TEAM_COLOR DontChange
#define RED Red
#define BLUE Blue
#define GREY Grey
#define ColorChat client_print_color
/* ColorChat Support */

enum _:Colors {
	DontChange,
	Red,
	Blue,
	Grey
}

native client_print_color(id, iColor=DontChange, const szMsg[], any:...);
native register_dictionary_colored(const filename[]);
#pragma reqlib "http_sys"


/*
Http server lib by hackziner
hackziner@gmail.com
*/


//send the text of a page in function "http page"
//the max size is 1024 to send text is 1024 and the page max size is 20480
native http_send_text(const msg[], ...)


//function called when someone try to open a page on the server
forward http_page(requestedfile[128])
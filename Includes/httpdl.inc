/**

 *

 *   (c)2007, Bentski

 *   Homepage: http://kzlt.bentski.lt/

 *   Server: cs.bentski.lt:27015

 *

 *   HTTP downloader. Allows to download files from the web.

 *

 */



#if defined _httpdl_included

  #endinput

#endif

#define _httpdl_included



#pragma library httpdl



#define MAX_DOWNLOADS 32

#define DOWNLOAD_TIMEOUT_IN_MS 10 // 1sec = 10

#define DOWNLOAD_SPEED_IN_MS 104857 // 1024 = 10kb/s



/* Forwards */



// Called when download is finished

// * id   - download id

// * file - path + filename of downloaded file

forward dlcomplete(id, file[], url[], bytes_downloaded);





/* Natives */



// Downloads a file

// Returns download id or 0 if something failed

// * url    - address of remote file (eg. "http://bentski.lt/something.zip")

// * dlpath - where to place downloaded file (eg. "addons/amxmodx/data/something.zip")

native download(url[], dlpath[]);
#if defined _server_comm_included
	#endinput
#endif

#define _server_comm_included

#if AMXX_VERSION_NUM >= 175
	#pragma reqlib server_comm
	#if !defined AMXMODX_NOAUTOLOAD
		#pragma loadlib server_comm
	#endif
#else
	#pragma library server_comm
#endif

/*
 * Called when the server receives data from another server
 * 
 * @param		data - The string containing data
 * @param		len - The length of the data
 * 
 * @return		Return value is ignored
 * 
 */
forward scomm_receive(data[], len);

/*
 * Sends data to a given IP
 * 
 * @param		ip - The IP to send data to
 * @param		data - The data to send
 * 
 * @note		The port must be at the end of the IP address
 * @note		To send data back to the same server, use "loopback" as the IP and no port at the end of it
 * 
 * @return		Returns 1 on success, 0 on failure
 * 
 */
native scomm_send(const ip[], const data[]);

/*
 * Sends formatted data to a given IP
 * 
 * @param		ip - The IP to send data to
 * @param		format - The format of the data
 * 
 * @note		The port must be at the end of the IP address
 * @note		To send data back to the same server, use "loopback" as the IP and no port at the end of it
 * 
 * @return		Returns 1 on success, 0 on failure
 * 
 */
native scomm_sendf(const ip[], const format[], any:...);
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1033\\ f0\\ fs16 \n\\ par }
*/

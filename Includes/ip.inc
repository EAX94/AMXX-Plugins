#if defined _ip_included
  #endinput
#endif
#define _ip_included

/*
	IP converter by Zefir<zefir-cs@ukr.net>
		developed for Cerberus project
		http://cerberus.cstrike.in.ua/
	2 jule 2009 (c) Zefir


	WARNING!!! INPUT DATA NOT CHECKED FOR AVAILABLE RANGE
	WARNING!!! mask used only left filled, not mask as 11101111 11110000 000...

	inet_aton(ip_string[])
		convert x.x.x.x to LONG
		return unsigned long

	inet_ntoa(ip_number)
		convert LONG to x.x.x.x
		return string[16]

	inet_atom(mask_string)
		convert x.x.x.x to /xx
		return digit 0-32

	inet_ntom(mask_number)
		convert LONG to /xx
		return digit 0-32

	inet_mtoa(mask_string)
		convert /xx to x.x.x.x
		return string[16]

	inet_mton(mask_string)
		convert /xx to LONG
		return unsigned long

	inet_maskton(mask_string[])
		convert both types (/xx or x.x.x.x)  to LONG
		return unsigned long

	inet_range(net_string, &net, &mask)
		get net and mask as LONG from subnet x.x.x.x/xx OR x.x.x.x/x.x.x.x
		return true if mask /32

	in_range(net[], ip[])
		check net[] subnet contain ip[] address

	ip_local(ip)
		return true if ip as LONG be contained in any from this networks:
			127.0.0.0/8
			10.0.0.0/8
			172.16.0.0/12
			192.168.0.0/16
			169.254.0.0/16

*/

stock inet_aton(const ip_string[]) {
	static ip[16], ips[1], i, j, cur; ips[0] = 0; j = 0; cur = 0;
	copy(ip, 15, ip_string);
	while (j < 3 && (i = contain(ip[cur], ".")) > -1) {
		ip[cur + i++] = EOS;
		ips{j++} = str_to_num(ip[cur]);
		cur += i;
	}
	ips{j} = str_to_num(ip[cur]);
	return ips[0]
}

stock inet_ntoa(ip) {
	static ip_string[16], ips[1]; ip_string[0] = EOS; ips[0] = ip
	formatex(ip_string, 15, "%d.%d.%d.%d", ips{0}, ips{1}, ips{2}, ips{3});
	return ip_string;
}


stock inet_atom(const mask_string[]) {
	static ip, i; ip = inet_aton(mask_string), i = 0;
	while (!(ip & 1) && i++ < 31) ip >>>= 1;
	return 31 - i;
}

stock inet_ntom(mask) {
	static i; i = 0;
	while (!(mask & 1) && i++ < 31) mask >>>= 1;
	return 31 - i;
}

stock bool:inet_range(const net_string[], &net, &mask) {
	static lnet[16], i;
	if ((i = contain(net_string, "/")) > -1) {
		copy(lnet, i, net_string);
		mask = inet_maskton(net_string[i + 1]);
	} else {
		mask = 0;
	}
	net = inet_aton(lnet) & mask;
	return mask == 4294967295;
}

stock bool:in_range(const net_string[], const ip_string[]) {
	static net, mask;
	inet_range(net_string, net, mask);
	return inet_aton(ip_string) & mask == net;
}

// All int is signed. And mask first bit, its bit of sign. :(
// Set if mask > 0 and signed shift of mask bits count - 1
stock inet_mton(const mask_string[]) {
	static mask;
	mask = str_to_num(mask_string);
	if (!mask) return 0;
	return 4294967295 << (31 - mask);
}

stock inet_mtoa(const mask_string[])
	return inet_ntoa(inet_mton(mask_string));

stock inet_maskton(const mask_string[]) {
	if (contain(mask_string, ".") > -1)
		return inet_aton(mask_string);
	return inet_mton(mask_string);
}

/*
net: 127.0.0.0/8,    net = 2130706432, mask = 4278190080
net: 10.0.0.0/8,     net = 167772160,  mask = 4278190080
net: 172.16.0.0/12,  net = 2886729728, mask = 4293918720
net: 192.168.0.0/16, net = 3232235520, mask = 4294901760
net: 169.254.0.0/16, net = 2851995648, mask = 4294901760
*/
stock bool:ip_local(ip) {
	return	2130706432 == ip & 4278190080 ||
			167772160  == ip & 4278190080 ||
			2886729728 == ip & 4293918720 ||
			3232235520 == ip & 4294901760 ||
			2851995648 == ip & 4294901760;
}



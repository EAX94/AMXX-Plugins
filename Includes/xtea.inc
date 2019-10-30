/*
	Extenshion of Tiny Encryption Algorithm
	from http://143.53.36.235:8080/tea.htm
	or http://en.wikipedia.org/wiki/Tiny_Encryption_Algorithm

	developed for Cerberus project
	by Zefir<zefir-cs@ukr.net>
	http://up.org.ua/
	xmpp://zefir@up.org.ua/
	http://cerberus.cstrike.in.ua/

	13 december 2010 (c) Zefir
*/

#if defined _xtea_included
  #endinput
#endif
#define _xtea_included


stock xtea_crypt_str(str[], key[4]) {
	new len = strlen(str);
	if (len & 1)
		set_fail_state("Length of the string for tea_crypt_str() must be even")

	while (len > 0)
		xtea_crypt(str[len -= 2], key);
}

stock xtea_decrypt_str(str[], key[4]) {
	new len = strlen(str);
	if (len & 1)
		set_fail_state("Length of the string for tea_decrypt_str() must be even")

	while (len > 0)
		xtea_decrypt(str[len -= 2], key);
}

stock xtea_crypt(str[], key[4]) {
	new y = str[0], z = str[1], sum = 0,
			delta = 0x9e3779b9, n = 32;

	while (n-- > 0) {
		y += (z << 4 ^ z >>> 5) + z ^ sum + key[sum & 3];
		sum += delta;
		z += (y << 4 ^ y >>> 5) + y ^ sum + key[sum >>> 11 & 3];
	}

	str[0] = y; str[1] = z;
}

stock xtea_decrypt(str[], key[4]) {
	new y = str[0], z = str[1], sum = 0xC6EF3720,
			delta = 0x9e3779b9, n = 32;

	while (n-- > 0) {
		z -= (y << 4 ^ y >>> 5) + y ^ sum + key[sum >>> 11 & 3];
		sum -= delta;
		y -= (z << 4 ^ z >>> 5) + z ^ sum + key[sum & 3];
	}

	str[0] = y; str[1] = z;
}

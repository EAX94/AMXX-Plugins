/*
	Tiny Encryption Algorithm
	from http://143.53.36.235:8080/tea.htm
	or http://en.wikipedia.org/wiki/Tiny_Encryption_Algorithm

	developed for Cerberus project
	by Zefir<zefir-cs@ukr.net>
	http://up.org.ua/
	xmpp://zefir@up.org.ua/
	http://cerberus.cstrike.in.ua/

	13 december 2010 (c) Zefir
*/

#if defined _tea_included
  #endinput
#endif
#define _tea_included


stock tea_crypt_str(str[], key[4]) {
	new len = strlen(str);
	if (len & 1)
		set_fail_state("Length of the string for tea_crypt_str() must be even")

	while (len > 0)
		tea_crypt(str[len -= 2], key);
}

stock tea_decrypt_str(str[], key[4]) {
	new len = strlen(str);
	if (len & 1)
		set_fail_state("Length of the string for tea_decrypt_str() must be even")

	while (len > 0)
		tea_decrypt(str[len -= 2], key);
}

stock tea_crypt(str[], key[4]) {
	new y = str[0], z = str[1], sum = 0,
			delta = 0x9e3779b9, n = 32;

	new k0 = key[0], k1 = key[1], k2 = key[2], k3 = key[3];

	while (n-- > 0) {
		sum += delta;
		y += ((z << 4) + k0) ^ (z + sum ^ (z >>> 5) + k1);
		z += ((y << 4) + k2) ^ (y + sum ^ (y >>> 5) + k3);
	}

	str[0] = y; str[1] = z;
}

stock tea_decrypt(str[], key[4]) {
	new y = str[0], z = str[1], sum = 0xC6EF3720,
			delta = 0x9e3779b9, n = 32;

	new k0 = key[0], k1 = key[1], k2 = key[2], k3 = key[3];

	while (n-- > 0) {
		z -= ((y << 4) + k2) ^ (y + sum) ^ ((y >>> 5) + k3);
		y -= ((z << 4) + k0) ^ (z + sum) ^ ((z >>> 5) + k1);
		sum -= delta;
	}

	str[0] = y; str[1] = z;
}

enum _:structServers {
	PUB1,
	PUB2,
	PUB3,
	PUB4,
	AUTOMIX,
	DM,
	DMOH,
	GG,
	GGTP,
	AUTOMIX2,
	ZP,
	KZ,
	SURF,
	CTF,
	DR,
	SJ,
	BNR,
	JAILBREAK,
	MIX1,
	MIX2,
	TD,
	TEST
};

new const g_IP_Servers[][] = {
	":27015",
	":27016",
	":27017",
	":27018",
	":27019",
	":27020",
	":27021",
	":27022",
	":27023",
	":27024",
	":27025",
	":27026",
	":27027",
	":27028",
	":27029",
	":27030",
	":27031",
	":27032",
	":27033",
	":27034",
	":27035",
	":27050"
};

new g_Server[structServers];

cargarServidores() {
	new sIp[24];
	new sServerIp[24];
	new i;
	
	get_user_ip(0, sIp, charsmax(sIp));
	
	for(i = 0; i < structServers; ++i) {
		formatex(sServerIp, 23, "181.177.203.180%s", g_IP_Servers[i]);
		
		if(equal(sIp, sServerIp)) {
			g_Server[i] = 1;
		}
	}
}
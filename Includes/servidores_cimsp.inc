enum _:structServers {
	OPEN,
	ONLY_DUST2,
	ONLY_INFERNO,
	ONLY_NUKE,
	ONLY_ASSAULT,
	ZPv3,
	ZPv6,
	JB,
	CTF,
	TTT,
	ZR2,
	TD,
	MIX,
	DM,
	DMOH,
	GG,
	GGTP,
	KZ,
	SURF,
	DR,
	SJ,
	BNR,
	ONLY_PREMIUM,
	
	AUTOMIX_ARG,
	AUTOMIX_FR
};

new const g_IP_Servers[][] = {
	"190.0.164.152:30000",
	"190.0.164.152:30001",
	"190.0.164.152:30002",
	"190.0.164.152:30003",
	"190.0.164.152:30004",
	"190.0.164.152:30005",
	"190.0.164.152:30006",
	"190.0.164.152:30007",
	"190.0.164.152:30008",
	"190.0.164.152:30009",
	"190.0.164.152:30010",
	"190.0.164.152:30011",
	"190.0.164.152:30012",
	"190.0.164.152:27015",
	"190.0.164.152:27016",
	"190.0.164.152:27017",
	"190.0.164.152:27018",
	"190.0.164.152:27019",
	"190.0.164.152:27020",
	"190.0.164.152:27021",
	"190.0.164.152:27022",
	"190.0.164.152:27023",
	"190.0.164.152:27034",
	
	"190.0.164.152", // AUTOMIX ARG
	"91.121.110.121" // AUTOMIX FR
};

new g_Server[structServers];

cargarServidores() {
	new sIp[24];
	new sHostPort[11];
	new iHostPort;
	new i;
	
	get_cvar_string("hostport", sHostPort, 10);
	iHostPort = str_to_num(sHostPort);
	
	get_user_ip(0, sIp, 23, 1);
	
	if(equal(sIp, g_IP_Servers[AUTOMIX_ARG])) {
		switch(iHostPort) {
			case 30013, 30014, 27024, 27025, 27026, 27027, 27028, 27029, 27030, 27031, 27032, 27033: {
				g_Server[AUTOMIX_ARG] = 1;
			}
		}
	} else if(equal(sIp, g_IP_Servers[AUTOMIX_FR])) {
		if(iHostPort >= 15 && iHostPort <= 40) {
			g_Server[AUTOMIX_FR] = 1;
		}
	}
	
	get_user_ip(0, sIp, 23);
	
	for(i = 0; i < structServers; ++i) {
		if(equal(sIp, g_IP_Servers[i])) {
			g_Server[i] = 1;
		}
	}
}
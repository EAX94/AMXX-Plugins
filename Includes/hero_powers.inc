enum _:HerosPowers {
	Float:timerFinish,
	Float:timerReset,
	taskPower,
	taskReset
}

new const HERO_POWERS[][HerosPowers] = {
	{10.0, 20.1, TASK_POWER_NATASHA_ROMANOFF, TASK_RESET_NATASHA_ROMANOFF}, // Natasha Romanoff
	{0.2, 60.1, 0, TASK_RESET_CYCLOPS}, // Cyclops
	{10.0, 40.1, TASK_POWER_GHOST, TASK_RESET_GHOST}, // Ghost
	{0.0, 25.1, TASK_POWER_ICE_QUEEN_00, TASK_RESET_ICE_QUEEN_00}, // Ice Queen
	{0.0, 60.1, 0, TASK_RESET_GAIDEN_00}, // Gaiden
	{15.0, 45.1, TASK_POWER_HELL_FISH, TASK_RESET_HELL_FISH}, // Hell Fish
	{0.0, 60.1, 0, TASK_RESET_NEPENTHES}, // Nephentes
	{0.0, 0.0, 0, 0}, // Mc Warrior
	{0.0, 45.0, 0, TASK_RESET_LION_FANG}, // Lion Fang
	{0.0, 30.1, 0, TASK_RESET_HURRINCANE_00}, // Hurrincane
	{0.0, 25.1, 0, TASK_RESET_NIGHT_BAT_00}, // Night Bat
	{0.0, 0.0, 0, 0}, // Tyr
	{0.0, 30.1, 0, TASK_RESET_SPIDION}, // Spidion
	{10.0, 60.1, TASK_POWER_SHADOW, TASK_RESET_SHADOW}, // Shadow
	{0.0, 30.0, 0, TASK_RESET_LUCKY}, // Lucky
	{0.0, 60.1, 0, TASK_RESET_KRONOS_00}, // Kronos
	{10.0, 50.1, TASK_POWER_NORRIN_RADD, TASK_RESET_NORRIN_RADD}, // Norrin Radd
	{0.0, 45.1, 0, TASK_RESET_PSYCHIST_00}, // Psychist
	{0.0, 120.1, 0, TASK_RESET_SURGEON}, // Surgeon
	{0.0, 30.1, 0, TASK_RESET_DUENDE_VERDE}, // El Duende Verde
	{0.0, 90.1, 0, TASK_RESET_HADES}, // Hades
	{0.0, 180.1, 0, TASK_RESET_EARTHQUAKE}, // Earthquake
	{10.0, 60.1, TASK_POWER_SNIPER, TASK_RESET_SNIPER}, // Sniper
	{10.0, 50.1, TASK_POWER_BERSEKER, TASK_RESET_BERSKER}, // Berseker
	{0.0, 0.0, 0, 0}, // Green Arrow
	{0.0, 50.1, 0, TASK_RESET_CLARINETE}, // El Muñequito de Clarin
	{0.0, 20.0, 0, TASK_RESET_ZEUS}, // Zeus
	{10.0, 40.0, TASK_POWER_HERMES, TASK_RESET_HERMES}, // Hermes
	{0.0, 0.0, 0, 0}, // Light Knifg
	{0.0, 0.0, 0, 0}, // Dark Night
	{15.0, 90.1, TASK_POWER_EL_INFECTADO, TASK_RESET_EL_INFECTADO} // El Infectado
};

enum _:HerosStruct {
	heroName[32],
	heroInfo[512],
	heroLevel,
	heroRama
}

enum _:Heros {
	HERO_NATASHA_ROMANOFF = 0,
	HERO_CYCLOPS,
	
	HERO_GHOST,
	HERO_ICE_QUEEN,
	
	HERO_GAIDEN,
	
	HERO_HELL_FISH,
	HERO_NEPENTHES,
	HERO_MC_WARRIOR,
	
	HERO_LION_FANG,
	
	HERO_HURRINCANE,
	HERO_NIGHT_BAT,
	
	HERO_TYR,
	HERO_SPIDION,
	
	HERO_SHADOW,
	HERO_LUCKY,
	
	HERO_KRONOS,
	
	HERO_NORRIN_RADD,
	HERO_PSYCHIST,
	HERO_SURGEON,
	
	HERO_EL_DUENDE_VERDE,
	
	HERO_HADES,
	HERO_EARTHQUAKE,
	
	HERO_SNIPER,
	HERO_BERSEKER,
	
	HERO_GREEN_ARROW,
	HERO_CLARINETE,
	
	HERO_ZEUS,
	
	HERO_HERMES,
	
	HERO_LIGHT_KNIGHT,
	HERO_DARK_KNIGHT,
	HERO_EL_INFECTADO,
	
	MAX_HEROS
}

new const HEROS[][HerosStruct] = {
	{"Natasha Romanoff", "\yHABILIDADES:^n\r - \wPuntería perfecta con \yDesert Eagle .50 AE^n\r - \wVelocidad aumentada x1", 1, 3},
	{"Cyclops", "\yHABILIDADES:^n\r - \wLanza rayos", 1, 2},
	
	{"Ghost", "\yHABILIDADES:^n\r - \wEscape", 2, 1},
	{"Ice Queen", "\yHABILIDADES:^n\r - \wCongela enemigos^n\r - \wArmadura de hielo", 2, 0},
	
	{"Gaiden", "\yHABILIDADES:^n\r - \wLanzamiento a distancia de cuchillos^n\r - \wVelocidad aumentada x2", 3, 2},
	
	{"Hell Fish", "\yHABILIDADES:^n\r - \wEscudo de agua^n\r - \wResistencia al agua^n\r - \wDaño de fuego recibido aumentado", 4, 3},
	{"Nepenthes", "\yHABILIDADES:^n\r - \wExplosión", 4, 1},
	{"MC Warrior", "\yHABILIDADES:^n\r - \wAtaca con espadas^n\r - \wSalvación", 4, 0},
	
	{"Lion Fang", "\yHABILIDADES:^n\r - \wRugido", 5, 2},
	
	{"Hurrincane", "\yHABILIDADES:^n\r - \wHuracán de Luz^n\r - \wVelocidad Aumentada x3", 6, 0},
	{"Night Bat", "\yHABILIDADES:^n\r - \wUltrasonido^n\r - \wVelocidad aumentada x3", 6, 1},
	
	{"Tyr", "\yHABILIDADES:^n\r - \wGolpe cargado^n\r - \wVida aumentada", 7, 3},
	{"Spidion", "\yHABILIDADES:^n\r - \wCola venenosa", 7, 2},
	
	{"Shadow", "\yHABILIDADES:^n\r - \wInvisible^n\r - \wVida aumentada", 8, 1},
	{"Lucky", "\yHABILIDADES:^n\r - \wSuerte^n\r - \wDespistado", 8, 0},
	
	{"Kronos", "\yHABILIDADES:^n\r - \wMime^n\r - \wAvance en el tiempo", 9, 2},
	
	{"Norrin Radd", "\yHABILIDADES:^n\r - \wReflejo de daño", 10, 3},
	{"Psychist", "\yHABILIDADES:^n\r - \wPsicosis^n\r - \wTelequinesis", 10, 1},
	{"Surgeon", "\yHABILIDADES:^n\r - \wCuración", 10, 0},
	
	{"El Duende Verde", "\yHABILIDADES:^n\r - \wLanza bombas", 11, 2},
	
	{"Hades", "\yHABILIDADES:^n\r - \wCorrupción", 12, 1},
	{"Earthquake", "\yHABILIDADES:^n\r - \wTemblor", 12, 0},
	
	{"Sniper", "\yHABILIDADES:^n\r - \wAWP^n\r - \wInmunidad parcial (efecto secundario)", 13, 3},
	{"Berseker", "\yHABILIDADES:^n\r - \wIra", 13, 2},
	
	{"Green Arrow", "\yHABILIDADES:^n\r - \wFlechas explosivas", 14, 1},
	
	{"El muñequito de Clarín", "\yHABILIDADES:^n\r - \wConfunde a sus enemigos", 15, 2},
	
	{"Zeus", "\yHABILIDADES:^n\r - \wRayo eléctrico^n\r - \wEléctrico", 16, 3},
	
	{"Hermes", "\yHABILIDADES:^n\r - \wVolar", 19, 3},
	
	{"Light Knight", "\yHABILIDADES:^n\r - \wLuz^n\r - \wResplandor", 50, 0},
	{"Dark Knight", "\yHABILIDADES:^n\r - \wOscuridad^n\r - \wPosesión", 50, 1},
	{"El infectado", "\yHABILIDADES:^n\r - \wInmunidad total", 50, 3}
};

new const HEROS_POWER[][][] = {
	{"Velocidad aumentada x1", "NADA"},
	{"Lanza rayos", "NADA"},
	
	{"Escape", "NADA"},
	{"Congela enemigos", "Armadura de hielo"},
	
	{"Lanza cuchillos", "Velocidad aumentada x2"},
	
	{"Escudo de agua", "NADA"},
	{"Explosión", "NADA"},
	{"NADA", "NADA"},
	
	{"Rugido", "NADA"},
	
	{"Huracán de Luz", "Velocidad aumentada x3"},
	{"Ultrasonido", "Velocidad aumentada x3"},
	
	{"NADA", "NADA"},
	{"Cola venenosa", "NADA"},
	
	{"Invisible", "NADA"},  
	{"Despistado", "NADA"},
	
	{"Mime", "Avance en el tiempo"},
	
	{"Reflejo de daño", "NADA"},
	{"Psicosis", "Telequinesis"},
	{"Curación", "NADA"},
	
	{"NADA", "NADA"},
	
	{"Corrupción", "NADA"},
	{"Temblor", "NADA"},
	
	{"Inmunidad parcial (efecto secundario)", "NADA"},
	{"Ira", "NADA"},
	
	{"NADA", "NADA"},
	
	{"Confunde a sus enemigos", "NADA"},
	
	{"Rayo eléctrico", "NADA"},
	
	{"Volar", "NADA"},
	
	{"Luz", "Resplandor"},
	{"Oscuridad", "Posesión"},
	{"Inmunidad Total", "NADA"}
};
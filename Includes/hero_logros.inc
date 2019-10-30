enum _:FormatAchievements {
	nameLogro[32],
	descLogro[128],
	rewardLogro
};

enum _:MaxAchievements {
	L_BETA_TESTER
};

new const LOGROS[][FormatAchievements] = {
	"BETA TESTER", "Participa de la BETA del HeroMod", 100
};

new g_logro[33][MaxAchievements];
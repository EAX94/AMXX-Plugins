enum _:MUTE_Type {
	MUTE_None = 0,
	MUTE_ALL,
	MUTE_Mic,
	MUTE_Say
};

native isGagged(id);
native isMuted(id, id2);
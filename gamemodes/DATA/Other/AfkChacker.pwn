new playerupdate[MAX_PLAYERS];
PLC::AfkChack(playerid)
{
    if(GetTickCount() > (GetPVarInt(playerid,"LastUpdate") + 1000) && GetPlayerState(playerid) != PLAYER_STATE_PASSENGER)
	{
	    playerupdate[playerid]++;
	}
	return 1;
}
PLC::Afk_OnPlayerUpdate(playerid)
{
    SetPVarInt(playerid,"LastUpdate",GetTickCount());
    playerupdate[playerid] = 0;
	return 1;
}
PLC::CheckPausing(playerid)
{
   if(GetTickCount() > ( GetPVarInt(playerid,"LastUpdate") + 3000 ) && GetPlayerState(playerid) != PLAYER_STATE_PASSENGER)return 1;
   return 0;
}

#include DATA/jiaju_function.pwn
PLC::Jiaju_OnGameModeInit()
{
    mysql_tquery(1, "SELECT * FROM `"SQL_JJ_DATABASE"`", "OnJiajuLoad", "");
	return 1;
}
PLC::Jiaju_OnGameModeExit()
{
	foreach(new r : jj)orm_destroy(jj[r][_orm]);
	return 1;
}
CMD:jj(playerid, params[], help)
{
	new gunid;
	if(sscanf(params,"i",gunid)) return Usage(playerid, "/jj");
	new Float:x,Float:y,Float:z;
    GetPlayerPos(playerid,x,y,z);
	AddJiaju(gunid,"系统家具",x,y,z,0.0,0.0,0.0,GetPlayerInterior(playerid),GetPlayerVirtualWorld(playerid));
	return 1;
}


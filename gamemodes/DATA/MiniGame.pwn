#include DATA/minigame_function.pwn
PLC::minigame_OnGameModeInit()
{
    mysql_tquery(1, "SELECT * FROM `"SQL_MINIGAME_DATABASE"`", "OnMiniGameLoad", "");
	return 1;
}
PLC::minigame_OnGameModeExit()
{
	foreach(new r : gmap)orm_destroy(gmap[r][_orm]);
	return 1;
}
PLC::minigame_OnPlayerConnect(playerid)
{
	GetPlayerGameIn(playerid)=MINIGAME_NONE;
	PlayerTeam(playerid)=NOTHING;
	pgame_veh[playerid]=NOTHING;
	return 1;
}
PLC::minigame_OnPlayerDisconnect(playerid, reason)
{
	GetPlayerGameIn(playerid)=MINIGAME_NONE;
	PlayerTeam(playerid)=NOTHING;
	pgame_veh[playerid]=NOTHING;
	return 1;
}
PLC::CMD_ADDGAME(playerid,body[])
{
    if(GetPlayerGameIn(playerid)!=MINIGAME_NONE)return  SCM(playerid, "你正在小游戏中，无法使用此指令");
    new type,name[80],veh;
    if(sscanf(body,"is[80]D(-1)",type,name,veh)) return Usage(playerid, "/add game 类型[1-TDM 2-DM 3-DERBY 4-FALLOUT 5-CTP] 房间名 汽车ID(可选)");
	if(type<MINIGAME_TDM||type>MINIGAME_CTP)return  SCM(playerid, "没有此类型的游戏");
	if(!Iter_Count(gmap))return SCM(playerid,""CHAT_YELLOW"没有使用的游戏地图");
	switch(type)
	{
	    case MINIGAME_TDM:SetPVarInt(playerid,"choose_game_type",MINIGAME_TDM);
	    case MINIGAME_DM:SetPVarInt(playerid,"choose_game_type",MINIGAME_DM);
   	    case MINIGAME_DERBY:SetPVarInt(playerid,"choose_game_type",MINIGAME_DERBY);
   	    case MINIGAME_FALLOUT:SetPVarInt(playerid,"choose_game_type",MINIGAME_FALLOUT);
   	    case MINIGAME_CTP:
 		{
 		     if(!IsValidVehicleModel(veh))return Info(playerid,"车型ID无效");
		 	SetPVarInt(playerid,"choose_game_type",MINIGAME_CTP);
 		}
	}
	SetPVarString(playerid,"choose_game_name",name);
	SetPVarInt(playerid,"choose_game_veh",veh);
    page[playerid]=1;
	Dialog_Show(playerid,_GAMEMAP_LIST, DIALOG_STYLE_TABLIST_HEADERS,"地图选择",ShowGameMapList(playerid,page[playerid]), "确定", "取消");
	return 1;
}
PLC::CMD_DELGAME(playerid,body[])
{
    new index;
    if(sscanf(body,"%i",index)) return Usage(playerid, "/del ID");
    if(!close_game(index))return Info(playerid,"ID无效");
	return 1;
}
PLC::minigame_OnPlayerDeath(playerid, killerid, reason)
{
	if(!IsPlayerConnected(playerid)||!IsPlayerConnected(killerid))return 1;
	if(!IsLogin(playerid)||!IsLogin(killerid))return 1;
	if(GetPlayerGameIn(playerid)==MINIGAME_NONE)return 1;
	if(GetPlayerGameIn(killerid)==MINIGAME_NONE)return 1;
	pdate[playerid][_death]++;
	pdate[killerid][_kill]++;
	orm_update(pdate[playerid][_orm]);
	orm_update(pdate[killerid][_orm]);
	SetSpawnInfoEx(playerid,PlayerTeam(playerid),pdate[playerid][_skin],gmap[GameMap(GetPlayerGameIn(playerid))][_x][PlayerTeam(playerid)]+random(3),gmap[GameMap(GetPlayerGameIn(playerid))][_y][PlayerTeam(playerid)]+random(3),gmap[GameMap(GetPlayerGameIn(playerid))][_z][PlayerTeam(GetPlayerGameIn(playerid))]+random(1),0.0,0,0,0,0,0,0 );
	return 1;
}
PLC::minigame_OnPlayerSpawn(playerid)
{
    if(GetPlayerGameIn(playerid)==MINIGAME_NONE)return 1;
	switch(game[GetPlayerGameIn(playerid)][_state])
	{
		case MINIGAME_CONVENE:
		{

		}
		case MINIGAME_SRTAT:
		{
			switch(game[GetPlayerGameIn(playerid)][_type])
			{
			    case MINIGAME_TDM:
	    		{
					ResetPlayerWeapons(playerid);
					forex(s,12)GivePlayerWeapon(playerid,gmap[GameMap(GetPlayerGameIn(playerid))][_weapon][s],9999999);
					SetPlayerColor(playerid,team_name[PlayerTeam(playerid)][_hex]);
	            }
			    case MINIGAME_DM:
			    {

			    }
		   	    case MINIGAME_DERBY:
			    {

			    }
		   	    case MINIGAME_FALLOUT:
			    {

			    }
		   	    case MINIGAME_CTP:
			    {

			    }
			}
		}
	}
	return 1;
}

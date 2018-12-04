PLC::OnMiniGameLoad()
{
    forex(r,cache_num_rows())
	{
		new ORM:ormid = gmap[r][_orm] = orm_create(SQL_MINIGAME_DATABASE);
		orm_addvar_int(ormid, gmap[r][_id], "ID");
		orm_addvar_int(ormid, gmap[r][_rate], "RATE");
		orm_addvar_string(ormid, gmap[r][_id],80, "NAME");
		orm_addvar_float(ormid, gmap[r][_x][0],"X1");
		orm_addvar_float(ormid, gmap[r][_y][0],"Y1");
		orm_addvar_float(ormid, gmap[r][_z][0],"Z1");
		orm_addvar_float(ormid, gmap[r][_x][1],"X2");
		orm_addvar_float(ormid, gmap[r][_y][1],"Y2");
		orm_addvar_float(ormid, gmap[r][_z][1],"Z2");
		orm_addvar_int(ormid, gmap[r][_interior], "INTREIOR");
		orm_addvar_int(ormid, gmap[r][_skin][0], "SKIN1");
		orm_addvar_int(ormid, gmap[r][_skin][1], "SKIN2");
		new line[32];
		for(new i=0;i<=11;i++)
		{
			format(line,sizeof(line),"WEAPON%i",i+1);
		    orm_addvar_int(ormid, gmap[r][_weapon][i],line);
		}
		orm_apply_cache(ormid, r);
		orm_setkey(ormid,"ID");
		Iter_Add(gmap,r);
	}
	return 1;
}
PLC::GetGamePopulation(gameid)
{
	new amout=0;
	foreach(new i:Player)
	{
	    if(GetPlayerGameIn(i)==gameid)amout++;
	}
    return amout;
}
PLC::GetGameTeamPopulation(gameid,team)
{
	new amout=0;
	foreach(new i:Player)
	{
	    if(GetPlayerGameIn(i)==gameid)
		{
		    if(PlayerTeam(i)==team)amout++;
		}
	}
    return amout;
}
PLC::BlancePlayerTeam(playerid,gameid)
{
    new gTeam1 = GetGameTeamPopulation(gameid,TEAM_RED),gTeam2 = GetGameTeamPopulation(gameid,TEAM_BLUE);
    if(gTeam1 <= gTeam2)
	{
	    SendClientMessage(playerid, -1,"你加入了红队!");
	    PlayerTeam(playerid)=TEAM_RED;
	    SetPlayerTeam(playerid,TEAM_RED);
	}
	else
	{
	    SendClientMessage(playerid, -1,"你加入了蓝队!");
	    PlayerTeam(playerid)=TEAM_BLUE;
	    SetPlayerTeam(playerid,TEAM_BLUE);
	}
    return 1;
}
SendMiniGameMsg(gameid,body[],team=-1)
{
	foreach(new i:Player)
	{
	    if(GetPlayerGameIn(i)==gameid)
	    {
	        if(team!=-1&&PlayerTeam(i)==team)SCM(i,body);
	        else SCM(i,body);
	    }
	}
    return 1;
}
PLC::exit_game(playerid)
{
    if(GetPlayerGameIn(playerid)==MINIGAME_NONE)return 0;
	switch(game[GetPlayerGameIn(playerid)][_type])
	{
	    case MINIGAME_TDM:
	    {
			GetPlayerGameIn(playerid)=MINIGAME_NONE;
			PlayerTeam(playerid)=NOTHING;
			pgame_veh[playerid]=NOTHING;
			SpawnPlayer(playerid);
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
	if(GetGamePopulation(GetPlayerGameIn(playerid))<1)close_game(GetPlayerGameIn(playerid));
    return 1;
}
PLC::join_game(playerid,gameid)
{
	if(game[gameid][_state]==MINIGAME_COUNT)return 0;
	switch(game[gameid][_type])
	{
	    case MINIGAME_TDM:
	    {
	        switch(game[gameid][_state])
	        {
				case MINIGAME_CONVENE:GetPlayerGameIn(playerid)=gameid;
				case MINIGAME_SRTAT:
				{
				    GetPlayerGameIn(playerid)=gameid;
					BlancePlayerTeam(playerid,gameid);
					SetPlayerHealth(playerid,100);
					SetPlayerArmour(playerid,100);
					ResetPlayerWeapons(playerid);
					forex(s,12)GivePlayerWeapon(playerid,gmap[GameMap(gameid)][_weapon][s],9999999);
					SetPlayerSkin(playerid,gmap[GameMap(gameid)][_skin][PlayerTeam(playerid)]);
					SetPlayerColor(playerid,team_name[PlayerTeam(playerid)][_hex]);
					TeleportPlayer(playerid,gmap[GameMap(gameid)][_x][PlayerTeam(playerid)]+random(3),gmap[GameMap(gameid)][_y][PlayerTeam(playerid)]+random(3),gmap[GameMap(gameid)][_z][PlayerTeam(playerid)]+random(1),0.0,gmap[GameMap(gameid)][_interior],gameid+MINIGAME_WORLD_LIMIT,false,2);
					Server(playerid,"游戏开始了,快去战斗吧");
					new line[128];
				    format(line,sizeof(line),"%s 加入了战斗 %s",game[gameid][_name],team_name[PlayerTeam(playerid)][_name]);
					SendMiniGameMsg(gameid,line);
				}
	        }
	    }
	    case MINIGAME_DM:
	    {
	        GetPlayerGameIn(playerid)=gameid;
	    }
   	    case MINIGAME_DERBY:
	    {
	        GetPlayerGameIn(playerid)=gameid;
	    }
   	    case MINIGAME_FALLOUT:
	    {
	        GetPlayerGameIn(playerid)=gameid;
	    }
   	    case MINIGAME_CTP:
	    {
	        GetPlayerGameIn(playerid)=gameid;
	    }
	}
    return 1;
}
stock create_game(playerid,name[],type,gamemap=-1,vehicle=-1)
{
    if(Iter_Free(game) == -1) return 0;
    new gameid = Iter_Free(game);
    game[gameid][_type]=type;
    game[gameid][_pid]=pdate[playerid][_uid];
    format(game[gameid][_name],80,name);
    game[gameid][_vehmodel]=vehicle;
	switch(game[gameid][_type])
	{
	    case MINIGAME_TDM:
	    {
            game[gameid][_mapid]=gamemap;
            game[gameid][_state]=MINIGAME_CONVENE;
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
	game[gameid][_count]=10;
	Iter_Add(game,gameid);
	GetPlayerGameIn(playerid)=gameid;
	SCM(playerid,""CHAT_YELLOW"房间创建成功,你已加入了该游戏");
	return 1;
}
PLC::close_game(gameid)
{
    if(!Iter_Contains(game,gameid))return 0;
	switch(game[gameid][_type])
	{
	    case MINIGAME_TDM:
	    {
	        foreach(new i:Player)
			{
			    if(GetPlayerGameIn(i)==gameid)
				{
				    GetPlayerGameIn(i)=MINIGAME_NONE;
				    PlayerTeam(i)=NOTHING;
				    pgame_veh[i]=NOTHING;
				    SpawnPlayer(i);
				    new line[128];
				    format(line,sizeof(line),"[团队竞赛]: '%s' 结束了",game[gameid][_name]);
				    Server(i,line);
				}
			}
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
	Iter_Remove(game,gameid);
	return 1;
}
PLC::start_game(gameid)
{
    game[gameid][_count]--;
    if(!game[gameid][_count])
    {
		switch(game[gameid][_type])
		{
		    case MINIGAME_TDM:
		    {
		        if(GetGamePopulation(gameid)<1)
				{
				    new line[128];
				    format(line,sizeof(line),"[团队竞赛]: '%s' 由于没有玩家参与,已结束",game[gameid][_name]);
				    SendClientMessageToAll(lred,line);
				    return close_game(gameid);
				}
				foreach(new i:Player)
				{
				    if(GetPlayerGameIn(i)==gameid)
				    {
						BlancePlayerTeam(i,gameid);
						SetPlayerHealth(i,100);
						SetPlayerArmour(i,100);
						ResetPlayerWeapons(i);
						forex(s,12)GivePlayerWeapon(i,gmap[GameMap(gameid)][_weapon][s],9999999);
					    SetPlayerSkin(i,gmap[GameMap(gameid)][_skin][PlayerTeam(i)]);
					    SetPlayerColor(i,team_name[PlayerTeam(i)][_hex]);
						TeleportPlayer(i,gmap[GameMap(gameid)][_x][PlayerTeam(i)]+random(3),gmap[GameMap(gameid)][_y][PlayerTeam(i)]+random(3),gmap[GameMap(gameid)][_z][PlayerTeam(i)]+random(1),0.0,gmap[GameMap(gameid)][_interior],gameid+MINIGAME_WORLD_LIMIT,false,2);
						Server(i,"游戏开始了,快去战斗吧");
					}
				}
		    }
		    case MINIGAME_DM:
		    {
		        if(!GetGamePopulation(gameid))
				{
				    new line[128];
				    format(line,sizeof(line),"[个人对战]: '%s' 由于没有玩家参与,已结束",game[gameid][_name]);
				    SendClientMessageToAll(lred,line);
				    return close_game(gameid);
				}
		    }
		    case MINIGAME_DERBY:
		    {
		        if(!GetGamePopulation(gameid))
				{
				    new line[128];
				    format(line,sizeof(line),"[DERBY]: '%s' 由于没有玩家参与,已结束",game[gameid][_name]);
				    SendClientMessageToAll(lred,line);
				    return close_game(gameid);
				}
		    }
		    case MINIGAME_FALLOUT:
		    {
		        if(!GetGamePopulation(gameid))
				{
				    new line[128];
				    format(line,sizeof(line),"[FALLOUT]: '%s' 由于没有玩家参与,已结束",game[gameid][_name]);
				    SendClientMessageToAll(lred,line);
				    return close_game(gameid);
				}
		    }
		    case MINIGAME_CTP:
		    {
		        if(!GetGamePopulation(gameid))
				{
				    new line[128];
				    format(line,sizeof(line),"[CTP]: '%s' 由于没有玩家参与,已结束",game[gameid][_name]);
				    SendClientMessageToAll(lred,line);
				    return close_game(gameid);
				}
		    }
		}
		game[gameid][_state]=MINIGAME_SRTAT;
	}
	else
	{
	    new line[128];
	    switch(game[gameid][_type])
		{
		    case MINIGAME_TDM:format(line,sizeof(line),"[团队竞赛]: '%s' 将在 %i 秒后开始! /join game %i 可以加入",game[gameid][_name],game[gameid][_count],gameid);
		    case MINIGAME_DM:format(line,sizeof(line),"[个人对战]: '%s' 将在 %i 秒后开始! /join game %i 可以加入",game[gameid][_name],game[gameid][_count],gameid);
		    case MINIGAME_DERBY:format(line,sizeof(line),"[DERBY]: '%s' 将在 %i 秒后开始! /join game %i 可以加入",game[gameid][_name],game[gameid][_count],gameid);
		    case MINIGAME_FALLOUT:format(line,sizeof(line),"[FALLOUT]: '%s' 将在 %i 秒后开始! /join game %i 可以加入",game[gameid][_name],game[gameid][_count],gameid);
		    case MINIGAME_CTP:format(line,sizeof(line),"[CTP]: '%s' 将在 %i 秒后开始! /join game %i 可以加入",game[gameid][_name],game[gameid][_count],gameid);
		}
		SendClientMessageToAll(lred,line);
		SetTimerEx("start_game",1000,false,"i",gameid);
	}
	return 1;
}
stock ShowGameMapList(playerid,pager)
{
    listarray[playerid]=1;
    for(new i=Iter_End(gmap);(i=Iter_Prev(gmap, i))!=Iter_Begin(gmap);)
	{
		totals[playerid][listarray[playerid]]=i;
      	listarray[playerid]++;
	}
    new body[1024];
    pager = (pager-1)*MAX_DILOG_LIST;
    if(pager == 0)pager = 1;
	else pager++;
	new over=0;
	format(body,sizeof(body), "ID\t地图名\t次数\n");
	strcat(body, "\t\t"CHAT_SERVER"上一页\n");
	Loop(i,pager,pager+MAX_DILOG_LIST)
	{
		new line[100],index=totals[playerid][i];
		if(i<listarray[playerid])format(line,sizeof(line),"%i\t%s\t%i\n",index,gmap[index][_name],gmap[index][_rate]);
		if(i>=listarray[playerid])
		{
			over=1;
			break;
		}
		else strcat(body,line);
	}
	if(over==0)strcat(body, "\t\t"CHAT_SERVER"下一页\n");
    return body;
}
Dialog:_GAMEMAP_LIST(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new pager=(page[playerid]-1)*MAX_DILOG_LIST;
		if(pager == 0)pager = 1;
		else pager++;
		switch(listitem)
		{
		    case 0:
		  	{
		    	page[playerid]--;
		    	if(page[playerid]<1)
		    	{
		    	    page[playerid]=1;
		    	    SCM(playerid,""CHAT_YELLOW"[传送] 没有上一页了");
		    	}
				Dialog_Show(playerid,_GAMEMAP_LIST,DIALOG_STYLE_TABLIST_HEADERS,"地图选择",ShowGameMapList(playerid,page[playerid]), "支付传送", "取消");
		    }
		    case MAX_DILOG_LIST+1:
		    {
	    		page[playerid]++;
				Dialog_Show(playerid,_GAMEMAP_LIST,DIALOG_STYLE_TABLIST_HEADERS,"地图选择",ShowGameMapList(playerid,page[playerid]), "支付传送", "取消");
		    }
			default:
			{
				new index=totals[playerid][pager+listitem-1];
				if(!Iter_Contains(gmap,index))
				{
				    SCM(playerid,""CHAT_YELLOW"[游戏地图] 该地图已失效");
				    return Dialog_Show(playerid,_GAMEMAP_LIST,DIALOG_STYLE_TABLIST_HEADERS,"地图选择",ShowGameMapList(playerid,page[playerid]), "支付传送", "取消");
				}
				switch(GetPVarInt(playerid,"choose_game_type"))
				{
				    case MINIGAME_TDM:
				    {
				        SetPVarInt(playerid,"choose_game_veh",-1);
				        new line[80];
				        GetPVarString(playerid,"choose_game_name",line, sizeof(line));
				        if(!create_game(playerid,line,GetPVarInt(playerid,"choose_game_type"),index,GetPVarInt(playerid,"choose_game_veh")))return SCM(playerid,""CHAT_YELLOW"房间创建失败");
				    }
				    case MINIGAME_DM:
				    {
				        SetPVarInt(playerid,"choose_game_veh",-1);
				        new line[80];
				        GetPVarString(playerid,"choose_game_name",line, sizeof(line));
				        if(create_game(playerid,line,GetPVarInt(playerid,"choose_game_type"),index,GetPVarInt(playerid,"choose_game_veh")))return SCM(playerid,""CHAT_YELLOW"房间创建失败");
				    }
			   	    case MINIGAME_DERBY:
				    {
				        SetPVarInt(playerid,"choose_game_veh",-1);
				        new line[80];
				        GetPVarString(playerid,"choose_game_name",line, sizeof(line));
				        if(create_game(playerid,line,GetPVarInt(playerid,"choose_game_type"),index,GetPVarInt(playerid,"choose_game_veh")))return SCM(playerid,""CHAT_YELLOW"房间创建失败");
				    }
			   	    case MINIGAME_FALLOUT:
				    {
				        SetPVarInt(playerid,"choose_game_veh",-1);
				        new line[80];
				        GetPVarString(playerid,"choose_game_name",line, sizeof(line));
				        if(create_game(playerid,line,GetPVarInt(playerid,"choose_game_type"),index,GetPVarInt(playerid,"choose_game_veh")))return SCM(playerid,""CHAT_YELLOW"房间创建失败");
				    }
			   	    case MINIGAME_CTP:
				    {
				        new line[80];
				        GetPVarString(playerid,"choose_game_name",line, sizeof(line));
				        if(create_game(playerid,line,GetPVarInt(playerid,"choose_game_type"),index,GetPVarInt(playerid,"choose_game_veh")))return SCM(playerid,""CHAT_YELLOW"房间创建失败");
				    }
				}
			}
		}
	}
	return 1;
}

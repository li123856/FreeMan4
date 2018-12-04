enum vipinfo
{
    ORM:_orm,
    _id,
    _pid,
	_level,
	_join,
	_limit,
}
new vip[MAX_PLAYERS][vipinfo];
PLC::Vip_OnPlayerLogin(playerid)
{
    vip[playerid][_pid]=pdate[playerid][_uid];
    new ORM:ormid = vip[playerid][_orm] = orm_create(SQL_VIP_DATABASE);
    orm_addvar_int(ormid, vip[playerid][_id], "ID");
    orm_addvar_int(ormid, vip[playerid][_pid], "PID");
    orm_addvar_int(ormid, vip[playerid][_level], "LEVEL");
    orm_addvar_int(ormid, vip[playerid][_join], "JOIN");
    orm_addvar_int(ormid, vip[playerid][_limit],"LIMIT");
    orm_setkey(ormid, "PID");
    orm_select(ormid, "OnVipDataLoad", "d",playerid);
	return 1;
}
PLC::Vip_OnPlayerDisconnect(playerid, reason)
{
    orm_destroy(vip[playerid][_orm]);
    return 1;
}
PLC::OnVipDataLoad(playerid)
{
    orm_setkey(vip[playerid][_orm],"ID");
	switch(orm_errno(vip[playerid][_orm]))
	{
	    case ERROR_OK:
		{
		    if(vip[playerid][_level]>0)
		    {
		    	new line[128];
		    	if(vip[playerid][_join]==NOTHING)
				{
					format(line, sizeof(line), "您是光荣的永久VIP %i 用户,拥有更多的功能体验",vip[playerid][_level]);
					SCM(playerid,line);
				}
		    	else
				{
					format(line, sizeof(line), "您是光荣的VIP %i 用户,拥有更多的功能体验",vip[playerid][_level]);
		    		SCM(playerid,line);
		    		format(line, sizeof(line), "您的VIP将于 %s 后到期",GetTimeStr(vip[playerid][_limit]-(ServerRunTime-vip[playerid][_join])));
					SCM(playerid,line);
				}
		    }
		}
		case ERROR_NO_DATA:
		{
		    vip[playerid][_pid]=pdate[playerid][_uid];
		    vip[playerid][_level]=0;
		    vip[playerid][_join]=0;
		    vip[playerid][_limit]=0;
		    orm_insert(vip[playerid][_orm]);
		}
	}
	return 1;
}
PLC::VipUpdate(playerid)
{
	if(vip[playerid][_level]>0)
	{
	    if(vip[playerid][_join]!=NOTHING)
	    {
	        vip[playerid][_limit]++;
	        if(vip[playerid][_limit]-(ServerRunTime-vip[playerid][_join])==0)
	        {
	            new line[128];
	            format(line, sizeof(line), "您VIP %i 已到期,请及时续费",vip[playerid][_level]);
	            addbox_msg(vip[playerid][_pid],"系统消息",line);
				vip[playerid][_level]=0;
		    	vip[playerid][_join]=0;
		    	vip[playerid][_limit]=0;
	        }
	        orm_update(vip[playerid][_orm]);
	    }
	}
	return 1;
}
PLC::SetPlayerVip(playerid,level,minute)
{
    vip[playerid][_level]=level;
    vip[playerid][_join]=ServerRunTime;
    vip[playerid][_limit]=minute;
    orm_update(vip[playerid][_orm]);
	return 1;
}
PLC::SetPlayerVipForever(playerid,level)
{
    vip[playerid][_level]=level;
    vip[playerid][_join]=-1;
    vip[playerid][_limit]=0;
    orm_update(vip[playerid][_orm]);
	return 1;
}
enum lpumu
{
	_level,
	_prize,
	_exp,
	_title[32]
}
new LevelProgress[][lpumu]=
{
	{0,0,0,"{FFFF00}☆"},
	{1,15000,300,"{FFFF00}☆☆"},
	{2,20000,600,"{FFFF00}☆☆☆"},
	{3,25000,1200,"{FFFF00}☆☆☆☆"},
	{4,30000,2400,"{FFFF00}☆☆☆☆☆"},
	{5,35000,4800,"{FFFF00}★"},
	{6,40000,19200,"{FFFF00}★☆"},
	{7,45000,38400,"{FFFF00}★☆☆"},
	{8,50000,76800,"{FFFF00}★☆☆☆"},
	{9,55000,153600,"{FFFF00}★☆☆☆☆"},
	{10,60000,307200,"{FFFF00}★☆☆☆☆☆"},
	{11,65000,614400,"{FFFF00}★★"},
	{12,70000,1228800,"{FFFF00}★★☆"},
	{13,75000,2457600,"{FFFF00}★★☆☆"},
	{14,80000,4915200,"{FFFF00}★★☆☆☆"},
	{15,85000,9830400,"{FFFF00}★★☆☆☆☆"},
	{16,90000,19660800,"{FFFF00}★★☆☆☆☆☆"},
	{17,95000,39321600,"{FFFF00}★★★"},
	{18,100000,78643200,"{FFFF00}★★★☆"},
	{19,150000,157286400,"{FFFF00}★★★☆☆"},
	{20,200000,314572800,"{FFFF00}★★★☆☆☆"}
};
new Text3D:LevelTitle[MAX_PLAYERS];
new PlayerText:LevelText[MAX_PLAYERS];
PLC::LevelUpdate(playerid)
{
	if(AFK(playerid))return Dialog_Show(playerid,_MSG,DIALOG_STYLE_MSGBOX,"提示","你离开了游戏,无法获取经验", "呃", "");
	if(pdate[playerid][_exp]<LevelProgress[pdate[playerid][_level]+1][_exp])pdate[playerid][_exp]=pdate[playerid][_exp]+VIP(playerid)+1;
	else
	{
	    pdate[playerid][_exp]=pdate[playerid][_exp]+VIP(playerid)+1;
	    pdate[playerid][_exp]++;
	    pdate[playerid][_level]++;
	    UpdateDynamic3DTextLabelText(LevelTitle[playerid],-1,LevelProgress[pdate[playerid][_level]][_title]);
	    new line[128];
	    format(line, sizeof(line), "恭喜你的游戏等级升到了 %i 级,你获得了 $%i 的奖励以及新的头衔", pdate[playerid][_level],LevelProgress[pdate[playerid][_level]][_prize]);
	    addbox_msg(pdate[playerid][_uid],"系统消息",line,LevelProgress[pdate[playerid][_level]][_prize]);
	}
	Update_PlayerLevelText(playerid);
	orm_update(pdate[playerid][_orm]);
	SetPlayerScore(playerid,pdate[playerid][_exp]);
	return 1;
}
PLC::Level_OnPlayerConnect(playerid)
{
	LevelText[playerid] = CreatePlayerTextDraw(playerid,311.898773, 430.873199, "LEVEL   0/0");
	PlayerTextDrawLetterSize(playerid,LevelText[playerid], 0.400000, 1.600000);
	PlayerTextDrawAlignment(playerid,LevelText[playerid], 2);
	PlayerTextDrawColor(playerid,LevelText[playerid],  0xFF0000FF);
	PlayerTextDrawSetShadow(playerid,LevelText[playerid], 1);
	PlayerTextDrawSetOutline(playerid,LevelText[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid,LevelText[playerid], 255);
	PlayerTextDrawFont(playerid,LevelText[playerid], 2);
	PlayerTextDrawSetProportional(playerid,LevelText[playerid], 1);
	PlayerTextDrawSetShadow(playerid,LevelText[playerid], 1);
	PlayerTextDrawSetSelectable(playerid,LevelText[playerid], true);
	PlayerTextDrawHide(playerid,LevelText[playerid]);
    LevelTitle[playerid]=CreateDynamic3DTextLabel(LevelProgress[pdate[playerid][_level]][_title],-1,0.0,0.0,0.5,20.0,playerid);
    return 1;
}
PLC::Level_OnPlayerLogin(playerid)
{
    Update_PlayerLevelText(playerid);
    PlayerTextDrawShow(playerid,LevelText[playerid]);
    SetPlayerScore(playerid,pdate[playerid][_exp]);
    return 1;
}
PLC::Update_PlayerLevelText(playerid)
{
	new line[128];
	format(line, sizeof(line), "LEVEL %i   %i/%i", pdate[playerid][_level],pdate[playerid][_exp],LevelProgress[pdate[playerid][_level]+1][_exp]);
	PlayerTextDrawSetString(playerid,LevelText[playerid],line);
    return 1;
}
PLC::Level_OnPlayerDisconnect(playerid, reason)
{
    DestroyDynamic3DTextLabel(LevelTitle[playerid]);
    PlayerTextDrawDestroy(playerid,LevelText[playerid]);
    return 1;
}

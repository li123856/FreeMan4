#include DATA/account_function.pwn
PLC::accout_OnPlayerConnect(playerid)
{
	GetPlayerName(playerid, pdate[playerid][_name], 80);
	new ORM:ormid = pdate[playerid][_orm] = orm_create(SQL_ACCOUT_DATABASE);
	orm_addvar_int(ormid, pdate[playerid][_uid], "ID");
	orm_addvar_int(ormid, pdate[playerid][_admin], "ADMIN");
	orm_addvar_string(ormid, pdate[playerid][_name],80, "NAME");
	orm_addvar_string(ormid, pdate[playerid][_pass],128, "PASS");
	orm_addvar_string(ormid, pdate[playerid][_motto],256, "MOTTO");
	orm_addvar_int(ormid, pdate[playerid][_mottocolor], "MOTTOCOLOR");
	orm_addvar_int(ormid,pdate[playerid][_skin],"SKIN");
	orm_addvar_int(ormid,pdate[playerid][_interior],"INTERIOR");
	orm_addvar_int(ormid,pdate[playerid][_world],"WORLD");
	orm_addvar_int(ormid,pdate[playerid][_location],"LOCATION");
	orm_addvar_float(ormid,pdate[playerid][_x],"X");
	orm_addvar_float(ormid,pdate[playerid][_y],"Y");
	orm_addvar_float(ormid,pdate[playerid][_z],"Z");
	orm_addvar_float(ormid,pdate[playerid][_a],"A");
	orm_addvar_int(ormid,pdate[playerid][_cash],"CASH");
	orm_addvar_int(ormid,pdate[playerid][_bank],"BANK");
	orm_addvar_int(ormid,pdate[playerid][_moneybag],"MONEYBAG");
	orm_addvar_int(ormid,pdate[playerid][_gid],"GID");
	orm_addvar_int(ormid,pdate[playerid][_rank],"RANK");
	orm_addvar_int(ormid,pdate[playerid][_color],"COLOR");
	orm_addvar_int(ormid,pdate[playerid][_saycolor],"SAYCOLOR");
	orm_addvar_int(ormid,pdate[playerid][_kill],"KILL");
	orm_addvar_int(ormid,pdate[playerid][_death],"DEATH");
	orm_addvar_int(ormid,pdate[playerid][_level],"LEVEL");
	orm_addvar_int(ormid,pdate[playerid][_exp],"EXP");
	orm_addvar_int(ormid,pdate[playerid][_qb],"QB");
	orm_addvar_int(ormid,pdate[playerid][_choose],"CHOOSE");
	orm_setkey(ormid, "NAME");
	orm_select(ormid, "OnPlayerDataLoad", "d", playerid);
	return 1;
}
PLC::accout_OnPlayerDisconnect(playerid, reason)
{
	SetLoginState(playerid,0);
	KillTimer(pdate[playerid][_logindialog]);
	if(pdate[playerid][_uid]!=0) orm_update(pdate[playerid][_orm]);
	orm_destroy(pdate[playerid][_orm]);
 	new dreason[3][] =
    {
        "超时/闪退了",
        "离开了游戏",
        "被T了"
    };
	new line[128];
    format(line, sizeof(line), "%s %s.", pdate[playerid][_name],dreason[reason]);
    SendClientMessageToAll(0xC4C4C4FF, line);
	for(new userinfo:e; e < userinfo; ++e)pdate[playerid][e]=0;
 	return 1;
}
PLC::accout_OnPlayerText(playerid, text[])
{
	if(pGang(playerid)==NOTHING)
	{
		new body[512],line[128];
		format(line,sizeof(line),"%s%s:%s",hue[pdate[playerid][_color]][_code],pdate[playerid][_name],pdate[playerid][_saycolor],text,hue[pdate[playerid][_mottocolor]][_code],pdate[playerid][_motto]);
		strcat(body,line);
        strcat(body,text);
        format(line,sizeof(line),"  %s%s",hue[pdate[playerid][_mottocolor]][_code],pdate[playerid][_motto]);
		strcat(body,line);
		SendClientMessageToAll(COLOR_WHITE,body);
	}
    return 1;
}
PLC::accout_OnPlayerLogin(playerid)
{
	new line[128];
	format(line,sizeof(line),"玩家  %s%s"#CHAT_WHITE"登陆了!",hue[pdate[playerid][_color]][_code],pdate[playerid][_name]);
	SendClientMessageToAll(COLOR_WHITE,line);
	if(pGang(playerid)==NOTHING)SetPlayerColor(playerid,hue[pdate[playerid][_color]][_code]);
	pdate[playerid][_gaming]=1;
    return 1;
}
PLC::ShowPersonInfo(playerid)return Dialog_Show(playerid,_INFO, DIALOG_STYLE_MSGBOX,"账户详情",PersonInfo(playerid),"操作","关闭");


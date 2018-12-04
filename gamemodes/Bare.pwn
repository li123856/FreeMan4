#include <a_samp>
#include <streamer>
#include <a_mysql>
#include <YSI\y_iterate>
#include <YSI\y_groups>
#include <YSI\y_bit>
#include <izcmd>
#include <foreach>
#include <sscanf2>
#include <alltextures>
#pragma tabsize 0

#define GetPlayerName(%1) GetPlayerName_prefixed(%1)
#define PLC::%1(%3) \
                forward %1(%3); \
                public %1(%3)
#define forex(%0,%1) for(new %0 = 0; %0 < %1; %0++)
#define Loop(%0,%1,%2) for(new %0 = %1; %0 < %2; %0++)


#define SQL_HOST "localhost"
#define SQL_USER "root"
#define SQL_PASSWORD "d7root"
#define SQL_DATABASE "free"
#define SQL_ACCOUT_DATABASE "account"
#define SQL_MSGBOX_DATABASE "msgbox"
#define SQL_TELE_DATABASE "teleport"
#define SQL_GROUP_DATABASE "gang"
#define SQL_ISLAND_DATABASE "island"
#define SQL_MINIGAME_DATABASE "minigame"
#define SQL_SERVER_DATABASE "server"
#define SQL_VIP_DATABASE "vip"
#define SQL_BAN_DATABASE "ban"
#define SQL_JJ_DATABASE "jiaju"

#define CHAT_YELLOW 			"{FFFF00}"
#define CHAT_WHITE 				"{FFFFFF}"
#define CHAT_SERVER 			"{808080}"
#define CHAT_RED 				"{FF0000}"
#define	COLOR_WHITE				0xFFFFFFFF

#define IsLogin(%0) GetPVarInt(%0,"online")
#define SetReg(%0,%1) SetPVarInt(%0,"reg",%1)
#define Reg(%0) GetPVarInt(%0,"reg")
#define SetLoginState(%0,%1) SetPVarInt(%0,"online",%1)
#define AFK(%0) CheckPausing(%0)

#define VIP(%0) vip[%0][_level]
#define GAMING(%0) pdate[%0][_gaming]

#define pGang(%0) pdate[%0][_gid]
#define pGangLevel(%0) pdate[%0][_rank]
#define NOTHING -1

#define IsValidVehicleModel(%0) \
    ((%0 > 399) && (%0 < 612))
    

    
#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
#define HOLDING(%0) \
	((newkeys & (%0)) == (%0))
#define RELEASED(%0) \
	(((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))
#define CRF CallRemoteFunction
#define MAX_DILOG_LIST 15
new page[MAX_PLAYERS];
new totals[MAX_PLAYERS][2000];
new listarray[MAX_PLAYERS];



#define MAX_MONEY 500000000
enum humu
{
	_hex,
	_code[16]
}
new hue[][humu]=
{
	{0xFFFFFFC8,"{FFFFFF}"},
	{0xFF8040C8,"{FF8040}"},
	{0xFFFF00C8,"{FFFF00}"},
	{0xFFFF80C8,"{FFFF80}"},
	{0x408080C8,"{408080}"},
	{0x000080C8,"{000080}"},
	{0x0000FFC8,"{0000FF}"},
	{0x004080C8,"{004080}"},
	{0x00FFFFC8,"{00FFFF}"},
	{0x80FFFFC8,"{80FFFF}"},
	{0x400080C8,"{400080}"},
	{0x8000FFC8,"{8000FF}"},
	{0xFF00FFC8,"{FF00FF}"},
	{0xFF80FFC8,"{FF80FF}"},
	{0x808080C8,"{808080}"},
	{0xFF0000C8,"{FF0000}"},
	{0xFF8000C8,"{FF8000}"},
	{0x00FF40C8,"{00FF40}"},
	{0x400040C8,"{400040}"},
	{0x800080C8,"{800080}"},
	{0xC0C0C0C8,"{C0C0C0}"}
};

#include DATA/Define.pwn
#include DATA/Custom.pwn



#define ARRAY_MODE_NULL 0
#define ARRAY_MODE_MSG  1
#define ARRAY_MODE_TELE 2
#define ARRAY_MODE_GANG 3
#define ARRAY_MODE_JJ 	4
#include <easyDialog>

#include DATA/Other/AntiCheat.pwn
#include DATA/Other/ObjectLoader.pwn
#include DATA/Other/ServerState.pwn
#include DATA/Other/LevelAndVip.pwn
#include DATA/Other/BanSystem.pwn
#include DATA/Other/AfkChacker.pwn

#include DATA/Account.pwn
#include DATA/Msgbox.pwn
#include DATA/Tele.pwn
#include DATA/Gang.pwn
#include DATA/Island.pwn
#include DATA/MiniGame.pwn
#include DATA/Jiaju.pwn

#include DATA/Other/TempVehicle.pwn
#include DATA/Other/ClassSelect.pwn
#include DATA/Other/TimePatch.pwn
#include DATA/Other/GunAttach.pwn
main()
{
    SendRconCommand("hostname ZYZ4");
	//SendRconCommand("mapname 微光X30");
	SendRconCommand("weburl Q群:434972992");
}
public OnGameModeInit()
{
    new Database = mysql_connect(SQL_HOST,SQL_USER,SQL_DATABASE,SQL_PASSWORD);
    mysql_set_charset("gbk",Database);
	mysql_log(LOG_ALL);
	if(Database)
	{
		printf("[数据库]: `%s`@'%s' 连接成功",SQL_DATABASE,SQL_HOST);
		Server_OnGameModeInit();
		ObJLoader_Array_OnGameModeInit();
		LoadAllObjectFiles();
		msgbox_OnGameModeInit();
		tele_OnGameModeInit();
		gang_OnGameModeInit();
		island_OnGameModeInit();
		minigame_OnGameModeInit();
		Time_OnGameModeInit();
        Jiaju_OnGameModeInit();
	}
	else printf("[数据库]: `%s`@'%s' 连接失败",SQL_DATABASE,SQL_HOST);
	
	Class_OnGameModeInit();
	UsePlayerPedAnims();
	EnableStuntBonusForAll(0);
	Streamer_VisibleItems(STREAMER_TYPE_OBJECT,2000);
	SetTimer("OnEverySecondPass", 1000, true);
	SetTimer("OnEveryMinutePass", 60000, true);
	UpdateSeverRunModeTexT();
	return 1;
}
public OnGameModeExit()
{
    msgbox_OnGameModeExit();
    tele_OnGameModeExit();
    gang_OnGameModeExit();
    island_OnGameModeExit();
    minigame_OnGameModeExit();
    Jiaju_OnGameModeExit();
	return 1;
}
public OnPlayerConnect(playerid)
{
    animInit(playerid);
	SendDeathMessage(INVALID_PLAYER_ID, playerid, 200);
	TempVeh_OnPlayerConnect(playerid);
	accout_OnPlayerConnect(playerid);
	minigame_OnPlayerConnect(playerid);
	Level_OnPlayerConnect(playerid);
	GunAtt_OnPlayerConnect(playerid);
	Anti_OnPlayerConnect(playerid);
	Jiaju_OnPlayerConnect(playerid);
	return 1;
}
public OnPlayerDisconnect(playerid, reason)
{
	accout_OnPlayerDisconnect(playerid, reason);
	TempVeh_OnPlayerDisconnect(playerid, reason);
	minigame_OnPlayerDisconnect(playerid, reason);
	Level_OnPlayerDisconnect(playerid, reason);
	Vip_OnPlayerDisconnect(playerid, reason);
	Ban_OnPlayerDisconnect(playerid, reason);
	Time_OnPlayerDisconnect(playerid, reason);
	GunAtt_OnPlayerDisconnect(playerid, reason);
	Anti_OnPlayerDisconnect(playerid, reason);
	Jiaju_OnPlayerDisconnect(playerid, reason);
	SendDeathMessage(INVALID_PLAYER_ID, playerid, reason);
	return 1;
}
PLC::OnPlayerLogin(playerid)
{
	if(IsLogin(playerid))return 1;
    accout_OnPlayerLogin(playerid);
    gang_OnPlayerLogin(playerid);
    Msg_SendUnRead(playerid);
    Level_OnPlayerLogin(playerid);
    Vip_OnPlayerLogin(playerid);
    Time_OnPlayerLogin(playerid);
	return 1;
}
public OnPlayerText(playerid, text[])
{
    accout_OnPlayerText(playerid, text);
	gang_OnPlayerText(playerid, text);
	return 0;
}
public OnPlayerSpawn(playerid)
{
    Anti_OnPlayerSpawn(playerid);
    minigame_OnPlayerSpawn(playerid);
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	if(GAMING(playerid))return 1;
	Class_OnPlayerRequestClass(playerid,classid);
	return 1;
}
public OnPlayerRequestSpawn(playerid)
{
	if(!IsLogin(playerid))return 0;
	if(GAMING(playerid))return 1;
	Class_OnPlayerRequestSpawn(playerid);
	return 1;
}
public OnPlayerDeath(playerid, killerid, reason)
{
    if(IsLogin(playerid))
    {
    	minigame_OnPlayerDeath(playerid, killerid, reason);
    	Anti_OnPlayerDeath(playerid, killerid, reason);
    	Jiaju_OnPlayerDeath(playerid, killerid, reason);
    }
	return 1;
}
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(IsLogin(playerid))
    {
        TempVeh_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
        Jiaju_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
    }
	return 1;
}
public OnPlayerUpdate(playerid)
{
    if(IsLogin(playerid))
    {
        Afk_OnPlayerUpdate(playerid);
        Attach_Gun(playerid);
        AntiCheater(playerid);
    }
	return 1;
}
public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
    if(IsLogin(playerid))
    {
        Anti_OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ);
	}
    return 1;
}
public OnPlayerTakeDamage(playerid, issuerid, Float: amount, weaponid)
{
    if(IsLogin(playerid))
    {
        Anti_OnPlayerTakeDamage(playerid, issuerid, Float: amount, weaponid);
    }
	return 1;
}
public OnPlayerGiveDamage(playerid, damagedid, Float: amount, weaponid)
{
    if(IsLogin(playerid))
    {
        Anti_OnPlayerGiveDamage(playerid, damagedid, Float: amount, weaponid);
    }
    return 1;
}
PLC::OnPlayerHack(playerid,type)
{
	switch(type)
	{
	    case HACK_WEAPON:
	    {
	        RecoverWeapon(playerid);
	        printf("1");
	    }
	    case HACK_WEAPON_AMMO:
	    {
	        RecoverWeapon(playerid);
	        printf("2");
	    }
	    case HACK_HEALTH:
	    {
	        printf("3");
	    }
	    case HACK_ARMOUR:
	    {
	        printf("4");
	    }
		case HACK_CAR_SPEED:
	    {
	        printf("5");
	    }
		case HACK_TELEPORT:
		{
	        printf("6");
		}
	}
    return 1;
}
PLC::OnEverySecondPass()
{
    Settime();
	foreach(new i:Player)
	{
	    if(IsLogin(i))
	    {
			AfkChack(i);
	    }
	}
}
PLC::OnEveryMinutePass()
{
    SeverUpdate();
    JiajuUpdate();
	foreach(new i:Player)
	{
	    if(IsLogin(i))
	    {
	    	LevelUpdate(i);
	    	VipUpdate(i);
	    }
	}
}
GetTimeStr(time)
{
    new line[128],rday,rhour,rmin;
    ConvertMinTime(time,rday,rhour,rmin);
	format(line, sizeof(line),"%i天%i小时%i分钟",rday,rhour,rmin);
    return line;
}
animInit(playerid)
{
	PreloadAnimLib(playerid,"BOMBER");
	PreloadAnimLib(playerid,"RAPPING");
    PreloadAnimLib(playerid,"SHOP");
	PreloadAnimLib(playerid,"BEACH");
    PreloadAnimLib(playerid,"SMOKING");
	PreloadAnimLib(playerid,"FOOD");
    PreloadAnimLib(playerid,"ON_LOOKERS");
	PreloadAnimLib(playerid,"DEALER");
    PreloadAnimLib(playerid,"CRACK");
	PreloadAnimLib(playerid,"CARRY");
    PreloadAnimLib(playerid,"COP_AMBIENT");
	PreloadAnimLib(playerid,"PARK");
    PreloadAnimLib(playerid,"INT_HOUSE");
	PreloadAnimLib(playerid,"PED");
    PreloadAnimLib(playerid,"MISC");
	PreloadAnimLib(playerid,"OTB");
    PreloadAnimLib(playerid,"BD_Fire");
	PreloadAnimLib(playerid,"BENCHPRESS");
    PreloadAnimLib(playerid,"KISSING");
	PreloadAnimLib(playerid,"BSKTBALL");
    PreloadAnimLib(playerid,"MEDIC");
	PreloadAnimLib(playerid,"SWORD");
    PreloadAnimLib(playerid,"POLICE");
	PreloadAnimLib(playerid,"SUNBATHE");
    PreloadAnimLib(playerid,"FAT");
	PreloadAnimLib(playerid,"WUZI");
    PreloadAnimLib(playerid,"SWEET");
	PreloadAnimLib(playerid,"ROB_BANK");
    PreloadAnimLib(playerid,"GANGS");
	PreloadAnimLib(playerid,"RIOT");
    PreloadAnimLib(playerid,"GYMNASIUM");
	PreloadAnimLib(playerid,"CAR");
    PreloadAnimLib(playerid,"CAR_CHAT");
	PreloadAnimLib(playerid,"GRAVEYARD");
    PreloadAnimLib(playerid,"POOL");
	return 1;
}
stock PreloadAnimLib(playerid, animlib[])
{
	ApplyAnimation(playerid, animlib, "null", 0.0, 0, 0, 0, 0, 0);
	return 1;
}
stock ARGB(color_rgba)
{
	new alpha = (color_rgba & 0xff) << 24;
	new rgb = color_rgba >>> 8;
	return alpha | rgb;
}
stock SCM(playerid, message[])return SendClientMessage(playerid, COLOR_WHITE, message);
stock Server(playerid, message[])
{
	new pesan[128];
	format(pesan, sizeof(pesan), ""CHAT_SERVER"[信息] "CHAT_WHITE"%s", message);
	return SCM(playerid, pesan);
}

stock Usage(playerid, message[])
{
	new pesan[128];
	format(pesan, sizeof(pesan), ""CHAT_RED"[指令] "CHAT_WHITE"用法 : "CHAT_RED"%s", message);
	return SCM(playerid, pesan);
}

stock Info(playerid, message[])
{
	new pesan[128];
	format(pesan, sizeof(pesan), ""CHAT_SERVER"[提示] "CHAT_WHITE"%s", message);
	return SCM(playerid, pesan);
}

PLC::GiveCash(playerid,amount)
{
	if(amount==0)return 1;
    pdate[playerid][_cash]+=amount;
    if(pdate[playerid][_cash]<0)pdate[playerid][_cash]=0;
    if(pdate[playerid][_cash]>MAX_MONEY)
    {
        pdate[playerid][_moneybag]+=MAX_MONEY/100000000;
        pdate[playerid][_cash]-=MAX_MONEY;
        new line[128];
        format(line, sizeof(line), "由于你的现金大于%i亿,系统自动将%i亿存入你的安全钱包!",MAX_MONEY/100000000,MAX_MONEY/100000000);
        Server(playerid,line);
    }
    ResetPlayerMoney(playerid);
    GivePlayerMoney(playerid,pdate[playerid][_cash]);
    orm_update(pdate[playerid][_orm]);
    return 1;
}
PLC::GiveBank(playerid,amount)
{
	if(amount==0)return 1;
    pdate[playerid][_bank]+=amount;
    if(pdate[playerid][_bank]<0)pdate[playerid][_bank]=0;
    if(pdate[playerid][_bank]>MAX_MONEY)
    {
        pdate[playerid][_moneybag]+=MAX_MONEY/100000000;
        pdate[playerid][_bank]-=MAX_MONEY;
        new line[128];
        format(line, sizeof(line), "由于你的存款大于%i亿,系统自动将%i亿存入你的安全钱包!",MAX_MONEY/100000000,MAX_MONEY/100000000);
        Server(playerid,line);
    }
    orm_update(pdate[playerid][_orm]);
    return 1;
}
PLC::GiveQb(playerid,amount)
{
	if(amount==0)return 1;
    pdate[playerid][_qb]+=amount;
    orm_update(pdate[playerid][_orm]);
    return 1;
}
PLC::SetCash(playerid,amount)
{
    pdate[playerid][_cash]=amount;
    if(pdate[playerid][_cash]<0)pdate[playerid][_cash]=0;
    if(pdate[playerid][_cash]>MAX_MONEY)
    {
        pdate[playerid][_moneybag]+=MAX_MONEY/100000000;
        pdate[playerid][_cash]-=MAX_MONEY;
        new line[128];
        format(line, sizeof(line), "由于你的现金大于%i亿,系统自动将%i亿存入你的安全钱包!",MAX_MONEY/100000000,MAX_MONEY/100000000);
        Server(playerid,line);
    }
    ResetPlayerMoney(playerid);
    GivePlayerMoney(playerid,pdate[playerid][_cash]);
    orm_update(pdate[playerid][_orm]);
    return 1;
}
PLC::SetQb(playerid,amount)
{
    pdate[playerid][_qb]=amount;
    orm_update(pdate[playerid][_orm]);
    return 1;
}
PLC::SetBank(playerid,amount)
{
    pdate[playerid][_bank]=amount;
    if(pdate[playerid][_bank]<0)pdate[playerid][_bank]=0;
    if(pdate[playerid][_bank]>MAX_MONEY)
    {
        pdate[playerid][_moneybag]+=MAX_MONEY/100000000;
        pdate[playerid][_bank]-=MAX_MONEY;
        new line[128];
        format(line, sizeof(line), "由于你的存款大于%i亿,系统自动将%i亿存入你的安全钱包!",MAX_MONEY/100000000,MAX_MONEY/100000000);
        Server(playerid,line);
    }
    orm_update(pdate[playerid][_orm]);
    return 1;
}
PLC::EnoughCash(playerid,amount)
{
    if(pdate[playerid][_cash]>=amount)return 1;
	return 0;
}
stock TeleportPlayer(playerid,Float:x,Float:y,Float:z,Float:a,interior=0,world=0,bool:vehicle=false,delay=0)
{
    SetPos(playerid,x,y,z);
    SetPlayerFacingAngle(playerid,a);
	SetInterior(playerid,interior);
	SetPlayerVirtualWorld(playerid,world);
   	if(IsPlayerInAnyVehicle(playerid)&&GetPlayerVehicleSeat(playerid)==0&&vehicle)
	{
         new carid=GetPlayerVehicleID(playerid);
         LinkVehicleToInterior(carid,interior);
    	 SetVehicleVirtualWorld(carid,world);
    	 SetVehiclePos(carid,x,y,z+3);
    	 PutInVehicle(playerid,carid,0);
	}
    SetCameraBehindPlayer(playerid);
    if(delay>0)
    {
        TogglePlayerControllable(playerid,0);
        SetTimerEx("unfreeze",delay*1000, false, "i", playerid);
    }
    return 1;
}
PLC::unfreeze(playerid)return TogglePlayerControllable(playerid ,1);
PLC::KickEx(playerid)
{
    SetTimerEx("DelayKick", 500, false, "i", playerid);
    return 1;
}
PLC::DelayKick(playerid)Kick(playerid);
GetPidName(pid)
{
	new query[128];
	format(query, sizeof(query), "SELECT `NAME` FROM `"SQL_ACCOUT_DATABASE"` WHERE `ID` = '%i' LIMIT 1",pid);
	mysql_query(1,query);
	new line[80];
	cache_get_field_content(0,"NAME",line,1,sizeof(line));
	return line;
}
GetPidVip(pid)
{
	new query[128];
	format(query, sizeof(query), "SELECT `LEVEL` FROM `"SQL_VIP_DATABASE"` WHERE `PID` = '%i' LIMIT 1",pid);
	mysql_query(1,query);
	new viplevel=cache_get_field_content_int(0,"LEVEL");
	return viplevel;
}
stock ExistChinese(str[])
{
	for( new i=0; str[i]!=0; i++ )
	{
		if(str[i] < 0 || str[i] > 127) return 1;
	}
	return 0;
}
GetXYInFrontOfPlayer(playerid, &Float:x, &Float:y, Float:distance)
{
    new Float:a;
    GetPlayerPos(playerid, x, y, a);
    GetPlayerFacingAngle(playerid, a);
    if (GetPlayerVehicleID(playerid))
    {
		GetVehicleZAngle(GetPlayerVehicleID(playerid), a);
    }
    x += (distance * floatsin(-a, degrees));
    y += (distance * floatcos(-a, degrees));
}
stock strlower(string[])
{
    for(new i; i<strlen(string); i++) string[i] = tolower(string[i]);
    return string;
}
stock token_by_delim(const string[], return_str[], delim, start_index)
{
    new x=0;
    while(string[start_index] != EOS && string[start_index] != delim) {
        return_str[x] = string[start_index];
        x++;
        start_index++;
    }
    return_str[x] = EOS;
    if(string[start_index] == EOS) start_index = (-1);
    return start_index;
}
SSCANF:handlemenu(string[])
{
 	if(!strcmp(string,"cs",false)) return 1;
 	if(!strcmp(string,"land",false)) return 2;
 	if(!strcmp(string,"game",false)) return 3;
 	if(!strcmp(string,"gang",false)) return 4;
	if(!strcmp(string,"msg",false)) return 5;
    return 0;
}
CMD:add(playerid, params[], help)
{
	new action,string[128];
	if(sscanf(params,"k<handlemenu>S()[128]",action,string)) return Usage(playerid, "/add cs|land|game|gang");
	switch(action)
	{
	    case 1:CMD_ADDCS(playerid,string);
	    case 2:CMD_ADDLAND(playerid,string);
	    case 3:CMD_ADDGAME(playerid,string);
	    case 4:CMD_ADDGANG(playerid,string);
	}
	return 1;
}
CMD:del(playerid, params[], help)
{
	new action,string[128];
	if(sscanf(params,"k<handlemenu>S()[128]",action,string)) return Usage(playerid, "/del cs|land|game|gang|msg");
	switch(action)
	{
	    case 1:CMD_DELCS(playerid,string);
	    case 2:CMD_DELLAND(playerid,string);
	    case 3:CMD_DELGAME(playerid,string);
	    case 4:CMD_DELGANG(playerid,string);
	    case 5:CMD_DELMSG(playerid,string);
	}
	return 1;
}
CMD:join(playerid, params[], help)
{
	new action,string[128];
	if(sscanf(params,"k<handlemenu>S()[128]",action,string)) return Usage(playerid, "/join gang");
	if(action==4)CMD_JOINGANG(playerid,string);
	return 1;
}
CMD:gun(playerid, params[], help)
{
	new gunid,ammo;
	if(sscanf(params,"ii",gunid,ammo)) return Usage(playerid, "/gun");
	SetWeapon(playerid,gunid,ammo);
	return 1;
}
CMD:kill(playerid, params[], help)
{
	SetHealth(playerid,0.0);
	return 1;
}
stock GetPlayerName_prefixed(playerid, name[], len)
{
        new ret = GetPlayerName( playerid, name, len );
        for( new i=0; name[i]!=0; i++ )
                if( name[i]<0 ) name[i] += 256;
        return ret;
}
strlenEx(const string[])
{
	new i;
	while( string[i]!=0 )i++;
	return i;
}
